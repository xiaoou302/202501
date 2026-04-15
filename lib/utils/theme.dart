import 'package:flutter/material.dart';

class AppTheme {
  static const Color polarIce = Color(0xFFF0F4F8);
  static const Color aeroNavy = Color(0xFF1C2D42);
  static const Color laminarCyan = Color(0xFF00D2D3);
  static const Color turbulenceMagenta = Color(0xFFFF007F);
  static const Color titaniumSilver = Color(0xFFB0BEC5);
  static const Color stallRed = Color(0xFFFF003C);
  static const Color bezelBlack = Color(0xFF121212);
  static const Color glassPanel = Color(0x66FFFFFF);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: laminarCyan,
      scaffoldBackgroundColor: polarIce,
      colorScheme: const ColorScheme.light(
        primary: laminarCyan,
        secondary: turbulenceMagenta,
        surface: polarIce,
        onSurface: aeroNavy,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: aeroNavy),
        titleTextStyle: TextStyle(
          color: aeroNavy,
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.2,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: aeroNavy),
        bodyMedium: TextStyle(color: aeroNavy),
        titleLarge: TextStyle(color: aeroNavy, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: aeroNavy,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
