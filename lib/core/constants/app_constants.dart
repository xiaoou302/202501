import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/models/level_model.dart';

// Application Colors
class AppColors {
  // Backgrounds
  static const Color midnight = Color(0xFF1A1D26);
  static const Color slate = Color(0xFF353B48);

  // Brand Colors
  static const Color electric = Color(0xFF6C5CE7);
  static const Color mint = Color(0xFF00CEC9);

  // Text
  static const Color mica = Color(0xFFDFE6E9);
  static const Color textSecondary = Color(0xFF95A5A6);

  // Status Colors
  static const Color danger = Color(0xFFFF4757);
  static const Color success = Color(0xFF00CEC9);

  // Opacity Variants
  static Color overlay = midnight.withOpacity(0.95);
  static Color cardOverlay = slate.withOpacity(0.3);
}

// Card Icon Colors - Nature & Animals Theme
class CardColors {
  static const List<Color> neonColors = [
    Color(0xFF2ECC71), // Forest Green - 森林绿
    Color(0xFF3498DB), // Sky Blue - 天空蓝
    Color(0xFFE67E22), // Sunset Orange - 日落橙
    Color(0xFFE74C3C), // Rose Red - 玫瑰红
    Color(0xFF9B59B6), // Lavender Purple - 薰衣草紫
    Color(0xFFF1C40F), // Sunflower Yellow - 向日葵黄
    Color(0xFF1ABC9C), // Ocean Turquoise - 海洋青
    Color(0xFFE67E73), // Coral Pink - 珊瑚粉
    Color(0xFF16A085), // Deep Teal - 深青色
    Color(0xFFF39C12), // Amber Gold - 琥珀金
    Color(0xFF8E44AD), // Violet - 紫罗兰
    Color(0xFF27AE60), // Grass Green - 草绿色
    Color(0xFF2980B9), // Ocean Blue - 海洋蓝
    Color(0xFFD35400), // Pumpkin Orange - 南瓜橙
    Color(0xFFC0392B), // Crimson - 深红色
    Color(0xFF00CEC9), // Mint - 薄荷色
  ];
}

// Game Icons - Nature & Animals Theme
class GameIcons {
  static const List<IconData> icons = [
    // Animals
    FontAwesomeIcons.dog,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.crow,
    FontAwesomeIcons.fish,
    FontAwesomeIcons.frog,
    FontAwesomeIcons.dragon,
    FontAwesomeIcons.dove,
    FontAwesomeIcons.horse,
    FontAwesomeIcons.hippo,
    FontAwesomeIcons.otter,
    FontAwesomeIcons.spider,
    FontAwesomeIcons.shrimp,
    // Nature Elements
    FontAwesomeIcons.tree,
    FontAwesomeIcons.leaf,
    FontAwesomeIcons.seedling,
    FontAwesomeIcons.clover,
    FontAwesomeIcons.cloudSun,
    FontAwesomeIcons.cloudMoon,
    FontAwesomeIcons.snowflake,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.droplet,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.mountain,
    FontAwesomeIcons.volcano,
    FontAwesomeIcons.water,
    FontAwesomeIcons.wind,
    FontAwesomeIcons.sun,
    FontAwesomeIcons.moon,
    FontAwesomeIcons.star,
    FontAwesomeIcons.rainbow,
  ];
}

// Level Configuration (12 Levels - Progressive Difficulty)
class GameLevels {
  static const List<LevelModel> levels = [
    // 入门阶段 (Easy) - Levels 1-3
    LevelModel(
      id: 1,
      name: 'Departure',
      rows: 3,
      cols: 4,
      time: 60,
      pairs: 6,
      hasObservation: true,
    ),
    LevelModel(
      id: 2,
      name: 'Explorer',
      rows: 4,
      cols: 4,
      time: 75,
      pairs: 8,
      hasObservation: true,
    ),
    LevelModel(
      id: 3,
      name: 'Awakening',
      rows: 4,
      cols: 5,
      time: 90,
      pairs: 10,
      hasObservation: true,
    ),

    // 进阶阶段 (Medium) - Levels 4-6
    LevelModel(
      id: 4,
      name: 'Deep Dive',
      rows: 5,
      cols: 5,
      time: 100,
      pairs: 12,
      hasObservation: true,
    ),
    LevelModel(
      id: 5,
      name: 'Labyrinth',
      rows: 5,
      cols: 6,
      time: 110,
      pairs: 15,
      hasObservation: true,
    ),
    LevelModel(
      id: 6,
      name: 'Abyss',
      rows: 6,
      cols: 6,
      time: 120,
      pairs: 18,
      hasObservation: true,
    ),

    // 高级阶段 (Hard) - Levels 7-9
    // 从这里开始通过减少时间来增加难度
    LevelModel(
      id: 7,
      name: 'Trial',
      rows: 6,
      cols: 6,
      time: 100,
      pairs: 18,
      hasObservation: true,
    ),
    LevelModel(
      id: 8,
      name: 'Extreme',
      rows: 6,
      cols: 6,
      time: 90,
      pairs: 18,
      hasObservation: true,
    ),
    LevelModel(
      id: 9,
      name: 'Storm',
      rows: 6,
      cols: 6,
      time: 80,
      pairs: 18,
      hasObservation: true,
    ),

    // 大师阶段 (Expert) - Levels 10-12
    // 终极挑战，时间更短
    LevelModel(
      id: 10,
      name: 'Inferno',
      rows: 6,
      cols: 6,
      time: 70,
      pairs: 18,
      hasObservation: true,
    ),
    LevelModel(
      id: 11,
      name: 'Nightmare',
      rows: 6,
      cols: 6,
      time: 60,
      pairs: 18,
      hasObservation: true,
    ),
    LevelModel(
      id: 12,
      name: 'Legend',
      rows: 6,
      cols: 6,
      time: 50,
      pairs: 18,
      hasObservation: true,
    ),
  ];
}

// Scoring Rules
class ScoringRules {
  static const int baseMatchPoints = 100;
  static const int comboMultiplier = 50;
  static const int timeBonus = 10;

  static int calculateMatchScore(int comboStreak) {
    int baseScore = baseMatchPoints;
    int comboBonus = (comboStreak > 1)
        ? (comboStreak - 1) * comboMultiplier
        : 0;
    return baseScore + comboBonus;
  }

  static int calculateFinalScore(int matchScore, int timeRemaining) {
    return matchScore + (timeRemaining * timeBonus);
  }
}

// Star Rating
class StarRating {
  static int calculateStars(int timeLeft, int totalTime) {
    double percentage = (timeLeft / totalTime) * 100;

    if (percentage > 50) return 3;
    if (percentage > 20) return 2;
    return 1;
  }
}

// Border Radius
class AppRadius {
  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius large = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(24));

  static const BorderRadius card = BorderRadius.all(Radius.circular(12));
  static const BorderRadius button = BorderRadius.all(Radius.circular(12));
  static const BorderRadius modal = BorderRadius.all(Radius.circular(24));
}

// Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// Animation Durations
class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration cardFlip = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 800);
}

// Shadows
class AppShadows {
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> glowMint = [
    BoxShadow(
      color: AppColors.mint.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> glowElectric = [
    BoxShadow(
      color: AppColors.electric.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}
