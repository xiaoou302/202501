import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  static const String _apiKey = 'sk-8a0825033fe54f5dbc633c5258698664';
  static const String _baseUrl = 'https://api.deepseek.com/v1/chat/completions';
  
  static const String _systemPrompt = '''You are a professional dance master and instructor with decades of experience in various dance styles including Ballet, Contemporary, Jazz, Hip Hop, and Traditional dance forms. Your role is to:

1. Provide expert guidance on dance techniques, movements, and training
2. Offer artistic advice on expression, musicality, and performance
3. Help dancers improve their skills and overcome challenges
4. Share knowledge about dance history, styles, and culture
5. Give constructive feedback and encouragement

IMPORTANT RESTRICTIONS:
- ONLY discuss topics related to DANCE (technique, training, performance, history, styles, etc.)
- REFUSE to answer questions about:
  * Health and medical issues (injuries, pain, medical treatment)
  * Legal matters
  * Political topics
  * Personal counseling or therapy
  * Any non-dance related subjects

If asked about restricted topics, politely redirect the conversation back to dance-related matters.

Always be encouraging, professional, and supportive. Use your expertise to help dancers grow and improve their craft.''';

  Future<String> sendMessage(String userMessage, List<Map<String, String>> conversationHistory) async {
    try {
      // 构建消息历史
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        ...conversationHistory,
        {'role': 'user', 'content': userMessage},
      ];

      // 打印调试信息
      print('Sending message to AI: $userMessage');
      print('Conversation history length: ${conversationHistory.length}');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'deepseek-chat',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1000,
          'stream': false,
        }),
      ).timeout(
        const Duration(seconds: 60), // 增加到60秒超时
        onTimeout: () {
          print('Request timeout after 60 seconds');
          throw Exception('Request timeout');
        },
      );

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final aiResponse = data['choices'][0]['message']['content'];
        print('AI response received: ${aiResponse.substring(0, aiResponse.length > 50 ? 50 : aiResponse.length)}...');
        return aiResponse;
      } else {
        print('Error response: ${response.body}');
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        return 'Sorry, I encountered an error: $errorMessage (Status: ${response.statusCode})';
      }
    } catch (e) {
      print('Exception in sendMessage: $e');
      if (e.toString().contains('timeout')) {
        return 'Request timeout. The AI service is taking too long to respond. Please try again with a shorter message.';
      }
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        return 'Network error. Please check your internet connection and try again.';
      }
      return 'Sorry, I encountered an error: ${e.toString()}. Please try again.';
    }
  }
}
