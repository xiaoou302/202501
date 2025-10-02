import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Manager class for handling app preferences and game progress
class PreferencesManager {
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyMusicEnabled = 'music_enabled';
  static const String _keyHapticsEnabled = 'haptics_enabled';
  static const String _keyCompletedLevels = 'completed_levels';
  static const String _keyLevelProgress = 'level_progress';
  static const String _keyAchievements = 'achievements';
  static const String _keyConsecutivePerfectLevels =
      'consecutive_perfect_levels';
  static const String _keyLevelCompletionTimes = 'level_completion_times';

  /// Get the SharedPreferences instance
  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  /// Save sound setting
  static Future<bool> setSoundEnabled(bool enabled) async {
    final prefs = await _prefs;
    return prefs.setBool(_keySoundEnabled, enabled);
  }

  /// Get sound setting
  static Future<bool> getSoundEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keySoundEnabled) ?? true;
  }

  /// Save music setting
  static Future<bool> setMusicEnabled(bool enabled) async {
    final prefs = await _prefs;
    return prefs.setBool(_keyMusicEnabled, enabled);
  }

  /// Get music setting
  static Future<bool> getMusicEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyMusicEnabled) ?? false;
  }

  /// Save haptics setting
  static Future<bool> setHapticsEnabled(bool enabled) async {
    final prefs = await _prefs;
    return prefs.setBool(_keyHapticsEnabled, enabled);
  }

  /// Get haptics setting
  static Future<bool> getHapticsEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyHapticsEnabled) ?? true;
  }

  /// Mark a level as completed
  static Future<bool> setLevelCompleted(int levelId, int moveCount) async {
    final prefs = await _prefs;

    // Get existing completed levels
    final completedLevels = prefs.getStringList(_keyCompletedLevels) ?? [];
    if (!completedLevels.contains(levelId.toString())) {
      completedLevels.add(levelId.toString());
      await prefs.setStringList(_keyCompletedLevels, completedLevels);
    }

    // Save the move count if it's better than the previous best
    final levelProgress = prefs.getString(_keyLevelProgress) ?? '{}';
    final Map<String, dynamic> progressMap = json.decode(levelProgress);

    final currentBest = progressMap[levelId.toString()] as int? ?? 0;
    if (currentBest == 0 || moveCount < currentBest) {
      progressMap[levelId.toString()] = moveCount;
      await prefs.setString(_keyLevelProgress, json.encode(progressMap));
    }

    return true;
  }

  /// Get list of completed level IDs
  static Future<List<int>> getCompletedLevels() async {
    final prefs = await _prefs;
    final completedLevels = prefs.getStringList(_keyCompletedLevels) ?? [];
    return completedLevels.map((id) => int.parse(id)).toList();
  }

  /// Get best move count for a specific level
  static Future<int> getLevelBestMoves(int levelId) async {
    final prefs = await _prefs;
    final levelProgress = prefs.getString(_keyLevelProgress) ?? '{}';
    final Map<String, dynamic> progressMap = json.decode(levelProgress);
    return progressMap[levelId.toString()] as int? ?? 0;
  }

  /// Unlock an achievement
  static Future<bool> unlockAchievement(String achievementId) async {
    final prefs = await _prefs;
    final achievements = prefs.getStringList(_keyAchievements) ?? [];
    if (!achievements.contains(achievementId)) {
      achievements.add(achievementId);
      return prefs.setStringList(_keyAchievements, achievements);
    }
    return true;
  }

  /// Get list of unlocked achievement IDs
  static Future<List<String>> getUnlockedAchievements() async {
    final prefs = await _prefs;
    return prefs.getStringList(_keyAchievements) ?? [];
  }

  /// Update achievement progress
  static Future<bool> updateAchievementProgress(
    String achievementId,
    double progress,
  ) async {
    final prefs = await _prefs;
    final key = '${_keyAchievements}_progress_$achievementId';
    return prefs.setDouble(key, progress);
  }

  /// Get achievement progress
  static Future<double> getAchievementProgress(String achievementId) async {
    final prefs = await _prefs;
    final key = '${_keyAchievements}_progress_$achievementId';
    return prefs.getDouble(key) ?? 0.0;
  }

  /// Get consecutive perfect levels count
  static Future<int> getConsecutivePerfectLevels() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyConsecutivePerfectLevels) ?? 0;
  }

  /// Set consecutive perfect levels count
  static Future<bool> setConsecutivePerfectLevels(int count) async {
    final prefs = await _prefs;
    return prefs.setInt(_keyConsecutivePerfectLevels, count);
  }

  /// Save level completion time
  static Future<bool> saveLevelCompletionTime(int levelId, int seconds) async {
    final prefs = await _prefs;
    final times = prefs.getString(_keyLevelCompletionTimes) ?? '{}';
    final Map<String, dynamic> timesMap = json.decode(times);

    // Only save if it's a better time or first completion
    final currentBest = timesMap[levelId.toString()] as int? ?? 0;
    if (currentBest == 0 || seconds < currentBest) {
      timesMap[levelId.toString()] = seconds;
      return prefs.setString(_keyLevelCompletionTimes, json.encode(timesMap));
    }

    return true;
  }

  /// Get level completion time
  static Future<int> getLevelCompletionTime(int levelId) async {
    final prefs = await _prefs;
    final times = prefs.getString(_keyLevelCompletionTimes) ?? '{}';
    final Map<String, dynamic> timesMap = json.decode(times);
    return timesMap[levelId.toString()] as int? ?? 0;
  }

  /// Clear all saved preferences (for testing)
  static Future<bool> clearAll() async {
    final prefs = await _prefs;
    return prefs.clear();
  }
}
