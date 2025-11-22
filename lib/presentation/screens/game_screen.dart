import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/card_model.dart';
import '../../data/models/level_model.dart';
import '../../data/local/local_storage.dart';
import '../widgets/card_widget.dart';
import '../widgets/combo_indicator.dart';
import '../widgets/particle_background.dart';
import '../widgets/timer_bar.dart';

class GameScreen extends StatefulWidget {
  final int levelId;

  const GameScreen({Key? key, required this.levelId}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late LevelModel _currentLevel;
  late List<CardModel> _cards;
  List<CardModel> _flippedCards = [];

  int _score = 0;
  int _timeLeft = 0;
  int _matchedPairs = 0;
  int _moves = 0;
  int _comboStreak = 0;
  int _mistakes = 0; // 记录错误次数（用于鹰眼成就）
  bool _isLocked = false;
  bool _isPaused = false;
  bool _showCombo = false;
  bool _isObserving = false;
  int _observationTimeLeft = 0;
  Set<int> _shakingCardIndices = {}; // 追踪正在震动的卡片索引

  Timer? _gameTimer;
  Timer? _observationTimer;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _observationTimer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    _currentLevel = GameLevels.levels.firstWhere((l) => l.id == widget.levelId);
    _timeLeft = _currentLevel.time;
    _cards = _generateCards();
    _matchedPairs = 0;
    _moves = 0;
    _score = 0;
    _comboStreak = 0;
    _mistakes = 0;
    _flippedCards = [];
    _isLocked = false;
    _isPaused = false;
    _isObserving = false;

    // Ensure all cards start face-down
    for (var card in _cards) {
      card.isFlipped = false;
      card.isMatched = false;
    }

    LocalStorage.incrementTotalGames();

    if (_currentLevel.hasObservation) {
      _startObservationPhase();
    } else {
      _startTimer();
    }
  }

  List<CardModel> _generateCards() {
    List<CardModel> cards = [];
    final random = Random();

    for (int i = 0; i < _currentLevel.pairs; i++) {
      final icon = GameIcons.icons[i % GameIcons.icons.length];
      final color = CardColors.neonColors[i % CardColors.neonColors.length];

      cards.add(CardModel(id: i, icon: icon, color: color));
      cards.add(CardModel(id: i, icon: icon, color: color));
    }

    cards.shuffle(random);
    return cards;
  }

