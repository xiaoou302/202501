import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum AchievementType {
  eagleEye,      // 鹰眼：完美通关（无错误）
  speedster,     // 光速：剩余时间>80%
  persistence,   // 坚持不懈：累计失败10次后通关
  memoryMaster,  // 记忆大师：完成所有6×6难度
}

class AchievementModel {
  final AchievementType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  bool isUnlocked;

  AchievementModel({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
  });

  static List<AchievementModel> get allAchievements => [
        AchievementModel(
          type: AchievementType.eagleEye,
          name: 'Eagle Eye',
          description: 'Perfect clear with no mistakes',
          icon: FontAwesomeIcons.eye,
          color: const Color(0xFF00CEC9),
        ),
        AchievementModel(
          type: AchievementType.speedster,
          name: 'Speedster',
          description: 'Complete with >80% time remaining',
          icon: FontAwesomeIcons.bolt,
          color: const Color(0xFFF1C40F),
        ),
        AchievementModel(
          type: AchievementType.persistence,
          name: 'Persistence',
          description: 'Win after 10+ failures',
          icon: FontAwesomeIcons.trophy,
          color: const Color(0xFFE67E22),
        ),
        AchievementModel(
          type: AchievementType.memoryMaster,
          name: 'Memory Master',
          description: 'Complete any 6×6 level',
          icon: FontAwesomeIcons.brain,
          color: const Color(0xFF9B59B6),
        ),
      ];
}

