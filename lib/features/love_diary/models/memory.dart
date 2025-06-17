import 'dart:math';

class Memory {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final List<String> imageUrls;

  Memory({
    String? id,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrls = const [],
  }) : id = id ?? _generateId();

  // 从JSON创建对象
  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imageUrls': imageUrls,
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
