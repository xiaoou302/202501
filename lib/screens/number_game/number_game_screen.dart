import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import '../../models/number_tile.dart';
import '../../widgets/number_game/number_tile_widget.dart';
import '../../core/utils/haptic_feedback.dart';
import 'number_result_screen.dart';

/// 数字记忆游戏页面
class NumberGameScreen extends StatefulWidget {
  /// 游戏难度
  final String difficulty;

  const NumberGameScreen({super.key, required this.difficulty});

  @override
  State<NumberGameScreen> createState() => _NumberGameScreenState();
}

class _NumberGameScreenState extends State<NumberGameScreen>
    with TickerProviderStateMixin {
  // 游戏状态
  bool _isMemorizingPhase = true;
  bool _isGameOver = false;

  // 游戏数据
  late List<NumberTile> _tiles;
  late List<int> _correctSequence;
  late List<int> _playerSequence;
  int _tileCount = 5;
  int _memoryTimeSeconds = 5;
  int _remainingTime = 0;
  int _score = 0;

  // 元素类型
  late String _elementType;
  late int _startValue;

  // 计时器
  late Timer _gameTimer;

  // 动画控制器
  late AnimationController _countdownController;

  // 触觉反馈
  final HapticFeedbackManager _hapticFeedback = HapticFeedbackManager();

  @override
  void initState() {
    super.initState();

    // 设置游戏参数
    _tileCount = GameConstants.numberTileCount[widget.difficulty] ?? 5;
    _memoryTimeSeconds = GameConstants.numberMemoryTime[widget.difficulty] ?? 5;
    _remainingTime = _memoryTimeSeconds;

    // 设置元素类型
    _elementType =
        GameConstants.numberLevelElementType[widget.difficulty] ??
        GameConstants.elementTypeNumbers;
    _startValue = GameConstants.numberLevelStartValue[widget.difficulty] ?? 1;

    // 初始化动画控制器
    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // 创建方块
    _createTiles();

    // 启动记忆阶段计时器
    _startMemorizingPhase();
  }

  @override
  void dispose() {
    _gameTimer.cancel();
    _countdownController.dispose();
    super.dispose();
  }

  /// 创建方块
  void _createTiles() {
    // 初始化玩家序列
    _playerSequence = [];

    // 创建正确序列
    _correctSequence = List.generate(_tileCount, (index) => index + 1);

    // 创建方块
    _tiles = [];
    final random = math.Random();

    for (int i = 0; i < _tileCount; i++) {
      // 生成随机位置，避免重叠
      double x, y;
      bool overlapping;
      int attempts = 0;

      do {
        overlapping = false;
        x = random.nextDouble() * 0.8 + 0.1; // 10%-90%的范围
        y = random.nextDouble() * 0.7 + 0.1; // 10%-80%的范围

        // 检查是否与已有方块重叠
        for (final tile in _tiles) {
          final double distance = math.sqrt(
            math.pow(tile.x - x, 2) + math.pow(tile.y - y, 2),
          );
          if (distance < 0.15) {
            // 如果距离太近
            overlapping = true;
            break;
          }
        }

        attempts++;
      } while (overlapping && attempts < 50);

      // 创建方块
      _tiles.add(
        NumberTile(
          id: 'tile_$i',
          value: i + 1,
          x: x,
          y: y,
          elementType: _elementType,
          startValue: _startValue,
        ),
      );
    }
  }

  /// 启动记忆阶段
  void _startMemorizingPhase() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;

        // 播放倒计时动画
        _countdownController.forward(from: 0);

        // 记忆阶段结束
        if (_remainingTime <= 0) {
          timer.cancel();
          _startPlayingPhase();
        }
      });
    });
  }

  /// 启动游戏阶段
  void _startPlayingPhase() {
    setState(() {
      _isMemorizingPhase = false;

      // 隐藏所有方块的值
      _tiles = _tiles.map((tile) => tile.hideNumber()).toList();
    });
  }

  /// 处理方块点击
  void _handleTileTap(NumberTile tile) {
    if (_isGameOver || _isMemorizingPhase) return;

    setState(() {
      // 添加到玩家序列
      _playerSequence.add(tile.value);

      // 更新方块状态
      final int index = _tiles.indexWhere((t) => t.id == tile.id);
      _tiles[index] = _tiles[index].select();

      // 触发触觉反馈
      _hapticFeedback.lightImpact();

      // 检查是否正确
      final int currentIndex = _playerSequence.length - 1;
      if (_playerSequence[currentIndex] != _correctSequence[currentIndex]) {
        // 选择错误，游戏结束
        _gameOver(false);
        return;
      }

      // 检查是否完成
      if (_playerSequence.length == _correctSequence.length) {
        // 全部正确，游戏胜利
        _gameOver(true);
      }
    });
  }

  /// 游戏结束
  void _gameOver(bool isVictory) {
    setState(() {
      _isGameOver = true;
    });

    // 计算分数
    if (isVictory) {
      _score = _calculateScore();
      _hapticFeedback.mediumImpact();
    } else {
      _hapticFeedback.heavyImpact();
    }

    // 显示结果页面
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NumberResultScreen(
            score: _score,
            isVictory: isVictory,
            difficulty: widget.difficulty,
            correctCount: _playerSequence.length,
            totalCount: _correctSequence.length,
          ),
        ),
      );
    });
  }

  /// 计算分数
  int _calculateScore() {
    // 基础分数
    int baseScore = _tileCount * 100;

    // 根据难度增加分数
    switch (widget.difficulty) {
      case GameConstants.numberEasy:
        baseScore = baseScore;
        break;
      case GameConstants.numberMedium:
        baseScore = (baseScore * 1.2).toInt();
        break;
      case GameConstants.numberHard:
        baseScore = (baseScore * 1.5).toInt();
        break;
      case GameConstants.numberExpert:
        baseScore = (baseScore * 2.0).toInt();
        break;
      case GameConstants.numberMaster:
        baseScore = (baseScore * 3.0).toInt();
        break;
    }

    return baseScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(_getDifficultyName()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 游戏状态
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 阶段指示器
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _isMemorizingPhase
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isMemorizingPhase ? Colors.blue : Colors.green,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _isMemorizingPhase ? 'Memorize' : 'Play',
                      style: TextStyle(
                        color: _isMemorizingPhase ? Colors.blue : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // 倒计时
                  if (_isMemorizingPhase)
                    AnimatedBuilder(
                      animation: _countdownController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + _countdownController.value * 0.2,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.2),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Center(
                          child: Text(
                            _remainingTime.toString(),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // 进度指示器
                  if (!_isMemorizingPhase)
                    Text(
                      '${_playerSequence.length}/${_correctSequence.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            // 游戏区域
            Expanded(
              child: Stack(
                children: [
                  // 背景网格
                  _buildGrid(),

                  // 方块
                  ..._tiles.map(
                    (tile) => NumberTileWidget(
                      tile: tile,
                      onTap: () => _handleTileTap(tile),
                    ),
                  ),
                ],
              ),
            ),

            // 游戏说明
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _isMemorizingPhase
                    ? 'Memorize the ${_elementType == GameConstants.elementTypeLetters ? 'letters' : 'numbers'} and their positions'
                    : _elementType == GameConstants.elementTypeLetters
                    ? 'Tap the tiles in alphabetical order (A, B, C, ...)'
                    : 'Tap the tiles in ascending order (${_startValue}, ${_startValue + 1}, ${_startValue + 2}, ...)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建背景网格
  Widget _buildGrid() {
    return CustomPaint(size: Size.infinite, painter: GridPainter());
  }

  /// 获取难度名称
  String _getDifficultyName() {
    String levelName;
    switch (widget.difficulty) {
      case GameConstants.numberLevel1:
        levelName = 'Level 1';
        break;
      case GameConstants.numberLevel2:
        levelName = 'Level 2';
        break;
      case GameConstants.numberLevel3:
        levelName = 'Level 3';
        break;
      case GameConstants.numberLevel4:
        levelName = 'Level 4';
        break;
      case GameConstants.numberLevel5:
        levelName = 'Level 5';
        break;
      case GameConstants.numberLevel6:
        levelName = 'Level 6';
        break;
      case GameConstants.numberLevel7:
        levelName = 'Level 7';
        break;
      default:
        levelName = 'Unknown';
    }

    String gameType = _elementType == GameConstants.elementTypeLetters
        ? 'Letter'
        : 'Number';
    return '$gameType Memory - $levelName';
  }
}

/// 网格绘制器
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    // 绘制横线
    for (int i = 0; i <= 10; i++) {
      final y = size.height * (i / 10);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // 绘制竖线
    for (int i = 0; i <= 10; i++) {
      final x = size.width * (i / 10);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
