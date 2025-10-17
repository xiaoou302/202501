import '../../data/models/achievement_model.dart';

/// Interface for achievement repository
abstract class IAchievementRepository {
  /// Gets all achievements
  Future<List<Achievement>> getAchievements();

  /// Unlocks an achievement
  Future<void> unlockAchievement(String achievementId);

  /// Checks if an achievement is unlocked
  Future<bool> isAchievementUnlocked(String achievementId);

  /// Resets all achievements (for testing)
  Future<void> resetAchievements(); //asdadasdasd
}
