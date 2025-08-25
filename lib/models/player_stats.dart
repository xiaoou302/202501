/// 玩家统计数据模型
class PlayerStats {
  Duration totalPlaytime;
  int totalUnitsEliminated;
  int totalPlexiMatches;
  int longestComboChain;
  int highestScore;
  Map<int, int> levelHighScores; // 关卡ID -> 最高分
  Map<int, int> levelBestMoves; // 关卡ID -> 最少步数

  PlayerStats({
    this.totalPlaytime = Duration.zero,
    this.totalUnitsEliminated = 0,
    this.totalPlexiMatches = 0,
    this.longestComboChain = 0,
    this.highestScore = 0,
    Map<int, int>? levelHighScores,
    Map<int, int>? levelBestMoves,
  }) : levelHighScores = levelHighScores ?? {},
       levelBestMoves = levelBestMoves ?? {};

  // 更新游戏时间
  void addPlaytime(Duration duration) {
    totalPlaytime += duration;
  }

  // 更新消除单元数量
  void addUnitsEliminated(int count) {
    totalUnitsEliminated += count;
  }

  // 更新完美匹配次数
  void addPlexiMatches(int count) {
    totalPlexiMatches += count;
  }

  // 更新连击链
  void updateComboChain(int comboChain) {
    if (comboChain > longestComboChain) {
      longestComboChain = comboChain;
    }
  }

  // 更新最高分
  void updateHighestScore(int score) {
    if (score > highestScore) {
      highestScore = score;
    }
  }

  // 更新关卡最高分
  void updateLevelHighScore(int levelId, int score) {
    final currentHighScore = levelHighScores[levelId] ?? 0;
    if (score > currentHighScore) {
      levelHighScores[levelId] = score;
    }
  }

  // 更新关卡最少步数
  void updateLevelBestMoves(int levelId, int moves) {
    final currentBestMoves = levelBestMoves[levelId] ?? 999;
    if (moves < currentBestMoves) {
      levelBestMoves[levelId] = moves;
    }
  }

  // 序列化为JSON
  Map<String, dynamic> toJson() {
    // 将Map<int, int>转换为Map<String, int>，确保键是字符串
    Map<String, int> convertIntMap(Map<int, int> map) {
      return map.map((key, value) => MapEntry(key.toString(), value));
    }

    return {
      'totalPlaytimeSeconds': totalPlaytime.inSeconds,
      'totalUnitsEliminated': totalUnitsEliminated,
      'totalPlexiMatches': totalPlexiMatches,
      'longestComboChain': longestComboChain,
      'highestScore': highestScore,
      'levelHighScores': convertIntMap(levelHighScores),
      'levelBestMoves': convertIntMap(levelBestMoves),
    };
  }

  // 从JSON反序列化
  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    // 将JSON中的Map<String, dynamic>转换为Map<int, int>
    Map<int, int> parseIntMap(Map<String, dynamic>? map) {
      if (map == null) return {};
      return map.map((key, value) => MapEntry(int.parse(key), value as int));
    }

    return PlayerStats(
      totalPlaytime: Duration(seconds: json['totalPlaytimeSeconds'] ?? 0),
      totalUnitsEliminated: json['totalUnitsEliminated'] ?? 0,
      totalPlexiMatches: json['totalPlexiMatches'] ?? 0,
      longestComboChain: json['longestComboChain'] ?? 0,
      highestScore: json['highestScore'] ?? 0,
      levelHighScores: parseIntMap(
        json['levelHighScores'] as Map<String, dynamic>?,
      ),
      levelBestMoves: parseIntMap(
        json['levelBestMoves'] as Map<String, dynamic>?,
      ),
    );
  }
}
