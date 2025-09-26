/// 网友分享的幸福时刻模型
class SharedMemoryModel {
  final String id;
  final String imageAsset; // 图片资源路径
  final String title;
  final String content;
  final String author;
  final int likeCount;
  bool isLiked; // 当前用户是否点赞

  SharedMemoryModel({
    required this.id,
    required this.imageAsset,
    required this.title,
    required this.content,
    required this.author,
    this.likeCount = 0,
    this.isLiked = false,
  });

  // 从JSON构建模型
  factory SharedMemoryModel.fromJson(Map<String, dynamic> json) {
    return SharedMemoryModel(
      id: json['id'] as String,
      imageAsset: json['imageAsset'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      likeCount: json['likeCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageAsset': imageAsset,
      'title': title,
      'content': content,
      'author': author,
      'likeCount': likeCount,
      'isLiked': isLiked,
    };
  }

  // 复制并修改
  SharedMemoryModel copyWith({
    String? id,
    String? imageAsset,
    String? title,
    String? content,
    String? author,
    int? likeCount,
    bool? isLiked,
  }) {
    return SharedMemoryModel(
      id: id ?? this.id,
      imageAsset: imageAsset ?? this.imageAsset,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
