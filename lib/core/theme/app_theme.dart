import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.voidBlack,
      primaryColor: AppColors.floraNeon,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.floraNeon,
        secondary: AppColors.alienPurple,
        tertiary: AppColors.aquaCyan,
        surface: AppColors.deepTeal,
        error: AppColors.toxicityAlert,
        onPrimary: AppColors.voidBlack,
        onSecondary: AppColors.starlightWhite,
        onSurface: AppColors.starlightWhite,
      ),
      cardTheme: CardThemeData(
        color: AppColors.deepTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.starlightWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors
            .deepTeal, // Glass panel effect needed in UI, but here basic
        selectedItemColor: AppColors.floraNeon,
        unselectedItemColor: AppColors.mossMuted,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.starlightWhite,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.starlightWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.starlightWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.starlightWhite, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.mossMuted, fontSize: 14),
        labelLarge: TextStyle(
          color: AppColors.floraNeon,
          fontWeight: FontWeight.bold,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.aquaCyan,
        inactiveTrackColor: AppColors.trenchBlue,
        thumbColor: AppColors.starlightWhite,
        trackHeight: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.trenchBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.mossMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
