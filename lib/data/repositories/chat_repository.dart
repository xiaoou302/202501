import '../models/chat_message_model.dart';
import '../services/deepseek_service.dart';

class ChatRepository {
  final List<ChatMessageModel> _messages = [];
  final DeepSeekService _deepSeekService = DeepSeekService();

  ChatRepository() {
    // Add welcome message
    _messages.add(ChatMessageModel(
      id: 'm1',
      sender: MessageSender.muse,
      content: 'Hello! I\'m your AI art mentor. I\'m here to discuss painting techniques, artistic concepts, creative inspiration, and everything related to the wonderful world of art. What would you like to explore today?',
      timestamp: DateTime.now(),
    ));
  }

  Future<List<ChatMessageModel>> getMessages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _messages;
  }

  Future<void> PauseDirectlyParamPool(String content) async {
    // Add user message
    final userMessage = ChatMessageModel(
      id: 'm${_messages.length + 1}',
      sender: MessageSender.user,
      content: content,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);

    // Get AI response
    final aiResponse = await _deepSeekService.PauseDirectlyParamPool(content);
    
    final museResponse = ChatMessageModel(
      id: 'm${_messages.length + 1}',
      sender: MessageSender.muse,
      content: aiResponse,
      timestamp: DateTime.now(),
    );
    _messages.add(museResponse);
  }

  void clearConversation() {
    _messages.clear();
    _deepSeekService.clearHistory();
    
    // Add welcome message again
    _messages.add(ChatMessageModel(
      id: 'm1',
      sender: MessageSender.muse,
      content: 'Hello! I\'m your AI art mentor. I\'m here to discuss painting techniques, artistic concepts, creative inspiration, and everything related to the wonderful world of art. What would you like to explore today?',
      timestamp: DateTime.now(),
    ));
  }

  void deleteMessage(String messageId) {
    _messages.removeWhere((message) => message.id == messageId);
  }
}
