import 'package:flutter/material.dart';

/// App color palette based on the Modern & Muted design
class AppColors {
  // Background color
  static const Color background = Color(0xFFF5F5F0); // Linen White/Light Gray

  // Arrow tile colors
  static const Color arrowBlue = Color(0xFF6A8EAE); // Misty Blue
  static const Color arrowTerracotta = Color(0xFFCC7A62); // Terracotta
  static const Color arrowGreen = Color(0xFF78866B); // Olive Green
  static const Color arrowPink = Color(0xFFD3A6A0); // Dusty Pink

  // Text and icon color
  static const Color textGraphite = Color(0xFF4A4A4A); // Graphite Gray

  // Accent/highlight color
  static const Color accentCoral = Color(0xFFFF6F61); // Coral

  // Additional UI colors
  static const Color lightOverlay = Color(0x80FFFFFF); // Semi-transparent white
  static const Color disabledGray = Color(0xFF8A8A8E); // Disabled text color
}

/// Animation durations
class AnimationDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
}

/// UI constants
class UIConstants {
  static const double defaultBorderRadius = 16.0;
  static const double tileBorderRadius = 10.0;
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultShadowBlur = 10.0;
  static const double defaultShadowOffset = 4.0;

  // Game grid constants
  static const int defaultGridSize = 5; // 5x5 grid
  static const double gridGap = 8.0; // Gap between tiles
  static const double gridPadding = 12.0; // Padding around grid
}

/// Text styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textGraphite,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textGraphite,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textGraphite,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16.0,
    color: AppColors.textGraphite,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14.0,
    color: AppColors.disabledGray,
  );
}

/// App routes
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String main = '/main'; // 主导航界面路由
  static const String levelSelect = '/level-select';
  static const String gameScreen = '/game';
  static const String details = '/details';
  static const String achievements = '/achievements';
  static const String settings = '/settings';
  static const String levelValidation = '/level-validation';
  static const String levelCheck = '/level-check';

  // 新增设置相关界面路由
  static const String aboutUs = '/about-us';
  static const String helpCenter = '/help-center';
  static const String feedback = '/feedback';
  static const String contactSupport = '/contact-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
}
