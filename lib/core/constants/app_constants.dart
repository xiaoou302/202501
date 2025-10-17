import 'package:flutter/material.dart';

/// App-wide constants for the Jongara game
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// Maximum number of tiles in the hand
  static const int maxHandSize = 7;

  /// App name
  static const String appName = 'Jongara';

  /// App subtitle
  static const String appSubtitle = 'Strategy in Every Tile';
}

/// Color constants based on the "Warm Wood, Carved Jade" palette
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color xuanPaperWhite = Color(0xFFF5F0E6); // Main background
  static const Color ebonyBrown = Color(0xFF5C5249); // Main text/UI icons
  static const Color carvedJadeGreen = Color(
    0xFF527D6E,
  ); // Primary interactive elements

  // Secondary Colors
  static const Color birchWood = Color(0xFFDCD1C0); // Card backgrounds
  static const Color beeswaxAmber = Color(0xFFE8A866); // Accents, power-ups

  // Mahjong Tile Colors
  static const Color mahjongRed = Color(0xFFD32F2F); // Red characters
  static const Color mahjongBlue = Color(0xFF1976D2); // Blue elements
  static const Color mahjongGreen = Color(0xFF43A047); // Bamboo/tiao suit
}

/// UI sizing constants
class UISizes {
  // Private constructor to prevent instantiation
  UISizes._();

  static const double tileSizeWidth = 48.0;
  static const double tileSizeHeight = 68.0;
  static const double tileOverlapFactor = 0.7; // How much tiles overlap
  static const double handTileScale = 0.8; // Scale factor for tiles in hand

  // 根据关卡级别的缩放因子 (iPhone)
  static const double boardScaleFactorEasy = 1.35; // 1-3关卡 (35% 放大)
  static const double boardScaleFactorMedium = 1.25; // 4-7关卡 (25% 放大)
  static const double boardScaleFactorHard = 1.15; // 8-12关卡 (15% 放大)

  // iPad专用缩放因子 (进一步增加40%)
  static const double ipadBoardScaleFactorEasy = 2.31; // 1-3关卡 (131% 放大)
  static const double ipadBoardScaleFactorMedium = 2.17; // 4-7关卡 (117% 放大)
  static const double ipadBoardScaleFactorHard = 2.03; // 8-12关卡 (103% 放大)
}

/// Animation durations
class AnimationDurations {
  // Private constructor to prevent instantiation
  AnimationDurations._();

  static const Duration tileSelect = Duration(milliseconds: 300);
  static const Duration tileMatch = Duration(milliseconds: 500);
  static const Duration screenTransition = Duration(milliseconds: 300);
}
