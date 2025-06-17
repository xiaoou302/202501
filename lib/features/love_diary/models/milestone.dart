import 'dart:math';
import '../../../shared/utils/date_utils.dart';

class Milestone {
  final String id;
  final String title;
  final DateTime date;
  final String type; // "birthday", "anniversary", etc.

  Milestone({
    String? id,
    required this.title,
    required this.date,
    required this.type,
  }) : id = id ?? _generateId();

  // 获取剩余天数
  int get daysLeft => AppDateUtils.daysUntil(date);

  // 从JSON创建对象
  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'type': type,
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
