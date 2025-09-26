/// 社区帖子数据模型
class CommunityPostModel {
  final String id;
  final String author;
  final String title;
  final String content;
  final int replyCount;
  final int likeCount;
  final DateTime createdAt;
  final List<String> tags;

  CommunityPostModel({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    this.replyCount = 0,
    this.likeCount = 0,
    required this.createdAt,
    this.tags = const [],
  });

  // 从JSON构建模型
  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'] as String,
      author: json['author'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      replyCount: json['replyCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'content': content,
      'replyCount': replyCount,
      'likeCount': likeCount,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
    };
  }

  // 复制并修改
  CommunityPostModel copyWith({
    String? id,
    String? author,
    String? title,
    String? content,
    int? replyCount,
    int? likeCount,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return CommunityPostModel(
      id: id ?? this.id,
      author: author ?? this.author,
      title: title ?? this.title,
      content: content ?? this.content,
      replyCount: replyCount ?? this.replyCount,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommunityPostModel &&
        other.id == id &&
        other.author == author &&
        other.title == title &&
        other.content == content;
  }

  @override
  int get hashCode {
    return id.hashCode ^ author.hashCode ^ title.hashCode ^ content.hashCode;
  }
}
