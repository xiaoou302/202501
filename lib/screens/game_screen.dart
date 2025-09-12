import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/block.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../models/leaderboard_entry.dart';
import '../services/game_logic.dart';
import '../services/storage.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/game_board.dart';
import '../widgets/match_template_item.dart';
import '../app.dart'; // 导入 GameOverArguments 类

/// 核心游戏界面
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _gameState;
  late GameLogicService _gameLogic;
  late Level _level;
  late Timer _gameTimer;
  Duration _elapsedTime = Duration.zero;
  int? _activeTemplateIndex;
  bool _isGameStateInitialized = false;

  @override
  void initState() {
    super.initState();
    _gameLogic = GameLogicService();

    // 延迟初始化，等待参数传递
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
    });
  }

  @override
  void dispose() {
    if (_isGameStateInitialized) {
      _gameTimer.cancel();
    }
    super.dispose();
  }

  void _initializeGame() {
    // 获取路由参数
    final args = ModalRoute.of(context)?.settings.arguments as Level?;
    if (args == null) {
      // 如果没有参数，返回上一页
      Navigator.pop(context);
      return;
    }

    _level = args;

    // 初始化游戏状态
    _gameState = _gameLogic.initializeGame(_level);
    _isGameStateInitialized = true;

    // 启动游戏计时器
    _startGameTimer();

    setState(() {});
  }

  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_gameState.isPaused && !_gameState.isGameOver) {
        setState(() {
          _elapsedTime = _gameState.elapsedTime;
        });
      }
    });
  }

  void _onBlockTap(Block block) {
    setState(() {
      _gameState = _gameLogic.handleBlockSelection(_gameState, block);
      _activeTemplateIndex = null;
    });
  }

  void _onTemplateTap(int index) {
    if (_gameState.selectedBlocks.length != 2) {
      return;
    }

    // 检查是否匹配成功
    final isMatch = _gameLogic.canMatchWithTemplate(
        _gameState.selectedBlocks, _gameState.templates[index]);

    setState(() {
      _activeTemplateIndex = index;

      if (isMatch) {
        // 匹配成功，播放成功反馈
        _showMatchSuccessEffect();

        _gameState = _gameLogic.handleTemplateMatch(
            _gameState, _gameState.templates[index]);

        // 检查游戏是否结束
        if (_gameState.isGameOver) {
          _gameTimer.cancel();
          _handleGameOver();
        }
      } else {
        // 匹配失败，显示反馈
        _showMatchFailureEffect();
      }
    });
  }

  void _showMatchSuccessEffect() {
    // 显示成功反馈
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Match Success!'),
          ],
        ),
        duration: const Duration(milliseconds: 800),
        backgroundColor: Colors.green.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 100, left: 80, right: 80),
      ),
    );
  }

  void _showMatchFailureEffect() {
    // 显示失败反馈
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Cannot Match'),
          ],
        ),
        duration: const Duration(milliseconds: 800),
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 100, left: 80, right: 80),
      ),
    );
  }

  void _onPauseTap() {
    setState(() {
      _gameState = _gameLogic.togglePause(_gameState);
    });
  }

  void _onRefreshTemplatesTap() {
    // 显示刷新反馈
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.refresh, color: Colors.white),
            SizedBox(width: 12),
            Text('Templates Refreshed'),
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.accentMintGreen.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 80, left: 40, right: 40),
      ),
    );

    setState(() {
      // 使用新的refreshTemplates方法，只刷新模板而不改变棋盘
      _gameState = _gameLogic.refreshTemplates(_gameState);
      _activeTemplateIndex = null;
    });
  }

  Future<void> _handleGameOver() async {
    // 保存游戏结果
    try {
      final prefs = await SharedPreferences.getInstance();
      final storageService = StorageService(prefs);

      // 更新玩家数据
      final player = await storageService.getPlayer();
      final updatedPlayer = player.updateGameResult(
        isVictory: _gameState.isVictory,
        timeSeconds: _elapsedTime.inSeconds,
        gridSize: _level.gridSize,
      );
      await storageService.savePlayer(updatedPlayer);

      // 更新关卡数据
      if (_gameState.isVictory) {
        final levels = await storageService.getLevels();
        final currentLevelIndex = levels.indexWhere((l) => l.id == _level.id);

        if (currentLevelIndex != -1) {
          // 计算星星数量（基于时间和步数）
          int stars = _calculateStars();

          // 更新当前关卡
          final updatedLevel = _level.copyWith(
            stars: stars > _level.stars ? stars : _level.stars,
            bestTimeSeconds: _level.bestTimeSeconds == null ||
                    _elapsedTime.inSeconds < _level.bestTimeSeconds!
                ? _elapsedTime.inSeconds
                : _level.bestTimeSeconds,
            bestMoves:
                _level.bestMoves == null || _gameState.moves < _level.bestMoves!
                    ? _gameState.moves
                    : _level.bestMoves,
          );
          levels[currentLevelIndex] = updatedLevel;

          // 解锁下一关
          if (currentLevelIndex < levels.length - 1) {
            final nextLevel = levels[currentLevelIndex + 1];
            if (nextLevel.mode == _level.mode && !nextLevel.isUnlocked) {
              levels[currentLevelIndex + 1] =
                  nextLevel.copyWith(isUnlocked: true);
            }
          }

          await storageService.saveLevels(levels);

          // 更新排行榜
          _updateLeaderboard(storageService);
        }
      }

      // 导航到游戏结束界面
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.gameOver,
          arguments: GameOverArguments(
            time: _elapsedTime,
            levelId: _level.id,
          ),
        );
      }
    } catch (e) {
      // 错误处理
      debugPrint('Error handling game over: $e');
    }
  }

  Future<void> _updateLeaderboard(StorageService storageService) async {
    try {
      final leaderboard = await storageService.getLeaderboard();

      // 创建新的排行榜条目
      final newEntry = LeaderboardEntry(
        rank: 0, // 临时排名，后面会重新计算
        dateTimeMillis: DateTime.now().millisecondsSinceEpoch,
        timeSeconds: _elapsedTime.inSeconds,
        mode: _level.mode,
      );

      // 添加新条目
      leaderboard.add(newEntry);

      // 按模式和时间排序
      final classicEntries = leaderboard
          .where((entry) => entry.mode == GameConstants.classicMode)
          .toList()
        ..sort((a, b) => a.timeSeconds.compareTo(b.timeSeconds));

      final challengeEntries = leaderboard
          .where((entry) => entry.mode == GameConstants.challengeMode)
          .toList()
        ..sort((a, b) => a.timeSeconds.compareTo(b.timeSeconds));

      // 更新排名
      for (int i = 0; i < classicEntries.length; i++) {
        classicEntries[i] = classicEntries[i].copyWith(rank: i + 1);
      }

      for (int i = 0; i < challengeEntries.length; i++) {
        challengeEntries[i] = challengeEntries[i].copyWith(rank: i + 1);
      }

      // 合并并保存
      final updatedLeaderboard = [...classicEntries, ...challengeEntries];
      await storageService.saveLeaderboard(updatedLeaderboard);
    } catch (e) {
      debugPrint('Error updating leaderboard: $e');
    }
  }

  int _calculateStars() {
    // 基于时间和步数计算星星数量
    // 这里使用简单的算法，可以根据需要调整
    if (_elapsedTime.inSeconds < 60) {
      return 3; // 1分钟内完成，3星
    } else if (_elapsedTime.inSeconds < 120) {
      return 2; // 2分钟内完成，2星
    } else {
      return 1; // 其他情况，1星
    }
  }

  @override
  Widget build(BuildContext context) {
    // 检查游戏状态是否已初始化
    if (!mounted || !_isGameStateInitialized) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.bgDeepSpaceGray,
                AppColors.bgDeepSpaceGray.withBlue(70),
              ],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    color: AppColors.accentMintGreen,
                    strokeWidth: 6.0,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  '准备游戏中...',
                  style: TextStyle(
                    color: AppColors.textMoonWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgDeepSpaceGray,
              AppColors.bgDeepSpaceGray.withBlue(70),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                // 顶部状态栏
                _buildTopBar(),

                // 游戏棋盘
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: GameBoard(
                        board: _gameState.board,
                        onBlockTap: _onBlockTap,
                      ),
                    ),
                  ),
                ),

                // 匹配模板
                _buildTemplates(),

                // 底部操作栏
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
      // 暂停覆盖层
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _gameState.isPaused ? _buildPauseOverlay() : null,
    );
  }

  Widget _buildTopBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accentMintGreen.withOpacity(0.7),
                  AppColors.accentMintGreen.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentMintGreen.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors.textMoonWhite,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'LVL ${_level.name.split(' ').last}',
                  style: const TextStyle(
                    color: AppColors.textMoonWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: AppColors.textMoonWhite,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatDuration(_elapsedTime),
                      style: const TextStyle(
                        color: AppColors.textMoonWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.textMoonWhite,
                    size: 22,
                  ),
                  onPressed: () {
                    // 显示提示
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Select two adjacent blocks, then match with templates below'),
                        duration: const Duration(seconds: 2),
                        backgroundColor:
                            AppColors.accentMintGreen.withOpacity(0.8),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplates() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Text(
                'Match Templates',
                style: TextStyle(
                  color: AppColors.textMoonWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                _gameState.templates.length,
                (index) => MatchTemplateItem(
                  template: _gameState.templates[index],
                  isActive: _activeTemplateIndex == index,
                  onTap: () => _onTemplateTap(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    // 计算剩余方块数量 - 每个方块单独计数
    final remainingBlocks = _gameState.getTotalRemainingBlocks();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomButton(
            icon: _gameState.isPaused
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
            label: _gameState.isPaused ? 'Resume' : 'Pause',
            onPressed: _onPauseTap,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentMintGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.grid_view_rounded,
                  color: AppColors.accentMintGreen,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  '$remainingBlocks',
                  style: const TextStyle(
                    color: AppColors.textMoonWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _buildBottomButton(
            icon: Icons.refresh_rounded,
            label: 'Refresh',
            onPressed: _onRefreshTemplatesTap,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.textMoonWhite,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMoonWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      margin: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.85),
            Colors.black.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accentMintGreen.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pause_rounded,
              color: AppColors.accentMintGreen,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Game Paused',
            style: TextStyle(
              color: AppColors.textMoonWhite,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Take a break, continue anytime',
            style: TextStyle(
              color: AppColors.textMoonWhite,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _onPauseTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentMintGreen,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: AppColors.accentMintGreen.withOpacity(0.5),
            ),
            child: const Text(
              'Continue Game',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              foregroundColor: AppColors.textMoonWhite,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Exit Game',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
