import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Storage Keys
  static const String _keyPrefix = 'membly_';
  static const String _keyLevelUnlocked = '${_keyPrefix}level_unlocked_';
  static const String _keyLevelStars = '${_keyPrefix}level_stars_';
  static const String _keyLevelBestScore = '${_keyPrefix}level_best_score_';
  static const String _keyLevelBestTime = '${_keyPrefix}level_best_time_';
  static const String _keyTotalGames = '${_keyPrefix}total_games';
  static const String _keyTotalWins = '${_keyPrefix}total_wins';
  static const String _keyTotalFails = '${_keyPrefix}total_fails';
  static const String _keyVibrationEnabled = '${_keyPrefix}vibration_enabled';
  static const String _keyAchievement = '${_keyPrefix}achievement_';
  static const String _keyHasSeenOnboarding =
      '${_keyPrefix}has_seen_onboarding';

  // Level Progress
  static Future<bool> setLevelUnlocked(int levelId, bool unlocked) async {
    return await _prefs?.setBool('$_keyLevelUnlocked$levelId', unlocked) ??
        false;
  }

  static bool isLevelUnlocked(int levelId) {
    if (levelId == 1) return true;
    return _prefs?.getBool('$_keyLevelUnlocked$levelId') ?? false;
  }

  static Future<bool> setLevelStars(int levelId, int stars) async {
    return await _prefs?.setInt('$_keyLevelStars$levelId', stars) ?? false;
  }

  static int getLevelStars(int levelId) {
    return _prefs?.getInt('$_keyLevelStars$levelId') ?? 0;
  }

  static Future<bool> setLevelBestScore(int levelId, int score) async {
    int currentBest = getLevelBestScore(levelId);
    if (score > currentBest) {
      return await _prefs?.setInt('$_keyLevelBestScore$levelId', score) ??
          false;
    }
    return false;
  }

  static int getLevelBestScore(int levelId) {
    return _prefs?.getInt('$_keyLevelBestScore$levelId') ?? 0;
  }

  static Future<bool> setLevelBestTime(int levelId, int timeRemaining) async {
    int currentBest = getLevelBestTime(levelId);
    if (timeRemaining > currentBest) {
      return await _prefs?.setInt(
            '$_keyLevelBestTime$levelId',
            timeRemaining,
          ) ??
          false;
    }
    return false;
  }

  static int getLevelBestTime(int levelId) {
    return _prefs?.getInt('$_keyLevelBestTime$levelId') ?? 0;
  }

  // Game Statistics
  static Future<bool> incrementTotalGames() async {
    int current = getTotalGames();
    return await _prefs?.setInt(_keyTotalGames, current + 1) ?? false;
  }

  static int getTotalGames() {
    return _prefs?.getInt(_keyTotalGames) ?? 0;
  }

  static Future<bool> incrementTotalWins() async {
    int current = getTotalWins();
    return await _prefs?.setInt(_keyTotalWins, current + 1) ?? false;
  }

  static int getTotalWins() {
    return _prefs?.getInt(_keyTotalWins) ?? 0;
  }

  static Future<bool> incrementTotalFails() async {
    int current = getTotalFails();
    return await _prefs?.setInt(_keyTotalFails, current + 1) ?? false;
  }

  static int getTotalFails() {
    return _prefs?.getInt(_keyTotalFails) ?? 0;
  }

  // Achievements
  static Future<bool> unlockAchievement(String achievementId) async {
    return await _prefs?.setBool('$_keyAchievement$achievementId', true) ??
        false;
  }

  static bool isAchievementUnlocked(String achievementId) {
    return _prefs?.getBool('$_keyAchievement$achievementId') ?? false;
  }

  static List<String> getAllUnlockedAchievements() {
    List<String> unlocked = [];
    final achievements = [
      'eagle_eye',
      'speedster',
      'persistence',
      'memory_master',
    ];
    for (var achievement in achievements) {
      if (isAchievementUnlocked(achievement)) {
        unlocked.add(achievement);
      }
    }
    return unlocked;
  }

  // Settings
  static Future<bool> setVibrationEnabled(bool enabled) async {
    return await _prefs?.setBool(_keyVibrationEnabled, enabled) ?? false;
  }

  static bool getVibrationEnabled() {
    return _prefs?.getBool(_keyVibrationEnabled) ?? true;
  }

  // Onboarding
  static Future<bool> setHasSeenOnboarding(bool seen) async {
    return await _prefs?.setBool(_keyHasSeenOnboarding, seen) ?? false;
  }

  static bool hasSeenOnboarding() {
    return _prefs?.getBool(_keyHasSeenOnboarding) ?? false;
  }

  // Utility
  static Future<bool> clearAllData() async {
    return await _prefs?.clear() ?? false;
  }
}
