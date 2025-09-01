import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import '../../models/memory_card.dart';
import '../../services/level_service.dart';
import '../../utils/card_icons.dart';
import '../../widgets/memory_game/memory_card_widget.dart';
import 'memory_result_screen.dart';

/// 记忆游戏页面
class MemoryGameScreen extends StatefulWidget {
  /// 游戏难度
  final String difficulty;

  const MemoryGameScreen({super.key, required this.difficulty});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  // 游戏状态
  bool _isGamePaused = false;

  // 游戏数据
  late List<MemoryCard> _cards;
  int _score = 0;
  int _moves = 0;
  int _secondsElapsed = 0;
  late int _gridSize;
  String _gameMode = GameConstants.memoryClassic;

  // 连续匹配计数和倍数
  int _comboCount = 0;
  double _scoreMultiplier = 1.0;

  // 游戏限制
  int? _timeLimit;
  int _remainingTime = 0;

  // 翻牌状态
  MemoryCard? _firstCard;
  MemoryCard? _secondCard;
  bool _isProcessing = false;

  // 计时器
  late Timer _timer;

  // 游戏特效
  bool _isShaking = false;

  // 关卡服务
  final LevelService _levelService = LevelService();

  // 关卡主题
  late String _levelTheme;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// 初始化游戏
  void _initGame() {
    // 设置网格大小
    _gridSize = GameConstants.memoryGridSize[widget.difficulty] ?? 4;

    // 设置游戏模式和主题
    _setupGameMode();
    _setupLevelTheme();

    // 创建卡片
    _createCards();

    // 启动计时器
    _startTimer();

    // 游戏已初始化
  }

  /// 设置游戏模式
  void _setupGameMode() {
    // 获取关卡时间限制
    _timeLimit = GameConstants.memoryLevelTimeLimit[widget.difficulty];
    if (_timeLimit != null) {
      _remainingTime = _timeLimit!;
      _gameMode = GameConstants.memoryTimed;
    }

    // 根据难度设置游戏模式
    if (widget.difficulty == GameConstants.memoryLevel1) {
      _gameMode = GameConstants.memoryClassic;
    } else if (widget.difficulty == GameConstants.memoryLevel2 ||
        widget.difficulty == GameConstants.memoryLevel3 ||
        widget.difficulty == GameConstants.memoryLevel4) {
      _gameMode = GameConstants.memoryTimed;
    } else {
      _gameMode = GameConstants.memoryChallenge;
    }
  }

  /// 设置关卡主题
  void _setupLevelTheme() {
    // 获取关卡主题
    _levelTheme =
        GameConstants.memoryLevelThemes[widget.difficulty] ?? 'default';
  }

  /// 创建卡片
  void _createCards() {
    // 获取当前主题的图标列表
    final List<String> themeIcons = CardIcons.getIconsForTheme(_levelTheme);

    // 根据网格大小计算需要的图标数量
    final int pairsCount = (_gridSize * _gridSize) ~/ 2;

    // 确保有足够的图标
    if (themeIcons.length < pairsCount) {
      // 如果主题图标不足，添加一些通用图标
      final List<String> defaultIcons = CardIcons.getIconsForTheme('default');
      themeIcons.addAll(defaultIcons);
    }

    // 随机选择图标
    themeIcons.shuffle();
    final List<String> selectedIcons = themeIcons.take(pairsCount).toList();

    // 创建卡片对
    List<MemoryCard> cards = [];

    // 卡片颜色列表
    final List<CardColor> cardColors = CardColor.values.toList();

    // 获取特殊卡片比例
    final Map<String, double>? specialCardRatios =
        GameConstants.memoryLevelSpecialCards[widget.difficulty];
    final double bonusCardRatio =
        specialCardRatios?[GameConstants.categoryBonus] ?? 0.0;
    final double trapCardRatio =
        specialCardRatios?[GameConstants.categoryTrap] ?? 0.0;

    // 为每个图标创建一对卡片
    for (int i = 0; i < pairsCount; i++) {
      final String icon = selectedIcons[i];
      final CardColor cardColor = cardColors[i % cardColors.length];

      // 确定卡片类别和得分倍数
      String category = GameConstants.categoryStandard;
      double scoreMultiplier = 1.0;

      // 根据比例添加特殊卡片
      final double random = math.Random().nextDouble();
      if (random < bonusCardRatio) {
        category = GameConstants.categoryBonus;
        scoreMultiplier = 2.0;
      } else if (random < bonusCardRatio + trapCardRatio) {
        category = GameConstants.categoryTrap;
        scoreMultiplier = 0.5;
      }

      // 添加两张相同图标的卡片
      cards.add(
        MemoryCard(
          id: 'card_${i}_1',
          icon: icon,
          cardColor: cardColor,
          category: category,
          scoreMultiplier: scoreMultiplier,
        ),
      );

      cards.add(
        MemoryCard(
          id: 'card_${i}_2',
          icon: icon,
          cardColor: cardColor,
          category: category,
          scoreMultiplier: scoreMultiplier,
        ),
      );
    }

    // 随机排序卡片
    cards.shuffle();

    _cards = cards;
  }

