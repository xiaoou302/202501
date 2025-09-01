import '../models/game_score.dart';
import '../models/leaderboard.dart';
import '../core/constants/game_constants.dart';
import 'storage_service.dart';

/// 分数管理服务
class ScoreService {
  static final ScoreService _instance = ScoreService._internal();

  factory ScoreService() {
    return _instance;
  }

  ScoreService._internal();

  final StorageService _storageService = StorageService();

  /// 保存游戏分数
  Future<void> saveScore(GameScore score) async {
    await _storageService.saveHighScore(score);
    await _checkScoreAchievements(score);
  }

  /// 获取指定游戏的最高分
  Future<GameScore?> getHighScore(String gameId, String difficulty) async {
    return await _storageService.getHighScore(gameId, difficulty);
  }

  /// 获取指定游戏的所有难度的最高分
  Future<List<GameScore>> getGameHighScores(String gameId) async {
    final allScores = await _storageService.getAllHighScores();
    return allScores.where((score) => score.gameId == gameId).toList();
  }

  /// 获取排行榜数据
  Future<List<LeaderboardEntry>> getLeaderboard(
    String gameId,
    String difficulty,
  ) async {
    // 在实际应用中，这里可能会从服务器获取排行榜数据
    // 这里我们创建一些模拟数据
    final List<LeaderboardEntry> leaderboard = [
      LeaderboardEntry(
        userId: 'user1',
        username: 'Zephyr',
        avatarUrl: 'player1',
        score: 54120,
        rank: 1,
      ),
      LeaderboardEntry(
        userId: 'user2',
        username: 'Nova',
        avatarUrl: 'player2',
        score: 51880,
        rank: 2,
      ),
      LeaderboardEntry(
        userId: 'user3',
        username: 'Orion',
        avatarUrl: 'player3',
        score: 49500,
        rank: 3,
      ),
      LeaderboardEntry(
        userId: 'user4',
        username: 'Luna',
        avatarUrl: 'player4',
        score: 47250,
        rank: 4,
      ),
      LeaderboardEntry(
        userId: 'user5',
        username: 'Astro',
        avatarUrl: 'player5',
        score: 45800,
        rank: 5,
      ),
    ];

    // 获取玩家的最高分
    final playerHighScore = await getHighScore(gameId, difficulty);
    if (playerHighScore != null) {
      // 计算玩家的排名
      int playerRank = 1;
      for (final entry in leaderboard) {
        if (entry.score > playerHighScore.score) {
          playerRank++;
        }
      }

      // 添加玩家的排行榜条目
      leaderboard.add(
        LeaderboardEntry(
          userId: 'current_user',
          username: 'You',
          avatarUrl: 'player_you',
          score: playerHighScore.score,
          rank: playerRank,
        ),
      );

      // 按排名排序
      leaderboard.sort((a, b) => a.rank.compareTo(b.rank));
    }

    return leaderboard;
  }

  /// 检查分数相关的成就
  Future<void> _checkScoreAchievements(GameScore score) async {
    // 在实际应用中，这里会根据分数触发相应的成就
    // 这里只是一个示例
    if (score.gameId == GameConstants.memoryGame) {
      if (score.score > 1000) {
        // 触发记忆游戏高分成就
      }
    } else if (score.gameId == GameConstants.rhythmGame) {
      if (score.score > 500) {
        // 触发节奏游戏高分成就
      }
    }
  }
}
