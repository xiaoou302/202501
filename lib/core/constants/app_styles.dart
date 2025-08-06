import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App text styles based on the design specifications
class AppStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.stardustWhite,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.stardustWhite,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.stardustWhite,
  );

  // Body text
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.stardustWhite,
  );

  static const TextStyle bodyTextSmall = TextStyle(
    fontSize: 14,
    color: AppColors.stardustWhite,
  );

  // Secondary text (for subtitles, captions, etc.)
  static TextStyle secondaryText = TextStyle(
    fontSize: 14,
    color: AppColors.stardustWhite.withOpacity(0.7),
  );

  // Card title
  static const TextStyle cardTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.stardustWhite,
  );

  // Tab labels
  static const TextStyle tabLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // Status indicators
  static const TextStyle positiveChange = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.fieryRed,
  );

  static const TextStyle negativeChange = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.coolBlue,
  );
}
