import 'dart:math' as math;
import '../core/constants/game_constants.dart';
import '../models/achievement.dart';
import '../models/game_statistics.dart';
import 'storage_service.dart';
import 'stats_service.dart';

/// Service for managing achievements
class AchievementService {
  static final AchievementService _instance = AchievementService._internal();

  factory AchievementService() {
    return _instance;
  }

  AchievementService._internal();

  final StorageService _storageService = StorageService();
  final StatsService _statsService = StatsService();

  /// Get all achievements with their current progress
  Future<List<Achievement>> getAllAchievements() async {
    // Get all game statistics
    final List<GameStatistics> allStats = await _statsService
        .getAllGameStatistics();

    // Define all possible achievements
    final List<Achievement> achievements = await _defineAchievements(allStats);

    // Check for any saved achievements (for backward compatibility)
    try {
      final List<Achievement> savedAchievements = await _storageService
          .getAllAchievements();
      if (savedAchievements.isNotEmpty) {
        // Merge saved achievements with current ones
        for (final saved in savedAchievements) {
          final index = achievements.indexWhere((a) => a.id == saved.id);
          if (index != -1) {
            // Keep the higher progress
            final current = achievements[index];
            if (saved.progress > current.progress) {
              achievements[index] = saved;
            }
          }
        }
      }
    } catch (e) {
      // Ignore errors if no saved achievements
    }

    return achievements;
  }

