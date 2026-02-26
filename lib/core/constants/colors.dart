import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color vellum = Color(0xFFF2EAD3);      // Main Background
  static const Color shale = Color(0xFFE6DBC2);       // Card Background
  
  // Brand Colors
  static const Color brass = Color(0xFFC89F5D);       // Primary / Highlight
  static const Color bronze = Color(0xFF967241);      // Pressed / Darker Metal
  static const Color leather = Color(0xFF5D4037);     // Dark Brown / Nav
  
  // Accents
  static const Color teal = Color(0xFF4B7F76);        // Accent / Verdigris
  static const Color wax = Color(0xFFA83232);         // Alert / Seal
  
  // Text
  static const Color ink = Color(0xFF2C2C2C);         // Primary Text
  static const Color soot = Color(0xFF66625E);        // Secondary Text
  
  // Gradients
  static const LinearGradient metalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brass, Color(0xFFF5D595), bronze],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient leatherGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF5D4037), Color(0xFF4A332C)],
  );
}
