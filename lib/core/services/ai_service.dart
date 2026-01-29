import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = "40efa984-630e-4721-a9e4-c86f9a5edc3d";
  static const String _baseUrl =
      "https://ark.cn-beijing.volces.com/api/v3/chat/completions";
  static const String _imageGenerationUrl =
      "https://ark.cn-beijing.volces.com/api/v3/images/generations";
  static const String _model = "doubao-seed-1-6-251015";
  static const String _imageModel = "doubao-seedream-4-0-250828";

  // System prompt to restrict domain
  static const String _systemPrompt = """
You are Strida, a professional home decoration and aesthetics consultant. 
Your goal is to help users with interior design, renovation, furniture selection, and home aesthetics.

IMPORTANT RULES:
1. You MUST ONLY discuss topics related to home decoration, interior design, architecture, renovation, and aesthetics.
2. You MUST REFUSE to answer any questions related to:
   - Health and medical advice
   - Law and legal advice
   - Money, finance, and investment
   - Politics and social issues
   - Specific commercial brand promotion (unless describing a style)
3. If a user asks about prohibited topics, politely decline and steer the conversation back to home decoration (e.g., "I apologize, but I specialize in home aesthetics. Let's discuss how to improve your living room instead.").
4. When analyzing images, focus on the style, layout, colors, materials, and lighting.
""";

  Future<String> FindOtherLayoutHandler({
    required List<Map<String, dynamic>> history,
    String? newText,
    String? newImageBase64,
  }) async {
    // Construct the message list for standard OpenAI-compatible Chat Completions API

    final List<Map<String, dynamic>> messages = [];

    // Add system prompt
    messages.add({"role": "system", "content": _systemPrompt});

    // Add history
    // The history is already in a format close to what we need, but we should ensure
    // content is formatted correctly as per OpenAI specs for multimodal input.
    // AIDiscourseScreen sends: [{'role': '...', 'content': [{'type': 'text', 'text': '...'}]}]
    for (var msg in history) {
      messages.add(msg);
    }

    // Add new message
    if (newText != null || newImageBase64 != null) {
      final List<Map<String, dynamic>> content = [];

      if (newText != null && newText.isNotEmpty) {
        content.add({"type": "text", "text": newText});
      }

      if (newImageBase64 != null) {
        // OpenAI format for image_url
        content.add({
          "type": "image_url",
          "image_url": {"url": "data:image/jpeg;base64,$newImageBase64"},
        });
      }

      messages.add({"role": "user", "content": content});
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"model": _model, "messages": messages}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          final content = data['choices'][0]['message']['content'];
          return content.toString();
        }
        return "Sorry, I couldn't understand the response.";
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        return "Network error: ${response.statusCode}. Please try again.";
      }
    } catch (e) {
      print("Exception: $e");
      return "An error occurred. Please check your connection.";
    }
  }

  Future<String?> generateImage({
    required String prompt,
    String? imageBase64,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "model": _imageModel,
        "prompt": prompt,
        "sequential_image_generation": "disabled",
        "response_format": "url",
        "size": "2K",
        "stream": false,
        "watermark": true,
      };

      // Add image if provided (Image-to-Image)
      if (imageBase64 != null) {
        // Ensure proper format.
        if (!imageBase64.startsWith('data:image')) {
          body["image"] = "data:image/jpeg;base64,$imageBase64";
        } else {
          body["image"] = imageBase64;
        }
      }

      final response = await http.post(
        Uri.parse(_imageGenerationUrl),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['data'] != null && data['data'].isNotEmpty) {
          return data['data'][0]['url'];
        }
      } else {
        print(
          "Image Generation Error: ${response.statusCode} - ${response.body}",
        );
        throw Exception("Failed to generate image: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in generateImage: $e");
      rethrow;
    }
    return null;
  }
}
