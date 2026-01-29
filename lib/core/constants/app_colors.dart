import 'package:flutter/material.dart';

class AppColors {
  static const Color snowWhite = Color(0xFFFAFAFA);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color slateGreen = Color(0xFF2F4F4F);
  static const Color coolGray = Color(0xFFB0B7C6);
  static const Color glassBg = Color.fromRGBO(250, 250, 250, 0.85);

  // Additional colors derived from the design
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  // New Design Palette (Morandi / Earth Tones for richness)
  static const Color warmBeige = Color(0xFFF5E6D3);
  static const Color softSage = Color(0xFFD3E0DC);
  static const Color dustyBlue = Color(0xFFC4D3E0);
  static const Color terracotta = Color(0xFFE0B0A0);
  static const Color mutedLavender = Color(0xFFD8D3E0);
  static const Color cream = Color(0xFFFFFDF5);
  static const Color olive = Color(0xFF8A9A5B);

  // Category Colors
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Living Room':
        return const Color(0xFFE6D5B8); // Warm Beige
      case 'Bedroom':
        return const Color(0xFFD4E2D4); // Soft Sage
      case 'Dining & Kitchen':
        return const Color(0xFFEBC7C0); // Soft Terracotta
      case 'Office':
        return const Color(0xFFC0D6E4); // Dusty Blue
      case 'Bathroom':
        return const Color(0xFFD6D6E0); // Muted Lavender
      default:
        return const Color(0xFFF0F0F0);
    }
  }

  static Color getCategoryTextColor(String category) {
    switch (category) {
      case 'Living Room':
        return const Color(0xFF5C4033);
      case 'Bedroom':
        return const Color(0xFF2F4F2F);
      case 'Dining & Kitchen':
        return const Color(0xFF8B4513);
      case 'Office':
        return const Color(0xFF191970);
      case 'Bathroom':
        return const Color(0xFF483D8B);
      default:
        return Colors.black54;
    }
  }
}
