import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/arrow_tile.dart';
import '../models/direction_changer.dart';
import '../models/game_state.dart';
import '../utils/constants.dart';
import '../utils/game_logic.dart';
import '../utils/level_cache.dart';
import '../utils/level_generator.dart';
import '../utils/preferences_manager.dart';
import '../widgets/direction_changes_counter.dart';
import '../widgets/direction_dialog.dart';
import '../widgets/game_grid_widget.dart';

/// Screen for playing a game level
class GameScreen extends StatefulWidget {
  /// Level ID to play
  final int levelId;

  const GameScreen({Key? key, required this.levelId}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameState _gameState;
  late AnimationController _winAnimationController;
  late AnimationController _deadEndAnimationController;
  bool _isWinMessageVisible = false;
  bool _isDeadEndMessageVisible = false;
  bool _hapticsEnabled = true;

  // 倒计时相关变量
  late Timer _timer;
  int _remainingSeconds = 180; // 3分钟倒计时
  bool _isTimerActive = false;

  // 当前选中的箭头索引
  int? _selectedArrowIndex;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _loadSettings();
    _startTimer();

    _winAnimationController = AnimationController(
      duration: AnimationDurations.medium,
      vsync: this,
    );

    _deadEndAnimationController = AnimationController(
      duration: AnimationDurations.medium,
      vsync: this,
    );
  }

