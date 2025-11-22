import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.midnight,
      colorScheme: ColorScheme.dark(
        primary: AppColors.electric,
        secondary: AppColors.mint,
        surface: AppColors.slate,
        background: AppColors.midnight,
        error: AppColors.danger,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodySmall,
        labelSmall: AppTextStyles.label,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}

class AppTextStyles {
  // Headers - System font with tech feel
  static const TextStyle h1 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.mica,
    letterSpacing: 2.0,
    fontFamily: '.SF Pro Display', // iOS system font, falls back on Android
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.mica,
    letterSpacing: 1.5,
    fontFamily: '.SF Pro Display',
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.mica,
    letterSpacing: 1.2,
    fontFamily: '.SF Pro Display',
  );

  // Body Text - System font
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.mica,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Labels - System font
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
    fontFamily: '.SF Pro Display',
  );

  // Stats/Numbers - System font
  static const TextStyle stat = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.mica,
    fontFamily: '.SF Pro Display',
  );
}
