import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/settings_model.dart';
import '../../core/models/user_stats_model.dart';

/// Local storage service using SharedPreferences
class StorageService {
  static const String _keySettings = 'app_settings';
  static const String _keyUserStats = 'user_stats';
  static const String _keyLastChapterId = 'last_chapter_id';
  static const String _keyFirstLaunch = 'is_first_launch';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Initialize storage service
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Save settings
  Future<bool> saveSettings(AppSettings settings) async {
    final json = jsonEncode(settings.toJson());
    return await _prefs.setString(_keySettings, json);
  }

  /// Load settings
  AppSettings loadSettings() {
    final json = _prefs.getString(_keySettings);
    if (json == null) return const AppSettings();

    try {
      return AppSettings.fromJson(jsonDecode(json));
    } catch (e) {
      return const AppSettings();
    }
  }

  /// Save user stats
  Future<bool> saveUserStats(UserStats stats) async {
    final json = jsonEncode(stats.toJson());
    return await _prefs.setString(_keyUserStats, json);
  }

  /// Load user stats
  UserStats loadUserStats() {
    final json = _prefs.getString(_keyUserStats);
    if (json == null) return const UserStats();

    try {
      return UserStats.fromJson(jsonDecode(json));
    } catch (e) {
      return const UserStats();
    }
  }

  /// Save last played chapter ID
  Future<bool> saveLastChapterId(int chapterId) async {
    return await _prefs.setInt(_keyLastChapterId, chapterId);
  }

  /// Load last played chapter ID
  int? loadLastChapterId() {
    return _prefs.getInt(_keyLastChapterId);
  }

  /// Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  /// Check if user has played before
  bool hasPlayedBefore() {
    return _prefs.containsKey(_keyUserStats);
  }

  /// Check if this is the first launch
  bool isFirstLaunch() {
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// Mark that the app has been launched
  Future<bool> setFirstLaunchComplete() async {
    return await _prefs.setBool(_keyFirstLaunch, false);
  }
}
