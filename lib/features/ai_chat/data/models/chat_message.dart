enum MessageType { text, imageQuery, suggestion }

class ChatMessage {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final bool isUser;
  final List<String>? suggestedImageUrls;

  ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    required this.isUser,
    this.suggestedImageUrls,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      type: MessageType.values.byName(json['type'] as String),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUser: json['isUser'] as bool,
      suggestedImageUrls: (json['suggestedImageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isUser': isUser,
      'suggestedImageUrls': suggestedImageUrls,
    };
  }
}
