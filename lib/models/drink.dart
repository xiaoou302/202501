import 'dart:convert';
import '../utils/helpers.dart';

class Drink {
  final String name;
  final int volume; // 毫升
  final int caffeine; // 毫克
  final DateTime time;
  final String icon;
  final String category; // 咖啡、茶、能量饮料等

  const Drink({
    required this.name,
    required this.volume,
    required this.caffeine,
    required this.time,
    required this.icon,
    required this.category,
  });

  // 从JSON转换为Drink对象
  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      name: json['name'],
      volume: json['volume'],
      caffeine: json['caffeine'],
      time: DateTime.parse(json['time']),
      icon: json['icon'],
      category: json['category'],
    );
  }

  // 将Drink对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'volume': volume,
      'caffeine': caffeine,
      'time': time.toIso8601String(),
      'icon': icon,
      'category': category,
    };
  }

  // 从JSON字符串列表转换为Drink对象列表
  static List<Drink> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Drink.fromJson(json)).toList();
  }

  // 将Drink对象列表转换为JSON字符串
  static String toJsonList(List<Drink> drinks) {
    final List<Map<String, dynamic>> jsonList =
        drinks.map((drink) => drink.toJson()).toList();
    return json.encode(jsonList);
  }

  // 判断是否为今天的饮品
  bool get isToday => DateTimeHelper.isSameDay(time, DateTime.now());

  // 复制并修改Drink对象
  Drink copyWith({
    String? name,
    int? volume,
    int? caffeine,
    DateTime? time,
    String? icon,
    String? category,
  }) {
    return Drink(
      name: name ?? this.name,
      volume: volume ?? this.volume,
      caffeine: caffeine ?? this.caffeine,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      category: category ?? this.category,
    );
  }
}
