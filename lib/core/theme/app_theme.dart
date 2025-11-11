import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppConstants.softCoral,
    scaffoldBackgroundColor: AppConstants.shellWhite,
    colorScheme: const ColorScheme.light(
      primary: AppConstants.softCoral,
      secondary: AppConstants.softCoral,
      surface: AppConstants.panelWhite,
      background: AppConstants.shellWhite,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppConstants.shellWhite,
      foregroundColor: AppConstants.darkGraphite,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppConstants.darkGraphite,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppConstants.panelWhite,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppConstants.darkGraphite,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppConstants.darkGraphite,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppConstants.darkGraphite,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppConstants.darkGraphite,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppConstants.darkGraphite,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppConstants.darkGraphite,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppConstants.darkGraphite),
      bodyMedium: TextStyle(fontSize: 14, color: AppConstants.darkGraphite),
      bodySmall: TextStyle(fontSize: 12, color: AppConstants.mediumGray),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.softCoral,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: AppConstants.softCoral.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppConstants.panelWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: const TextStyle(color: AppConstants.mediumGray, fontSize: 14),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppConstants.softCoral,
    scaffoldBackgroundColor: AppConstants.deepPlum,
    colorScheme: const ColorScheme.dark(
      primary: AppConstants.softCoral,
      secondary: AppConstants.softCoral,
      surface: AppConstants.darkGray,
      background: AppConstants.deepPlum,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppConstants.deepPlum,
      foregroundColor: AppConstants.softWhite,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppConstants.softWhite,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppConstants.darkGray,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppConstants.softWhite,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppConstants.softWhite,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppConstants.softWhite,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppConstants.softWhite,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppConstants.softWhite,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppConstants.softWhite,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppConstants.softWhite),
      bodyMedium: TextStyle(fontSize: 14, color: AppConstants.softWhite),
      bodySmall: TextStyle(fontSize: 12, color: AppConstants.mediumGray),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.softCoral,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: AppConstants.softCoral.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppConstants.darkGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: const TextStyle(color: AppConstants.mediumGray, fontSize: 14),
    ),
  );
}
