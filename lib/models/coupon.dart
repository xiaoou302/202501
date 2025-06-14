import 'dart:convert';
import '../utils/helpers.dart';

class Coupon {
  final String title;
  final String description;
  final DateTime expiryDate;
  final String category; // 餐饮、购物、旅行等
  final String iconName;
  final bool isUsed;
  final String? barcode; // 优惠券条形码或二维码数据

  const Coupon({
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.category,
    required this.iconName,
    this.isUsed = false,
    this.barcode,
  });

  // 从JSON转换为Coupon对象
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      title: json['title'],
      description: json['description'],
      expiryDate: DateTime.parse(json['expiryDate']),
      category: json['category'],
      iconName: json['iconName'],
      isUsed: json['isUsed'] ?? false,
      barcode: json['barcode'],
    );
  }

  // 将Coupon对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'expiryDate': expiryDate.toIso8601String(),
      'category': category,
      'iconName': iconName,
      'isUsed': isUsed,
      'barcode': barcode,
    };
  }

  // 从JSON字符串列表转换为Coupon对象列表
  static List<Coupon> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Coupon.fromJson(json)).toList();
  }

  // 将Coupon对象列表转换为JSON字符串
  static String toJsonList(List<Coupon> coupons) {
    final List<Map<String, dynamic>> jsonList =
        coupons.map((coupon) => coupon.toJson()).toList();
    return json.encode(jsonList);
  }

  // 判断优惠券是否已过期
  bool get isExpired {
    final now = DateTime.now();
    return expiryDate.isBefore(now);
  }

  // 判断优惠券是否即将到期（7天内）
  bool get isExpiringSoon {
    final now = DateTime.now();
    final daysToExpiry = DateTimeHelper.daysBetween(now, expiryDate);
    return daysToExpiry >= 0 && daysToExpiry <= 7;
  }

  // 获取到期天数
  int get daysToExpiry {
    final now = DateTime.now();
    return DateTimeHelper.daysBetween(now, expiryDate);
  }

  // 复制并修改Coupon对象
  Coupon copyWith({
    String? title,
    String? description,
    DateTime? expiryDate,
    String? category,
    String? iconName,
    bool? isUsed,
    String? barcode,
  }) {
    return Coupon(
      title: title ?? this.title,
      description: description ?? this.description,
      expiryDate: expiryDate ?? this.expiryDate,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
      isUsed: isUsed ?? this.isUsed,
      barcode: barcode ?? this.barcode,
    );
  }
}
