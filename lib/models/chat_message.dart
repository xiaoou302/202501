enum MessageSender { user, ai, system }

class ChatMessage {
  final String id;
  final MessageSender sender;
  final String content;
  final DateTime timestamp;
  final bool isEthicalGuardrail;
  final String? relatedPoemId;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.isEthicalGuardrail = false,
    this.relatedPoemId,
  });
}
