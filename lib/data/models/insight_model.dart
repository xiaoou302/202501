import 'user_model.dart';
import 'emotion_tag_model.dart';

class Insight {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final User author;
  final DateTime timestamp;
  final List<EmotionTag> emotionTags;
  final int readCount;

  Insight({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl = '',
    required this.author,
    required this.timestamp,
    this.emotionTags = const [],
    this.readCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'author': author.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'emotionTags': emotionTags.map((tag) => tag.toJson()).toList(),
      'readCount': readCount,
    };
  }

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'] ?? '',
      author: User.fromJson(json['author']),
      timestamp: DateTime.parse(json['timestamp']),
      emotionTags: (json['emotionTags'] as List?)
              ?.map((tag) => EmotionTag.fromJson(tag))
              .toList() ??
          [],
      readCount: json['readCount'] ?? 0,
    );
  }
}
