import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

/// Theme configuration for the Jongara app
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme for the app
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.carvedJadeGreen,
        primary: AppColors.carvedJadeGreen,
        onPrimary: AppColors.xuanPaperWhite,
        secondary: AppColors.beeswaxAmber,
        onSecondary: AppColors.xuanPaperWhite,
        surface: AppColors.birchWood,
        onSurface: AppColors.ebonyBrown,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.xuanPaperWhite,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.ebonyBrown,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.ebonyBrown,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.ebonyBrown,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.ebonyBrown,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.ebonyBrown),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.ebonyBrown),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.carvedJadeGreen,
          foregroundColor: AppColors.xuanPaperWhite,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 4,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.carvedJadeGreen,
          side: BorderSide(color: AppColors.carvedJadeGreen),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.carvedJadeGreen),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.xuanPaperWhite,
        foregroundColor: AppColors.ebonyBrown,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      iconTheme: IconThemeData(color: AppColors.ebonyBrown),
    );
  }

  /// Custom button styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.carvedJadeGreen,
    foregroundColor: AppColors.xuanPaperWhite,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    elevation: 4,
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.beeswaxAmber,
    foregroundColor: AppColors.xuanPaperWhite,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    elevation: 2,
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );

  static ButtonStyle get levelButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.birchWood,
    foregroundColor: AppColors.ebonyBrown,
    minimumSize: const Size(64, 64),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  );
}
