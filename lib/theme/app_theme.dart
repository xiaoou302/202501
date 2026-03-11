import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class AppTheme {
  static ThemeData get normalTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.cosmicBlack,
      primaryColor: AppColors.orionPurple,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.orionPurple,
        secondary: AppColors.andromedaCyan,
        surface: AppColors.darkMatter,
        onSurface: AppColors.starlightWhite,
      ),
      textTheme: GoogleFonts.spaceMonoTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.starlightWhite,
        displayColor: AppColors.starlightWhite,
      ).copyWith(
        bodyMedium: TextStyle(color: AppColors.starlightWhite),
        bodySmall: TextStyle(color: AppColors.meteoriteGrey),
      ),
      useMaterial3: true,
      // Custom extensions could be added here for specific custom colors
    );
  }

  static ThemeData get redSafelightTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.oledBlack,
      primaryColor: AppColors.safelightRed,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.safelightRed,
        secondary: AppColors.safelightRed,
        surface: AppColors.deepRedSurface,
        onSurface: AppColors.opticRed,
        background: AppColors.oledBlack,
      ),
      textTheme: GoogleFonts.spaceMonoTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.opticRed,
        displayColor: AppColors.opticRed,
      ).copyWith(
        bodyMedium: TextStyle(color: AppColors.opticRed, fontWeight: FontWeight.bold),
        bodySmall: TextStyle(color: AppColors.fadedRed, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppColors.opticRed, fontWeight: FontWeight.bold),
      ),
      useMaterial3: true,
    );
  }
}
