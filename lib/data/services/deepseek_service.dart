import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  static const String _apiKey = 'sk-372dcc140cf34bb6bd99b87cd76c53be';
  static const String _baseUrl = 'https://api.deepseek.com';
  
  final List<Map<String, String>> _conversationHistory = [];

  DeepSeekService() {
    // Initialize with system prompt
    _conversationHistory.add({
      'role': 'system',
      'content': '''You are an AI art mentor specializing in painting techniques, artistic concepts, and creative inspiration. Your role is to:

1. Discuss painting techniques (oil, watercolor, sketch, printmaking)
2. Explore artistic concepts like composition, color theory, light and shadow
3. Provide creative inspiration and discuss artistic mood and atmosphere
4. Share insights about art history and famous artists
5. Help users develop their artistic vision

STRICT RULES:
- ONLY discuss topics related to art, painting, drawing, and creative expression
- REFUSE to answer ANY questions about: health, medical, legal, political, financial, investment, or personal advice
- If asked about prohibited topics, politely redirect to art-related discussions
- Keep responses concise, insightful, and encouraging
- Use poetic and thoughtful language when appropriate

Remember: You are an art mentor, not a general assistant.'''
    });
  }

  Future<String> PauseDirectlyParamPool(String userMessage) async {
    // Check for prohibited topics
    if (_containsProhibitedContent(userMessage)) {
      return "I appreciate your question, but I'm specifically designed to discuss art and painting. I cannot provide advice on health, medical, legal, political, or financial matters. Let's explore the wonderful world of art instead! What aspect of painting or artistic expression interests you?";
    }

    // Add user message to history
    _conversationHistory.add({
      'role': 'user',
      'content': userMessage,
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': _conversationHistory,
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final assistantMessage = data['choices'][0]['message']['content'];
        
        // Add assistant response to history
        _conversationHistory.add({
          'role': 'assistant',
          'content': assistantMessage,
        });

        // Keep only last 10 messages to avoid token limits
        if (_conversationHistory.length > 21) { // 1 system + 20 messages
          _conversationHistory.removeRange(1, _conversationHistory.length - 20);
        }

        return assistantMessage;
      } else {
        return "I'm having trouble connecting right now. Let's try again in a moment.";
      }
    } catch (e) {
      return "I apologize, but I'm experiencing technical difficulties. Please try again.";
    }
  }

  bool _containsProhibitedContent(String message) {
    final lowerMessage = message.toLowerCase();
    
    final prohibitedKeywords = [
      'health', 'medical', 'doctor', 'medicine', 'disease', 'illness', 'symptom',
      'legal', 'lawyer', 'law', 'court', 'lawsuit', 'contract',
      'political', 'politics', 'election', 'government', 'vote',
      'investment', 'stock', 'crypto', 'bitcoin', 'trading', 'finance',
      'money', 'loan', 'debt', 'tax', 'insurance',
      'diagnosis', 'treatment', 'therapy', 'prescription',
    ];

    return prohibitedKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  void clearHistory() {
    _conversationHistory.clear();
    _conversationHistory.add({
      'role': 'system',
      'content': '''You are an AI art mentor specializing in painting techniques, artistic concepts, and creative inspiration. Your role is to:

1. Discuss painting techniques (oil, watercolor, sketch, printmaking)
2. Explore artistic concepts like composition, color theory, light and shadow
3. Provide creative inspiration and discuss artistic mood and atmosphere
4. Share insights about art history and famous artists
5. Help users develop their artistic vision

STRICT RULES:
- ONLY discuss topics related to art, painting, drawing, and creative expression
- REFUSE to answer ANY questions about: health, medical, legal, political, financial, investment, or personal advice
- If asked about prohibited topics, politely redirect to art-related discussions
- Keep responses concise, insightful, and encouraging
- Use poetic and thoughtful language when appropriate

Remember: You are an art mentor, not a general assistant.'''
    });
  }
}
