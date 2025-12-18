class Poem {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String authorAvatarUrl;
  final String? imageUrl;
  final DateTime createdAt;
  int likes;
  final List<String> tags;
  bool isLiked;
  bool isBookmarked;

  Poem({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarUrl,
    this.imageUrl,
    required this.createdAt,
    this.likes = 0,
    this.tags = const [],
    this.isLiked = false,
    this.isBookmarked = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'authorId': authorId,
    'authorName': authorName,
    'authorAvatarUrl': authorAvatarUrl,
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
    'likes': likes,
    'tags': tags,
    'isLiked': isLiked,
    'isBookmarked': isBookmarked,
  };

  factory Poem.fromJson(Map<String, dynamic> json) => Poem(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    authorId: json['authorId'],
    authorName: json['authorName'],
    authorAvatarUrl: json['authorAvatarUrl'],
    imageUrl: json['imageUrl'],
    createdAt: DateTime.parse(json['createdAt']),
    likes: json['likes'] ?? 0,
    tags: List<String>.from(json['tags'] ?? []),
    isLiked: json['isLiked'] ?? false,
    isBookmarked: json['isBookmarked'] ?? false,
  );
}