  /// 启动计时器
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isGamePaused) {
        setState(() {
          _secondsElapsed++;

          // 处理限时模式
          if (_timeLimit != null) {
            _remainingTime = _timeLimit! - _secondsElapsed;

            // 时间到，游戏结束
            if (_remainingTime <= 0) {
              _gameOver();
            }

            // 时间不多了，添加视觉提示
            if (_remainingTime <= 10) {
              _isShaking = true;
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  setState(() {
                    _isShaking = false;
                  });
                }
              });
            }
          }
        });
      }
    });
  }

  /// 翻转卡片
  void _flipCard(MemoryCard card) {
    // 如果正在处理匹配、卡片已经翻开或已匹配，则不处理
    if (_isProcessing || card.isFlipped || card.isMatched) {
      return;
    }

    setState(() {
      // 翻转卡片
      final int cardIndex = _cards.indexWhere((c) => c.id == card.id);
      _cards[cardIndex] = card.flip();

      // 处理第一张卡片
      if (_firstCard == null) {
        _firstCard = _cards[cardIndex];
        return;
      }

      // 处理第二张卡片
      _secondCard = _cards[cardIndex];
      _moves++;

      // 检查是否匹配
      _isProcessing = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        _checkMatch();
      });
    });
  }

  /// 检查卡片是否匹配
  void _checkMatch() {
    if (_firstCard == null || _secondCard == null) return;

    final bool isMatch = _firstCard!.icon == _secondCard!.icon;
    final int firstIndex = _cards.indexWhere((c) => c.id == _firstCard!.id);
    final int secondIndex = _cards.indexWhere((c) => c.id == _secondCard!.id);

    setState(() {
      if (isMatch) {
        // 匹配成功
        _cards[firstIndex] = _firstCard!.match();
        _cards[secondIndex] = _secondCard!.match();

        // 处理连击
        _comboCount++;
        if (_comboCount > 1) {
          // 连击越多，倍数越高，最高3倍
          _scoreMultiplier = math.min(3.0, 1.0 + (_comboCount - 1) * 0.2);
        }

        // 处理特殊卡片
        double cardMultiplier = _firstCard!.scoreMultiplier;
        String category = _firstCard!.category;

        // 根据卡片类别应用不同效果
        if (category == GameConstants.categoryBonus) {
          // 奖励卡片：额外分数
          // 不做额外操作
        } else if (category == GameConstants.categoryTrap) {
          // 陷阱卡片：减少分数，打乱剩余卡片
          _shuffleRemainingCards();
        }

        // 计算基础分数
        int baseScore = 100 + math.max(0, 50 - _secondsElapsed ~/ 2);

        // 应用倍数
        int finalScore = (baseScore * _scoreMultiplier * cardMultiplier)
            .toInt();
        _score += finalScore;

        // 显示分数提示
        _showScorePopup(finalScore);

        // 检查游戏是否结束
        _checkGameOver();
      } else {
        // 匹配失败，重置连击
        _comboCount = 0;
        _scoreMultiplier = 1.0;

        // 翻回卡片
        _cards[firstIndex] = _firstCard!.flip();
        _cards[secondIndex] = _secondCard!.flip();
      }

      // 重置选择
      _firstCard = null;
      _secondCard = null;
      _isProcessing = false;
    });
  }

  /// 打乱剩余卡片
  void _shuffleRemainingCards() {
    // 获取所有未匹配的卡片
    final List<MemoryCard> unmatchedCards = _cards
        .where((card) => !card.isMatched)
        .map((card) => card.reset())
        .toList();

    // 打乱卡片
    unmatchedCards.shuffle();

    // 更新卡片
    int unmatchedIndex = 0;
    for (int i = 0; i < _cards.length; i++) {
      if (!_cards[i].isMatched) {
        _cards[i] = unmatchedCards[unmatchedIndex++];
      }
    }
  }

  /// 显示分数提示
  void _showScorePopup(int score) {
    // 在实际应用中，这里可以添加一个动画效果显示得分
    // 这里只是一个简单的示例
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '+$score points${_comboCount > 1 ? ' (${_comboCount}x combo!)' : ''}',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 检查游戏是否结束
  void _checkGameOver() {
    final bool allMatched = _cards.every((card) => card.isMatched);

    if (allMatched) {
      _gameOver(isVictory: true);
    }
  }

  /// 游戏结束处理
  void _gameOver({bool isVictory = false}) {
    _timer.cancel();

    // 游戏结束

    // 根据游戏模式计算最终分数
    int finalScore = _score;

    // 限时模式下，剩余时间越多，分数越高
    if (_gameMode == GameConstants.memoryTimed &&
        _timeLimit != null &&
        isVictory) {
      finalScore += (_remainingTime * 10);
    }

    // 挑战模式下，如果胜利，额外奖励
    if (_gameMode == GameConstants.memoryChallenge && isVictory) {
      finalScore = (finalScore * 1.5).toInt();
    }

    // 如果胜利，解锁下一关卡
    if (isVictory) {
      _levelService.unlockNextLevel(widget.difficulty);
    }

    // 显示结果页面
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MemoryResultScreen(
            score: finalScore,
            moves: _moves,
            time: _secondsElapsed,
            difficulty: widget.difficulty,
            isVictory: isVictory,
            gameMode: _gameMode,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _levelService.getLevelName(widget.difficulty),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_isGamePaused ? Icons.play_arrow : Icons.pause),
            onPressed: () {
              setState(() {
                _isGamePaused = !_isGamePaused;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 游戏信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard('Score', _score.toString()),
                  if (_comboCount > 1)
                    _buildInfoCard(
                      'Combo',
                      '${_comboCount}x',
                      color: Colors.orange,
                    ),
                  _buildInfoCard(
                    _timeLimit != null ? 'Time Left' : 'Time',
                    _timeLimit != null
                        ? '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}'
                        : '${(_secondsElapsed ~/ 60).toString().padLeft(2, '0')}:${(_secondsElapsed % 60).toString().padLeft(2, '0')}',
                    color: _timeLimit != null && _remainingTime <= 10
                        ? Colors.red
                        : null,
                  ),
                ],
              ),
            ),

            // 主题和模式指示器
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 主题指示器
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getThemeColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getThemeColor(), width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(_getThemeIcon(), color: _getThemeColor(), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _levelTheme.toUpperCase(),
                        style: TextStyle(
                          color: _getThemeColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // 游戏模式指示器
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
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
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            // 游戏网格
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: _isShaking
                    ? (Matrix4.translationValues(
                        5 * math.sin(_secondsElapsed * 10),
                        0,
                        0,
                      ))
                    : Matrix4.identity(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridSize,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      return MemoryCardWidget(
                        card: _cards[index],
                        onTap: () => _flipCard(_cards[index]),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 游戏统计
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Moves: $_moves',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取游戏模式颜色
  Color _getModeColor() {
    switch (_gameMode) {
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
    switch (_gameMode) {
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

  /// 获取主题颜色
  Color _getThemeColor() {
    switch (_levelTheme) {
      case 'nature':
        return Colors.green;
      case 'animals':
        return Colors.orange;
      case 'food':
        return Colors.red;
      case 'travel':
        return Colors.blue;
      case 'space':
        return Colors.purple;
      case 'tech':
        return Colors.teal;
      case 'fantasy':
        return Colors.amber;
      default:
        return AppColors.primary;
    }
  }

  /// 获取主题图标
  IconData _getThemeIcon() {
    switch (_levelTheme) {
      case 'nature':
        return Icons.eco;
      case 'animals':
        return Icons.pets;
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.flight;
      case 'space':
        return Icons.rocket;
      case 'tech':
        return Icons.devices;
      case 'fantasy':
        return Icons.auto_fix_high;
      default:
        return Icons.extension;
    }
  }

  Widget _buildInfoCard(String title, String value, {Color? color}) {
    final displayColor = color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: displayColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: displayColor.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: displayColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
