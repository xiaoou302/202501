/// 排行榜条目数据模型
class LeaderboardEntry {
  /// 用户唯一标识符
  final String userId;

  /// 用户名
  final String username;

  /// 用户头像 URL
  final String avatarUrl;

  /// 分数
  final int score;

  /// 排名
  final int rank;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.score,
    required this.rank,
  });

  /// 从 JSON 创建排行榜条目实例
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String,
      score: json['score'] as int,
      rank: json['rank'] as int,
    );
  }

  /// 将排行榜条目转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'score': score,
      'rank': rank,
    };
  }

  /// 创建当前用户的排行榜条目
  factory LeaderboardEntry.currentUser({
    required int score,
    required int rank,
  }) {
    return LeaderboardEntry(
      userId: 'current_user',
      username: 'You',
      avatarUrl: '',
      score: score,
      rank: rank,
    );
  }
}
