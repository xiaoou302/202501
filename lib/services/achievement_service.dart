import 'package:flutter/material.dart';
import '../utils/preferences_manager.dart';
import '../utils/constants.dart';
import '../widgets/achievement_unlock_notification.dart';

/// Model for achievement data
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isSecret;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.isSecret = false,
  });
}

/// Service for managing achievements
class AchievementService {
  /// Get all available achievements
  static List<Achievement> getAllAchievements() {
    return [
      Achievement(
        id: 'beginner',
        title: 'Beginner',
        description: 'Complete 10 levels',
        icon: Icons.emoji_events,
        iconColor: AppColors.accentCoral,
      ),
      Achievement(
        id: 'logic_master',
        title: 'Logic Master',
        description: 'Complete 5 levels in a row without errors',
        icon: Icons.psychology,
        iconColor: AppColors.arrowBlue,
      ),
      Achievement(
        id: 'perfectionist',
        title: 'Perfectionist',
        description: 'Achieve 100% completion in a level pack',
        icon: Icons.lock,
        iconColor: AppColors.textGraphite,
      ),
      Achievement(
        id: 'speed_demon',
        title: 'Speed Demon',
        description: 'Complete a level in under 10 seconds',
        icon: Icons.speed,
        iconColor: AppColors.arrowTerracotta,
      ),
      Achievement(
        id: 'explorer',
        title: 'Explorer',
        description: 'Try all level packs',
        icon: Icons.explore,
        iconColor: AppColors.arrowGreen,
      ),
    ];
  }

  /// Get achievement by ID
  static Achievement? getAchievementById(String id) {
    for (final achievement in getAllAchievements()) {
      if (achievement.id == id) {
        return achievement;
      }
    }
    return null;
  }

  /// Check if an achievement is unlocked
  static Future<bool> isAchievementUnlocked(String id) async {
    final unlockedAchievements =
        await PreferencesManager.getUnlockedAchievements();
    return unlockedAchievements.contains(id);
  }

  /// Get progress for an achievement
  static Future<double> getAchievementProgress(String id) async {
    return PreferencesManager.getAchievementProgress(id);
  }

  /// Update achievement progress and unlock if completed
  static Future<bool> updateAchievementProgress(
    String id,
    double progress,
  ) async {
    // Cap progress at 100%
    if (progress > 1.0) {
      progress = 1.0;
    }

    await PreferencesManager.updateAchievementProgress(id, progress);

    // If progress is 100%, unlock the achievement
    if (progress >= 1.0) {
      return unlockAchievement(id);
    }

    return false;
  }

  /// Unlock an achievement
  static Future<bool> unlockAchievement(String id) async {
    // Check if already unlocked
    if (await isAchievementUnlocked(id)) {
      return false;
    }

    // Set progress to 100%
    await PreferencesManager.updateAchievementProgress(id, 1.0);

    // Mark as unlocked
    final result = await PreferencesManager.unlockAchievement(id);

    return result;
  }

  /// Show achievement unlock notification
  static void showAchievementUnlockNotification(
    BuildContext context,
    String achievementId,
  ) {
    final achievement = getAchievementById(achievementId);
    if (achievement == null) return;

    // Create overlay entry
    final overlayState = Overlay.of(context);
    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: AchievementUnlockNotification(
            achievement: achievement,
            onDismiss: () {
              // Remove the overlay entry when dismissed
              overlayEntry.remove();
            },
          ),
        ),
      ),
    );

    // Insert the overlay
    overlayState.insert(overlayEntry);

    // Auto remove after 5 seconds as a fallback
    Future.delayed(const Duration(seconds: 5), () {
      try {
        overlayEntry.remove();
      } catch (e) {
        // Entry might already be removed
      }
    });
  }

  /// Check for achievement progress after completing a level
  static Future<List<Achievement>> checkLevelCompletionAchievements(
    BuildContext context,
    int levelId,
    int moveCount,
    bool perfectSolution,
  ) async {
    final List<Achievement> newlyUnlocked = [];
    final completedLevels = await PreferencesManager.getCompletedLevels();

    // Check "Beginner" achievement
    if (completedLevels.length >= 10) {
      if (await updateAchievementProgress(
        'beginner',
        completedLevels.length / 10,
      )) {
        final achievement = getAchievementById('beginner')!;
        newlyUnlocked.add(achievement);
        showAchievementUnlockNotification(context, achievement.id);
      }
    } else {
      await updateAchievementProgress('beginner', completedLevels.length / 10);
    }

    // Check "Logic Master" achievement - 5 levels in a row without errors
    final consecutivePerfectLevels =
        await PreferencesManager.getConsecutivePerfectLevels();
    if (perfectSolution) {
      final newCount = consecutivePerfectLevels + 1;
      await PreferencesManager.setConsecutivePerfectLevels(newCount);

      if (newCount >= 5) {
        if (await updateAchievementProgress('logic_master', 1.0)) {
          final achievement = getAchievementById('logic_master')!;
          newlyUnlocked.add(achievement);
          showAchievementUnlockNotification(context, achievement.id);
        }
      } else {
        await updateAchievementProgress('logic_master', newCount / 5);
      }
    } else {
      // Reset consecutive count on errors
      await PreferencesManager.setConsecutivePerfectLevels(0);
    }

    // Check "Speed Demon" achievement - complete level in under 10 seconds
    final levelTime = await PreferencesManager.getLevelCompletionTime(levelId);
    if (levelTime > 0 && levelTime <= 10) {
      if (await updateAchievementProgress('speed_demon', 1.0)) {
        final achievement = getAchievementById('speed_demon')!;
        newlyUnlocked.add(achievement);
        showAchievementUnlockNotification(context, achievement.id);
      }
    }

    return newlyUnlocked;
  }
}
