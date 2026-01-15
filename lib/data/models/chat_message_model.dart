enum MessageSender {
  user,
  muse,
}

class ChatMessageModel {
  final String id;
  final MessageSender sender;
  final String content;
  final DateTime timestamp;

  ChatMessageModel({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toString(),
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      sender: json['sender'] == 'MessageSender.user'
          ? MessageSender.user
          : MessageSender.muse,
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
