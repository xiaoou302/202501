import 'package:flutter/material.dart';

/// Settings item model representing a settings menu item
class SettingsItem {
  final String title;
  final IconData icon;
  final String route; // Navigation route
  final Color iconColor;

  const SettingsItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.iconColor,
  });

  factory SettingsItem.fromJson(Map<String, dynamic> json) {
    return SettingsItem(
      title: json['title'] as String,
      icon: IconData(json['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
      route: json['route'] as String,
      iconColor: Color(json['iconColor'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'iconCodePoint': icon.codePoint,
      'route': route,
      'iconColor': iconColor.value,
    };
  }
}
