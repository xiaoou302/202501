/// 玩家模型，存储玩家的统计数据和成就
class Player {
  /// 游戏局数
  final int gamesPlayed;

  /// 获胜局数
  final int gamesWon;

  /// 6x6 模式最佳用时（秒）
  final int? bestTime6x6;

  /// 8x8 模式最佳用时（秒）
  final int? bestTime8x8;

  /// 已解锁的成就列表
  final List<String> achievements;

  Player({
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.bestTime6x6,
    this.bestTime8x8,
    List<String>? achievements,
  }) : achievements = achievements ?? [];

  /// 计算胜率
  double get winRate {
    if (gamesPlayed == 0) return 0;
    return gamesWon / gamesPlayed;
  }

  /// 从JSON创建玩家对象
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      gamesWon: json['gamesWon'] as int? ?? 0,
      bestTime6x6: json['bestTime6x6'] as int?,
      bestTime8x8: json['bestTime8x8'] as int?,
      achievements: (json['achievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  /// 将玩家对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'bestTime6x6': bestTime6x6,
      'bestTime8x8': bestTime8x8,
      'achievements': achievements,
    };
  }

  /// 创建玩家的副本
  Player copyWith({
    int? gamesPlayed,
    int? gamesWon,
    int? bestTime6x6,
    int? bestTime8x8,
    List<String>? achievements,
  }) {
    return Player(
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
      bestTime6x6: bestTime6x6 ?? this.bestTime6x6,
      bestTime8x8: bestTime8x8 ?? this.bestTime8x8,
      achievements: achievements ?? List.from(this.achievements),
    );
  }

  /// 更新玩家游戏结果
  Player updateGameResult({
    required bool isVictory,
    required int timeSeconds,
    required int gridSize,
  }) {
    final newGamesPlayed = gamesPlayed + 1;
    final newGamesWon = isVictory ? gamesWon + 1 : gamesWon;

    int? newBestTime6x6 = bestTime6x6;
    int? newBestTime8x8 = bestTime8x8;

    // Create a new list of achievements
    final newAchievements = List<String>.from(achievements);

    // If this is the first win, unlock the 'first_win' achievement
    if (isVictory && !achievements.contains('first_win')) {
      newAchievements.add('first_win');
    }

    // 如果获胜且时间更好，则更新最佳时间
    if (isVictory) {
      if (gridSize == 6) {
        // Check if this is a speed record (under 60 seconds)
        if (timeSeconds < 60 && !achievements.contains('speed_demon')) {
          newAchievements.add('speed_demon');
        }

        if (bestTime6x6 == null || timeSeconds < bestTime6x6!) {
          newBestTime6x6 = timeSeconds;
        }
      } else if (gridSize == 8) {
        if (bestTime8x8 == null || timeSeconds < bestTime8x8!) {
          newBestTime8x8 = timeSeconds;
        }
      }
    }

    // If player has won 5+ games, unlock 'strategy_master'
    if (newGamesWon >= 5 && !achievements.contains('strategy_master')) {
      newAchievements.add('strategy_master');
    }

    // If player has excellent win rate (>80% after 10+ games), unlock 'perfectionist'
    if (newGamesPlayed >= 10 &&
        (newGamesWon / newGamesPlayed) >= 0.8 &&
        !achievements.contains('perfectionist')) {
      newAchievements.add('perfectionist');
    }

    return copyWith(
      gamesPlayed: newGamesPlayed,
      gamesWon: newGamesWon,
      bestTime6x6: newBestTime6x6,
      bestTime8x8: newBestTime8x8,
      achievements: newAchievements,
    );
  }
}
