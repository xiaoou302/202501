import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/bean.dart';
import 'package:uuid/uuid.dart';

class AiService {
  static const String _apiKey = '90257769-b980-4ca0-9fa7-68a190bd1fdf';
  // Switching to standard OpenAI-compatible endpoint for Volcengine Ark
  static const String _apiUrl =
      'https://ark.cn-beijing.volces.com/api/v3/chat/completions';

  static const String _deepSeekApiKey = 'sk-17415403611c4d6684e8c4d0d595f32a';
  static const String _deepSeekApiUrl =
      'https://api.deepseek.com/chat/completions';

  static Future<Map<String, dynamic>?> analyzeTastingNotes(String notes) async {
    try {
      final response = await http.post(
        Uri.parse(_deepSeekApiUrl),
        headers: {
          'Authorization': 'Bearer $_deepSeekApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "deepseek-chat",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a professional Q-Grader. Analyze the user's coffee tasting notes. Return a JSON object with: 1. 'radar_data': A map of 6 flavor attributes (Acidity, Sweet, Body, Bitter, Finish, Aroma) with scores from 0-10. 2. 'sca_score': An estimated SCA score (e.g., 84.5). 3. 'recommendation': A short suggestion for the next bean to try based on these preferences. 4. 'tags': A list of 3 flavor tags extracted from the notes.",
            },
            {"role": "user", "content": "Tasting notes: $notes"},
          ],
          "response_format": {"type": "json_object"},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      } else {
        print('DeepSeek API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error analyzing tasting notes: $e');
    }
    return null;
  }

  static Future<Bean?> analyzeBeanImage(XFile imageFile) async {
    try {
      final bytes = await File(imageFile.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "doubao-seed-1-6-251015", // Keeping the model ID as provided
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                      "Analyze this coffee bean packaging image. Extract the following details and return them in a strict JSON format (no markdown, no code blocks): name, origin, process, roastLevel, flavorNotes (array of strings). If a field is not found, use 'Unknown' or empty list.",
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
                },
              ],
            },
          ],
        }),
      );

      print("AI Service Response Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Handle standard OpenAI response format
        // { "choices": [ { "message": { "content": "..." } } ] }
        final Map<String, dynamic> data = jsonDecode(
          response.body,
        ); // Use UTF8 decoding if needed, but jsonDecode handles it usually.

        String? content;
        if (data.containsKey('choices') &&
            (data['choices'] as List).isNotEmpty) {
          content = data['choices'][0]['message']['content'];
        }

        if (content != null) {
          print("AI Raw Content: $content");

          // Clean up json string (remove ```json ... ```)
          content = content
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();

          // Find first '{' and last '}' to extract JSON if there's extra text
          final startIndex = content.indexOf('{');
          final endIndex = content.lastIndexOf('}');
          if (startIndex != -1 && endIndex != -1) {
            content = content.substring(startIndex, endIndex + 1);
          }

          final Map<String, dynamic> jsonMap = jsonDecode(content);

          return Bean(
            id: const Uuid().v4(),
            name: jsonMap['name'] ?? 'Unknown Bean',
            origin: jsonMap['origin'] ?? 'Unknown Origin',
            process: jsonMap['process'] ?? 'Unknown',
            roastLevel: jsonMap['roastLevel'] ?? 'Medium',
            roastDate: DateTime.now(),
            initialWeight: 250,
            remainingWeight: 250,
            flavorNotes: List<String>.from(jsonMap['flavorNotes'] ?? []),
            imagePath: imageFile.path,
          );
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error analyzing image: $e');
    }
    return null;
  }
}
