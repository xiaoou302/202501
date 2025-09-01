import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import '../../models/game_score.dart';
import '../../services/level_service.dart';
import '../../services/score_service.dart';
import '../../services/achievement_service.dart';
import '../../widgets/common/glow_button.dart';
import '../../widgets/common/neumorphic_card.dart';
import 'memory_game_screen.dart';

/// 记忆游戏结果页面
class MemoryResultScreen extends StatefulWidget {
  /// 游戏分数
  final int score;

  /// 游戏步数
  final int moves;

  /// 游戏时间（秒）
  final int time;

  /// 游戏难度
  final String difficulty;

  /// 是否胜利
  final bool isVictory;

  /// 游戏模式
  final String gameMode;

  const MemoryResultScreen({
    super.key,
    required this.score,
    required this.moves,
    required this.time,
    required this.difficulty,
    this.isVictory = true,
    this.gameMode = 'classic',
  });

  @override
  State<MemoryResultScreen> createState() => _MemoryResultScreenState();
}

class _MemoryResultScreenState extends State<MemoryResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final ScoreService _scoreService = ScoreService();
  final LevelService _levelService = LevelService();
  final AchievementService _achievementService = AchievementService();
  bool _isNewHighScore = false;
  bool _hasNextLevel = false;
  String? _nextLevel;

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
    _saveScore();

    // 检查是否有下一关
    _checkNextLevel();
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
      gameId: GameConstants.memoryGame,
      score: widget.score,
      gameSpecificData: {
        'difficulty': widget.difficulty,
        'moves': widget.moves,
        'time': widget.time,
      },
    );

    // 获取之前的最高分
    final highScore = await _scoreService.getHighScore(
      GameConstants.memoryGame,
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

  /// 检查是否有下一关
  Future<void> _checkNextLevel() async {
    if (!widget.isVictory) {
      return; // 如果没有胜利，不检查下一关
    }

    // 获取所有关卡
    final List<String> allLevels = [
      GameConstants.memoryLevel1,
      GameConstants.memoryLevel2,
      GameConstants.memoryLevel3,
      GameConstants.memoryLevel4,
      GameConstants.memoryLevel5,
      GameConstants.memoryLevel6,
      GameConstants.memoryLevel7,
    ];

    // 找到当前关卡的索引
    final int currentIndex = allLevels.indexOf(widget.difficulty);

    // 如果已经是最后一关或找不到当前关卡，则没有下一关
    if (currentIndex == -1 || currentIndex >= allLevels.length - 1) {
      return;
    }

    // 获取下一关卡
    final String nextLevel = allLevels[currentIndex + 1];

    // 获取已解锁关卡列表
    final List<String> unlockedLevels = await _levelService.getUnlockedLevels();

    // 检查下一关是否已解锁
    if (unlockedLevels.contains(nextLevel)) {
      setState(() {
        _hasNextLevel = true;
        _nextLevel = nextLevel;
      });
    }
  }

  /// 格式化时间
  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
                // 胜利图标
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
                      color: Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.emoji_events,
                        size: 60,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 结果标题
                Text(
                  widget.isVictory ? 'VICTORY!' : 'GAME OVER',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: widget.isVictory ? Colors.white : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  widget.isVictory
                      ? 'You matched them all!'
                      : 'Time ran out! Try again!',
                  style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                ),

                const SizedBox(height: 8),

                // 游戏模式指示
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getModeColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getModeColor(), width: 1),
                  ),
                  child: Text(
                    _getModeText(),
                    style: TextStyle(
                      color: _getModeColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 游戏统计
                NeumorphicCard(
                  isInset: true,
                  child: Column(
                    children: [
                      _buildStatRow('Time', _formatTime(widget.time)),
                      const Divider(color: Colors.grey),
                      _buildStatRow('Moves', widget.moves.toString()),
                      const Divider(color: Colors.grey),
                      _buildStatRow(
                        'Final Score',
                        widget.score.toString(),
                        isHighlighted: true,
                        isNewHighScore: _isNewHighScore,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 按钮区域
                if (_hasNextLevel && _nextLevel != null)
                  GlowButton(
                    text: 'Next Level',
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MemoryGameScreen(difficulty: _nextLevel!),
                        ),
                      );
                    },
                    width: double.infinity,
                  ),
                if (!_hasNextLevel || _nextLevel == null)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // 返回难度选择页面
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
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
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // 再玩一次
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MemoryGameScreen(difficulty: widget.difficulty),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Play Again',
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

  /// 获取游戏模式颜色
  Color _getModeColor() {
    switch (widget.gameMode) {
      case GameConstants.memoryClassic:
        return Colors.blue;
      case GameConstants.memoryTimed:
        return Colors.orange;
      case GameConstants.memoryChallenge:
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  /// 获取游戏模式文本
  String _getModeText() {
    switch (widget.gameMode) {
      case GameConstants.memoryClassic:
        return 'CLASSIC MODE';
      case GameConstants.memoryTimed:
        return 'TIMED MODE';
      case GameConstants.memoryChallenge:
        return 'CHALLENGE MODE';
      default:
        return 'MEMORY MATCH';
    }
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
}
