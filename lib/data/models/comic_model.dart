/// 漫画风格枚举
enum ComicStyle {
  /// 赛博朋克
  cyberpunk,

  /// 奇幻
  fantasy,

  /// 科幻
  sciFi,

  /// 现代
  modern,

  /// 其他
  other,
}

/// 漫画模型
class ComicModel {
  /// 唯一标识
  final String id;

  /// 漫画标题
  final String title;

  /// 剧情描述
  final String plot;

  /// 漫画风格
  final ComicStyle style;

  /// 漫画格数 (2-4)
  final int panelCount;

  /// 生成的漫画图片URL列表
  final List<String> imageUrls;

  /// 创建时间
  final DateTime createdAt;

  /// 构造函数
  ComicModel({
    required this.id,
    required this.title,
    required this.plot,
    required this.style,
    required this.panelCount,
    required this.imageUrls,
    required this.createdAt,
  });

  /// 从JSON创建漫画
  factory ComicModel.fromJson(Map<String, dynamic> json) {
    return ComicModel(
      id: json['id'] as String,
      title: json['title'] as String,
      plot: json['plot'] as String,
      style: ComicStyle.values[json['style'] as int],
      panelCount: json['panelCount'] as int,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'plot': plot,
      'style': style.index,
      'panelCount': panelCount,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 复制漫画并修改部分属性
  ComicModel copyWith({
    String? id,
    String? title,
    String? plot,
    ComicStyle? style,
    int? panelCount,
    List<String>? imageUrls,
    DateTime? createdAt,
  }) {
    return ComicModel(
      id: id ?? this.id,
      title: title ?? this.title,
      plot: plot ?? this.plot,
      style: style ?? this.style,
      panelCount: panelCount ?? this.panelCount,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
