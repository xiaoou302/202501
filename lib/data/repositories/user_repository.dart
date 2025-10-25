import '../../core/models/user_stats_model.dart';
import '../../core/models/settings_model.dart';
import '../local/storage_service.dart';

/// Repository for user data
class UserRepository {
  final StorageService _storage;

  UserRepository(this._storage);

  /// Get user stats
  UserStats getUserStats() {
    return _storage.loadUserStats();
  }

  /// Save user stats
  Future<bool> saveUserStats(UserStats stats) async {
    return await _storage.saveUserStats(stats);
  }

  /// Update chapter progress
  Future<bool> updateChapterProgress(
    int chapterId,
    ChapterProgress progress,
  ) async {
    final currentStats = getUserStats();
    final updatedProgress = Map<int, ChapterProgress>.from(
      currentStats.chapterProgress,
    );
    updatedProgress[chapterId] = progress;

    // Update completed count if newly completed
    int completedCount = currentStats.chaptersCompleted;
    if (progress.isCompleted &&
        (!currentStats.chapterProgress.containsKey(chapterId) ||
            !currentStats.chapterProgress[chapterId]!.isCompleted)) {
      completedCount++;
    }

    final updatedStats = currentStats.copyWith(
      chapterProgress: updatedProgress,
      chaptersCompleted: completedCount,
      totalWordsSaved:
          currentStats.totalWordsSaved + progress.savedKeywords.length,
    );

    return await saveUserStats(updatedStats);
  }

  /// Get settings
  AppSettings getSettings() {
    return _storage.loadSettings();
  }

  /// Save settings
  Future<bool> saveSettings(AppSettings settings) async {
    return await _storage.saveSettings(settings);
  }

  /// Get last played chapter ID
  int? getLastChapterId() {
    return _storage.loadLastChapterId();
  }

  /// Save last played chapter ID
  Future<bool> saveLastChapterId(int chapterId) async {
    return await _storage.saveLastChapterId(chapterId);
  }

  /// Add play time
  Future<bool> addPlayTime(Duration duration) async {
    final currentStats = getUserStats();
    final updatedStats = currentStats.copyWith(
      totalTimePlayed: currentStats.totalTimePlayed + duration,
    );
    return await saveUserStats(updatedStats);
  }

  /// Reset all progress
  Future<bool> resetProgress() async {
    return await _storage.clearAll();
  }
}
