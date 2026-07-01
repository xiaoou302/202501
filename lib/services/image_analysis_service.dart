import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ImageAnalysisService {
  static const String _apiKey =
      'ark-d39b7f2e-ed4f-424d-8fde-da39f93a11ea-4dcf1';
  static const String _apiUrl =
      'https://ark.cn-beijing.volces.com/api/v3/responses';

  static Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "doubao-seed-2-0-pro-260215",
          "input": [
            {
              "role": "user",
              "content": [
                {
                  "type": "input_image",
                  "image_url": "data:image/jpeg;base64,$base64Image",
                },
                {
                  "type": "input_text",
                  "text":
                      "You are an AI assistant for a stray dog and cat rescue app. Please analyze the provided photo.\n"
                      "First, determine if there is a dog or cat in the image.\n"
                      "If there is NO dog or cat, return exactly this JSON: {\"isValidPet\": false, \"message\": \"No cat or dog detected in the image. Please upload a clear photo of the stray animal.\", \"breed\": \"\", \"estimatedAge\": \"\", \"condition\": \"\"}\n"
                      "If there IS a dog or cat, analyze its condition to help rescuers. Return exactly this JSON: {\"isValidPet\": true, \"breed\": \"[Estimated Breed]\", \"estimatedAge\": \"[Estimated Age]\", \"condition\": \"[Brief physical and mental state]\", \"message\": \"[Brief advice for rescuer]\"}\n"
                      "Ensure the output is strictly valid JSON without any markdown formatting (no ```json) or extra text.",
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        String resultText = '';
        if (data['output'] != null && data['output'] is List) {
          for (var item in data['output']) {
            if (item['type'] == 'message' &&
                item['content'] != null &&
                item['content'] is List) {
              for (var contentItem in item['content']) {
                if (contentItem['type'] == 'output_text') {
                  resultText += contentItem['text'] ?? '';
                }
              }
            }
          }
        }

        if (resultText.isNotEmpty) {
          resultText = resultText
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();
          return jsonDecode(resultText);
        }
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error analyzing image: $e");
    }

    // Default fallback if error occurs
    return {
      'isValidPet': false,
      'message': 'Failed to analyze the image. Please try again.',
      'breed': '',
      'estimatedAge': '',
      'condition': '',
    };
  }
}
