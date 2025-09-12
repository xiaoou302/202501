/// 排行榜条目模型，定义排行榜中的一条记录
class LeaderboardEntry {
  /// 排名
  final int rank;

  /// 日期（毫秒时间戳）
  final int dateTimeMillis;

  /// 用时（秒）
  final int timeSeconds; //ddddddeeee

  /// 游戏模式（classic 或 challenge）
  final String mode;

  LeaderboardEntry({
    required this.rank,
    required this.dateTimeMillis,
    required this.timeSeconds,
    required this.mode,
  });

  /// 从JSON创建排行榜条目
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      dateTimeMillis: json['dateTimeMillis'] as int,
      timeSeconds: json['timeSeconds'] as int,
      mode: json['mode'] as String,
    );
  }

  /// 将排行榜条目转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'dateTimeMillis': dateTimeMillis,
      'timeSeconds': timeSeconds,
      'mode': mode,
    };
  }

  /// 创建排行榜条目的副本
  LeaderboardEntry copyWith({
    int? rank,
    int? dateTimeMillis,
    int? timeSeconds,
    String? mode,
  }) {
    return LeaderboardEntry(
      rank: rank ?? this.rank,
      dateTimeMillis: dateTimeMillis ?? this.dateTimeMillis,
      timeSeconds: timeSeconds ?? this.timeSeconds,
      mode: mode ?? this.mode,
    );
  }
}
