import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color surfaceColor = Color(0xFF1A2238);
  static const Color backgroundColor = Color(0xFF12192D);
  static const Color textColor = Color(0xFFE0E0E0);

  // Accent Colors
  static const Color accentBlue = Color(0xFF4A90E2);
  static const Color accentGreen = Color(0xFF4FC1B9);
  static const Color accentPurple = Color(0xFF9B5DE5);
  static const Color accentPink = Color(0xFFFF6B6B);
  static const Color accentYellow = Color(0xFFFEE440);
  static const Color accentOrange = Color(0xFFD97C29);
  static const Color accentRed = Color(0xFFE53935);

  // Gradients
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2238), Color(0xFF12192D)],
  );

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  // Border Radius
  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(12),
  );

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  // Theme Data
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: surfaceColor,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor),
      ),
      iconTheme: const IconThemeData(color: textColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: buttonRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: textColor),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: surfaceColor,
        contentTextStyle: TextStyle(color: textColor),
      ),
    );
  }
}
