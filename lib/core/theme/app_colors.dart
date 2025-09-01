import 'package:flutter/material.dart';

/// 应用的颜色常量
class AppColors {
  // 主要颜色
  static const Color primary = Color(0xFF00BFFF); // 青色
  static const Color background = Color(0xFF1A1A1A); // 深灰色背景
  static const Color cardBackground = Color(0xFF2A2A2A); // 卡片背景色

  // 文本颜色
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFCCCCCC); // 浅灰色文本
  static const Color textDisabled = Color(0xFF666666); // 禁用文本颜色

  // 功能颜色
  static const Color success = Color(0xFF4CAF50); // 绿色
  static const Color error = Color(0xFFFF5252); // 红色
  static const Color warning = Color(0xFFFFB74D); // 橙色

  // 游戏特殊颜色
  static const Color memoryCardBack = Color(0xFF444444); // 记忆卡片背面
  static const Color rhythmTile = Colors.black; // 节奏游戏黑块
  static const Color rhythmObstacle = Color(0xFFFF5252); // 节奏游戏障碍物

  // 渐变色
  static const List<Color> primaryGradient = [
    Color(0xFF00BFFF),
    Color(0xFF0080FF),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFF1A1A1A),
    Color(0xFF2D2D2D),
  ];
}
