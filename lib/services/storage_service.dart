import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../models/game_score.dart';
import '../models/game_statistics.dart';

/// 本地存储服务
class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  late SharedPreferences _prefs;

  /// 初始化存储服务
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 高分存储键
  static const String _keyHighScores = 'high_scores';

  // 成就存储键
  static const String _keyAchievements = 'achievements';

  // 游戏统计数据存储键
  static const String _keyGameStatistics = 'game_statistics';

  /// 保存高分
  Future<void> saveHighScore(GameScore score) async {
    final List<String> scoresJson = _prefs.getStringList(_keyHighScores) ?? [];
    final List<GameScore> scores = scoresJson
        .map((json) => GameScore.fromJson(jsonDecode(json)))
        .toList();

    // 检查是否已存在该游戏的分数
    final existingScoreIndex = scores.indexWhere(
      (s) =>
          s.gameId == score.gameId &&
          s.gameSpecificData['difficulty'] ==
              score.gameSpecificData['difficulty'],
    );

    if (existingScoreIndex != -1) {
      // 如果已存在且新分数更高，则替换
      if (scores[existingScoreIndex].score < score.score) {
        scores[existingScoreIndex] = score;
      }
    } else {
      // 如果不存在，则添加
      scores.add(score);
    }

    // 保存更新后的分数列表
    final updatedScoresJson = scores
        .map((score) => jsonEncode(score.toJson()))
        .toList();

    await _prefs.setStringList(_keyHighScores, updatedScoresJson);
  }

  /// 获取指定游戏的最高分
  Future<GameScore?> getHighScore(String gameId, String difficulty) async {
    final List<String> scoresJson = _prefs.getStringList(_keyHighScores) ?? [];
    final List<GameScore> scores = scoresJson
        .map((json) => GameScore.fromJson(jsonDecode(json)))
        .toList();

    // 查找指定游戏和难度的最高分
    final highScore = scores
        .where(
          (s) =>
              s.gameId == gameId &&
              s.gameSpecificData['difficulty'] == difficulty,
        )
        .fold<GameScore?>(
          null,
          (highest, score) =>
              highest == null || highest.score < score.score ? score : highest,
        );

    return highScore;
  }

  /// 获取所有高分
  Future<List<GameScore>> getAllHighScores() async {
    final List<String> scoresJson = _prefs.getStringList(_keyHighScores) ?? [];
    return scoresJson
        .map((json) => GameScore.fromJson(jsonDecode(json)))
        .toList();
  }

  /// 保存成就
  Future<void> saveAchievement(Achievement achievement) async {
    final List<String> achievementsJson =
        _prefs.getStringList(_keyAchievements) ?? [];
    final List<Achievement> achievements = achievementsJson
        .map((json) => Achievement.fromJson(jsonDecode(json)))
        .toList();

    // 检查是否已存在该成就
    final existingIndex = achievements.indexWhere(
      (a) => a.id == achievement.id,
    );

    if (existingIndex != -1) {
      // 如果已存在，则更新
      achievements[existingIndex] = achievement;
    } else {
      // 如果不存在，则添加
      achievements.add(achievement);
    }

    // 保存更新后的成就列表
    final updatedAchievementsJson = achievements
        .map((achievement) => jsonEncode(achievement.toJson()))
        .toList();

    await _prefs.setStringList(_keyAchievements, updatedAchievementsJson);
  }

  /// 获取所有成就
  Future<List<Achievement>> getAllAchievements() async {
    final List<String> achievementsJson =
        _prefs.getStringList(_keyAchievements) ?? [];
    return achievementsJson
        .map((json) => Achievement.fromJson(jsonDecode(json)))
        .toList();
  }

  /// 获取指定成就
  Future<Achievement?> getAchievement(String id) async {
    final List<String> achievementsJson =
        _prefs.getStringList(_keyAchievements) ?? [];
    final List<Achievement> achievements = achievementsJson
        .map((json) => Achievement.fromJson(jsonDecode(json)))
        .toList();

    return achievements.firstWhere(
      (a) => a.id == id,
      orElse: () => throw Exception('Achievement not found: $id'),
    );
  }

  /// 保存设置
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else {
      await _prefs.setString(key, jsonEncode(value));
    }
  }

  /// 获取设置
  T? getSetting<T>(String key) {
    if (T == String) {
      return _prefs.getString(key) as T?;
    } else if (T == int) {
      return _prefs.getInt(key) as T?;
    } else if (T == bool) {
      return _prefs.getBool(key) as T?;
    } else if (T == double) {
      return _prefs.getDouble(key) as T?;
    } else {
      final value = _prefs.getString(key);
      if (value == null) return null;
      return jsonDecode(value) as T?;
    }
  }

  /// Save game statistics
  Future<void> saveGameStatistics(GameStatistics stats) async {
    final List<String> allStatsJson =
        _prefs.getStringList(_keyGameStatistics) ?? [];
    final List<GameStatistics> allStats = allStatsJson
        .map((json) => GameStatistics.fromJson(jsonDecode(json)))
        .toList();

    // Check if stats for this game already exist
    final existingIndex = allStats.indexWhere((s) => s.gameId == stats.gameId);

    if (existingIndex != -1) {
      // Update existing stats
      allStats[existingIndex] = stats;
    } else {
      // Add new stats
      allStats.add(stats);
    }

    // Save updated stats
    final updatedStatsJson = allStats
        .map((stats) => jsonEncode(stats.toJson()))
        .toList();

    await _prefs.setStringList(_keyGameStatistics, updatedStatsJson);
  }

  /// Get statistics for a specific game
  Future<GameStatistics?> getGameStatistics(String gameId) async {
    final List<String> allStatsJson =
        _prefs.getStringList(_keyGameStatistics) ?? [];
    final List<GameStatistics> allStats = allStatsJson
        .map((json) => GameStatistics.fromJson(jsonDecode(json)))
        .toList();

    // Find stats for the specified game
    final gameStats = allStats.firstWhere(
      (stats) => stats.gameId == gameId,
      orElse: () => GameStatistics.defaultStats(gameId),
    );

    return gameStats;
  }

  /// Get statistics for all games
  Future<List<GameStatistics>> getAllGameStatistics() async {
    final List<String> allStatsJson =
        _prefs.getStringList(_keyGameStatistics) ?? [];
    return allStatsJson
        .map((json) => GameStatistics.fromJson(jsonDecode(json)))
        .toList();
  }

  /// Update game statistics after a game session
  Future<void> updateGameStatistics({
    required String gameId,
    required int score,
    required int timePlayed,
    String? completedLevel,
    Map<String, dynamic>? additionalStats,
  }) async {
    // Get current stats
    GameStatistics currentStats =
        await getGameStatistics(gameId) ?? GameStatistics.defaultStats(gameId);

    // Create updated stats
    final updatedStats = currentStats.copyWith(
      gamesPlayed: currentStats.gamesPlayed + 1,
      totalTimePlayed: currentStats.totalTimePlayed + timePlayed,
      bestScore: score > currentStats.bestScore
          ? score
          : currentStats.bestScore,
      bestTime: (timePlayed < (currentStats.bestTime ?? double.infinity))
          ? timePlayed
          : currentStats.bestTime,
    );

    // Add completed level if provided and not already in the list
    if (completedLevel != null &&
        !updatedStats.levelsCompleted.contains(completedLevel)) {
      final updatedLevels = List<String>.from(updatedStats.levelsCompleted)
        ..add(completedLevel);

      // Update with new levels list
      final statsWithLevel = updatedStats.copyWith(
        levelsCompleted: updatedLevels,
      );

      await saveGameStatistics(statsWithLevel);
    } else {
      await saveGameStatistics(updatedStats);
    }
  }
}
