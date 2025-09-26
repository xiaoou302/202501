/// 热门话题模型
class HotTopicModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int popularity;
  final bool isNew;

  HotTopicModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.popularity = 0,
    this.isNew = false,
  });

  // 从JSON构建模型
  factory HotTopicModel.fromJson(Map<String, dynamic> json) {
    return HotTopicModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      popularity: json['popularity'] as int? ?? 0,
      isNew: json['isNew'] as bool? ?? false,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'popularity': popularity,
      'isNew': isNew,
    };
  }

  // 复制并修改
  HotTopicModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? popularity,
    bool? isNew,
  }) {
    return HotTopicModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      popularity: popularity ?? this.popularity,
      isNew: isNew ?? this.isNew,
    );
  }
}