  void _startObservationPhase() {
    // First, ensure all cards start face-down
    for (var card in _cards) {
      card.isFlipped = false;
    }

    setState(() {
      _isLocked = true;
      _isObserving = true;
      _observationTimeLeft = 3;
    });

    // Delay flipping cards to face-up to allow proper initialization
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          for (var card in _cards) {
            card.isFlipped = true;
          }
        });
      }
    });

    _observationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _observationTimeLeft--;
        });

        if (_observationTimeLeft <= 0) {
          timer.cancel();
          if (mounted) {
            // Flip all cards back to face-down
            setState(() {
              for (var card in _cards) {
                card.isFlipped = false;
              }
              _isLocked = false;
              _isObserving = false;
            });
            _startTimer();
          }
        }
      }
    });
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && mounted) {
        setState(() {
          _timeLeft--;
          if (_timeLeft <= 0) {
            _endGame(false);
          }
        });
      }
    });
  }

  void _onCardTap(int index) {
    // Prevent taps during observation or when game is locked
    if (_isObserving) return;
    if (_isLocked) return;
    if (_cards[index].isMatched) return;
    if (_cards[index].isFlipped) return;
    if (_flippedCards.length >= 2) return;

    HapticUtils.lightImpact();

    setState(() {
      _cards[index].isFlipped = true;
      _flippedCards.add(_cards[index]);
    });

    if (_flippedCards.length == 2) {
      _moves++;
      _checkMatch();
    }
  }

  void _checkMatch() {
    setState(() {
      _isLocked = true;
    });

    final card1 = _flippedCards[0];
    final card2 = _flippedCards[1];

    if (card1.id == card2.id) {
      _handleMatch(card1, card2);
    } else {
      _handleMismatch(card1, card2);
    }
  }

  void _handleMatch(CardModel card1, CardModel card2) {
    _comboStreak++;
    _matchedPairs++;

    final points = ScoringRules.calculateMatchScore(_comboStreak);
    _score += points;

    HapticUtils.mediumImpact();

    if (_comboStreak > 1) {
      setState(() => _showCombo = true);
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _showCombo = false);
      });
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          card1.isMatched = true;
          card2.isMatched = true;
          _flippedCards.clear();
          _isLocked = false;
        });

        if (_matchedPairs == _currentLevel.pairs) {
          _endGame(true);
        }
      }
    });
  }

  void _handleMismatch(CardModel card1, CardModel card2) {
    _comboStreak = 0;
    _mistakes++; // 记录错误
    HapticUtils.heavyImpact();

    // 找到这两张卡片的索引并触发震动动画
    final index1 = _cards.indexOf(card1);
    final index2 = _cards.indexOf(card2);

    // 延迟300ms后开始震动动画
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _shakingCardIndices.add(index1);
          _shakingCardIndices.add(index2);
        });

        // 震动动画持续500ms后清除
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _shakingCardIndices.clear();
            });
          }
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          card1.isFlipped = false;
          card2.isFlipped = false;
          _flippedCards.clear();
          _isLocked = false;
        });
      }
    });
  }

  void _endGame(bool isWin) {
    _gameTimer?.cancel();
    _isLocked = true;

    if (isWin) {
      final stars = StarRating.calculateStars(_timeLeft, _currentLevel.time);
      final finalScore = ScoringRules.calculateFinalScore(_score, _timeLeft);
      final timePercentage = (_timeLeft / _currentLevel.time) * 100;

      LocalStorage.incrementTotalWins();
      LocalStorage.setLevelStars(widget.levelId, stars);
      LocalStorage.setLevelBestScore(widget.levelId, finalScore);
      LocalStorage.setLevelBestTime(widget.levelId, _timeLeft);

      if (widget.levelId < GameLevels.levels.length) {
        LocalStorage.setLevelUnlocked(widget.levelId + 1, true);
      }

      // 成就检测
      _checkAndUnlockAchievements(timePercentage);

      _showResultModal(isWin: true, stars: stars, finalScore: finalScore);
    } else {
      LocalStorage.incrementTotalFails();
      _showResultModal(isWin: false, stars: 0, finalScore: _score);
    }
  }

  void _checkAndUnlockAchievements(double timePercentage) {
    // 鹰眼成就：完美通关（无错误）
    if (_mistakes == 0) {
      LocalStorage.unlockAchievement('eagle_eye');
    }

    // 光速成就：剩余时间>80%
    if (timePercentage > 80) {
      LocalStorage.unlockAchievement('speedster');
    }

    // 坚持不懈：累计失败10次后通关
    if (LocalStorage.getTotalFails() >= 10) {
      LocalStorage.unlockAchievement('persistence');
    }

    // 记忆大师：完成6×6难度（第6关）
    if (widget.levelId == 6) {
      LocalStorage.unlockAchievement('memory_master');
    }
  }

  void _showResultModal({
    required bool isWin,
    required int stars,
    required int finalScore,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.midnight.withOpacity(0.95),
      transitionDuration: AppDurations.normal,
      pageBuilder: (context, anim1, anim2) {
        return _ResultModal(
          isWin: isWin,
          stars: stars,
          score: finalScore,
          timeRemaining: _timeLeft,
          levelId: widget.levelId,
          onRetry: () {
            Navigator.of(context).pop();
            setState(() => _initializeGame());
          },
          onNext: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => GameScreen(levelId: widget.levelId + 1),
              ),
            );
          },
          onHome: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim1.value),
          child: Opacity(opacity: anim1.value, child: child),
        );
      },
    );
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      _showPauseModal();
    }
  }

  void _showPauseModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.midnight.withOpacity(0.95),
      builder: (context) => _PauseModal(
        onResume: () {
          Navigator.of(context).pop();
          setState(() => _isPaused = false);
        },
        onHome: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildGameArea()),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Get nature-themed color for current level
    final levelColor = _getLevelColor(widget.levelId);
    final animalIcon = _getLevelAnimalIcon(widget.levelId);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.midnight,
            AppColors.midnight.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Level badge with animal icon
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [levelColor, levelColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: levelColor.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    FaIcon(animalIcon, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LEVEL',
                          style: AppTextStyles.label.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 9,
                          ),
                        ),
                        Text(
                          widget.levelId.toString().padLeft(2, '0'),
                          style: AppTextStyles.h3.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Pause button with nature theme
              GestureDetector(
                onTap: _togglePause,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.slate,
                        AppColors.slate.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: levelColor.withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.pause_rounded, color: levelColor, size: 24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TimerBar(
            timeLeft: _timeLeft,
            totalTime: _currentLevel.time,
            color: levelColor,
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(int levelId) {
    final colors = [
      const Color(0xFF2ECC71), // Green
      const Color(0xFF3498DB), // Blue
      const Color(0xFFE67E22), // Orange
      const Color(0xFF9B59B6), // Purple
      const Color(0xFF1ABC9C), // Turquoise
      const Color(0xFFE74C3C), // Red
      const Color(0xFFF1C40F), // Yellow
      const Color(0xFF16A085), // Teal
      const Color(0xFF27AE60), // Dark Green
      const Color(0xFF2980B9), // Dark Blue
      const Color(0xFFD35400), // Dark Orange
      const Color(0xFF8E44AD), // Dark Purple
    ];
    return colors[(levelId - 1) % colors.length];
  }

  IconData _getLevelAnimalIcon(int levelId) {
    final icons = [
      FontAwesomeIcons.dog,
      FontAwesomeIcons.cat,
      FontAwesomeIcons.crow,
      FontAwesomeIcons.fish,
      FontAwesomeIcons.frog,
      FontAwesomeIcons.dragon,
      FontAwesomeIcons.dove,
      FontAwesomeIcons.horse,
      FontAwesomeIcons.hippo,
      FontAwesomeIcons.otter,
      FontAwesomeIcons.spider,
      FontAwesomeIcons.shrimp,
    ];
    return icons[(levelId - 1) % icons.length];
  }

  Widget _buildGameArea() {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _currentLevel.cols,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                return CardWidget(
                  key: ValueKey(
                    'card_${index}_${_cards[index].id}_${_cards[index].isFlipped}',
                  ),
                  card: _cards[index],
                  isLocked: _isLocked || _isObserving,
                  shouldShake: _shakingCardIndices.contains(index),
                  onTap: () => _onCardTap(index),
                );
              },
            ),
          ),
        ),
        if (_isObserving) _buildObservationOverlay(),
        if (_showCombo) Center(child: ComboIndicator(combo: _comboStreak)),
      ],
    );
  }

  Widget _buildObservationOverlay() {
    final levelColor = _getLevelColor(widget.levelId);
    final animalIcon = _getLevelAnimalIcon(widget.levelId);

    return Container(
      color: AppColors.midnight.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animal icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [levelColor, levelColor.withOpacity(0.7)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: levelColor.withOpacity(0.5),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: FaIcon(animalIcon, size: 36, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'MEMORIZE',
              style: AppTextStyles.h2.copyWith(color: levelColor, fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Remember the positions',
              style: AppTextStyles.body.copyWith(
                color: AppColors.mica.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            // Countdown circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: levelColor, width: 4),
                color: AppColors.slate.withOpacity(0.3),
                boxShadow: [
                  BoxShadow(
                    color: levelColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _observationTimeLeft.toString(),
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 64,
                    color: levelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Decorative leaves
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.leaf,
                  size: 16,
                  color: levelColor.withOpacity(0.5),
                ),
                const SizedBox(width: 16),
                FaIcon(
                  FontAwesomeIcons.seedling,
                  size: 20,
                  color: levelColor.withOpacity(0.7),
                ),
                const SizedBox(width: 16),
                FaIcon(
                  FontAwesomeIcons.leaf,
                  size: 16,
                  color: levelColor.withOpacity(0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final levelColor = _getLevelColor(widget.levelId);

    return Container(
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.midnight,
            AppColors.midnight.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
        border: Border(
          top: BorderSide(color: levelColor.withOpacity(0.2), width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStat(
            'PAIRS',
            '$_matchedPairs/${_currentLevel.pairs}',
            levelColor,
            FontAwesomeIcons.layerGroup,
          ),
          _buildStat(
            'MOVES',
            _moves.toString(),
            const Color(0xFF3498DB),
            FontAwesomeIcons.handPointer,
          ),
          _buildStat(
            'SCORE',
            _score.toString(),
            const Color(0xFFF1C40F),
            FontAwesomeIcons.star,
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    String label,
    String value,
    Color valueColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: valueColor.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, size: 10, color: valueColor.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  fontSize: 10,
                  color: valueColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.stat.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Result Modal Widget
class _ResultModal extends StatelessWidget {
  final bool isWin;
  final int stars;
  final int score;
  final int timeRemaining;
  final int levelId;
  final VoidCallback onRetry;
  final VoidCallback onNext;
  final VoidCallback onHome;

  const _ResultModal({
    required this.isWin,
    required this.stars,
    required this.score,
    required this.timeRemaining,
    required this.levelId,
    required this.onRetry,
    required this.onNext,
    required this.onHome,
  });

  Color _getLevelColor() {
    final colors = [
      const Color(0xFF2ECC71),
      const Color(0xFF3498DB),
      const Color(0xFFE67E22),
      const Color(0xFF9B59B6),
      const Color(0xFF1ABC9C),
      const Color(0xFFE74C3C),
      const Color(0xFFF1C40F),
      const Color(0xFF16A085),
      const Color(0xFF27AE60),
      const Color(0xFF2980B9),
      const Color(0xFFD35400),
      const Color(0xFF8E44AD),
    ];
    return colors[(levelId - 1) % colors.length];
  }

  IconData _getLevelAnimalIcon() {
    final icons = [
      FontAwesomeIcons.dog,
      FontAwesomeIcons.cat,
      FontAwesomeIcons.crow,
      FontAwesomeIcons.fish,
      FontAwesomeIcons.frog,
      FontAwesomeIcons.dragon,
      FontAwesomeIcons.dove,
      FontAwesomeIcons.horse,
      FontAwesomeIcons.hippo,
      FontAwesomeIcons.otter,
      FontAwesomeIcons.spider,
      FontAwesomeIcons.shrimp,
    ];
    return icons[(levelId - 1) % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor();
    final animalIcon = _getLevelAnimalIcon();

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.slate,
              AppColors.slate.withOpacity(0.95),
              AppColors.midnight,
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isWin
                ? levelColor.withOpacity(0.5)
                : AppColors.danger.withOpacity(0.3),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isWin ? levelColor : AppColors.danger).withOpacity(0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isWin ? levelColor : AppColors.danger).withOpacity(
                    0.05,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.02),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIcon(levelColor, animalIcon),
                  const SizedBox(height: 20),
                  Text(
                    isWin ? 'LEVEL COMPLETE!' : 'TIME\'S UP!',
                    style: AppTextStyles.h2.copyWith(
                      color: isWin ? levelColor : AppColors.danger,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isWin
                        ? 'Nature celebrates your victory'
                        : 'The forest awaits your return',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.mica.withOpacity(0.7),
                      fontSize: 13,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  if (isWin)
                    _buildStars(levelColor)
                  else
                    _buildFailureIcon(levelColor),
                  const SizedBox(height: 24),
                  _buildStats(levelColor),
                  const SizedBox(height: 28),
                  _buildButtons(levelColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color levelColor, IconData animalIcon) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isWin
              ? [levelColor, levelColor.withOpacity(0.7)]
              : [AppColors.danger, AppColors.danger.withOpacity(0.7)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isWin ? levelColor : AppColors.danger).withOpacity(0.6),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background animal icon (larger, faded)
          Opacity(
            opacity: 0.15,
            child: FaIcon(animalIcon, size: 60, color: Colors.white),
          ),
          // Main icon (check or x)
          FaIcon(
            isWin ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildStars(Color levelColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: levelColor.withOpacity(0.3), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final isActive = index < stars;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 150)),
              curve: Curves.elasticOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: isActive ? value : 0.8,
                  child: FaIcon(
                    isActive
                        ? FontAwesomeIcons.solidStar
                        : FontAwesomeIcons.star,
                    color: isActive
                        ? const Color(0xFFF1C40F)
                        : Colors.grey.shade800,
                    size: 28,
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFailureIcon(Color levelColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.danger.withOpacity(0.3), width: 2),
      ),
      child: FaIcon(
        FontAwesomeIcons.cloudRain,
        color: AppColors.danger.withOpacity(0.8),
        size: 36,
      ),
    );
  }

  Widget _buildStats(Color levelColor) {
    return Row(
      children: [
        Expanded(
          child: _buildStatBox(
            FontAwesomeIcons.clock,
            'TIME',
            '${timeRemaining}s',
            levelColor,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildStatBox(
            FontAwesomeIcons.star,
            'SCORE',
            score.toString(),
            const Color(0xFFF1C40F),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(
    IconData icon,
    String label,
    String value,
    Color valueColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.midnight.withOpacity(0.6),
            AppColors.midnight.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: valueColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          FaIcon(icon, size: 20, color: valueColor.withOpacity(0.8)),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 10,
              color: valueColor.withOpacity(0.7),
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.stat.copyWith(
              color: valueColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(Color levelColor) {
    return Column(
      children: [
        if (isWin && levelId < GameLevels.levels.length)
          _buildButton(
            'NEXT LEVEL',
            levelColor,
            FontAwesomeIcons.arrowRight,
            onNext,
            isPrimary: true,
          ),
        if (isWin && levelId < GameLevels.levels.length)
          const SizedBox(height: 12),
        _buildButton(
          'TRY AGAIN',
          AppColors.slate,
          FontAwesomeIcons.arrowsRotate,
          onRetry,
          isPrimary: false,
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: onHome,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.house,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Back to Home',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    String text,
    Color color,
    IconData icon,
    VoidCallback onPressed, {
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(colors: [color, color.withOpacity(0.8)])
              : null,
          color: isPrimary ? null : color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? color : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative leaves for primary button
            if (isPrimary) ...[
              Positioned(
                left: 16,
                child: FaIcon(
                  FontAwesomeIcons.leaf,
                  size: 14,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              Positioned(
                right: 16,
                child: FaIcon(
                  FontAwesomeIcons.leaf,
                  size: 14,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
            // Button content
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isPrimary ? Colors.white : AppColors.mica,
                    letterSpacing: 1.2,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 10),
                FaIcon(
                  icon,
                  size: 16,
                  color: isPrimary ? Colors.white : AppColors.mica,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Pause Modal Widget
class _PauseModal extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onHome;

  const _PauseModal({required this.onResume, required this.onHome});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('SYSTEM PAUSED', style: AppTextStyles.h2),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: onResume,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.electric,
                borderRadius: BorderRadius.circular(32),
                boxShadow: AppShadows.glowElectric,
              ),
              child: const Center(
                child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: onHome,
            child: Text(
              'Abort Mission',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
