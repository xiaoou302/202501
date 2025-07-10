import 'package:flutter/material.dart';

/// Application color constants
class AppColors {
  // Primary Colors
  static const Color primaryDark = Color(0xFF1A1B25); // Dark background
  static const Color deepBlue = Color(0xFF1E2433); // Rich deep blue
  static const Color deepPurple = Color(0xFF392F5A); // Deep purple
  static const Color accentPurple = Color(0xFF7C4DFF); // Vibrant purple
  static const Color accentBlue = Color(0xFF4D8AFF); // Bright blue
  static const Color accentGreen = Color(0xFF4CAF50); // Success green
  static const Color lightGray = Color(0xFFF0F2F5); // Clean light gray

  // Quadrant Colors
  static const Color urgentImportant = Color(0xFFFF5252); // Critical tasks
  static const Color importantNotUrgent = Color(0xFFFFB74D); // Important tasks
  static const Color urgentNotImportant = Color(0xFF4FC3F7); // Urgent tasks
  static const Color notUrgentNotImportant =
      Color(0xFF9575CD); // Optional tasks

  // Functional Colors
  static const Color success = Color(0xFF4CAF50); // Success green
  static const Color error = Color(0xFFFF5252); // Error red
  static const Color warning = Color(0xFFFFB74D); // Warning orange
  static const Color info = Color(0xFF4D8AFF); // Info blue

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textHint = Color(0xFFB0B0B0);

  // Button Colors
  static const Color buttonPrimary = accentPurple;
  static const Color buttonSecondary = Color(0xFF4A4D64);
  static const Color buttonDisabled = Color(0xFF3A3D4D);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonTextDisabled = Color(0xFF9A9BA5);

  // Card Colors
  static const Color cardBackground = Color(0xFF242838);
  static const Color cardBackgroundAlt = Color(0xFF2A2F45);
  static const Color cardBorder = Color(0xFF353A52);

  // Background Gradients
  static const List<Color> backgroundGradient = [
    Color(0xFF1A1B25), // Dark top
    Color(0xFF1E2433), // Deep blue bottom
  ];

  // Card Gradients
  static const List<Color> cardGradient = [
    Color(0xFF2A2F45), // Lighter card top
    Color(0xFF242838), // Darker card bottom
  ];

  // Button Gradients
  static const List<Color> buttonGradient = [
    Color(0xFF7C4DFF), // Primary purple
    Color(0xFF4D8AFF), // Transition to blue
  ];

  // Shadows and Overlays
  static final Color shadowColor = const Color(0xFF1A1B25).withOpacity(0.2);
  static final Color buttonShadowColor = accentPurple.withOpacity(0.25);
  static final Color cardOverlay = const Color(0xFF1A1B25).withOpacity(0.5);

  // Tag Colors
  static const List<Color> tagColors = [
    Color(0xFF7C4DFF), // Purple
    Color(0xFF4D8AFF), // Blue
    Color(0xFF4CAF50), // Green
    Color(0xFFFFB74D), // Orange
    Color(0xFFFF5252), // Red
    Color(0xFF9C27B0), // Deep Purple
    Color(0xFF00BCD4), // Cyan
    Color(0xFF795548), // Brown
  ];
}
