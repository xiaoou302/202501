import 'dart:math';
import '../core/constants/game_constants.dart';
import '../models/game_statistics.dart';
import '../services/storage_service.dart';

/// Utility class to generate demo data for testing
class DemoDataGenerator {
  final StorageService _storageService = StorageService();
  final Random _random = Random();

  /// Generate demo statistics for all games
  Future<void> generateDemoStats() async {
    await _generateMemoryGameStats();
    await _generateRhythmGameStats();
    await _generateNumberGameStats();
  }

  /// Generate demo statistics for Memory Match game
  Future<void> _generateMemoryGameStats() async {
    final gamesPlayed = _random.nextInt(20) + 5;
    final bestScore = _random.nextInt(5000) + 1000;
    final totalTimePlayed = gamesPlayed * (_random.nextInt(180) + 60);
    final bestTime = _random.nextInt(120) + 60;

    // Generate completed levels
    final levelCount = _random.nextInt(5) + 1;
    final List<String> completedLevels = [];
    for (int i = 0; i < levelCount; i++) {
      completedLevels.add('level_${i + 1}');
    }

    // Create game-specific stats
    final Map<String, dynamic> specificStats = {
      'perfectMatches': _random.nextInt(gamesPlayed),
      'totalMoves': gamesPlayed * (_random.nextInt(30) + 10),
      'specialCardsFound': _random.nextInt(20),
    };

    // Create and save statistics
    final stats = GameStatistics(
      gameId: GameConstants.memoryGame,
      gamesPlayed: gamesPlayed,
      totalTimePlayed: totalTimePlayed,
      bestScore: bestScore,
      bestTime: bestTime,
      levelsCompleted: completedLevels,
      specificStats: specificStats,
    );

    await _storageService.saveGameStatistics(stats);
  }

  /// Generate demo statistics for Rhythm Flow game
  Future<void> _generateRhythmGameStats() async {
    final gamesPlayed = _random.nextInt(15) + 3;
    final bestScore = _random.nextInt(3000) + 500;
    final totalTimePlayed = gamesPlayed * (_random.nextInt(120) + 30);

    // Generate completed levels
    final List<String> completedLevels = [
      GameConstants.flowEasy,
      GameConstants.flowNormal,
    ];

    if (_random.nextBool()) {
      completedLevels.add(GameConstants.flowHard);
    }

    if (_random.nextBool() &&
        completedLevels.contains(GameConstants.flowHard)) {
      completedLevels.add(GameConstants.flowExpert);
    }

    // Create game-specific stats
    final Map<String, dynamic> specificStats = {
      'totalScore': gamesPlayed * bestScore ~/ 2,
      'perfectMatches': _random.nextInt(gamesPlayed),
      'maxCombo': _random.nextInt(10) + 5,
    };

    // Create and save statistics
    final stats = GameStatistics(
      gameId: GameConstants.rhythmGame,
      gamesPlayed: gamesPlayed,
      totalTimePlayed: totalTimePlayed,
      bestScore: bestScore,
      bestTime: null, // Rhythm game doesn't track best time
      levelsCompleted: completedLevels,
      specificStats: specificStats,
    );

    await _storageService.saveGameStatistics(stats);
  }

  /// Generate demo statistics for Number Memory game
  Future<void> _generateNumberGameStats() async {
    final gamesPlayed = _random.nextInt(10) + 2;
    final bestScore = _random.nextInt(1000) + 200;
    final totalTimePlayed = gamesPlayed * (_random.nextInt(60) + 20);

    // Generate completed levels
    final List<String> completedLevels = [GameConstants.numberLevel1];

    if (_random.nextBool()) {
      completedLevels.add(GameConstants.numberLevel2);
    }

    // Create game-specific stats
    final Map<String, dynamic> specificStats = {
      'maxSequence': _random.nextInt(10) + 3,
      'successRate': _random.nextDouble() * 50 + 50, // 50-100%
      'totalAttempts': gamesPlayed * (_random.nextInt(5) + 3),
    };

    // Create and save statistics
    final stats = GameStatistics(
      gameId: GameConstants.numberGame,
      gamesPlayed: gamesPlayed,
      totalTimePlayed: totalTimePlayed,
      bestScore: bestScore,
      bestTime: _random.nextInt(30) + 10,
      levelsCompleted: completedLevels,
      specificStats: specificStats,
    );

    await _storageService.saveGameStatistics(stats);
  }
}
