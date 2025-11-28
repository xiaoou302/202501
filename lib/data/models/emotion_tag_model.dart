import 'package:flutter/material.dart';

enum TagType {
  resilience,
  joy,
  frustration,
  reflection,
}

class EmotionTag {
  final String name;
  final Color color;
  final TagType type;

  EmotionTag({
    required this.name,
    required this.color,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color.toARGB32(),
      'type': type.toString(),
    };
  }

  factory EmotionTag.fromJson(Map<String, dynamic> json) {
    return EmotionTag(
      name: json['name'],
      color: Color(json['color']),
      type: TagType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TagType.joy,
      ),
    );
  }
}
