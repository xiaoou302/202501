import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../models/game_unit.dart';
import '../../models/level.dart';
import '../../services/game_logic.dart';
import '../../services/audio.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/cyber_button.dart';
import '../../widgets/game/game_board.dart';
import '../../widgets/game/transmute_widget.dart';
import 'game_over_screen.dart';

/// 游戏界面
class GameScreen extends StatefulWidget {
  final Level level;

  const GameScreen({Key? key, required this.level}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameLogic _gameLogic;
  late GameBoardController _boardController;
  Timer? _gameTimer;
  Duration _elapsedTime = Duration.zero;
  bool _isTransmuteMode = false;
  bool _isColorTransmute = true; // true为改变颜色，false为改变形状
  bool _isPaused = false;
  bool _showTutorial = false;
  bool _isSwapping = false; // 添加交换状态标志
  bool _isLoading = true; // 添加加载状态标志

  // 动画控制器
  late AnimationController _scoreAnimController;
  late Animation<double> _scoreAnimation;
  int _displayScore = 0;
  String? _comboText;
  Timer? _comboTextTimer;

  @override
  void initState() {
    super.initState();
    _gameLogic = GameLogic();
    _boardController = GameBoardController();

    // 初始化分数动画
    _scoreAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scoreAnimation =
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _scoreAnimController, curve: Curves.easeOut),
        )..addListener(() {
          setState(() {
            _displayScore = (_gameLogic.score * _scoreAnimation.value).toInt();
          });
        });

    // 播放游戏音乐
    AudioService.instance.playGameMusic();

