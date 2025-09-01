import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import '../../models/game_score.dart';
import '../../services/score_service.dart';
import '../../services/achievement_service.dart';
import '../../widgets/common/glow_button.dart';
import '../../widgets/common/neumorphic_card.dart';
import 'number_game_screen.dart';

/// 数字记忆游戏结果页面
class NumberResultScreen extends StatefulWidget {
  /// 游戏分数
  final int score;

  /// 是否胜利
  final bool isVictory;

  /// 游戏难度
  final String difficulty;

  /// 正确数量
  final int correctCount;

  /// 总数量
  final int totalCount;

  const NumberResultScreen({
    super.key,
    required this.score,
    required this.isVictory,
    required this.difficulty,
    required this.correctCount,
    required this.totalCount,
  });

  @override
  State<NumberResultScreen> createState() => _NumberResultScreenState();
}

class _NumberResultScreenState extends State<NumberResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final ScoreService _scoreService = ScoreService();
  final AchievementService _achievementService = AchievementService();
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();

    // 创建动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // 创建缩放动画
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // 启动动画
    _animationController.forward();

    // 保存分数
    if (widget.isVictory) {
      _saveScore();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 保存游戏分数
  Future<void> _saveScore() async {
    // 创建游戏分数
    final gameScore = GameScore.now(
      gameId: GameConstants.numberGame,
      score: widget.score,
      gameSpecificData: {
        'difficulty': widget.difficulty,
        'correctCount': widget.correctCount,
        'totalCount': widget.totalCount,
      },
    );

    // 获取之前的最高分
    final highScore = await _scoreService.getHighScore(
      GameConstants.numberGame,
      widget.difficulty,
    );

    // 检查是否是新的最高分
    if (highScore == null || highScore.score < widget.score) {
      setState(() {
        _isNewHighScore = true;
      });
    }

    // 保存分数
    await _scoreService.saveScore(gameScore);

    // 更新成就
    await _achievementService.updateAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 结果图标
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: widget.isVictory
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.isVictory
                              ? Colors.green.withOpacity(0.3)
                              : Colors.red.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        widget.isVictory ? Icons.check : Icons.close,
                        size: 60,
                        color: widget.isVictory ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 结果标题
                Text(
                  widget.isVictory ? 'Perfect!' : 'Game Over',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: widget.isVictory ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  widget.isVictory
                      ? 'You remembered all numbers correctly!'
                      : 'You got ${widget.correctCount} out of ${widget.totalCount} correct',
                  style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                ),
                const SizedBox(height: 40),

                // 游戏统计
                NeumorphicCard(
                  isInset: true,
                  child: Column(
                    children: [
                      _buildStatRow('Difficulty', _getDifficultyName()),
                      const Divider(color: Colors.grey),
                      _buildStatRow(
                        'Sequence',
                        '${widget.correctCount}/${widget.totalCount}',
                      ),
                      if (widget.isVictory) ...[
                        const Divider(color: Colors.grey),
                        _buildStatRow(
                          'Score',
                          widget.score.toString(),
                          isHighlighted: true,
                          isNewHighScore: _isNewHighScore,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 按钮
                if (widget.isVictory)
                  GlowButton(
                    text: 'Next Level',
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      // 尝试进入下一关
                      String nextLevel = _getNextLevel();
                      if (nextLevel != widget.difficulty) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NumberGameScreen(difficulty: nextLevel),
                          ),
                        );
                      } else {
                        // 已经是最高难度，返回难度选择页面
                        Navigator.pop(context);
                      }
                    },
                    width: double.infinity,
                  ),
                if (!widget.isVictory)
                  GlowButton(
                    text: 'Try Again',
                    icon: Icons.replay,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              NumberGameScreen(difficulty: widget.difficulty),
                        ),
                      );
                    },
                    width: double.infinity,
                  ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // 返回难度选择页面
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Select Level',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value, {
    bool isHighlighted = false,
    bool isNewHighScore = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          Row(
            children: [
              if (isNewHighScore) ...[
                const Icon(Icons.new_releases, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: TextStyle(
                  color: isHighlighted ? AppColors.primary : Colors.white,
                  fontSize: isHighlighted ? 20 : 16,
                  fontWeight: isHighlighted
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 获取难度名称
  String _getDifficultyName() {
    switch (widget.difficulty) {
      case GameConstants.numberLevel1:
        return 'Level 1';
      case GameConstants.numberLevel2:
        return 'Level 2';
      case GameConstants.numberLevel3:
        return 'Level 3';
      case GameConstants.numberLevel4:
        return 'Level 4';
      case GameConstants.numberLevel5:
        return 'Level 5';
      case GameConstants.numberLevel6:
        return 'Level 6';
      case GameConstants.numberLevel7:
        return 'Level 7';
      default:
        return 'Unknown';
    }
  }

  /// 获取下一个难度级别
  String _getNextLevel() {
    switch (widget.difficulty) {
      case GameConstants.numberLevel1:
        return GameConstants.numberLevel2;
      case GameConstants.numberLevel2:
        return GameConstants.numberLevel3;
      case GameConstants.numberLevel3:
        return GameConstants.numberLevel4;
      case GameConstants.numberLevel4:
        return GameConstants.numberLevel5;
      case GameConstants.numberLevel5:
        return GameConstants.numberLevel6;
      case GameConstants.numberLevel6:
        return GameConstants.numberLevel7;
      case GameConstants.numberLevel7:
      default:
        return widget.difficulty; // 已经是最高难度
    }
  }
}
