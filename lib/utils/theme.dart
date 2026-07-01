import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.peachFuzz,
      scaffoldBackgroundColor: AppColors.pageBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.cocoaBrown),
        titleTextStyle: TextStyle(
          color: AppColors.cocoaBrown,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.peachFuzz,
        secondary: AppColors.seafoam,
        surface: AppColors.creamWhite,
        background: AppColors.pageBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.cocoaBrown,
        onBackground: AppColors.cocoaBrown,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.cocoaBrown,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.cocoaBrown,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: AppColors.cocoaBrown),
        bodyMedium: TextStyle(color: AppColors.chestnutGray),
      ),
      cardTheme: CardThemeData(
        color: AppColors.creamWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.warmGauze, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.peachFuzz,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.creamWhite,
        selectedItemColor: AppColors.peachFuzz,
        unselectedItemColor: AppColors.chestnutGray,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      useMaterial3: true,
    );
  }
}