    // 异步初始化游戏
    _asyncInit();
  }

  // 异步初始化
  Future<void> _asyncInit() async {
    try {
      // 初始化游戏
      await _initGame();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // 启动游戏计时器
        _startGameTimer();

        // 检查是否需要显示教程
        _checkShowTutorial();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error in async initialization: $e');
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _comboTextTimer?.cancel();
    _scoreAnimController.dispose();
    super.dispose();
  }

  // 初始化游戏
  Future<void> _initGame() async {
    try {
      await _gameLogic.initGame(widget.level);
      _displayScore = 0;
    } catch (e) {
      print('Error initializing game: $e');
      // 显示错误对话框
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('初始化游戏失败'),
            content: Text('出现错误: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // 返回上一个屏幕
                },
                child: const Text('返回'),
              ),
            ],
          ),
        );
      }
    }
  }

  // 启动游戏计时器
  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedTime += const Duration(seconds: 1);
        });
      }
    });
  }

  // 检查是否显示教程
  void _checkShowTutorial() {
    // 如果是第一关，显示教程
    if (widget.level.id == 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _showTutorial = true;
          _isPaused = true;
        });
      });
    }
  }

  // 显示教程
  void _showTutorialDialog() {
    // 根据关卡显示不同的教程内容
    String tutorialText = '';

    if (_gameLogic.level.id == 4) {
      // 第4关教程
      tutorialText =
          '1. Click and swap adjacent units to create matches\n'
          '2. Match 3+ units of the same color or shape\n'
          '3. Perfect matches (same color AND shape) earn transmute ability\n'
          '4. Use transmute ability to click on changing units to remove them\n'
          '5. Remove all changing units to complete the level';
    } else if (_gameLogic.level.id == 5) {
      // 第5关教程
      tutorialText =
          '1. Click and swap adjacent units to create matches\n'
          '2. Match 3+ units of the same color or shape\n'
          '3. Perfect matches (same color AND shape) earn transmute ability\n'
          '4. Use transmute ability to click on polluted tiles to convert them to changing units\n'
          '5. Use transmute ability again to click on changing units to remove them\n'
          '6. Complete this two-step process to purify polluted tiles';
    } else if (_gameLogic.level.id == 6) {
      // 第6关教程
      tutorialText =
          '1. Click and swap adjacent units to create matches\n'
          '2. Match 3+ units of the same color or shape\n'
          '3. Perfect matches (same color AND shape) earn transmute ability\n'
          '4. Use transmute ability to click on changing units to remove them\n'
          '5. Use transmute ability to click on polluted tiles to convert them, then use it again to remove them\n'
          '6. Complete both objectives to win the level';
    } else {
      // 默认教程
      tutorialText =
          '1. Click and swap adjacent units to create matches\n'
          '2. Match 3+ units of the same color or shape\n'
          '3. Perfect matches (same color AND shape) earn transmute ability\n'
          '4. Use transmute ability to change unit colors or shapes\n'
          '5. Complete level objectives to win';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Game Tutorial',
          style: TextStyle(color: AppColors.primaryAccent),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tutorialText,
              style: const TextStyle(color: AppColors.textColor),
            ),
            const SizedBox(height: 24),
            CyberButton(
              text: 'Start Game',
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _showTutorial = false;
                  _isPaused = false;
                });
              },
              backgroundColor: AppColors.primaryAccent,
              textColor: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }

  // 处理单元点击
  void _handleUnitTap(int row, int col) {
    if (_isPaused || _isSwapping) return;

    if (_isTransmuteMode) {
      // 嬗变模式：改变单元的颜色或形状
      final success = _gameLogic.useTransmute(
        Position(row: row, col: col),
        _isColorTransmute,
      );

      if (success) {
        AudioService.instance.playTransmuteSfx();
        setState(() {
          _isTransmuteMode = false;
        });

        // 检查游戏状态
        _checkGameState();
      }
    } else {
      // 正常模式：选择和交换单元
      final currentUnit = _gameLogic.board[row][col];
      if (currentUnit == null) return; // 忽略空单元

      // 如果没有选中的单元，选中当前单元
      if (!_boardController.hasSelection()) {
        _boardController.setSelectedPosition(Position(row: row, col: col));

        // 更新选中状态
        setState(() {
          // 更新选中状态
          _gameLogic.board[row][col] = currentUnit.copyWith(isSelected: true);
        });

        // 播放点击音效
        AudioService.instance.playTapSfx();
        return;
      }

      // 获取已选中的单元位置
      final selectedPos = _boardController.selectedPosition!;

      // 如果点击的是已选中的单元，取消选中
      if (selectedPos.row == row && selectedPos.col == col) {
        _boardController.clearSelection();
        setState(() {
          // 取消选中状态
          _gameLogic.board[row][col] = currentUnit.copyWith(isSelected: false);
        });
        AudioService.instance.playTapSfx();
        return;
      }

      // 检查是否相邻
      final isAdjacent =
          (row == selectedPos.row && (col - selectedPos.col).abs() == 1) ||
          (col == selectedPos.col && (row - selectedPos.row).abs() == 1);

      if (isAdjacent) {
        // 设置交换状态，防止用户在交换动画期间点击
        setState(() {
          _isSwapping = true;
          // 取消选中状态
          final selectedUnit =
              _gameLogic.board[selectedPos.row][selectedPos.col];
          if (selectedUnit != null) {
            _gameLogic.board[selectedPos.row][selectedPos.col] = selectedUnit
                .copyWith(isSelected: false);
          }
        });

        // 尝试交换
        final oldScore = _gameLogic.score;
        final oldCombo = _gameLogic.comboChain;

        // 在无尽模式下，确保交换操作能够正常执行
        final success = _gameLogic.swapUnits(
          selectedPos,
          Position(row: row, col: col),
        );

        if (success) {
          // 播放音效
          final hasMatches = _gameLogic.score > oldScore;
          if (hasMatches) {
            if (_gameLogic.plexiMatches > 0) {
              AudioService.instance.playPlexiMatchSfx();
            } else {
              AudioService.instance.playMatchSfx();
            }

            // 更新分数动画
            final scoreDiff = _gameLogic.score - oldScore;
            if (scoreDiff > 0) {
              _scoreAnimController.reset();
              _scoreAnimController.forward();

              // 显示连击文本
              if (_gameLogic.comboChain > 1) {
                _showComboText('${_gameLogic.comboChain}连击!');
              }

              // 显示完美匹配文本
              if (_gameLogic.comboChain > oldCombo) {
                _showComboText('完美匹配!', color: AppColors.secondaryAccent);
              }
            }
          } else {
            // 没有匹配，但交换成功，播放交换音效
            AudioService.instance.playTapSfx();
          }

          // 强制更新UI
          setState(() {});

          _boardController.clearSelection();

          // 检查游戏状态
          _checkGameState();
        } else {
          // 播放无效移动音效
          AudioService.instance.playTapSfx();
        }

        // 重置交换状态
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _isSwapping = false;
            });
          }
        });
      } else {
        // 如果不相邻，取消之前的选择，选择新单元
        final previousSelectedUnit =
            _gameLogic.board[selectedPos.row][selectedPos.col];

        setState(() {
          // 取消之前单元的选中状态
          if (previousSelectedUnit != null) {
            _gameLogic.board[selectedPos.row][selectedPos.col] =
                previousSelectedUnit.copyWith(isSelected: false);
          }

          // 选中新单元
          _gameLogic.board[row][col] = currentUnit.copyWith(isSelected: true);
        });

        // 更新选中位置
        _boardController.setSelectedPosition(Position(row: row, col: col));
        AudioService.instance.playTapSfx();
      }
    }
  }

  // 显示连击文本
  void _showComboText(String text, {Color color = Colors.amber}) {
    setState(() {
      _comboText = text;
    });

    _comboTextTimer?.cancel();
    _comboTextTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _comboText = null;
        });
      }
    });
  }

  // 处理嬗变槽点击
  void _handleTransmuteSlotTap(int index) {
    if (_isPaused || _gameLogic.transmutes <= 0) return;

    setState(() {
      _isTransmuteMode = true;
    });

    // 显示嬗变选择对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Select Transmute Type',
          style: TextStyle(color: AppColors.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CyberButton(
              text: 'Change Color',
              onPressed: () {
                setState(() {
                  _isColorTransmute = true;
                });
                Navigator.pop(context);
              },
              backgroundColor: AppColors.primaryAccent,
              textColor: AppColors.primaryDark,
            ),
            const SizedBox(height: 16),
            CyberButton(
              text: 'Change Shape',
              onPressed: () {
                setState(() {
                  _isColorTransmute = false;
                });
                Navigator.pop(context);
              },
              backgroundColor: AppColors.secondaryAccent,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    ).then((_) {
      if (!_isTransmuteMode) {
        // 如果用户取消了对话框
        setState(() {
          _isTransmuteMode = false;
        });
      }
    });
  }

  // 检查游戏状态
  void _checkGameState() {
    setState(() {});

    // 检查是否达成关卡目标
    if (_gameLogic.isLevelCompleted) {
      _gameTimer?.cancel();
      AudioService.instance.playLevelCompleteSfx();

      // 延迟显示游戏胜利界面
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameOverScreen(
              isVictory: true,
              level: _gameLogic.level,
              score: _gameLogic.score,
              plexiMatches: _gameLogic.plexiMatches,
              transmutesUsed: 3 - _gameLogic.transmutes, // 假设最大值为3
              movesLeft: _gameLogic.movesLeft,
              elapsedTime: _elapsedTime,
            ),
          ),
        );
      });
    }
    // 检查是否步数用完
    else if (_gameLogic.isGameOver) {
      _gameTimer?.cancel();
      AudioService.instance.playLevelFailSfx();

      // 延迟显示游戏失败界面
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameOverScreen(
              isVictory: false,
              level: _gameLogic.level,
              score: _gameLogic.score,
              plexiMatches: _gameLogic.plexiMatches,
              transmutesUsed: 3 - _gameLogic.transmutes,
              movesLeft: 0,
              elapsedTime: _elapsedTime,
            ),
          ),
        );
      });
    }
    // 检查时间是否用完
    else if (_gameLogic.level.timeLimit > 0 &&
        _elapsedTime.inSeconds >= _gameLogic.level.timeLimit) {
      _gameTimer?.cancel();
      AudioService.instance.playLevelFailSfx();

      // 延迟显示游戏失败界面
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameOverScreen(
              isVictory: false,
              level: _gameLogic.level,
              score: _gameLogic.score,
              plexiMatches: _gameLogic.plexiMatches,
              transmutesUsed: 3 - _gameLogic.transmutes,
              movesLeft: _gameLogic.movesLeft,
              elapsedTime: _elapsedTime,
            ),
          ),
        );
      });
    }
  }

  // 暂停游戏
  void _pauseGame() {
    setState(() {
      _isPaused = true;
    });

    // 显示暂停菜单
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Game Paused',
          style: TextStyle(color: AppColors.textColor),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CyberButton(
              text: 'Continue',
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isPaused = false;
                });
              },
              backgroundColor: AppColors.primaryAccent,
              textColor: AppColors.primaryDark,
            ),
            const SizedBox(height: 16),
            CyberButton(
              text: 'Restart',
              onPressed: () {
                Navigator.pop(context);
                _restartGame();
              },
              backgroundColor: Colors.orange,
              textColor: Colors.white,
            ),
            const SizedBox(height: 16),
            CyberButton(
              text: 'Tutorial',
              onPressed: () {
                Navigator.pop(context);
                _showTutorialDialog();
              },
              backgroundColor: AppColors.primaryAccent.withOpacity(0.7),
              textColor: Colors.white,
            ),
            const SizedBox(height: 16),
            CyberButton(
              text: 'Exit Level',
              onPressed: () {
                Navigator.pop(context); // 关闭对话框
                Navigator.pop(context); // 退出游戏界面
              },
              backgroundColor: Colors.red,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // 重新开始游戏
  void _restartGame() {
    _gameTimer?.cancel();
    setState(() {
      _elapsedTime = Duration.zero;
      _isPaused = false;
      _isTransmuteMode = false;
      _isSwapping = false;
      _boardController = GameBoardController();
      _initGame();
    });
    _startGameTimer();
  }

  // 格式化时间
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // 根据剩余时间获取颜色
  Color _getRemainingTimeColor() {
    final totalTime = _gameLogic.level.timeLimit;

    // 没有时间限制，显示绿色
    if (totalTime == 0) {
      return Colors.green;
    }

    final elapsedSeconds = _elapsedTime.inSeconds;
    final remainingSeconds = totalTime - elapsedSeconds;
    final remainingPercentage = remainingSeconds / totalTime;

    if (remainingPercentage <= 0.2) {
      // 剩余时间少于20%，显示红色
      return Colors.red;
    } else if (remainingPercentage <= 0.5) {
      // 剩余时间少于50%，显示黄色
      return Colors.amber;
    } else {
      // 剩余时间充足，显示绿色
      return Colors.green;
    }
  }

  // 获取关卡目标文本
  String _getObjectiveText() {
    final objective = _gameLogic.level.objective;

    // 第六关特殊处理：显示双重目标
    if (_gameLogic.level.id == 6 &&
        objective.type == LevelObjectiveType.changingUnits) {
      return 'Remove ${objective.target} changing units & purify 16 tiles';
    }

    switch (objective.type) {
      case LevelObjectiveType.score:
        return 'Reach ${objective.target} points';
      case LevelObjectiveType.matches:
        return 'Make ${objective.target} matches';
      case LevelObjectiveType.plexiMatches:
        return 'Make ${objective.target} perfect matches';
      case LevelObjectiveType.lockedUnits:
        return 'Remove ${objective.target} locked units';
      case LevelObjectiveType.changingUnits:
        return 'Remove ${objective.target} changing units';
      case LevelObjectiveType.purifyTiles:
        return 'Purify ${objective.target} polluted tiles';
    }
  }

  // 获取目标标签
  String _getObjectiveLabel() {
    final objective = _gameLogic.level.objective;

    // 第六关特殊处理：显示双重目标
    if (_gameLogic.level.id == 6 &&
        objective.type == LevelObjectiveType.changingUnits) {
      return 'Dual Objective';
    }

    switch (objective.type) {
      case LevelObjectiveType.score:
        return 'Current Score';
      case LevelObjectiveType.matches:
        return 'Matches';
      case LevelObjectiveType.plexiMatches:
        return 'Perfect Matches';
      case LevelObjectiveType.lockedUnits:
        return 'Locked Units Removed';
      case LevelObjectiveType.changingUnits:
        return 'Changing Units Removed';
      case LevelObjectiveType.purifyTiles:
        return 'Tiles Purified';
    }
  }

  // 获取目标进度
  String _getObjectiveProgress() {
    final objective = _gameLogic.level.objective;

    // 第六关特殊处理：显示双重进度
    if (_gameLogic.level.id == 6 &&
        objective.type == LevelObjectiveType.changingUnits) {
      // 计算已净化的污染格子数量
      int remainingPollutedTiles = 0;
      for (int row = 0; row < _gameLogic.level.boardHeight; row++) {
        for (int col = 0; col < _gameLogic.level.boardWidth; col++) {
          final unit = _gameLogic.board[row][col];
          if (unit != null && unit.isPolluted) {
            remainingPollutedTiles++;
          }
        }
      }
      int purifiedTiles = 16 - remainingPollutedTiles;

      return '${objective.current}/${objective.target} ch, ${purifiedTiles}/16 pur';
    }

    switch (objective.type) {
      case LevelObjectiveType.score:
        return '$_displayScore / ${objective.target}';
      case LevelObjectiveType.matches:
        return '${objective.current} / ${objective.target}';
      case LevelObjectiveType.plexiMatches:
        return '${_gameLogic.plexiMatches} / ${objective.target}';
      case LevelObjectiveType.lockedUnits:
        return '${objective.current} / ${objective.target}';
      case LevelObjectiveType.changingUnits:
        return '${objective.current} / ${objective.target}';
      case LevelObjectiveType.purifyTiles:
        return '${objective.current} / ${objective.target}';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 如果需要显示教程，则显示教程对话框
    if (_showTutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTutorialDialog();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: _isLoading
          ? _buildLoadingScreen()
          : SafeArea(
              child: Column(
                children: [
                  // 顶部信息栏
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        // 关卡名称和目标
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          borderColor: AppColors.secondaryAccent,
                          isGlowing: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Level ${_gameLogic.level.id}: ${_gameLogic.level.name}',
                                style: const TextStyle(
                                  color: AppColors.secondaryAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getObjectiveText(),
                                style: const TextStyle(
                                  color: AppColors.primaryAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 游戏状态信息
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 暂停按钮
                            GestureDetector(
                              onTap: _pauseGame,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.pause,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),

                            // 当前目标进度
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: GlassCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        _getObjectiveLabel(),
                                        style: TextStyle(
                                          color: AppColors.primaryAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        _getObjectiveProgress(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // 剩余步数
                            GlassCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              width: 70,
                              child: Column(
                                children: [
                                  Text(
                                    'Steps',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${_gameLogic.movesLeft}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 游戏棋盘
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 游戏棋盘
                        GameBoard(
                          board: _gameLogic.board,
                          onUnitTap: _handleUnitTap,
                          spacing: 2,
                        ),

                        // 连击文本
                        if (_comboText != null)
                          AnimatedOpacity(
                            opacity: _comboText != null ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                _comboText!,
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        // 嬗变模式提示
                        if (_isTransmuteMode)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _isColorTransmute
                                  ? 'Change color'
                                  : 'Change shape',
                              style: TextStyle(
                                color: _isColorTransmute
                                    ? AppColors.primaryAccent
                                    : AppColors.secondaryAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 底部信息栏
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 分数
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Score',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '$_displayScore',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // 嬗变能力
                        TransmuteWidget(
                          count: _gameLogic.transmutes,
                          maxCount: 3,
                          onSlotTap: _handleTransmuteSlotTap,
                        ),
                      ],
                    ),
                  ),

                  // 游戏时间和时间限制
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          color: _getRemainingTimeColor(),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _gameLogic.level.timeLimit == 0
                              ? '${_formatDuration(_elapsedTime)}'
                              : '${_formatDuration(_elapsedTime)} / ${_formatDuration(Duration(seconds: _gameLogic.level.timeLimit))}',
                          style: TextStyle(
                            color: _getRemainingTimeColor(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // 构建加载屏幕
  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 加载指示器
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryAccent,
                ),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 加载文本
          Text(
            'Initializing game...',
            style: TextStyle(
              color: AppColors.primaryAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: AppColors.primaryAccent.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
