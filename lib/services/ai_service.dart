import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class AIService {
  static const String _apiKey = 'sk-4015e2c5af5d4470a3dc53d1c6abe1dc';
  static const String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';
  
  final List<Map<String, String>> _conversationHistory = [];
  
  // System prompt that defines AI's role and ethical boundaries
  static const String _systemPrompt = '''You are a poetic guide and mentor in the Zina poetry community app. Your role is to inspire, educate, and guide poets in their creative journey.

CORE PRINCIPLES:
1. NEVER write complete poems for users - this is their creative journey
2. Guide through questions, imagery exploration, and technique discussion
3. Provide constructive feedback on their work
4. Teach poetic devices: metaphor, imagery, rhythm, rhyme schemes
5. Help them find their unique voice

ETHICAL BOUNDARIES - You MUST refuse these requests:
- "Write a poem for me"
- "Write my homework"
- "Complete this poem for me"
- "Generate a poem about..."
- Any request asking you to create full poems

WHEN REFUSING:
- Be kind but firm
- Explain why the creative process matters
- Offer alternative guidance (imagery exploration, technique discussion)
- Suggest specific questions or exercises

WHAT YOU CAN DO:
- Discuss imagery and symbolism
- Analyze poetic techniques
- Suggest improvements to their drafts
- Explore themes and emotions
- Teach about meter, rhyme, and structure
- Provide writing prompts and exercises
- Discuss famous poems and poets

Keep responses concise, warm, and encouraging. Use poetic language yourself to inspire.''';

  Future<ChatMessage> sendMessage(String userMessage, {List<ChatMessage>? context}) async {
    // Check for direct write requests first
    if (_detectDirectWriteRequest(userMessage.toLowerCase())) {
      return _createEthicalGuardrailResponse();
    }

    try {
      // Build conversation history
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        ..._conversationHistory,
        {'role': 'user', 'content': userMessage},
      ];

      // Make API request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 800,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'] as String;

        // Update conversation history
        _conversationHistory.add({'role': 'user', 'content': userMessage});
        _conversationHistory.add({'role': 'assistant', 'content': aiResponse});

        // Keep only last 10 messages to manage context size
        if (_conversationHistory.length > 20) {
          _conversationHistory.removeRange(0, _conversationHistory.length - 20);
        }

        return ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: MessageSender.ai,
          content: aiResponse,
          timestamp: DateTime.now(),
        );
      } else {
        throw Exception('API request failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: MessageSender.ai,
        content: 'I apologize, but I\'m having trouble connecting right now. Please try again in a moment.\n\nError: ${e.toString()}',
        timestamp: DateTime.now(),
      );
    }
  }

  bool _detectDirectWriteRequest(String content) {
    final keywords = [
      'write for me',
      'write a poem',
      'write me a',
      'can you write',
      'help me write my homework',
      'do my homework',
      'write my assignment',
      'generate a poem',
      'create a poem',
      'compose a poem',
      'make a poem',
      'give me a poem',
    ];
    return keywords.any((keyword) => content.contains(keyword));
  }

  ChatMessage _createEthicalGuardrailResponse() {
    final responses = [
      'I cannot write the poem for you, as the creative journey must be yours alone.\n\nHowever, I can help you explore techniques, imagery, and structure. What specific aspect would you like guidance on?',
      'The epiphany must be yours, not mine. I\'m here to guide, not to replace your voice.\n\nLet\'s work together: What emotion or scene are you trying to capture? I can help you find the right imagery.',
      'Writing poetry is like learning to swim - I can teach you the strokes, but you must feel the water yourself.\n\nWhat\'s the core feeling or image you want to express? Let\'s explore it together.',
    ];
    
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.ai,
      content: responses[DateTime.now().millisecond % responses.length],
      timestamp: DateTime.now(),
      isEthicalGuardrail: true,
    );
  }

  void clearHistory() {
    _conversationHistory.clear();
  }

  int get messageCount => _conversationHistory.length ~/ 2;
}
