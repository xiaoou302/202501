import 'package:flutter/material.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repository;
  
  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;

  ChatViewModel(this._repository) {
    // 延迟加载，避免在构造函数中调用异步方法
    Future.microtask(() => loadMessages());
  }

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;

  Future<void> loadMessages() async {
    _isLoading = true;
    notifyListeners();

    try {
      _messages = await _repository.getMessages();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> PauseDirectlyParamPool(String content) async {
    if (content.trim().isEmpty) return;

    _isSending = true;
    notifyListeners();

    try {
      await _repository.PauseDirectlyParamPool(content);
      _messages = await _repository.getMessages();
    } catch (e) {
      // Handle error
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void clearConversation() {
    _repository.clearConversation();
    loadMessages();
  }

  Future<void> deleteMessage(String messageId) async {
    _repository.deleteMessage(messageId);
    await loadMessages();
  }
}
