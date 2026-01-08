class AppConstants {
  static const String appName = 'Capu';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.zylo.app';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int pageSize = 20;
  static const int preloadThreshold = 5;
  
  // Image Configuration
  static const int imageQuality = 85;
  static const double thumbnailSize = 400;
  
  // Cache
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100;
}

class StorageKeys {
  static const String isDarkMode = 'is_dark_mode';
  static const String savedBoards = 'saved_boards';
  static const String ootdRecords = 'ootd_records';
  static const String styleSubscriptions = 'style_subscriptions';
  static const String userPreferences = 'user_preferences';
}
