import 'package:flutter/material.dart';

/// Virelia应用的主题配置
class AppTheme {
  // 基础与层次 (Foundation & Layers)
  static const Color primaryBackground = Color(
    0xFF121212,
  ); // 深空黑 (Deep Space Black)
  static const Color surfaceBackground = Color(
    0xFF1E1E1E,
  ); // 微光灰 (Subtle Glow Gray)

  // 内容与文本 (Content & Typography)
  static const Color primaryText = Color(0xFFEAEAEA); // 星尘白 (Stardust White)
  static const Color secondaryText = Color(0xFF8A8A8E); // 中性灰 (Neutral Gray)

  // 品牌与交互 (Brand & Interaction)
  static const Color brandBlue = Color(0xFF007AFF); // 宁静蓝 (Serenity Blue)
  static const Color accentOrange = Color(0xFFFF9500); // 活力橙 (Vitality Orange)

  // 系统与反馈 (System & Feedback)
  static const Color successGreen = Color(0xFF34C759); // 常青绿 (Evergreen Green)
  static const Color errorRed = Color(0xFFFF3B30); // 赤晶红 (Crimson Red)

  /// 创建应用的主题数据
  static ThemeData darkTheme() {
    final theme = ThemeData.dark();

    return theme.copyWith(
      scaffoldBackgroundColor: primaryBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: secondaryText),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: primaryText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: primaryText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: primaryText, fontSize: 16),
        bodyMedium: TextStyle(color: primaryText, fontSize: 14),
        bodySmall: TextStyle(color: secondaryText, fontSize: 12),
      ),
      cardColor: surfaceBackground,
      // 不使用cardTheme，改为在各组件中直接定义卡片样式
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBackground,
        hintStyle: const TextStyle(color: secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accentOrange, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentOrange,
          foregroundColor: primaryText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brandBlue,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceBackground,
        selectedItemColor: brandBlue,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      colorScheme: const ColorScheme.dark(
        primary: brandBlue,
        secondary: accentOrange,
        surface: surfaceBackground,
        background: primaryBackground,
        error: errorRed,
      ),
    );
  }
}
