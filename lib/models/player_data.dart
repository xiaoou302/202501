class PlayerData {
  int gamesPlayed;
  int victories;
  int totalScore;
  int highestScore;
  int bestStreak;
  Duration? fastestWin;
  Map<int, LevelStats> levelStats;
  Set<String> unlockedAchievements;

  PlayerData({
    this.gamesPlayed = 0,
    this.victories = 0,
    this.totalScore = 0,
    this.highestScore = 0,
    this.bestStreak = 0,
    this.fastestWin,
    Map<int, LevelStats>? levelStats,
    Set<String>? unlockedAchievements,
  })  : levelStats = levelStats ?? {},
        unlockedAchievements = unlockedAchievements ?? {};

  double get winRate => gamesPlayed > 0 ? (victories / gamesPlayed * 100) : 0;

  void recordGameStart() {
    gamesPlayed++;
  }

  void recordVictory({
    required int score,
    required int streak,
    required Duration time,
    required int levelNumber,
    required bool usedPowerUps,
  }) {
    victories++;
    totalScore += score;

    if (score > highestScore) {
      highestScore = score;
    }

    if (streak > bestStreak) {
      bestStreak = streak;
    }

    if (fastestWin == null || time < fastestWin!) {
      fastestWin = time;
    }

    // Update level stats
    final stats = levelStats[levelNumber] ?? LevelStats(levelNumber: levelNumber);
    stats.completions++;
    if (stats.bestTime == null || time < stats.bestTime!) {
      stats.bestTime = time;
    }
    if (score > stats.highestScore) {
      stats.highestScore = score;
    }
    if (streak > stats.bestStreak) {
      stats.bestStreak = streak;
    }
    levelStats[levelNumber] = stats;

    // Check achievements
    _checkAchievements(
      levelNumber: levelNumber,
      score: score,
      streak: streak,
      time: time,
      usedPowerUps: usedPowerUps,
    );
  }

  void _checkAchievements({
    required int levelNumber,
    required int score,
    required int streak,
    required Duration time,
    required bool usedPowerUps,
  }) {
    // First Victory
    if (victories == 1) {
      unlockedAchievements.add('first_victory');
    }

    // Speed Demon
    if (time.inSeconds < 120) {
      unlockedAchievements.add('speed_demon');
    }

    // Streak Master
    if (streak >= 10) {
      unlockedAchievements.add('streak_master');
    }

    // Perfect Score
    if (!usedPowerUps) {
      unlockedAchievements.add('perfect_score');
    }

    // Legend
    if (levelStats.length >= 8 && levelStats.values.every((s) => s.completions > 0)) {
      unlockedAchievements.add('legend');
    }

    // Memory Master
    if (levelNumber == 8 && !usedPowerUps) {
      unlockedAchievements.add('memory_master');
    }
  }

  bool hasAchievement(String id) => unlockedAchievements.contains(id);
}

class LevelStats {
  final int levelNumber;
  int completions;
  Duration? bestTime;
  int highestScore;
  int bestStreak;

  LevelStats({
    required this.levelNumber,
    this.completions = 0,
    this.bestTime,
    this.highestScore = 0,
    this.bestStreak = 0,
  });
}
