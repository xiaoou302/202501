import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'MeeMi';
  static const String version = '1.0.0';

  // Colors
  static const Color midnight = Color(0xFF181818);
  static const Color surface = Color(0xFF252525);
  static const Color offwhite = Color(0xFFE0E0E0);
  static const Color metalgray = Color(0xFF9E9E9E);
  static const Color gold = Color(0xFFC9A66B);
  static const Color indigo = Color(0xFF4A5F70);

  // Routes
  static const String routeHome = '/';
  static const String routeArtDetail = '/art-detail';
  static const String routeArtistProfile = '/artist-profile';
  static const String routeFullscreenReference = '/fullscreen-reference';

  // Categories
  static const List<String> artCategories = [
    'All',
    'Oil Painting',
    'Sketch',
    'Watercolor',
    'Printmaking',
  ];
}
