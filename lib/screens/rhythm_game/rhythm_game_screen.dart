import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../core/constants/game_constants.dart';
import '../../models/rhythm_obstacle.dart';
import '../../widgets/rhythm_game/obstacle_widget.dart';
import '../../core/utils/haptic_feedback.dart';
import 'rhythm_result_screen.dart';

/// 节奏游戏页面 - 新版本：音符堆积在轨道中，通过移动音符使相同类型的音符在同一轨道
class RhythmGameScreen extends StatefulWidget {
  /// 游戏难度
  final String difficulty;

  const RhythmGameScreen({super.key, required this.difficulty});

  @override
  State<RhythmGameScreen> createState() => _RhythmGameScreenState();
}

class _RhythmGameScreenState extends State<RhythmGameScreen>
    with TickerProviderStateMixin {
  // 游戏状态
  bool _isGameOver = false;
  bool _isGameStarted = false;
  bool _showHint = false; // 是否显示提示

  // 选中的音符
  RhythmObstacle? _selectedObstacle;

  // 提示计时器
  Timer? _hintTimer;

  // 游戏数据
  int _score = 0;
  int _moves = 0;
  int _maxMoves = 30; // 最大移动次数

  // 游戏元素
  final List<RhythmObstacle> _obstacles = [];
  late int _laneCount;
  late int _notesPerTrack; // 每个轨道的音符数量
  late int _totalNoteTypes; // 总共使用的音符类型数量

  // 游戏计时器
  late Timer _gameTimer;
  Timer? _navigationTimer; // 导航计时器
  int _remainingTime = 60; // 游戏时间（秒）

  // 动画控制器
  late AnimationController _scoreAnimationController;
  late AnimationController _matchAnimationController;
  late AnimationController _errorAnimationController;

  // 触觉反馈
  final HapticFeedbackManager _hapticFeedback = HapticFeedbackManager();

  // 音符类型列表
  final List<String> _allNoteTypes = [
    GameConstants.noteTypeQuarter,
    GameConstants.noteTypeEighth,
    GameConstants.noteTypeHalf,
    GameConstants.noteTypeWhole,
  ];

  // 实际使用的音符类型
  List<String> _activeNoteTypes = [];

  // 启动游戏的计时器
  Timer? _startGameTimer;

  @override
  void initState() {
    super.initState();

    // 根据难度设置轨道数
    _laneCount = GameConstants.flowColumns[widget.difficulty] ?? 4;

    // 根据难度设置游戏参数
    switch (widget.difficulty) {
      case GameConstants.flowEasy:
        _maxMoves = 20;
        _remainingTime = 90;
        _notesPerTrack = 2; // 简单难度每轨道只有2个音符
        _totalNoteTypes = 2; // 只使用2种音符类型
        break;
      case GameConstants.flowNormal:
        _maxMoves = 25;
        _remainingTime = 75;
        _notesPerTrack = 2;
        _totalNoteTypes = 3; // 使用3种音符类型
        break;
      case GameConstants.flowHard:
        _maxMoves = 30;
        _remainingTime = 60;
        _notesPerTrack = 3;
        _totalNoteTypes = 3;
        break;
      case GameConstants.flowExpert:
        _maxMoves = 35;
        _remainingTime = 50;
        _notesPerTrack = 3;
        _totalNoteTypes = 4; // 使用4种音符类型
        break;
      case GameConstants.flowMaster:
        _maxMoves = 40;
        _remainingTime = 45;
        _notesPerTrack = 4; // 每轨道有4个音符
        _totalNoteTypes = 4;
        break;
      case GameConstants.flowGrandmaster:
        _maxMoves = 45;
        _remainingTime = 40;
        _notesPerTrack = 4;
        _totalNoteTypes = 4;
        break;
      case GameConstants.flowLegend:
        _maxMoves = 50;
        _remainingTime = 35;
        _notesPerTrack = 5; // 最高难度每轨道有5个音符
        _totalNoteTypes = 4; // 使用全部音符类型
        break;
    }

    // 创建分数动画控制器
    _scoreAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // 创建匹配成功动画控制器
    _matchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // 创建错误动画控制器
    _errorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // 延迟启动游戏，给玩家准备时间
    _startGameTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        _startGame();
      }
    });
  }

  @override
  void dispose() {
    if (_isGameStarted) {
      _gameTimer.cancel();
    }
    _hintTimer?.cancel();
    _navigationTimer?.cancel(); // 取消导航计时器
    _startGameTimer?.cancel(); // 取消启动游戏计时器
    _scoreAnimationController.dispose();
    _matchAnimationController.dispose();
    _errorAnimationController.dispose();
    super.dispose();
  }

  /// 启动游戏
  void _startGame() {
    // 生成初始音符
    _generateInitialNotes();

    setState(() {
      _isGameStarted = true;
    });

    // 启动游戏计时器
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isGameOver || !mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingTime--;

        // 检查游戏是否结束（时间用完）
        if (_remainingTime <= 0) {
          _gameOver(false);
        }

        // 当剩余时间不多或移动次数不多时，显示提示
        if ((_remainingTime <= 20 || _moves >= _maxMoves - 5) && !_showHint) {
          _startHintSystem();
        }
      });
    });
  }

  /// 生成初始音符
  void _generateInitialNotes() {
    final random = math.Random();

    // 选择要使用的音符类型
    _activeNoteTypes = [];
    // 限制音符类型数量
    for (int i = 0; i < _totalNoteTypes; i++) {
      _activeNoteTypes.add(_allNoteTypes[i]);
    }

    // 计算每种音符类型的数量
    final int totalNotes = _laneCount * _notesPerTrack;
    final int notesPerType = totalNotes ~/ _totalNoteTypes;
    final int extraNotes = totalNotes % _totalNoteTypes;

    // 创建音符列表，确保每种类型的音符数量均匀
    final List<String> noteDistribution = [];
    for (int i = 0; i < _totalNoteTypes; i++) {
      int count = notesPerType;
      if (i < extraNotes) {
        count += 1; // 分配多出来的音符
      }
      for (int j = 0; j < count; j++) {
        noteDistribution.add(_activeNoteTypes[i]);
      }
    }

    // 随机打乱音符列表
    noteDistribution.shuffle(random);

    // 确保初始分布不会自动满足胜利条件
    // 我们会尽量将相同类型的音符分布在不同轨道中
    List<List<String>> trackNotes = List.generate(
      _laneCount,
      (_) => <String>[],
    );

    // 先将相同类型的音符尽量分布在不同轨道
    for (int i = 0; i < _activeNoteTypes.length; i++) {
      String noteType = _activeNoteTypes[i];
      int notesOfThisType = noteDistribution
          .where((note) => note == noteType)
          .length;

      // 尽量平均分配到每个轨道
      for (int j = 0; j < notesOfThisType; j++) {
        int targetTrack = j % _laneCount;
        if (trackNotes[targetTrack].length < _notesPerTrack) {
          trackNotes[targetTrack].add(noteType);
        } else {
          // 如果该轨道已满，找一个没满的轨道
          for (int k = 0; k < _laneCount; k++) {
            if (trackNotes[k].length < _notesPerTrack) {
              trackNotes[k].add(noteType);
              break;
            }
          }
        }
      }
    }

    // 再次随机打乱每个轨道内的音符
    for (int i = 0; i < _laneCount; i++) {
      trackNotes[i].shuffle(random);
    }

    // 为每个轨道生成音符
    for (int lane = 0; lane < _laneCount; lane++) {
      for (int position = 0; position < trackNotes[lane].length; position++) {
        // 使用预先生成的音符类型
        final noteType = trackNotes[lane][position];

        // 创建音符
        final obstacle = RhythmObstacle(
          id: 'note_${lane}_$position',
          noteType: noteType,
          position: lane.toDouble(),
          trackPosition: position,
          size: 0.8,
        );

        _obstacles.add(obstacle);
      }
    }

    // 检查初始状态是否已经有匹配
    _checkAllTracksForMatches();
  }

  /// 处理音符点击
  void _handleNoteTap(RhythmObstacle obstacle) {
    // 检查游戏是否结束
    if (_isGameOver) {
      return;
    }

    // 检查是否可选择
    if (!obstacle.isSelectable()) {
      _hapticFeedback.heavyImpact();
      _showErrorAnimation();
      return;
    }

    // 如果没有选中的音符，则选中当前音符
    if (_selectedObstacle == null) {
      setState(() {
        _selectedObstacle = obstacle;
      });
      _hapticFeedback.lightImpact();
      return;
    }

    // 如果点击的是已选中的音符，取消选中
    if (_selectedObstacle?.id == obstacle.id) {
      setState(() {
        _selectedObstacle = null;
      });
      _hapticFeedback.lightImpact();
      return;
    }

    // 检查两个音符是否相邻
    if (_selectedObstacle!.isAdjacentTo(obstacle)) {
      // 交换两个音符
      _swapNotes(_selectedObstacle!, obstacle);
    } else {
      // 如果不相邻，显示错误并重新选择
      _hapticFeedback.heavyImpact();
      _showErrorAnimation();
      setState(() {
        _selectedObstacle = obstacle;
      });
    }
  }

  /// 交换两个音符的位置
  void _swapNotes(RhythmObstacle note1, RhythmObstacle note2) {
    // 检查是否还有移动次数
    if (_moves >= _maxMoves) {
      _hapticFeedback.heavyImpact();
      _showErrorAnimation();
      setState(() {
        _selectedObstacle = null;
      });
      return;
    }

    // 触发触觉反馈
    _hapticFeedback.mediumImpact();

    setState(() {
      // 找到两个音符的索引
      final index1 = _obstacles.indexOf(note1);
      final index2 = _obstacles.indexOf(note2);

      if (index1 != -1 && index2 != -1) {
        // 交换音符的位置和轨道
        final double tempPosition = note1.position;
        final int tempTrackPosition = note1.trackPosition;

        // 更新第一个音符
        _obstacles[index1] = note1.copyWith(
          position: note2.position,
          trackPosition: note2.trackPosition,
        );

        // 更新第二个音符
        _obstacles[index2] = note2.copyWith(
          position: tempPosition,
          trackPosition: tempTrackPosition,
        );

        // 增加移动次数
        _moves++;

        // 重置选中状态
        _selectedObstacle = null;

        // 检查是否所有同类型的音符都在同一轨道
        _checkAllTracksForMatches();
      }
    });
  }

  /// 启动提示系统
  void _startHintSystem() {
    setState(() {
      _showHint = true;
    });

    // 设置定时器，每隔10秒切换提示显示状态
    _hintTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _showHint = !_showHint;
      });
    });
  }

  /// 检查所有轨道是否有匹配
  void _checkAllTracksForMatches() {
    // 创建一个映射，用于存储每种音符类型在每个轨道上的数量
    final Map<String, Map<double, int>> noteTypeTrackCount = {};

    // 初始化映射
    for (final noteType in _activeNoteTypes) {
      noteTypeTrackCount[noteType] = {};
      for (int i = 0; i < _laneCount; i++) {
        noteTypeTrackCount[noteType]![i.toDouble()] = 0;
      }
    }

    // 统计每种音符类型在每个轨道上的数量
    for (final obstacle in _obstacles) {
      final noteType = obstacle.noteType;
      final position = obstacle.position;
      noteTypeTrackCount[noteType]![position] =
          (noteTypeTrackCount[noteType]![position] ?? 0) + 1;
    }

    // 检查每种音符类型是否都在同一个轨道上
    final Map<String, double> correctTrackForNoteType = {};
    bool allMatched = true;

    for (final noteType in _activeNoteTypes) {
      // 找到该音符类型数量最多的轨道
      double? maxTrack;
      int maxCount = 0;

      noteTypeTrackCount[noteType]!.forEach((track, count) {
        if (count > maxCount) {
          maxCount = count;
          maxTrack = track;
        }
      });

      // 如果所有该类型的音符都在同一轨道上
      if (maxCount == _notesPerTrack) {
        correctTrackForNoteType[noteType] = maxTrack!;
      } else {
        // 只有当这种类型的音符在游戏中存在时才影响胜利条件
        if (maxCount > 0) {
          allMatched = false;
        }
      }
    }

    // 更新音符状态
    for (int i = 0; i < _obstacles.length; i++) {
      final obstacle = _obstacles[i];
      final noteType = obstacle.noteType;

      if (correctTrackForNoteType.containsKey(noteType) &&
          obstacle.position == correctTrackForNoteType[noteType]) {
        // 该音符在正确的轨道上
        if (!obstacle.isInCorrectTrack) {
          _obstacles[i] = obstacle.setCorrectTrack();

          // 增加分数
          _score += 10;

          // 触发匹配动画
          _showMatchAnimation();
        }
      }
    }

    // 如果所有类型的音符都匹配了，游戏胜利
    if (allMatched) {
      print('All notes matched! Game victory!');
      _gameOver(true);
    }
  }

  /// 显示匹配成功动画
  void _showMatchAnimation() {
    _matchAnimationController.forward(from: 0);
    _hapticFeedback.mediumImpact();
  }

  /// 显示错误动画
  void _showErrorAnimation() {
    _errorAnimationController.forward(from: 0);
  }

  /// 游戏结束
  void _gameOver(bool isVictory) {
    print('Game over called with isVictory: $isVictory');

    setState(() {
      _isGameOver = true;
    });

    // 计算最终得分
    int finalScore = _score;
    if (isVictory) {
      print('Victory! Calculating bonus score...');
      // 胜利加分：剩余时间 * 10 + 剩余移动次数 * 20
      finalScore += _remainingTime * 10;
      finalScore += (_maxMoves - _moves) * 20;

      // 根据难度增加额外分数
      switch (widget.difficulty) {
        case GameConstants.flowEasy:
          finalScore += 100;
          break;
        case GameConstants.flowNormal:
          finalScore += 200;
          break;
        case GameConstants.flowHard:
          finalScore += 300;
          break;
        case GameConstants.flowExpert:
          finalScore += 400;
          break;
        case GameConstants.flowMaster:
          finalScore += 500;
          break;
        case GameConstants.flowGrandmaster:
          finalScore += 600;
          break;
        case GameConstants.flowLegend:
          finalScore += 800;
          break;
      }

      print('Final score with bonuses: $finalScore');
    }

    // 触发触觉反馈
    if (isVictory) {
      _hapticFeedback.successfulImpact();
    } else {
      _hapticFeedback.heavyImpact();
    }

    // 显示结果页面
    print('Navigating to result screen with unlockedNextLevel: $isVictory');

    // 存储导航计时器
    _navigationTimer = Timer(const Duration(milliseconds: 1000), () {
      // 确保组件仍然挂载在widget树中
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RhythmResultScreen(
              score: finalScore,
              difficulty: widget.difficulty,
              unlockedNextLevel: isVictory,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 游戏信息区域
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 分数显示
                  ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                      CurvedAnimation(
                        parent: _scoreAnimationController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Score',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          _score.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 匹配成功/错误动画
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // 匹配成功动画
                      FadeTransition(
                        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                          CurvedAnimation(
                            parent: _matchAnimationController,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 2.0).animate(
                            CurvedAnimation(
                              parent: _matchAnimationController,
                              curve: Curves.easeOut,
                            ),
                          ),
                          child: Text(
                            'Match successful!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),

                      // 错误动画
                    ],
                  ),

                  // 剩余移动次数和时间
                  Column(
                    children: [
                      Text(
                        'move: $_moves/$_maxMoves',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _moves >= _maxMoves
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                      Text(
                        'time: $_remainingTime秒',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _remainingTime <= 10
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 游戏目标提示
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  Text(
                    'Click two adjacent notes to swap positions and place the same type of notes in the same track',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    textAlign: TextAlign.center,
                  ),
                  if (_showHint)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Hint: Try to move the same type of notes together',
                        style: TextStyle(fontSize: 14, color: Colors.amber),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),

            // 游戏区域
            Expanded(child: _buildGameArea()),

            // 底部音符类型说明
            Container(
              height: 90, // 增加高度以避免溢出
              child: _buildNoteTypeGuide(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameArea() {
    return Container(
      color: Colors.black,
      child: ClipRect(
        clipBehavior: Clip.none,
        child: Stack(
          children: [
            // 背景网格线
            CustomPaint(
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              ),
              painter: _GridPainter(laneCount: _laneCount),
            ),

            // 轨道
            Row(
              children: List.generate(_laneCount, (index) {
                return Expanded(child: _buildLane(index));
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLane(int lane) {
    // 获取该车道上的所有音符
    final laneObstacles = _obstacles
        .where((obstacle) => obstacle.position == lane.toDouble())
        .toList();

    // 按照轨道位置排序
    laneObstacles.sort((a, b) => a.trackPosition.compareTo(b.trackPosition));

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: lane < _laneCount - 1
              ? BorderSide(color: Colors.grey.withOpacity(0.3), width: 1)
              : BorderSide.none,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 绘制该车道上的所有音符
          ...laneObstacles.map((obstacle) {
            // 计算音符位置
            // 获取游戏区域高度
            final gameAreaHeight =
                MediaQuery.of(context).size.height - 200; // 减去头部和底部区域

            // 计算每个音符的垂直间距
            final double verticalSpacing =
                gameAreaHeight / (_notesPerTrack + 1);

            // 根据 trackPosition 计算音符的垂直位置
            // 使用 trackPosition 而不是 index 确保音符位置不变
            final notePosition = 80 + obstacle.trackPosition * verticalSpacing;

            return Positioned(
              left: -30, // 调整箭头空间
              right: -30, // 调整箭头空间
              top: notePosition,
              child: Center(
                child: SizedBox(
                  width: 120, // 调整宽度
                  height: 70, // 调整高度
                  child: ObstacleWidget(
                    obstacle: _selectedObstacle?.id == obstacle.id
                        ? obstacle
                              .select() // 如果是选中的音符，设置选中状态
                        : obstacle,
                    laneCount: _laneCount,
                    onTap: obstacle.isSelectable()
                        ? () => _handleNoteTap(obstacle)
                        : null,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // 底部音符类型说明区域
  Widget _buildNoteTypeGuide() {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 4.0), // 减少垂直内边距
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _activeNoteTypes.map((noteType) {
          // 创建示例音符
          final note = RhythmObstacle(
            id: 'guide_$noteType',
            noteType: noteType,
            position: 0,
            trackPosition: 0,
            size: 0.6,
          );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: ObstacleWidget(
                  obstacle: note,
                  isBottomNote: true,
                  laneCount: _laneCount,
                ),
              ),
              SizedBox(height: 2), // 减少间距
              Text(
                _getNoteTypeName(noteType),
                style: TextStyle(fontSize: 10, color: Colors.white70), // 减小字体大小
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // 获取音符类型名称
  String _getNoteTypeName(String noteType) {
    switch (noteType) {
      case GameConstants.noteTypeQuarter:
        return 'Quarter note';
      case GameConstants.noteTypeEighth:
        return 'Eighth note';
      case GameConstants.noteTypeHalf:
        return 'Half note';
      case GameConstants.noteTypeWhole:
        return 'Whole note';
      default:
        return 'note';
    }
  }
}

// 网格绘制器
class _GridPainter extends CustomPainter {
  final int laneCount;

  _GridPainter({required this.laneCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // 绘制水平网格线
    for (int i = 1; i < 10; i++) {
      final y = size.height * (i / 10);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // 绘制垂直网格线
    for (int i = 1; i < laneCount; i++) {
      final x = size.width * (i / laneCount);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 触觉反馈扩展
extension HapticFeedbackExtension on HapticFeedbackManager {
  void successfulImpact() {
    lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      lightImpact();
    });
  }
}
