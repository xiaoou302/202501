/// Game statistics data model
class GameStatistics {
  /// Game identifier
  final String gameId;

  /// Total games played
  final int gamesPlayed;

  /// Total time played (in seconds)
  final int totalTimePlayed;

  /// Best score achieved
  final int bestScore;

  /// Best completion time (in seconds, null if not applicable)
  final int? bestTime;

  /// Levels completed
  final List<String> levelsCompleted;

  /// Game-specific statistics
  final Map<String, dynamic> specificStats;

  GameStatistics({
    required this.gameId,
    required this.gamesPlayed,
    required this.totalTimePlayed,
    required this.bestScore,
    this.bestTime,
    required this.levelsCompleted,
    this.specificStats = const {},
  });

  /// Create from JSON
  factory GameStatistics.fromJson(Map<String, dynamic> json) {
    return GameStatistics(
      gameId: json['gameId'] as String,
      gamesPlayed: json['gamesPlayed'] as int,
      totalTimePlayed: json['totalTimePlayed'] as int,
      bestScore: json['bestScore'] as int,
      bestTime: json['bestTime'] as int?,
      levelsCompleted: List<String>.from(json['levelsCompleted'] as List),
      specificStats: json['specificStats'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'gamesPlayed': gamesPlayed,
      'totalTimePlayed': totalTimePlayed,
      'bestScore': bestScore,
      'bestTime': bestTime,
      'levelsCompleted': levelsCompleted,
      'specificStats': specificStats,
    };
  }

  /// Create a new instance with updated values
  GameStatistics copyWith({
    int? gamesPlayed,
    int? totalTimePlayed,
    int? bestScore,
    int? bestTime,
    List<String>? levelsCompleted,
    Map<String, dynamic>? specificStats,
  }) {
    return GameStatistics(
      gameId: this.gameId,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
      bestScore: bestScore ?? this.bestScore,
      bestTime: bestTime ?? this.bestTime,
      levelsCompleted: levelsCompleted ?? this.levelsCompleted,
      specificStats: specificStats ?? this.specificStats,
    );
  }

  /// Create default statistics for a game
  factory GameStatistics.defaultStats(String gameId) {
    return GameStatistics(
      gameId: gameId,
      gamesPlayed: 0,
      totalTimePlayed: 0,
      bestScore: 0,
      bestTime: null,
      levelsCompleted: [],
    );
  }
}
