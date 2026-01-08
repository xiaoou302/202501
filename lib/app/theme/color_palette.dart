import 'package:flutter/material.dart';

class AppColors {
  // Invisible Gallery Color Scheme
  static const Color background = Color(0xFFF2F4F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF121212);
  static const Color accent = Color(0xFF0047AB); // Klein Blue
  static const Color gray = Color(0xFFE5E5E5);
  static const Color grayLight = Color(0xFFF5F5F5);
  static const Color grayDark = Color(0xFF666666);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  
  // Opacity variants
  static Color textSecondary = text.withOpacity(0.6);
  static Color textTertiary = text.withOpacity(0.4);
  static Color surfaceElevated = surface;
  static Color divider = gray.withOpacity(0.2);
}
