/// 章节模型
class ChapterModel {
  /// 章节标题
  final String title;

  /// 章节内容
  final String content;

  /// 创建时间
  final DateTime createdAt;

  ChapterModel({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  /// 从JSON创建章节
  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// 灵感模型
class IdeaModel {
  /// 唯一标识
  final String id;

  /// 灵感标题
  final String title;

  /// 章节列表
  final List<ChapterModel> chapters;

  /// 标签列表
  final List<String> tags;

  /// 创建时间
  final DateTime createdAt;

  /// 最后更新时间
  final DateTime? updatedAt;

  /// 构造函数
  IdeaModel({
    required this.id,
    required this.title,
    required this.chapters,
    required this.tags,
    required this.createdAt,
    this.updatedAt,
  });

  /// 从JSON创建灵感
  factory IdeaModel.fromJson(Map<String, dynamic> json) {
    return IdeaModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'chapters': chapters.map((e) => e.toJson()).toList(),
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// 复制灵感并修改部分属性
  IdeaModel copyWith({
    String? id,
    String? title,
    List<ChapterModel>? chapters,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IdeaModel(
      id: id ?? this.id,
      title: title ?? this.title,
      chapters: chapters ?? List.from(this.chapters),
      tags: tags ?? List.from(this.tags),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 添加新章节
  IdeaModel addChapter(ChapterModel chapter) {
    return copyWith(
      chapters: [...chapters, chapter],
      updatedAt: DateTime.now(),
    );
  }

  /// 获取最新章节
  ChapterModel? get latestChapter => chapters.isNotEmpty ? chapters.last : null;

  /// 获取章节数
  int get chapterCount => chapters.length;

  /// 验证灵感数据是否有效
  bool isValid() {
    return id.isNotEmpty &&
        title.isNotEmpty &&
        chapters.isNotEmpty &&
        tags.isNotEmpty;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeaModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
