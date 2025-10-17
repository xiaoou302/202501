import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement_model.dart';
import '../../domain/repositories/achievement_repository_interface.dart';

/// Repository for achievement-related data and operations
class AchievementRepository implements IAchievementRepository {
  /// List of all achievements in the game
  final List<Achievement> _achievements = [
    // Beginner achievements
    const Achievement(
      id: 'first_win',
      title: 'First Steps',
      description: 'Complete your first level',
      icon: 'seedling',
      isUnlocked: false,
      category: 'beginner',
    ),
    const Achievement(
      id: 'chapter_one',
      title: 'Apprentice',
      description: 'Complete Chapter 1',
      icon: 'book-open',
      isUnlocked: false,
      category: 'beginner',
    ),
    const Achievement(
      id: 'three_games',
      title: 'Getting Started',
      description: 'Play 3 games',
      icon: 'gamepad',
      isUnlocked: false,
      category: 'beginner',
    ),

    // Intermediate achievements
    const Achievement(
      id: 'quick_win',
      title: 'Swift Hands',
      description: 'Complete a level in under 2 minutes',
      icon: 'bolt',
      isUnlocked: false,
      category: 'intermediate',
    ),
    const Achievement(
      id: 'win_streak',
      title: 'Winning Streak',
      description: 'Win 5 levels in a row',
      icon: 'trophy',
      isUnlocked: false,
      category: 'intermediate',
    ),
    const Achievement(
      id: 'shuffle_win',
      title: 'Lucky Shuffle',
      description: 'Win a level after using the shuffle power-up',
      icon: 'random',
      isUnlocked: false,
      category: 'intermediate',
    ),

    // Advanced achievements
    const Achievement(
      id: 'no_powerup',
      title: 'Pure Strategy',
      description: 'Complete a level without using any power-ups',
      icon: 'chess-knight',
      isUnlocked: false,
      category: 'advanced',
    ),
    const Achievement(
      id: 'full_hand',
      title: 'Full House',
      description: 'Fill your hand with 7 tiles and still win the level',
      icon: 'hand',
      isUnlocked: false,
      category: 'advanced',
    ),
    const Achievement(
      id: 'master',
      title: 'Zen Master',
      description: 'Complete all levels in the game',
      icon: 'crown',
      isUnlocked: false,
      category: 'advanced',
    ),

    // Hidden achievements
    const Achievement(
      id: 'speed_demon',
      title: 'Speed Demon',
      description: 'Complete a level in under 60 seconds',
      icon: 'fire',
      isUnlocked: false,
      category: 'hidden',
      isHidden: true,
    ),
    const Achievement(
      id: 'perfect_match',
      title: 'Perfect Match',
      description: 'Match 5 sets of tiles in a row without adding to your hand',
      icon: 'star',
      isUnlocked: false,
      category: 'hidden',
      isHidden: true,
    ),
    const Achievement(
      id: 'night_owl',
      title: 'Night Owl',
      description: 'Play Jongara after midnight',
      icon: 'moon',
      isUnlocked: false,
      category: 'hidden',
      isHidden: true,
    ),
  ];

  @override
  /// Gets all achievements
  Future<List<Achievement>> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();

    // Load the unlock status for each achievement
    return _achievements.map((achievement) {
      final isUnlocked =
          prefs.getBool('achievement_${achievement.id}') ?? false;
      final unlockedAtStr = prefs.getString(
        'achievement_${achievement.id}_time',
      );

      DateTime? unlockedAt;
      if (unlockedAtStr != null) {
        try {
          unlockedAt = DateTime.parse(unlockedAtStr);
        } catch (_) {
          unlockedAt = null;
        }
      }

      return achievement.copyWith(
        isUnlocked: isUnlocked,
        unlockedAt: unlockedAt,
      );
    }).toList();
  }

  @override
  /// Unlocks an achievement
  Future<void> unlockAchievement(String achievementId) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    await prefs.setBool('achievement_$achievementId', true);
    await prefs.setString(
      'achievement_${achievementId}_time',
      now.toIso8601String(),
    );
  }

  @override
  /// Checks if an achievement is unlocked
  Future<bool> isAchievementUnlocked(String achievementId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('achievement_$achievementId') ?? false;
  }

  @override
  /// Resets all achievements (for testing)
  Future<void> resetAchievements() async {
    final prefs = await SharedPreferences.getInstance();

    for (final achievement in _achievements) {
      await prefs.remove('achievement_${achievement.id}');
      await prefs.remove('achievement_${achievement.id}_time');
    }
  }
}
