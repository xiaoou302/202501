import 'package:flutter/material.dart';

class AppTheme {
  static const deepBg = Color(0xFF0F111A);
  static const deepSurface = Color(0xFF1E2130);
  static const deepCard = Color(0xFFE2E4E9);
  static const deepRed = Color(0xFFFF5A5F);
  static const deepBlack = Color(0xFF374151);
  static const deepAccent = Color(0xFFF6AD55);
  static const deepSlot = Color(0xFF2A2E3E);
  static const deepBlue = Color(0xFF4FACFE);
  static const deepNeon = Color(0xFF00F0FF);

  // 使用系统字体，避免网络加载问题
  // Orbitron 风格 -> 使用 monospace 字体
  // Inter 风格 -> 使用 sans-serif 字体
  static TextStyle orbitron(TextStyle baseStyle) {
    return baseStyle.copyWith(fontFamily: 'Courier', letterSpacing: 1.2);
  }

  static TextStyle inter(TextStyle baseStyle) {
    return baseStyle.copyWith(fontFamily: '.SF Pro Text');
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepBg,
      primaryColor: deepBlue,
      fontFamily: '.SF Pro Text', // iOS 系统字体
      textTheme: TextTheme(
        displayLarge: orbitron(const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white)),
        displayMedium: orbitron(const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
        titleLarge: orbitron(const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
        titleMedium: orbitron(const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
        bodyLarge: inter(const TextStyle(fontSize: 16, color: Colors.white)),
        bodyMedium: inter(const TextStyle(fontSize: 14, color: Colors.white70)),
      ),
      colorScheme: ColorScheme.dark(
        primary: deepBlue,
        secondary: deepAccent,
        surface: deepSurface,
        error: deepRed,
      ),
    );
  }
}
