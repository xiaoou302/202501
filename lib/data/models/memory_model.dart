/// 回忆数据模型
class MemoryModel {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime date;
  final List<String> tags;
  final String? description;

  MemoryModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.tags,
    this.description,
  });

  // 从JSON构建模型
  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      date: DateTime.parse(json['date'] as String),
      tags: List<String>.from(json['tags'] as List),
      description: json['description'] as String?,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'tags': tags,
      'description': description,
    };
  }

  // 复制并修改
  MemoryModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    DateTime? date,
    List<String>? tags,
    String? description,
  }) {
    return MemoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MemoryModel &&
        other.id == id &&
        other.title == title &&
        other.imageUrl == imageUrl &&
        other.date == date &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        imageUrl.hashCode ^
        date.hashCode ^
        description.hashCode;
  }
}
