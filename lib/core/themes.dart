import 'package:flutter/material.dart';
import 'constants.dart';

class AppThemes {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.inkGreen,
      primaryColor: AppColors.antiqueGold,
      fontFamily: 'serif',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: AppColors.antiqueGold,
          letterSpacing: 2,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.ivory,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.ivory,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.ivory,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ivory,
          foregroundColor: AppColors.inkGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
        ),
      ),
    );
  }
}
