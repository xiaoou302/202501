import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cartoon.dart';
import '../../../shared/utils/constants.dart';

class GeneratorService {
  static const String apiUrl =
      "https://api.siliconflow.cn/v1/images/generations";
  static const String apiKey =
      "sk-yxmylrgcnxnxbwqjtndmkhqlsbzmjqmnyamptorpdvkgcbnu";

  // Generate cartoon image using AI API
  Future<String> generateCartoonImage(String description) async {
    try {
      // Enhance the prompt to always include a couple
      final enhancedPrompt = description.toLowerCase().contains('couple')
          ? description
          : "A romantic couple, $description";

      final payload = {
        "model": AppConstants.aiModelName,
        "prompt": enhancedPrompt,
        "negative_prompt":
            "deformed, bad anatomy, disfigured, poorly drawn face, mutation, mutated, extra limb, ugly, poorly drawn hands, missing limb, floating limbs, disconnected limbs, malformed hands, blurry, ((((ugly)))), (((duplicate))), ((morbid)), ((mutilated)), out of frame, extra fingers, mutated hands, ((poorly drawn hands)), ((poorly drawn face)), (((mutation))), (((deformed))), ((ugly)), blurry, ((bad anatomy)), (((bad proportions))), ((extra limbs)), cloned face, (((disfigured))), out of frame, ugly, extra limbs, (bad anatomy), gross proportions, (malformed limbs), ((missing arms)), ((missing legs)), (((extra arms))), (((extra legs))), mutated hands, (fused fingers), (too many fingers), (((long neck)))",
        "image_size": AppConstants.aiImageSize,
        "batch_size": 1,
        "seed": AppConstants.aiSeed,
        "num_inference_steps": AppConstants.aiSteps,
        "guidance_scale": AppConstants.aiGuidance
      };

      final headers = {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json"
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Extract image URL from the response
        if (jsonResponse['data'] != null &&
            jsonResponse['data'].isNotEmpty &&
            jsonResponse['data'][0]['url'] != null) {
          return jsonResponse['data'][0]['url'];
        } else {
          throw Exception('No image URL in response');
        }
      } else {
        throw Exception('Failed to generate image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating image: $e');
      // Fallback to a placeholder image if the API call fails
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'https://picsum.photos/seed/$timestamp/400/300';
    }
  }

  // Create a new cartoon object
  Future<Cartoon> createCartoon(String description) async {
    final imageUrl = await generateCartoonImage(description);
    return Cartoon(description: description, imageUrl: imageUrl);
  }
}
