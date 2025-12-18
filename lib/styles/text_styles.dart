import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Serif styles for poetry
  static const TextStyle poemTitle = TextStyle(
    fontFamily: 'serif',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.ink,
    height: 1.2,
  );

  static const TextStyle poemContent = TextStyle(
    fontFamily: 'serif',
    fontSize: 18,
    color: AppColors.ink,
    height: 1.8,
    fontStyle: FontStyle.italic,
  );

  // Sans styles for UI
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.ink,
    letterSpacing: -0.5,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: AppColors.ink,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle authorName = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );
}
