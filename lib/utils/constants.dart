import 'package:flutter/material.dart';

/// 游戏配色方案
class AppColors {
  // 主色调
  static const Color bgDeepSpaceGray = Color(0xFF333945);
  static const Color uiLightElegantGray = Color(0xFFF5F7FA);

  // 辅助色
  static const Color textMoonWhite = Color(0xFFE8EAF6);
  static const Color textGraphiteGray = Color(0xFF5C6B73);

  // 点缀色
  static const Color accentMintGreen = Color(0xFF76D7C4);

  // 方块颜色
  static const Color blockCoralPink = Color(0xFFF1948A);
  static const Color blockSunnyYellow = Color(0xFFF7DC6F);
  static const Color blockSkyBlue = Color(0xFF85C1E9);
  static const Color blockGrapePurple = Color(0xFFBB8FCE);
  static const Color blockJadeGreen = Color(0xFF7DCEA0);
  static const Color blockTerracottaOrange = Color(0xFFE59866);

  // 奖牌颜色
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
}

/// 尺寸常量
class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 24.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  static const double buttonHeight = 56.0;
}

/// 路由名称
class AppRoutes {
  static const String home = '/';
  static const String levelSelection = '/level_selection';
  static const String game = '/game';
  static const String gameOver = '/game_over';
  static const String leaderboard = '/leaderboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String help = '/help';
}

/// 游戏相关常量
class GameConstants {
  static const int classicGridSize = 6;
  static const int challengeGridSize = 8;
  static const int templateCount = 4;
  static const int maxStars = 3;

  // 关卡解锁要求
  static const int starsToUnlockLevel = 1;

  // 游戏模式
  static const String classicMode = 'classic';
  static const String challengeMode = 'challenge';
}

/// 本地存储键名
class StorageKeys {
  static const String firstRun = 'first_run';
  static const String playerData = 'player_data';
  static const String levelsData = 'levels_data';
  static const String leaderboardData = 'leaderboard_data';
  static const String settings = 'settings';

  // 设置项
  static const String soundEnabled = 'sound_enabled';
  static const String musicEnabled = 'music_enabled';
  static const String colorBlindMode = 'color_blind_mode';
  static const String language = 'language';
}