  /// Define all possible achievements and calculate their progress
  Future<List<Achievement>> _defineAchievements(
    List<GameStatistics> allStats,
  ) async {
    final List<Achievement> achievements = [];

    // Get statistics for each game
    final memoryStats = allStats.firstWhere(
      (s) => s.gameId == GameConstants.memoryGame,
      orElse: () => GameStatistics.defaultStats(GameConstants.memoryGame),
    );

    final rhythmStats = allStats.firstWhere(
      (s) => s.gameId == GameConstants.rhythmGame,
      orElse: () => GameStatistics.defaultStats(GameConstants.rhythmGame),
    );

    final numberStats = allStats.firstWhere(
      (s) => s.gameId == GameConstants.numberGame,
      orElse: () => GameStatistics.defaultStats(GameConstants.numberGame),
    );

    // Total games played across all games
    final totalGamesPlayed =
        memoryStats.gamesPlayed +
        rhythmStats.gamesPlayed +
        numberStats.gamesPlayed;

    // ===== GENERAL ACHIEVEMENTS =====

    // First Game
    achievements.add(
      Achievement(
        id: 'first_game',
        title: 'First Steps',
        description: 'Play your first game',
        icon: 'check',
        progress: totalGamesPlayed > 0 ? 1 : 0,
        maxProgress: 1,
        isCompleted: totalGamesPlayed > 0,
      ),
    );

    // Game Enthusiast
    achievements.add(
      Achievement(
        id: 'game_enthusiast',
        title: 'Game Enthusiast',
        description: 'Play 10 games in total',
        icon: 'gamepad',
        progress: math.min(totalGamesPlayed, 10),
        maxProgress: 10,
        isCompleted: totalGamesPlayed >= 10,
      ),
    );

    // Game Master
    achievements.add(
      Achievement(
        id: 'game_master',
        title: 'Game Master',
        description: 'Play 50 games in total',
        icon: 'emoji_events',
        progress: math.min(totalGamesPlayed, 50),
        maxProgress: 50,
        isCompleted: totalGamesPlayed >= 50,
      ),
    );

    // All-Around Player
    final playedAllGames =
        memoryStats.gamesPlayed > 0 &&
        rhythmStats.gamesPlayed > 0 &&
        numberStats.gamesPlayed > 0;
    achievements.add(
      Achievement(
        id: 'all_around_player',
        title: 'All-Around Player',
        description: 'Play all three games at least once',
        icon: 'diversity_3',
        progress:
            (memoryStats.gamesPlayed > 0 ? 1 : 0) +
            (rhythmStats.gamesPlayed > 0 ? 1 : 0) +
            (numberStats.gamesPlayed > 0 ? 1 : 0),
        maxProgress: 3,
        isCompleted: playedAllGames,
      ),
    );

    // ===== MEMORY MATCH ACHIEVEMENTS =====

    // Memory Novice
    achievements.add(
      Achievement(
        id: 'memory_novice',
        title: 'Memory Novice',
        description: 'Complete level 1 in Memory Match',
        icon: 'grid_view',
        progress: memoryStats.levelsCompleted.contains('level_1') ? 1 : 0,
        maxProgress: 1,
        isCompleted: memoryStats.levelsCompleted.contains('level_1'),
      ),
    );

    // Memory Adept
    achievements.add(
      Achievement(
        id: 'memory_adept',
        title: 'Memory Adept',
        description: 'Complete level 3 in Memory Match',
        icon: 'psychology',
        progress: memoryStats.levelsCompleted.contains('level_3') ? 1 : 0,
        maxProgress: 1,
        isCompleted: memoryStats.levelsCompleted.contains('level_3'),
      ),
    );

    // Memory Master
    achievements.add(
      Achievement(
        id: 'memory_master',
        title: 'Memory Master',
        description: 'Complete level 5 in Memory Match',
        icon: 'auto_awesome',
        progress: memoryStats.levelsCompleted.contains('level_5') ? 1 : 0,
        maxProgress: 1,
        isCompleted: memoryStats.levelsCompleted.contains('level_5'),
      ),
    );

    // Memory Legend
    achievements.add(
      Achievement(
        id: 'memory_legend',
        title: 'Memory Legend',
        description: 'Complete all levels in Memory Match',
        icon: 'star',
        progress: memoryStats.levelsCompleted.length,
        maxProgress: 7,
        isCompleted: memoryStats.levelsCompleted.length >= 7,
      ),
    );

    // High Scorer
    final memoryHighScore = memoryStats.bestScore;
    achievements.add(
      Achievement(
        id: 'memory_high_scorer',
        title: 'Memory High Scorer',
        description: 'Score 5000 points in Memory Match',
        icon: 'score',
        progress: math.min(memoryHighScore, 5000),
        maxProgress: 5000,
        isCompleted: memoryHighScore >= 5000,
      ),
    );

    // ===== RHYTHM FLOW ACHIEVEMENTS =====

    // Rhythm Novice
    achievements.add(
      Achievement(
        id: 'rhythm_novice',
        title: 'Rhythm Novice',
        description: 'Complete level 1 in Flow Rush',
        icon: 'music_note',
        progress: rhythmStats.levelsCompleted.contains(GameConstants.flowEasy)
            ? 1
            : 0,
        maxProgress: 1,
        isCompleted: rhythmStats.levelsCompleted.contains(
          GameConstants.flowEasy,
        ),
      ),
    );

    // Rhythm Adept
    achievements.add(
      Achievement(
        id: 'rhythm_adept',
        title: 'Rhythm Adept',
        description: 'Complete level 3 in Flow Rush',
        icon: 'piano',
        progress: rhythmStats.levelsCompleted.contains(GameConstants.flowHard)
            ? 1
            : 0,
        maxProgress: 1,
        isCompleted: rhythmStats.levelsCompleted.contains(
          GameConstants.flowHard,
        ),
      ),
    );

    // Rhythm Master
    achievements.add(
      Achievement(
        id: 'rhythm_master',
        title: 'Rhythm Master',
        description: 'Complete level 5 in Flow Rush',
        icon: 'auto_awesome',
        progress: rhythmStats.levelsCompleted.contains(GameConstants.flowMaster)
            ? 1
            : 0,
        maxProgress: 1,
        isCompleted: rhythmStats.levelsCompleted.contains(
          GameConstants.flowMaster,
        ),
      ),
    );

    // Rhythm Legend
    final rhythmLevelCount = rhythmStats.levelsCompleted.length;
    achievements.add(
      Achievement(
        id: 'rhythm_legend',
        title: 'Rhythm Legend',
        description: 'Complete all levels in Flow Rush',
        icon: 'star',
        progress: rhythmLevelCount,
        maxProgress: 7,
        isCompleted: rhythmLevelCount >= 7,
      ),
    );

    // Flow Master
    final rhythmHighScore = rhythmStats.bestScore;
    achievements.add(
      Achievement(
        id: 'flow_master',
        title: 'Flow Master',
        description: 'Score 3000 points in Flow Rush',
        icon: 'score',
        progress: math.min(rhythmHighScore, 3000),
        maxProgress: 3000,
        isCompleted: rhythmHighScore >= 3000,
      ),
    );

    // ===== NUMBER MEMORY ACHIEVEMENTS =====

    // Number Novice
    achievements.add(
      Achievement(
        id: 'number_novice',
        title: 'Number Novice',
        description: 'Complete level 1 in Number Memory',
        icon: 'format_list_numbered',
        progress: numberStats.levelsCompleted.contains('level_1') ? 1 : 0,
        maxProgress: 1,
        isCompleted: numberStats.levelsCompleted.contains('level_1'),
      ),
    );

    // Number Adept
    achievements.add(
      Achievement(
        id: 'number_adept',
        title: 'Number Adept',
        description: 'Complete level 3 in Number Memory',
        icon: 'numbers',
        progress: numberStats.levelsCompleted.contains('level_3') ? 1 : 0,
        maxProgress: 1,
        isCompleted: numberStats.levelsCompleted.contains('level_3'),
      ),
    );

    // Number Master
    achievements.add(
      Achievement(
        id: 'number_master',
        title: 'Number Master',
        description: 'Complete level 5 in Number Memory',
        icon: 'auto_awesome',
        progress: numberStats.levelsCompleted.contains('level_5') ? 1 : 0,
        maxProgress: 1,
        isCompleted: numberStats.levelsCompleted.contains('level_5'),
      ),
    );

    // Number Legend
    final numberLevelCount = numberStats.levelsCompleted.length;
    achievements.add(
      Achievement(
        id: 'number_legend',
        title: 'Number Legend',
        description: 'Complete all levels in Number Memory',
        icon: 'star',
        progress: numberLevelCount,
        maxProgress: 7,
        isCompleted: numberLevelCount >= 7,
      ),
    );

    // Sequence Master
    int maxSequence = 0;
    if (numberStats.specificStats.containsKey('maxSequence')) {
      maxSequence = numberStats.specificStats['maxSequence'] as int;
    }
    achievements.add(
      Achievement(
        id: 'sequence_master',
        title: 'Sequence Master',
        description: 'Remember a sequence of 10 numbers',
        icon: 'memory',
        progress: math.min(maxSequence, 10),
        maxProgress: 10,
        isCompleted: maxSequence >= 10,
      ),
    );

    // ===== SPECIAL ACHIEVEMENTS =====

    // Completionist
    final totalLevelsCompleted =
        memoryStats.levelsCompleted.length +
        rhythmStats.levelsCompleted.length +
        numberStats.levelsCompleted.length;
    achievements.add(
      Achievement(
        id: 'completionist',
        title: 'Completionist',
        description: 'Complete all levels in all games',
        icon: 'workspace_premium',
        progress: totalLevelsCompleted,
        maxProgress: 21, // 7 levels in each of 3 games
        isCompleted: totalLevelsCompleted >= 21,
      ),
    );

    // Dedicated Player
    final totalPlayTime =
        memoryStats.totalTimePlayed +
        rhythmStats.totalTimePlayed +
        numberStats.totalTimePlayed;
    final playTimeHours = totalPlayTime / 3600; // Convert seconds to hours
    achievements.add(
      Achievement(
        id: 'dedicated_player',
        title: 'Dedicated Player',
        description: 'Play for a total of 5 hours',
        icon: 'timer',
        progress: math.min(
          (totalPlayTime / 60).round(),
          300,
        ), // Convert to minutes, max 300 (5 hours)
        maxProgress: 300, // 5 hours in minutes
        isCompleted: playTimeHours >= 5,
      ),
    );

    return achievements;
  }

  /// Update achievements after a game session
  Future<List<Achievement>> updateAchievements() async {
    final achievements = await getAllAchievements();

    // Save all achievements to storage
    for (final achievement in achievements) {
      await _storageService.saveAchievement(achievement);
    }

    return achievements;
  }

  /// Check for newly unlocked achievements
  Future<List<Achievement>> getNewlyUnlockedAchievements() async {
    final List<Achievement> currentAchievements = await getAllAchievements();
    final List<Achievement> savedAchievements = await _storageService
        .getAllAchievements();

    final List<Achievement> newlyUnlocked = [];

    for (final current in currentAchievements) {
      // Find matching saved achievement
      final saved = savedAchievements.firstWhere(
        (a) => a.id == current.id,
        orElse: () => Achievement(
          id: current.id,
          title: current.title,
          description: current.description,
          icon: current.icon,
          progress: 0,
          maxProgress: current.maxProgress,
        ),
      );

      // Check if newly completed
      if (current.isCompleted && !saved.isCompleted) {
        newlyUnlocked.add(current);
      }
    }

    return newlyUnlocked;
  }
}
