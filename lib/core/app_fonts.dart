import 'package:flutter/material.dart';

/// 字体辅助类 - 使用系统字体替代 Google Fonts
/// 避免网络加载问题，提升应用启动速度
class AppFonts {
  // Orbitron 风格 - 使用等宽字体模拟科技感
  static TextStyle orbitron({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    List<Shadow>? shadows,
  }) {
    return TextStyle(
      fontFamily: 'Courier',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing ?? 1.2,
      height: height,
      shadows: shadows,
    );
  }

  // Inter 风格 - 使用系统默认字体
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    List<Shadow>? shadows,
  }) {
    return TextStyle(
      fontFamily: '.SF Pro Text', // iOS 系统字体
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      shadows: shadows,
    );
  }
}
