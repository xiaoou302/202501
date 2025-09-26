import 'package:flutter/material.dart';

/// 颜色工具类
class ColorUtils {
  /// 设置颜色透明度
  static Color withOpacity(Color color, double opacity) {
    return Color.fromRGBO(
      (color.r * 255.0).round() & 0xff,
      (color.g * 255.0).round() & 0xff,
      (color.b * 255.0).round() & 0xff,
      opacity,
    );
  }
}