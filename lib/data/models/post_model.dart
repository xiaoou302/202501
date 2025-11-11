class Post {
  final String id;
  final String userId;
  final String? petId;
  final String content;
  final List<String> imageUrls;
  final List<String> tags;
  final int likes;
  final int comments;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    this.petId,
    required this.content,
    this.imageUrls = const [],
    this.tags = const [],
    this.likes = 0,
    this.comments = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'petId': petId,
      'content': content,
      'imageUrls': imageUrls,
      'tags': tags,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['userId'] as String,
      petId: json['petId'] as String?,
      content: json['content'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
