import 'dart:math';

class Cartoon {
  final String id;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  Cartoon({
    String? id,
    required this.description,
    required this.imageUrl,
    DateTime? createdAt,
  }) : id = id ?? _generateId(),
       createdAt = createdAt ?? DateTime.now();

  // 从JSON创建对象
  factory Cartoon.fromJson(Map<String, dynamic> json) {
    return Cartoon(
      id: json['id'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 生成随机ID
  static String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        10,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}
