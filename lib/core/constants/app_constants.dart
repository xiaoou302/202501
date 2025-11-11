import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Leno';
  static const String appVersion = '1.0.0';

  // AI API Configuration
  static const String deepseekApiKey = 'sk-9e7d69639d284bca9e3e392d735de63f';
  static const String deepseekApiUrl =
      'https://api.deepseek.com/v1/chat/completions';

  // Colors - Light Mode
  static const Color shellWhite = Color(0xFFFCFBFB);
  static const Color darkGraphite = Color(0xFF2F2F2F);
  static const Color panelWhite = Color(0xFFFFFFFF);
  static const Color softCoral = Color(0xFFFF7A8A);
  static const Color mediumGray = Color(0xFF909090);

  // Colors - Dark Mode
  static const Color deepPlum = Color(0xFF1F1B1E);
  static const Color softWhite = Color(0xFFEDEAEB);
  static const Color darkGray = Color(0xFF2A2629);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusFull = 999.0;

  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 20.0;
  static const double iconL = 24.0;
  static const double iconXL = 32.0;

  // Avatar Sizes
  static const double avatarS = 32.0;
  static const double avatarM = 48.0;
  static const double avatarL = 64.0;
  static const double avatarXL = 96.0;
}

class StorageKeys {
  static const String pets = 'pets_list';
  static const String reminders = 'reminders_list';
  static const String growthTracks = 'growth_tracks_list';
  static const String chatHistory = 'chat_history';
  static const String savedPosts = 'saved_posts';
  static const String isDarkMode = 'is_dark_mode';
  static const String notificationSettings = 'notification_settings';
  static const String currentPetId = 'current_pet_id';
}

class LocalAssets {
  // Pet images (32 images)
  static const List<String> pets = [
    'assets/cw/cw1.jpg',
    'assets/cw/cw2.jpg',
    'assets/cw/cw3.jpg',
    'assets/cw/cw4.jpg',
    'assets/cw/cw5.jpg',
    'assets/cw/cw6.jpg',
    'assets/cw/cw7.jpg',
    'assets/cw/cw8.jpg',
    'assets/cw/cw9.jpg',
    'assets/cw/cw10.jpg',
    'assets/cw/cw11.jpg',
    'assets/cw/cw12.jpg',
    'assets/cw/cw13.jpg',
    'assets/cw/cw14.jpg',
    'assets/cw/cw15.jpg',
    'assets/cw/cw16.jpg',
    'assets/cw/cw17.jpg',
    'assets/cw/cw18.jpg',
    'assets/cw/cw19.jpg',
    'assets/cw/cw20.jpg',
    'assets/cw/cw21.jpg',
    'assets/cw/cw22.jpg',
    'assets/cw/cw23.jpg',
    'assets/cw/cw24.jpg',
    'assets/cw/cw25.jpg',
    'assets/cw/cw26.jpg',
    'assets/cw/cw27.jpg',
    'assets/cw/cw28.jpg',
    'assets/cw/cw29.jpg',
    'assets/cw/cw30.jpg',
    'assets/cw/cw31.jpg',
    'assets/cw/cw32.jpg',
  ];

  // User avatars (32 avatars)
  static const List<String> avatars = [
    'assets/rw/rw1.jpg',
    'assets/rw/rw2.jpg',
    'assets/rw/rw3.jpg',
    'assets/rw/rw4.jpg',
    'assets/rw/rw5.jpg',
    'assets/rw/rw6.jpg',
    'assets/rw/rw7.jpg',
    'assets/rw/rw8.jpg',
    'assets/rw/rw9.jpg',
    'assets/rw/rw10.jpg',
    'assets/rw/rw11.jpg',
    'assets/rw/rw12.jpg',
    'assets/rw/rw13.jpg',
    'assets/rw/rw14.jpg',
    'assets/rw/rw15.jpg',
    'assets/rw/rw16.jpg',
    'assets/rw/rw17.jpg',
    'assets/rw/rw18.jpg',
    'assets/rw/rw19.jpg',
    'assets/rw/rw20.jpg',
    'assets/rw/rw21.jpg',
    'assets/rw/rw22.jpg',
    'assets/rw/rw23.jpg',
    'assets/rw/rw24.jpg',
    'assets/rw/rw25.jpg',
    'assets/rw/rw26.jpg',
    'assets/rw/rw27.jpg',
    'assets/rw/rw28.jpg',
    'assets/rw/rw29.jpg',
    'assets/rw/rw30.jpg',
    'assets/rw/rw31.jpg',
    'assets/rw/rw32.jpg',
  ];
}
