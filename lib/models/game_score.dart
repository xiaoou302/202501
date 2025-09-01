/// 游戏分数数据模型
class GameScore {
  /// 游戏类型标识符
  final String gameId;

  /// 分数值
  final int score;

  /// 记录时间
  final DateTime timestamp;

  /// 游戏特定数据（如难度、使用的能力等）
  final Map<String, dynamic> gameSpecificData;

  GameScore({
    required this.gameId,
    required this.score,
    required this.timestamp,
    this.gameSpecificData = const {},
  });

  /// 从 JSON 创建游戏分数实例
  factory GameScore.fromJson(Map<String, dynamic> json) {
    return GameScore(
      gameId: json['gameId'] as String,
      score: json['score'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      gameSpecificData: json['gameSpecificData'] as Map<String, dynamic>? ?? {},
    );
  }

  /// 将游戏分数转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'score': score,
      'timestamp': timestamp.toIso8601String(),
      'gameSpecificData': gameSpecificData,
    };
  }

  /// 创建当前时间的游戏分数
  factory GameScore.now({
    required String gameId,
    required int score,
    Map<String, dynamic> gameSpecificData = const {},
  }) {
    return GameScore(
      gameId: gameId,
      score: score,
      timestamp: DateTime.now(),
      gameSpecificData: gameSpecificData,
    );
  }
}
