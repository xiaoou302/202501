import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppConstants.midnight,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.gold,
        background: AppConstants.midnight,
        surface: AppConstants.surface,
        onPrimary: AppConstants.midnight,
        onBackground: AppConstants.offwhite,
        onSurface: AppConstants.offwhite,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppConstants.offwhite,
        ),
        displayMedium: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppConstants.offwhite,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: AppConstants.offwhite,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppConstants.offwhite,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: AppConstants.metalgray,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.midnight,
        elevation: 0,
      ),
    );
  }
}
