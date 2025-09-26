import 'package:flutter/material.dart';

/// 应用主题定义
class AppTheme {
  // 颜色方案 - "星夜鎏金" 主题
  static const Color deepSpace = Color(0xFF1C1C22); // 深空灰 - 主背景色
  static const Color champagne = Color(0xFFD3B88C); // 香槟金 - 主强调色
  static const Color moonlight = Color(0xFFEAEAEA); // 月光白 - 主文本色
  static const Color silverstone = Color(0xFF3A3A42); // 银石灰 - 辅助灰色
  static const Color coral = Color(0xFFE87A90); // 珊瑚粉 - 点缀色

  // 明亮主题
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: champagne,
        onPrimary: deepSpace,
        secondary: coral,
        onSecondary: Colors.white,
        surface: Colors.white,
        surfaceTint: Colors.grey[100]!,
        error: Colors.red[700]!,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: champagne,
        foregroundColor: deepSpace,
        elevation: 0,
      ),
      textTheme: _buildTextTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
    );
  }

  // 暗黑主题
  static ThemeData darkTheme() {
    final theme = ThemeData.dark(useMaterial3: true);
    return theme.copyWith(
      colorScheme: ColorScheme.dark(
        primary: champagne,
        onPrimary: deepSpace,
        secondary: coral,
        onSecondary: Colors.white,
        surface: silverstone,
        surfaceTint: deepSpace,
        error: Colors.red[300]!,
      ),
      scaffoldBackgroundColor: deepSpace,
      appBarTheme: const AppBarTheme(
        backgroundColor: deepSpace,
        foregroundColor: moonlight,
        elevation: 0,
      ),
      textTheme: _buildTextTheme(isDark: true),
      elevatedButtonTheme: _buildElevatedButtonTheme(isDark: true),
      inputDecorationTheme: _buildInputDecorationTheme(isDark: true),
      cardColor: silverstone,
      cardTheme: theme.cardTheme.copyWith(
        color: silverstone,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  // 构建文本主题
  static TextTheme _buildTextTheme({bool isDark = false}) {
    final Color textColor = isDark ? moonlight : deepSpace;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textColor),
      bodyMedium: TextStyle(fontSize: 14, color: textColor),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? champagne : deepSpace,
      ),
    );
  }

  // 构建按钮主题
  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    bool isDark = false,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: champagne,
        foregroundColor: deepSpace,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  // 构建输入框主题
  static InputDecorationTheme _buildInputDecorationTheme({
    bool isDark = false,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? silverstone : Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: champagne, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