  void _startTimer() {
    _isTimerActive = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          _isTimerActive = false;
          _showTimeUpMessage();
        }
      });
    });
  }

  void _showTimeUpMessage() {
    if (!_isWinMessageVisible) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('时间到！'),
          content: const Text('很遗憾，时间已用完。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 关闭对话框
                Navigator.pop(context); // 返回关卡选择界面
              },
              child: const Text('返回选择'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _loadSettings() async {
    _hapticsEnabled = await PreferencesManager.getHapticsEnabled();
  }

  void _initializeGame() {
    // Try to get level from cache first
    final cache = LevelCache();
    final cachedLevel = cache.getLevelById(widget.levelId);

    final level = cachedLevel ?? LevelGenerator.getLevelById(widget.levelId);
    if (level == null) {
      // Handle invalid level ID
      Navigator.pop(context);
      return;
    }

    // 使用新的可解关卡生成算法，确保关卡可通关
    final solvableLayout = GameLogic.generateSolvableLayout(
      level.layout,
      level.gridSize,
    );

    // 创建一个新的关卡，使用可解的布局
    final solvableLevel = level.copyWith(layout: solvableLayout);

    // 更新缓存
    cache.cacheLevel(solvableLevel);

    // 使用可解的关卡
    _gameState = GameState(
      currentLevel: solvableLevel,
      currentLayout: List.from(solvableLayout),
    );
  }

  void _handleTileClick(int tileId) {
    if (_gameState.isGameWon || _isDeadEndMessageVisible) return;

    // 如果处于方向修改模式
    if (_gameState.directionChanger.isChangingDirection) {
      // 选择要修改的箭头并显示方向选择对话框
      _selectArrowForChange(tileId);
      return;
    }

    // Provide haptic feedback
    if (_hapticsEnabled) {
      HapticFeedback.lightImpact();
    }

    // Update game state
    final newState = GameLogic.processTileClick(_gameState, tileId);
    setState(() {
      _gameState = newState;
    });

    // Check if the game is won
    if (newState.isGameWon) {
      _showWinMessage();
      _saveProgress();
    }

    // Check if we've reached a dead end
    if (GameLogic.isDeadEnd(newState)) {
      _showDeadEndMessage();
    }
  }

  /// 获取箭头ID对应的索引
  int _getTileIndexById(int tileId) {
    for (int i = 0; i < _gameState.currentLayout.length; i++) {
      final tile = _gameState.currentLayout[i];
      if (tile != null && tile.id == tileId) {
        return i;
      }
    }
    return -1;
  }

  /// 进入箭头方向修改模式
  void _enterDirectionChangeMode() {
    if (_gameState.directionChanger.hasRemainingChanges) {
      setState(() {
        _gameState.directionChanger.enterChangeMode();
        _selectedArrowIndex = null;
      });
    }
  }

  /// 退出箭头方向修改模式
  void _exitDirectionChangeMode() {
    setState(() {
      _gameState.directionChanger.exitChangeMode();
      _selectedArrowIndex = null;
    });
  }

  /// 选择要修改的箭头
  void _selectArrowForChange(int tileId) {
    final index = _getTileIndexById(tileId);
    final tile = _gameState.currentLayout[index];

    // 检查是否是有效的箭头瓦片
    if (tile == null || tile.isObstacle) {
      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请选择一个箭头进行修改'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // 保存选中的箭头索引
    setState(() {
      _selectedArrowIndex = index;
    });

    // 显示方向选择对话框
    _showDirectionDialog(tile.direction);
  }

  /// 显示方向选择对话框
  void _showDirectionDialog(ArrowDirection currentDirection) {
    showDialog(
      context: context,
      builder: (context) => DirectionDialog(
        currentDirection: currentDirection,
        onDirectionSelected: (newDirection) {
          _changeArrowDirection(newDirection);
        },
      ),
    );
  }

  /// 修改箭头方向
  void _changeArrowDirection(ArrowDirection newDirection) {
    if (_selectedArrowIndex == null) {
      return;
    }

    final selectedIndex = _selectedArrowIndex!;
    final currentLayout = List<ArrowTile?>.from(_gameState.currentLayout);
    final tile = currentLayout[selectedIndex];

    if (tile == null || tile.isObstacle) {
      return;
    }

    // 创建新的箭头瓦片，方向已修改
    final newTile = ArrowTile(
      id: tile.id,
      direction: newDirection,
      color: tile.color,
      row: tile.row,
      column: tile.column,
    );

    // 更新布局
    currentLayout[selectedIndex] = newTile;

    // 更新游戏状态
    _gameState.directionChanger.usedChanges++;
    _gameState.directionChanger.exitChangeMode();

    setState(() {
      _gameState = _gameState.copyWith(
        currentLayout: currentLayout,
        directionChanger: _gameState.directionChanger,
      );
      _selectedArrowIndex = null;
    });

    // 提供触觉反馈
    if (_hapticsEnabled) {
      HapticFeedback.mediumImpact();
    }

    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '箭头方向已修改！还剩${_gameState.directionChanger.remainingChanges}次修改机会',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showWinMessage() {
    _winAnimationController.forward();
    setState(() {
      _isWinMessageVisible = true;
    });

    // 停止倒计时
    if (_isTimerActive) {
      _timer.cancel();
      _isTimerActive = false;
    }
  }

  // 移除死局弹窗，使用提示条代替
  void _showDeadEndMessage() {
    // 不再显示死局弹窗
    // _deadEndAnimationController.forward();
    // setState(() {
    //   _isDeadEndMessageVisible = true;
    // });

    // 提示玩家可以使用方向修改功能
    if (_gameState.directionChanger.hasRemainingChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '没有可移动的箭头了，可以使用方向修改功能（还剩${_gameState.directionChanger.remainingChanges}次）',
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      // 如果没有方向修改机会了，只提示没有可移动的箭头
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('没有可移动的箭头了'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveProgress() async {
    await PreferencesManager.setLevelCompleted(
      _gameState.currentLevel.id,
      _gameState.playerMoves,
    );
  }

  void _restartLevel() {
    // 先取消计时器
    if (_isTimerActive) {
      _timer.cancel();
      _isTimerActive = false;
    }

    // 获取当前关卡ID
    final levelId = widget.levelId;

    // 从缓存获取原始关卡数据
    final cache = LevelCache();
    final level = cache.getLevelById(levelId);

    if (level == null) {
      // 如果找不到关卡，回到选择界面
      Navigator.pop(context);
      return;
    }

    // 创建新的游戏状态，确保布局正确初始化
    final newGameState = GameState(
      currentLevel: level,
      currentLayout: List<ArrowTile?>.from(
        level.layout.map((tile) {
          // 确保所有箭头都被标记为未移除
          if (tile != null) {
            return tile.copyWith(isRemoved: false);
          }
          return null;
        }),
      ),
      playerMoves: 0,
      correctMoves: 0,
      isGameWon: false,
      moveHistory: [],
      directionChanger: DirectionChanger(), // 重置方向修改器
    );

    // 重置状态
    setState(() {
      _isWinMessageVisible = false;
      _isDeadEndMessageVisible = false;
      _winAnimationController.reset();
      _deadEndAnimationController.reset();
      _selectedArrowIndex = null;
      _gameState = newGameState;
      _remainingSeconds = 180;
    });

    // 重新开始计时器
    _startTimer();
  }

  @override
  void dispose() {
    _winAnimationController.dispose();
    _deadEndAnimationController.dispose();
    if (_isTimerActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Color(0xFFEAE5E1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: Center(child: _buildGameContent())),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // 格式化剩余时间为 MM:SS 格式
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button positioned in the top-left corner

          // Centered content
          Column(
            children: [
              Text(
                _gameState.currentLevel.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGraphite,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Level ${_gameState.currentLevel.id}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.disabledGray,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 倒计时显示
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _remainingSeconds < 30
                          ? Colors.red
                          : AppColors.accentCoral,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          timeString,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Empty SizedBox with the same width as the back button to maintain balance
          Positioned(right: 0, child: SizedBox(width: 48)),
        ],
      ),
    );
  }

  Widget _buildGameContent() {
    // 计算可用高度，考虑到header和footer的高度
    final availableHeight = MediaQuery.of(context).size.height - 180;

    // 根据屏幕宽度计算网格的最大尺寸
    final maxGridSize = MediaQuery.of(context).size.width - 48;

    // 计算网格的实际尺寸，确保它不会太大
    final gridSize2 = maxGridSize < availableHeight * 0.6
        ? maxGridSize
        : availableHeight * 0.6;

    return Stack(
      alignment: Alignment.center,
      children: [
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    _gameState.currentLevel.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.disabledGray,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildGameStats(),
                const SizedBox(height: 12),

                // 游戏网格，使用SizedBox限制最大尺寸
                SizedBox(
                  width: gridSize2,
                  height: gridSize2,
                  child: GameGridWidget(
                    gameState: _gameState,
                    onTileClicked: _handleTileClick,
                  ),
                ),

                const SizedBox(height: 12),

                // 方向修改机会计数器
                DirectionChangesCounter(
                  directionChanger: _gameState.directionChanger,
                  onTap: _enterDirectionChangeMode,
                ),

                // 修改模式提示和取消按钮
                if (_gameState.directionChanger.isChangingDirection)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        Text(
                          '请点击要修改的箭头',
                          style: TextStyle(
                            color: AppColors.accentCoral,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _exitDirectionChangeMode,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: const Size(120, 36),
                          ),
                          child: const Text('取消修改'),
                        ),
                      ],
                    ),
                  ),

                // 底部空间，确保内容不会被footer遮挡
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        if (_isWinMessageVisible) _buildWinMessage(),
        if (_isDeadEndMessageVisible) _buildDeadEndMessage(),
      ],
    );
  }

  Widget _buildGameStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem('Moves', _gameState.playerMoves.toString()),
        const SizedBox(width: 24),
        _buildStatItem(
          'Best',
          _gameState.currentLevel.playerBestMoves > 0
              ? _gameState.currentLevel.playerBestMoves.toString()
              : '-',
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.disabledGray),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textGraphite,
          ),
        ),
      ],
    );
  }

  Widget _buildWinMessage() {
    return AnimatedBuilder(
      animation: _winAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: _winAnimationController.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: AppColors.accentCoral,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Level Complete!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGraphite,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Moves: ${_gameState.playerMoves}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.disabledGray,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // 返回关卡选择界面
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.main,
                      arguments: {'initialTabIndex': 0},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.arrowBlue,
                    minimumSize: const Size(150, 45),
                  ),
                  child: const Text('Level Select'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 已移除死局弹窗，改用提示条代替
  Widget _buildDeadEndMessage() {
    // 返回一个空的小部件，不再显示死局弹窗
    return const SizedBox.shrink();
  }

  Widget _buildFooter() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Moves: ${_gameState.playerMoves}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textGraphite,
            ),
          ),
          ElevatedButton(
            onPressed: _restartLevel,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCoral,
            ),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
