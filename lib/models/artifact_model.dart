import 'package:flutter/material.dart';

enum ArtifactType { velocity, eternal, precision, chaos, order }

class ArtifactModel {
  final String id;
  final String name;
  final String description;
  final ArtifactType type;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final List<String> unlockConditions;
  final IconData icon;
  final Color accentColor;

  ArtifactModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.isUnlocked = false,
    this.unlockedAt,
    this.unlockConditions = const [],
    required this.icon,
    required this.accentColor,
  });
}
