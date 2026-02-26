import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AiRestorationService {
  static const String _apiUrl =
      "https://ark.cn-beijing.volces.com/api/v3/images/generations";
  static const String _apiKey =
      "e7e76635-300d-4ee6-8bc0-9e1b5f59780a"; // In production, use env variables
  static const String _model = "doubao-seedream-4-0-250828";

  Future<String> generateRestoration(File imageFile) async {
    try {
      // 1. Convert image to Base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // IMPORTANT: The API might expect a URL or a specific Base64 format.
      // Based on error "invalid url specified", it seems the API treats the input as a URL unless it's a valid Data URI scheme or the field is named differently for base64.
      // However, checking the Doubao/Volcengine docs for `image` field in image-to-image:
      // It usually accepts a URL. If providing base64, it often needs to be a Data URI scheme: "data:image/jpeg;base64,..."

      // Let's try adding the Data URI scheme prefix.
      // Assuming JPEG or PNG.
      String mimeType = "image/jpeg";
      if (imageFile.path.toLowerCase().endsWith(".png")) {
        mimeType = "image/png";
      }
      final imageInput = "data:$mimeType;base64,$base64Image";

      // 2. Prepare request body
      // Note: The prompt is engineered to "restore" the object.
      final body = jsonEncode({
        "model": _model,
        "prompt":
            "Highly detailed, photorealistic restoration of this vintage artifact to its original brand new condition. Clean, shiny, no rust, no scratches, perfect lighting, studio quality, 8k resolution.",
        "image": imageInput, // Sending Data URI
        "sequential_image_generation": "disabled",
        "response_format": "url",
        "size": "2K",
        "stream": false,
        "watermark": false
      });

      // 3. Send Request
      print("Sending API Request to $_apiUrl");
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: body,
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      // 4. Handle Response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          return data['data'][0]['url'];
        } else {
          throw Exception("API returned empty data: ${response.body}");
        }
      } else {
        throw Exception("API Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception("Restoration failed: $e");
    }
  }
}
