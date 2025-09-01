import 'dart:math' as math;
import '../core/constants/game_constants.dart';
import '../models/game_statistics.dart';
import 'storage_service.dart';

/// Service for managing game statistics
class StatsService {
  static final StatsService _instance = StatsService._internal();

  factory StatsService() {
    return _instance;
  }

  StatsService._internal();

  final StorageService _storageService = StorageService();

  /// Get statistics for a specific game
  Future<GameStatistics> getGameStatistics(String gameId) async {
    final stats = await _storageService.getGameStatistics(gameId);
    return stats ?? GameStatistics.defaultStats(gameId);
  }

  /// Get statistics for all games
  Future<List<GameStatistics>> getAllGameStatistics() async {
    final List<GameStatistics> stats = await _storageService
        .getAllGameStatistics();

    // Ensure we have stats for all three games
    final List<String> gameIds = [
      GameConstants.memoryGame,
      GameConstants.rhythmGame,
      GameConstants.numberGame,
    ];

    for (final gameId in gameIds) {
      if (!stats.any((s) => s.gameId == gameId)) {
        stats.add(GameStatistics.defaultStats(gameId));
      }
    }

    return stats;
  }

  /// Get formatted statistics for Memory Match game
  Future<Map<String, String>> getMemoryGameStats() async {
    final stats = await getGameStatistics(GameConstants.memoryGame);
    final Map<String, String> formattedStats = {};

    // Basic stats
    formattedStats['Games Played'] = stats.gamesPlayed.toString();
    formattedStats['Best Score'] = stats.bestScore.toString();

    // Format best time if available
    if (stats.bestTime != null) {
      formattedStats['Best Time'] = _formatTime(stats.bestTime!);
    }

    // Levels completed
    formattedStats['Levels Completed'] = '${stats.levelsCompleted.length}/7';

    // Calculate completion percentage
    final completionPercent = (stats.levelsCompleted.length / 7 * 100).round();
    formattedStats['Completion'] = '$completionPercent%';

    // Average time per game (if played)
    if (stats.gamesPlayed > 0) {
      final avgTime = stats.totalTimePlayed ~/ math.max(1, stats.gamesPlayed);
      formattedStats['Avg. Time per Game'] = _formatTime(avgTime);
    }

    return formattedStats;
  }

  /// Get formatted statistics for Rhythm Flow game
  Future<Map<String, String>> getRhythmGameStats() async {
    final stats = await getGameStatistics(GameConstants.rhythmGame);
    final Map<String, String> formattedStats = {};

    // Basic stats
    formattedStats['Games Played'] = stats.gamesPlayed.toString();
    formattedStats['Best Score'] = stats.bestScore.toString();

    // Levels completed
    final totalLevels = 7; // From flow_easy to flow_legend
    formattedStats['Levels Completed'] =
        '${stats.levelsCompleted.length}/$totalLevels';

    // Calculate completion percentage
    final completionPercent = (stats.levelsCompleted.length / totalLevels * 100)
        .round();
    formattedStats['Completion'] = '$completionPercent%';

    // Total play time
    formattedStats['Total Play Time'] = _formatTime(stats.totalTimePlayed);

    // Average score (if played)
    if (stats.gamesPlayed > 0 &&
        stats.specificStats.containsKey('totalScore')) {
      final avgScore =
          (stats.specificStats['totalScore'] as int) ~/ stats.gamesPlayed;
      formattedStats['Avg. Score'] = avgScore.toString();
    }

    return formattedStats;
  }

  /// Get formatted statistics for Number Memory game
  Future<Map<String, String>> getNumberGameStats() async {
    final stats = await getGameStatistics(GameConstants.numberGame);
    final Map<String, String> formattedStats = {};

    // Basic stats
    formattedStats['Games Played'] = stats.gamesPlayed.toString();
    formattedStats['Best Score'] = stats.bestScore.toString();

    // Levels completed
    final totalLevels = 7; // From number_level1 to number_level7
    formattedStats['Levels Completed'] =
        '${stats.levelsCompleted.length}/$totalLevels';

    // Calculate completion percentage
    final completionPercent = (stats.levelsCompleted.length / totalLevels * 100)
        .round();
    formattedStats['Completion'] = '$completionPercent%';

    // Max sequence remembered (if available)
    if (stats.specificStats.containsKey('maxSequence')) {
      formattedStats['Max Sequence'] = stats.specificStats['maxSequence']
          .toString();
    }

    // Success rate (if available)
    if (stats.specificStats.containsKey('successRate')) {
      final rate = (stats.specificStats['successRate'] as double)
          .toStringAsFixed(1);
      formattedStats['Success Rate'] = '$rate%';
    }

    return formattedStats;
  }

  /// Format time in seconds to MM:SS format
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Update statistics after a game session
  Future<void> updateGameStats({
    required String gameId,
    required int score,
    required int timePlayed,
    String? completedLevel,
    Map<String, dynamic>? additionalStats,
  }) async {
    await _storageService.updateGameStatistics(
      gameId: gameId,
      score: score,
      timePlayed: timePlayed,
      completedLevel: completedLevel,
      additionalStats: additionalStats,
    );
  }

  /// Generate game-specific insights based on statistics
  Future<List<String>> getGameInsights(String gameId) async {
    final stats = await getGameStatistics(gameId);
    final List<String> insights = [];

    // General insights
    if (stats.gamesPlayed == 0) {
      insights.add("You haven't played this game yet. Give it a try!");
      return insights;
    }

    // Game-specific insights
    switch (gameId) {
      case GameConstants.memoryGame:
        if (stats.levelsCompleted.length < 3) {
          insights.add("Try completing more levels to unlock special cards!");
        }
        if (stats.bestScore > 5000) {
          insights.add("Great memory skills! You're a master at this game.");
        }
        break;

      case GameConstants.rhythmGame:
        if (stats.levelsCompleted.contains(GameConstants.flowHard)) {
          insights.add(
            "You've mastered the hard level! Try the expert level next.",
          );
        }
        if (stats.bestScore > 1000) {
          insights.add("Impressive rhythm skills! Your timing is excellent.");
        }
        break;

      case GameConstants.numberGame:
        if (stats.specificStats.containsKey('maxSequence') &&
            stats.specificStats['maxSequence'] > 10) {
          insights.add(
            "Amazing memory capacity! You can remember long sequences.",
          );
        }
        break;
    }

    // Add general insights
    if (stats.gamesPlayed > 10) {
      insights.add(
        "You've played this game ${stats.gamesPlayed} times. That's dedication!",
      );
    }

    return insights;
  }
}
