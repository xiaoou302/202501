import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/guide_step.dart';

class AiGuideService {
  static const String _apiUrl = "https://ark.cn-beijing.volces.com/api/v3/chat/completions";
  static const String _apiKey = "e7e76635-300d-4ee6-8bc0-9e1b5f59780a";
  static const String _model = "doubao-seed-1-6-251015";

  Future<GuideResult> getAnalysisAndGuide(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Determine mime type roughly
      String mimeType = "image/jpeg";
      if (imageFile.path.toLowerCase().endsWith(".png")) {
        mimeType = "image/png";
      }
      final dataUri = "data:$mimeType;base64,$base64Image";

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": _model,
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text": "Analyze this artifact image. First, describe the item in the photo (what it is, its condition, visible damage). Then identify the main material. Finally, provide a professional 3-step restoration/maintenance guide for it. \n\nReturn ONLY a JSON object with this structure:\n{\n  \"description\": \"Description of the item and its condition.\",\n  \"material\": \"Detected Material Name\",\n  \"steps\": [\n    {\n      \"title\": \"Step Title\",\n      \"description\": \"Concise instruction (under 20 words).\",\n      \"warning\": \"Optional safety warning.\"\n    }\n  ]\n}"
                },
                {
                  "type": "image_url",
                  "image_url": {
                    "url": dataUri
                  }
                }
              ]
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        print("Raw API Response: ${response.body}");
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Clean markdown code blocks if present
        String jsonString = content;
        if (content.startsWith('```json')) {
          jsonString = content.replaceAll('```json', '').replaceAll('```', '');
        } else if (content.startsWith('```')) {
          jsonString = content.replaceAll('```', '');
        }
        
        dynamic parsedContent;
        try {
            parsedContent = jsonDecode(jsonString);
        } catch (e) {
            print("Error parsing content JSON: $e");
            return _getFallbackSteps("Unknown");
        }

        if (parsedContent is Map) {
             return GuideResult(
               description: parsedContent['description'] ?? 'No description available.',
               material: parsedContent['material'] ?? 'Unknown',
               steps: (parsedContent['steps'] as List?)
                   ?.map((step) => GuideStep.fromJson(step))
                   .toList() ?? [],
             );
        } else {
             return _getFallbackSteps("Unknown");
        }
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        return _getFallbackSteps("Unknown");
      }
    } catch (e) {
      print("Exception in AiGuideService: $e");
      return _getFallbackSteps("Unknown");
    }
  }

  GuideResult _getFallbackSteps(String material) {
    return GuideResult(
      description: "Could not analyze image. Using generic guide.",
      material: material,
      steps: [
        GuideStep(title: "Clean", description: "Gently clean the surface with a soft cloth."),
        GuideStep(title: "Protect", description: "Apply appropriate protective coating for the material."),
        GuideStep(title: "Store", description: "Store in a stable environment away from direct sunlight."),
      ],
    );
  }
}
