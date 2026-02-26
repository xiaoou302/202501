import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.vellum,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brass,
        primary: AppColors.brass,
        secondary: AppColors.teal,
        surface: AppColors.shale,
        onSurface: AppColors.ink,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.ink,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.ink,
        ),
        bodyLarge: GoogleFonts.courierPrime(
          fontSize: 16,
          color: AppColors.ink,
        ),
        bodyMedium: GoogleFonts.courierPrime(
          fontSize: 14,
          color: AppColors.ink,
        ),
        labelLarge: GoogleFonts.courierPrime(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.leather,
        ),
        labelSmall: GoogleFonts.courierPrime(
          fontSize: 10,
          letterSpacing: 1.5,
          color: AppColors.soot,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.leather),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.leather,
        selectedItemColor: AppColors.brass,
        unselectedItemColor: Color(0xFF9E8F85),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
