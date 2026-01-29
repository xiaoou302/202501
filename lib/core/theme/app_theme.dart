import 'package:flutter/material.dart';
import 'package:oravie/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.snowWhite,
      primaryColor: AppColors.slateGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.slateGreen,
        surface: AppColors.snowWhite,
        onSurface: AppColors.charcoal,
        secondary: AppColors.coolGray,
      ),
      // fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          // fontFamily: 'Playfair Display',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.charcoal,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Playfair Display',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.charcoal,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Playfair Display',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.slateGreen,
        ),
        headlineMedium: TextStyle(
          // fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
        bodyLarge: TextStyle(
          // fontFamily: 'Inter',
          fontSize: 16,
          color: AppColors.charcoal,
        ),
        bodyMedium: TextStyle(
          // fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.charcoal,
        ),
        bodySmall: TextStyle(
          // fontFamily: 'Inter',
          fontSize: 12,
          color: AppColors.coolGray,
        ),
        labelSmall: TextStyle(
          // fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.charcoal, size: 24),
    );
  }
}
