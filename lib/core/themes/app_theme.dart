import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppConstants.ebony,
      primaryColor: AppConstants.theatreRed,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.theatreRed,
        secondary: AppConstants.techBlue,
        surface: AppConstants.graphite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.ebony,
        elevation: 0,
        iconTheme: IconThemeData(color: AppConstants.offWhite),
        titleTextStyle: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppConstants.midGray,
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppConstants.graphite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.theatreRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
    );
  }
}
