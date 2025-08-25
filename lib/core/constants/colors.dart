import 'package:flutter/material.dart';

/// 游戏的颜色常量
class AppColors {
  // 主题颜色
  static const primaryDark = Color(0xFF0A192F); // 深邃星空蓝 - 主背景色
  static const primaryAccent = Color(0xFF00F5D4); // 赛博青色 - 主强调色
  static const secondaryAccent = Color(0xFFFF00F7); // 霓虹粉 - 次强调色
  static const textColor = Color(0xFFE6F1FF); // 柔和白 - 文本色

  // 游戏单元颜色
  static const red = Color(0xFFFF5252);
  static const green = Color(0xFF4CAF50);
  static const blue = Color(0xFF2196F3);
  static const yellow = Color(0xFFFFEB3B);
  static const purple = Color(0xFF9C27B0);

  // 功能性颜色
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFFF5252);

  // 获取游戏单元颜色
  static Color getUnitColor(String colorKey) {
    switch (colorKey) {
      case 'r':
        return red;
      case 'g':
        return green;
      case 'b':
        return blue;
      case 'y':
        return yellow;
      case 'p':
        return purple;
      default:
        return primaryAccent;
    }
  }
}
