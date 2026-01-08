import 'package:dio/dio.dart';
import '../models/chat_message.dart';

class AiRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.deepseek.com',
    headers: {
      'Authorization': 'Bearer sk-abc46487d64443d6a776a17c7afc4cfd',
      'Content-Type': 'application/json',
    },
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // System prompt - Define AI's role and limitations
  final String _systemPrompt = '''You are a professional street photography and fashion styling consultant. Your expertise includes:
- Street photography techniques and composition methods
- Various styling suggestions (casual, business, streetwear, vintage, etc.)
- Color coordination and fabric selection
- Outfit recommendations for different occasions
- Fashion trend analysis

Important restrictions:
You can ONLY answer questions related to street photography, fashion styling, and outfit coordination.
For the following topics, you MUST politely decline to answer:
- Health and medical issues
- Legal advice
- Political topics and opinions
- Economic and investment advice
- Any other topics unrelated to street photography and fashion

If users ask about these topics, respond with: "I'm sorry, I can only help with street photography and fashion styling questions. Let's talk about fashion and photography! 😊"

Please respond in a friendly, professional tone and provide practical advice. Always respond in English.''';

  final List<Map<String, String>> _conversationHistory = [];

  Future<ChatMessage> sendMessage(String userMessage) async {
    try {
      // 添加用户消息到历史
      _conversationHistory.add({
        'role': 'user',
        'content': userMessage,
      });

      // 构建请求消息列表
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        ..._conversationHistory,
      ];

      // 发送请求到 DeepSeek API
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'deepseek-chat',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 2000,
        },
      );

      // 解析响应
      final aiContent = response.data['choices'][0]['message']['content'] as String;

      // 添加AI响应到历史
      _conversationHistory.add({
        'role': 'assistant',
        'content': aiContent,
      });

      // 限制历史记录长度（保留最近10轮对话）
      if (_conversationHistory.length > 20) {
        _conversationHistory.removeRange(0, _conversationHistory.length - 20);
      }

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.text,
        content: aiContent,
        timestamp: DateTime.now(),
        isUser: false,
      );
    } on DioException catch (e) {
      String errorMessage = 'Sorry, I cannot respond right now. Please try again later.';
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please check your network.';
      } else if (e.response?.statusCode == 401) {
        errorMessage = 'API authentication failed. Please check configuration.';
      } else if (e.response?.statusCode == 429) {
        errorMessage = 'Too many requests. Please try again later.';
      }

      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.text,
        content: errorMessage,
        timestamp: DateTime.now(),
        isUser: false,
      );
    } catch (e) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.text,
        content: 'An error occurred. Please try again later.',
        timestamp: DateTime.now(),
        isUser: false,
      );
    }
  }

  void clearHistory() {
    _conversationHistory.clear();
  }
}
