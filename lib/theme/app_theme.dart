import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_palette.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ColorPalette.concrete,
      primaryColor: ColorPalette.rustedCopper,
      colorScheme: ColorScheme.light(
        primary: ColorPalette.rustedCopper,
        secondary: ColorPalette.matteSteel,
        surface: ColorPalette.concrete,
        onSurface: ColorPalette.obsidian,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.inter(
          color: ColorPalette.obsidian,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.inter(
          color: ColorPalette.obsidian,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.inter(color: ColorPalette.obsidian),
        bodyMedium: GoogleFonts.inter(color: ColorPalette.obsidian),
        labelLarge: GoogleFonts.inter(
          color: ColorPalette.pureWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Fallback to Roboto Mono if JetBrains Mono is not available in this version
  static TextStyle get monoStyle => GoogleFonts.robotoMono();
}
