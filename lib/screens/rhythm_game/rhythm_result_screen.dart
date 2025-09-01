import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import '../../models/game_score.dart';
import '../../services/score_service.dart';
import '../../services/achievement_service.dart';
import '../../widgets/common/glow_button.dart';
import 'rhythm_game_screen.dart';
import 'rhythm_difficulty_screen.dart';

/// 流动游戏结果页面
class RhythmResultScreen extends StatefulWidget {
  /// 游戏分数
  final int score;

  /// 游戏难度
  final String difficulty;

  /// 是否解锁了下一关
  final bool unlockedNextLevel;

  const RhythmResultScreen({
    super.key,
    required this.score,
    required this.difficulty,
    this.unlockedNextLevel = false,
  });

  @override
  State<RhythmResultScreen> createState() => _RhythmResultScreenState();
}

class _RhythmResultScreenState extends State<RhythmResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final ScoreService _scoreService = ScoreService();
  final AchievementService _achievementService = AchievementService();
  bool _isNewHighScore = false;
  int _bestScore = 0;
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

    // 检查下一关
    _checkNextLevel();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 检查下一关
  void _checkNextLevel() {
    print(
      'Checking next level. unlockedNextLevel: ${widget.unlockedNextLevel}',
    );
    if (widget.unlockedNextLevel) {
      _nextLevel = _getNextLevel();
      print('Next level determined: $_nextLevel');
    }
  }

  /// 获取下一个难度级别
  String? _getNextLevel() {
    switch (widget.difficulty) {
      case GameConstants.flowEasy:
        return GameConstants.flowNormal;
      case GameConstants.flowNormal:
        return GameConstants.flowHard;
      case GameConstants.flowHard:
        return GameConstants.flowExpert;
      case GameConstants.flowExpert:
        return GameConstants.flowMaster;
      case GameConstants.flowMaster:
        return GameConstants.flowGrandmaster;
      case GameConstants.flowGrandmaster:
        return GameConstants.flowLegend;
      case GameConstants.flowLegend:
      default:
        return null; // 已经是最高难度
    }
  }

  /// 保存游戏分数
  Future<void> _saveScore() async {
    // 创建游戏分数
    final gameScore = GameScore.now(
      gameId: GameConstants.rhythmGame,
      score: widget.score,
      gameSpecificData: {'difficulty': widget.difficulty},
    );

    // 获取之前的最高分
    final highScore = await _scoreService.getHighScore(
      GameConstants.rhythmGame,
      widget.difficulty,
    );

    // 设置最高分
    if (highScore != null) {
      setState(() {
        _bestScore = highScore.score;
        _isNewHighScore = widget.score > highScore.score;
      });
    } else {
      setState(() {
        _bestScore = widget.score;
        _isNewHighScore = true;
      });
    }

    // 保存分数
    await _scoreService.saveScore(gameScore);

    // 更新成就
    await _achievementService.updateAchievements();

    // 如果通关了，解锁下一关
    if (widget.unlockedNextLevel) {
      await _unlockNextLevel();
    }
  }

  /// 解锁下一关
  Future<void> _unlockNextLevel() async {
    final nextLevel = _getNextLevel();
    if (nextLevel == null) return; // 已经是最高难度

    try {
      final prefs = await SharedPreferences.getInstance();
      final unlockedLevelsStr = prefs.getString(
        GameConstants.keyUnlockedLevels,
      );

      List<String> unlockedLevels = [];
      if (unlockedLevelsStr != null && unlockedLevelsStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(unlockedLevelsStr);
        unlockedLevels = List<String>.from(decoded);
      } else {
        // 如果没有已保存的解锁关卡，至少解锁第一关
        unlockedLevels = [GameConstants.flowEasy];
      }

      // 检查下一关是否已解锁
      if (!unlockedLevels.contains(nextLevel)) {
        unlockedLevels.add(nextLevel);
        // 保存更新后的解锁关卡
        await prefs.setString(
          GameConstants.keyUnlockedLevels,
          jsonEncode(unlockedLevels),
        );

        // 打印日志确认解锁成功
        print('Successfully unlocked level: $nextLevel');
        print('Updated unlocked levels: ${jsonEncode(unlockedLevels)}');

        // 刷新难度选择界面
        RhythmDifficultyScreen.refreshLevels();
      }
    } catch (e) {
      print('Error unlocking next level: $e');
    }
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
                // 游戏结束图标
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
                      color: _getResultColor().withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getResultColor().withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _isNewHighScore
                            ? Icons.emoji_events
                            : Icons.auto_awesome,
                        size: 60,
                        color: _getResultColor(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 游戏结束标题
                Text(
                  _isNewHighScore ? 'New Record!' : 'Game Over',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _getResultColor(),
                  ),
                ),
                const SizedBox(height: 40),

                // 分数显示
                Column(
                  children: [
                    const Text(
                      'SCORE',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isNewHighScore) ...[
                          const Icon(
                            Icons.new_releases,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.score.toString(),
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: _getResultColor(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 最高分显示
                Column(
                  children: [
                    const Text(
                      'BEST',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _bestScore.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 按钮区域
                if (_nextLevel != null)
                  GlowButton(
                    text: 'Next Level',
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      // 直接导航到下一关
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RhythmGameScreen(difficulty: _nextLevel!),
                        ),
                      );
                    },
                    width: double.infinity,
                    color: _getResultColor(),
                  ),
                if (_nextLevel == null)
                  GlowButton(
                    text: 'Play Again',
                    icon: Icons.replay,
                    onPressed: () {
                      // 返回难度选择页面
                      Navigator.pop(context);
                    },
                    width: double.infinity,
                    color: _getResultColor(),
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.grid_view),
                        SizedBox(width: 8),
                        Text(
                          'Select Level',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  /// 获取结果颜色
  Color _getResultColor() {
    if (_isNewHighScore) {
      return Colors.amber;
    }

    switch (widget.difficulty) {
      case GameConstants.flowEasy:
        return Colors.green;
      case GameConstants.flowNormal:
        return Colors.blue;
      case GameConstants.flowHard:
        return Colors.orange;
      case GameConstants.flowExpert:
        return Colors.red;
      case GameConstants.flowMaster:
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }
}
