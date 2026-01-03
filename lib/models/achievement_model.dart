import 'package:flutter/material.dart';

enum AchievementCategory {
  beginner,
  master,
  speed,
  perfect,
  special,
}

enum AchievementRarity {
  common,
  rare,
  epic,
  legendary,
}

class AchievementModel {
  final String id;
  final String name;
  final String description;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final IconData icon;
  final Color color;
  final int points;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0
  final String requirement;
  final int currentValue;
  final int targetValue;

  AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rarity,
    required this.icon,
    required this.color,
    required this.points,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    required this.requirement,
    this.currentValue = 0,
    this.targetValue = 1,
  });

  AchievementModel copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
    int? currentValue,
  }) {
    return AchievementModel(
      id: id,
      name: name,
      description: description,
      category: category,
      rarity: rarity,
      icon: icon,
      color: color,
      points: points,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      requirement: requirement,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue,
    );
  }
}
