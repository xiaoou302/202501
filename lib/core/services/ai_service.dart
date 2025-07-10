import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class AIService {
  static const String _baseUrl = 'https://api.siliconflow.cn/v1';
  static const String _apiKey =
      'sk-rhvyigccgnmezuvriwevnfusjztmzzerfyobzswpmsjhcxzv';

  /// Generate AI images
  static Future<List<String>> generateImages({
    required String prompt,
    String imageSize = '1024x1024',
    int batchSize = 1,
    int numInferenceSteps = 20,
    double guidanceScale = 7.5,
  }) async {
    try {
      developer.log('Making API request with parameters:', name: 'AIService');
      developer.log('Prompt: $prompt', name: 'AIService');
      developer.log('Image Size: $imageSize', name: 'AIService');
      developer.log('Batch Size: $batchSize', name: 'AIService');
      developer.log('Steps: $numInferenceSteps', name: 'AIService');

      final response = await http.post(
        Uri.parse('$_baseUrl/images/generations'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'Kwai-Kolors/Kolors',
          'prompt': prompt,
          'image_size': imageSize,
          'batch_size': batchSize,
          'num_inference_steps': numInferenceSteps,
          'guidance_scale': guidanceScale,
        }),
      );

      developer.log('API Response Status Code: ${response.statusCode}',
          name: 'AIService');
      developer.log('API Response Body: ${response.body}', name: 'AIService');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('images') && data['images'] is List) {
          final List<dynamic> images = data['images'];
          final List<String> imageUrls = [];

          for (var image in images) {
            if (image is Map<String, dynamic> && image.containsKey('url')) {
              imageUrls.add(image['url'] as String);
            } else if (image is String) {
              imageUrls.add(image);
            }
          }

          developer.log('Successfully extracted ${imageUrls.length} image URLs',
              name: 'AIService');
          return imageUrls;
        } else {
          throw Exception(
              'Invalid response format: missing or invalid images field');
        }
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage =
            errorBody['error']?['message'] ?? 'Unknown error occurred';
        throw Exception(
            'API request failed: $errorMessage (Status: ${response.statusCode})');
      }
    } catch (e, stackTrace) {
      developer.log('Error in generateImages',
          name: 'AIService', error: e, stackTrace: stackTrace);
      throw Exception('Error generating images: $e');
    }
  }

  /// Generate prompt based on comic style
  static String generatePromptForStyle(String plot, String style) {
    final basePrompt = switch (style.toLowerCase()) {
      'cyberpunk' =>
        'comic style, high quality, detailed, cyberpunk style, neon lights, futuristic city, high tech, dark atmosphere, digital art, sci-fi, ',
      'fantasy' =>
        'comic style, high quality, detailed, fantasy style, magical, mystical creatures, enchanted world, ethereal lighting, medieval, magical realism, ',
      'scifi' =>
        'comic style, high quality, detailed, science fiction style, space, advanced technology, alien worlds, cosmic scenes, futuristic, ',
      'modern' =>
        'comic style, high quality, detailed, modern style, contemporary urban setting, realistic, daily life scenes, city life, ',
      _ =>
        'comic style, high quality, detailed, artistic style, creative, imaginative, ',
    };

    final fullPrompt = '$basePrompt$plot';
    developer.log('Generated prompt: $fullPrompt', name: 'AIService');
    return fullPrompt;
  }
}
