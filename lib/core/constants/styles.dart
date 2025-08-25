import 'package:flutter/material.dart';
import 'colors.dart';

/// 应用程序样式常量
class AppStyles {
  // 文本样式
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'System',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'System',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'System',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'System',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'System',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'System',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  // 装饰样式
  static BoxDecoration glassmorphic = BoxDecoration(
    color: AppColors.primaryDark.withOpacity(0.5),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.primaryAccent.withOpacity(0.2),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryDark.withOpacity(0.3),
        blurRadius: 8,
        spreadRadius: 2,
      ),
    ],
  );

  static BoxDecoration cyanGlow = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryAccent.withOpacity(0.4),
        blurRadius: 15,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: AppColors.primaryAccent.withOpacity(0.6),
        blurRadius: 5,
        spreadRadius: 0,
      ),
    ],
  );

  static BoxDecoration pinkGlow = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.secondaryAccent.withOpacity(0.4),
        blurRadius: 15,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: AppColors.secondaryAccent.withOpacity(0.6),
        blurRadius: 5,
        spreadRadius: 0,
      ),
    ],
  );

  // 间距常量
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // 圆角常量
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
}
