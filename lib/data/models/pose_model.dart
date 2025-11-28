import 'user_model.dart';

class Pose {
  final String id;
  final String imageUrl;
  final String caption;
  final User author;
  final DateTime timestamp;
  final List<String> tags;
  final int likesCount;

  Pose({
    required this.id,
    required this.imageUrl,
    this.caption = '',
    required this.author,
    required this.timestamp,
    this.tags = const [],
    this.likesCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'caption': caption,
      'author': author.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'tags': tags,
      'likesCount': likesCount,
    };
  }

  factory Pose.fromJson(Map<String, dynamic> json) {
    return Pose(
      id: json['id'],
      imageUrl: json['imageUrl'],
      caption: json['caption'] ?? '',
      author: User.fromJson(json['author']),
      timestamp: DateTime.parse(json['timestamp']),
      tags: List<String>.from(json['tags'] ?? []),
      likesCount: json['likesCount'] ?? 0,
    );
  }
}
