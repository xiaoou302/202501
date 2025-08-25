import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../models/level.dart';
import '../../services/storage.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/cyber_button.dart';
import '../campaign/campaign_screen.dart';

/// 游戏结束界面
class GameOverScreen extends StatelessWidget {
  final bool isVictory;
  final Level level;
  final int score;
  final int plexiMatches;
  final int transmutesUsed;
  final int movesLeft;
  final Duration elapsedTime;

  const GameOverScreen({
    Key? key,
    required this.isVictory,
    required this.level,
    required this.score,
    required this.plexiMatches,
    required this.transmutesUsed,
    required this.movesLeft,
    required this.elapsedTime,
  }) : super(key: key);

  // 格式化时间
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // 计算星级
  int _calculateStars() {
    if (!isVictory) return 0;

    // 基本通关 = 1星
    int stars = 1;

    // 根据关卡目标类型计算额外星星
    switch (level.objective.type) {
      case LevelObjectiveType.score:
        // 高分通关 = 2星
        if (score >= level.objective.target * 1.5) {
          stars++;
        }
        break;
      case LevelObjectiveType.plexiMatches:
        // 超额完成 = 2星
        if (plexiMatches > level.objective.target) {
          stars++;
        }
        break;
      default:
        // 其他目标类型，完成即可
        stars++;
        break;
    }

    // 有剩余步数 = 3星
    if (movesLeft > 0) {
      stars++;
    }

    return stars.clamp(0, 3);
  }

  // 保存游戏结果
  Future<void> _saveGameResults() async {
    if (!isVictory) return;

    final stars = _calculateStars();

    // 更新关卡星级
    if (stars > level.starsEarned) {
      level.starsEarned = stars;
    }

    // 解锁下一关
    if (level.id < 6) {
      // 假设总共有6关
      final levels = await StorageService.instance.loadLevels();
      final nextLevelIndex = levels.indexWhere((l) => l.id == level.id + 1);
      if (nextLevelIndex >= 0) {
        levels[nextLevelIndex].isUnlocked = true;
        await StorageService.instance.saveLevels(levels);
      }
    }

    // 更新玩家统计数据
    final stats = await StorageService.instance.loadPlayerStats();
    stats.addPlaytime(elapsedTime);
    stats.updateHighestScore(score);
    stats.updateLevelHighScore(level.id, score);
    stats.addPlexiMatches(plexiMatches);
    await StorageService.instance.savePlayerStats(stats);
  }

  @override
  Widget build(BuildContext context) {
    // 保存游戏结果
    _saveGameResults();

    final stars = _calculateStars();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(
              'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?q=80&w=2071&auto=format&fit=crop',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.primaryDark.withOpacity(0.8),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GlassCard(
                borderColor: isVictory ? AppColors.primaryAccent : Colors.red,
                isGlowing: true,
                glowColor: isVictory ? AppColors.primaryAccent : Colors.red,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题
                    Text(
                      isVictory ? 'VICTORY' : 'DEFEAT',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: isVictory ? AppColors.primaryAccent : Colors.red,
                        shadows: [
                          Shadow(
                            color: isVictory
                                ? AppColors.primaryAccent.withOpacity(0.7)
                                : Colors.red.withOpacity(0.7),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${level.name} ${isVictory ? 'Completed' : 'Failed'}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    // 星级评价
                    if (isVictory)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Icon(
                            index < stars ? Icons.star : Icons.star_border,
                            color: index < stars ? Colors.amber : Colors.grey,
                            size: 36,
                          );
                        }),
                      ),

                    const SizedBox(height: 24),

                    // 游戏统计
                    Column(
                      children: [
                        _buildStatRow('Score:', score.toString()),
                        _buildStatRow(
                          'Perfect Matches:',
                          plexiMatches.toString(),
                        ),
                        _buildStatRow(
                          'Transmutes Used:',
                          transmutesUsed.toString(),
                        ),
                        _buildStatRow('Moves Left:', movesLeft.toString()),
                        _buildStatRow('Time:', _formatDuration(elapsedTime)),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 按钮
                    Row(
                      children: [
                        Expanded(
                          child: CyberButton(
                            text: 'Retry',
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            textColor: Colors.white,
                            onPressed: () {
                              // 返回到游戏界面并重新开始
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CyberButton(
                            text: isVictory ? 'Next Level' : 'Back',
                            backgroundColor: isVictory
                                ? AppColors.primaryAccent
                                : Colors.red,
                            textColor: isVictory
                                ? AppColors.primaryDark
                                : Colors.white,
                            onPressed: () {
                              // 返回到关卡选择界面
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CampaignScreen(),
                                ),
                                (route) => route.isFirst,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 主菜单按钮
                    TextButton(
                      onPressed: () {
                        // 返回到主菜单
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.menu, color: Colors.grey, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Main Menu',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 构建统计行
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
