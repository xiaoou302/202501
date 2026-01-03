class PlayerStats {
  final String playerId;
  final int totalWins;
  final int currentStreak;
  final int longestStreak;
  final Duration totalPlayTime;
  final Duration averageTimePerLevel;
  final double completionPercentage;
  final List<String> unlockedArtifacts;
  final Map<String, LevelProgress> levelProgress;

  PlayerStats({
    required this.playerId,
    this.totalWins = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalPlayTime = Duration.zero,
    this.averageTimePerLevel = Duration.zero,
    this.completionPercentage = 0.0,
    this.unlockedArtifacts = const [],
    this.levelProgress = const {},
  });
}

class LevelProgress {
  final int attempts;
  final bool completed;
  final Duration? bestTime;
  final int stars;
  final DateTime lastPlayed;

  LevelProgress({
    this.attempts = 0,
    this.completed = false,
    this.bestTime,
    this.stars = 0,
    required this.lastPlayed,
  });
}
