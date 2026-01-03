import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_fonts.dart';
import '../core/app_theme.dart';

import '../widgets/ui/card_widget.dart';
import '../models/card_model.dart';
import '../models/game_state.dart';
import '../models/level_config.dart';
import '../services/game_logic.dart';

class GameBoardScreen extends StatefulWidget {
  final String? levelId;
  
  const GameBoardScreen({super.key, this.levelId});

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  late GameState _gameState;
  Timer? _timer;
  late String _currentLevelId;
  late LevelGameConfig _levelConfig;
  
  // 拖拽状态
  int? _draggedFromColumn;
  int? _draggedFromBuffer;
  bool _draggedFromWaste = false;
  
  // 历史记录（用于撤销）
  final List<GameState> _history = [];
  final int _maxHistorySize = 50;
  
  // 提示状态
  Map<String, dynamic>? _currentHint;
  bool _showingHint = false;

  @override
  void initState() {
    super.initState();
    _currentLevelId = widget.levelId ?? 'level_01';
    _levelConfig = LevelConfigs.getConfig(_currentLevelId) ?? LevelConfigs.configs[0];
    _initializeGame();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    final deck = GameLogic.shuffleDeck(GameLogic.generateDeck());
    final gameData = GameLogic.initializeGame(deck);
    
    _gameState = GameState(
      currentLevelId: _currentLevelId,
      startTime: DateTime.now(),
      elapsedTime: Duration.zero,
      movesCount: 0,
      bufferCards: [],
      foundationSlots: List.generate(4, (_) => []),
      tableauColumns: gameData['tableau'] as List<List<CardModel>>,
      deck: gameData['stock'] as List<CardModel>,
      waste: [],
      status: GameStatus.playing,
    );
    
    _history.clear();
    _saveHistory();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameState.status == GameStatus.playing) {
        final newElapsedTime = DateTime.now().difference(_gameState.startTime);
        
        setState(() {
          _gameState = _gameState.copyWith(
            elapsedTime: newElapsedTime,
          );
        });
        
        // 检查时间限制
        if (_levelConfig.timeLimit != null) {
          final remainingTime = _levelConfig.timeLimit! - newElapsedTime;
          if (remainingTime.isNegative) {
            _gameOver();
          }
        }
      }
    });
  }

  void _gameOver() {
    setState(() {
      _gameState = _gameState.copyWith(status: GameStatus.lost);
    });
    _timer?.cancel();
    _showGameOverDialog();
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepSurface,
        title: Text(
          '⏰ Time\'s Up!',
          style: AppFonts.orbitron(color: AppTheme.deepRed, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Failed to complete within time limit',
              style: AppFonts.inter(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Time: ${_formatDuration(_gameState.elapsedTime)}',
              style: AppFonts.inter(color: Colors.white),
            ),
            Text(
              'Moves: ${_gameState.movesCount}',
              style: AppFonts.inter(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Back', style: AppFonts.inter(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: Text('Retry', style: AppFonts.inter(color: AppTheme.deepBlue)),
          ),
        ],
      ),
    );
  }

  void _saveHistory() {
    _history.add(_gameState);
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
    }
  }

  void _undo() {
    if (_history.length > 1) {
      setState(() {
        _history.removeLast();
        _gameState = _history.last;
      });
    }
  }

  void _resetGame() {
    _timer?.cancel();
    setState(() {
      _initializeGame();
      _startTimer();
    });
  }

  void _pauseGame() {
    setState(() {
      _gameState = _gameState.copyWith(
        status: _gameState.status == GameStatus.paused 
            ? GameStatus.playing 
            : GameStatus.paused,
      );
    });
  }

  void _showHint() {
    final levelData = LevelData.getLevel(_currentLevelId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepSurface,
        title: Row(
          children: [
            Icon(Icons.info_outline, color: AppTheme.deepBlue, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Level Info',
                style: AppFonts.orbitron(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 关卡信息
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.deepBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.deepBlue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      levelData?.name ?? 'Unknown Level',
                      style: AppFonts.orbitron(
                        color: AppTheme.deepBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _levelConfig.hint,
                      style: AppFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.storage, size: 14, color: AppTheme.deepAccent),
                        const SizedBox(width: 6),
                        Text(
                          'Buffer Slots: ${_levelConfig.bufferSlots}',
                          style: AppFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                        if (_levelConfig.timeLimit != null) ...[
                          const SizedBox(width: 16),
                          Icon(Icons.timer, size: 14, color: AppTheme.deepRed),
                          const SizedBox(width: 6),
                          Text(
                            'Time Limit: ${_levelConfig.timeLimit!.inMinutes}min',
                            style: AppFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 游戏规则
              Text(
                'GAME RULES',
                style: AppFonts.orbitron(
                  color: AppTheme.deepAccent,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              _buildRuleItem('🎯', 'Goal', 'Move all 52 cards to the 4 foundation slots, sorted by suit from A to K'),
              _buildRuleItem('📚', 'Tableau', 'Cards must alternate colors (red/black) and descend in rank (K→Q→J...→A)'),
              _buildRuleItem('🏠', 'Foundation', 'Each foundation holds one suit, starting with A and ascending to K'),
              _buildRuleItem('💾', 'Buffer', 'Temporarily store cards. Limited slots based on level difficulty'),
              _buildRuleItem('🃏', 'Stock', 'Click to draw cards. Deck resets when empty'),
              _buildRuleItem('👆', 'Controls', 'Long-press to drag cards. Double-tap to auto-move to foundation'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it!',
              style: AppFonts.inter(
                color: AppTheme.deepBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppFonts.inter(
                    color: Colors.white60,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _drawCard() {
    if (_gameState.status != GameStatus.playing) return;
    
    final result = GameLogic.drawFromDeck(
      _gameState.deck,
      _gameState.waste,
    );
    
    setState(() {
      _gameState = _gameState.copyWith(
        deck: result['deck'],
        waste: result['waste'],
        movesCount: _gameState.movesCount + 1,
      );
    });
    
    _saveHistory();
  }

  void _checkWin() {
    if (GameLogic.checkWin(_gameState.foundationSlots)) {
      setState(() {
        _gameState = _gameState.copyWith(status: GameStatus.won);
      });
      _timer?.cancel();
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    final stars = GameLogic.calculateStars(
      _gameState.elapsedTime,
      _gameState.movesCount,
    );
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepSurface,
        title: Text(
          '🎉 Victory!',
          style: AppFonts.orbitron(color: AppTheme.deepAccent, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => Icon(
                Icons.star,
                color: index < stars ? AppTheme.deepAccent : Colors.grey,
                size: 32,
              )),
            ),
            const SizedBox(height: 16),
            Text(
              'Time: ${_formatDuration(_gameState.elapsedTime)}',
              style: AppFonts.inter(color: Colors.white),
            ),
            Text(
              'Moves: ${_gameState.movesCount}',
              style: AppFonts.inter(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Back to Map', style: AppFonts.inter(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: Text('Play Again', style: AppFonts.inter(color: AppTheme.deepBlue)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // 移动卡牌到桌面列
  void _moveToTableau(CardModel card, int targetColumn, {int? fromColumn, int? fromBuffer, bool fromWaste = false}) {
    if (_gameState.status != GameStatus.playing) return;
    
    final newTableau = List<List<CardModel>>.from(
      _gameState.tableauColumns.map((col) => List<CardModel>.from(col)),
    );
    final newBuffer = List<CardModel>.from(_gameState.bufferCards);
    final newWaste = List<CardModel>.from(_gameState.waste);
    
    // 从源位置移除
    if (fromColumn != null) {
      final sourceColumn = newTableau[fromColumn];
      final cardIndex = sourceColumn.indexWhere((c) => c.id == card.id);
      if (cardIndex >= 0) {
        final sequence = sourceColumn.sublist(cardIndex);
        sourceColumn.removeRange(cardIndex, sourceColumn.length);
        
        // 翻开下一张牌
        if (sourceColumn.isNotEmpty && !sourceColumn.last.isFaceUp) {
          sourceColumn[sourceColumn.length - 1] = 
              sourceColumn.last.copyWith(isFaceUp: true);
        }
        
        // 添加到目标列
        newTableau[targetColumn].addAll(sequence);
      }
    } else if (fromBuffer != null) {
      newBuffer.removeAt(fromBuffer);
      newTableau[targetColumn].add(card);
    } else if (fromWaste) {
      newWaste.removeLast();
      newTableau[targetColumn].add(card);
    }
    
    _saveHistory();
    setState(() {
      _gameState = _gameState.copyWith(
        tableauColumns: newTableau,
        bufferCards: newBuffer,
        waste: newWaste,
        movesCount: _gameState.movesCount + 1,
      );
    });
  }

  // 移动卡牌到核心区
  void _moveToFoundation(CardModel card, int foundationIndex, {int? fromColumn, int? fromBuffer, bool fromWaste = false}) {
    if (_gameState.status != GameStatus.playing) return;
    
    final newTableau = List<List<CardModel>>.from(
      _gameState.tableauColumns.map((col) => List<CardModel>.from(col)),
    );
    final newBuffer = List<CardModel>.from(_gameState.bufferCards);
    final newWaste = List<CardModel>.from(_gameState.waste);
    final newFoundations = List<List<CardModel>>.from(
      _gameState.foundationSlots.map((f) => List<CardModel>.from(f)),
    );
    
    // 从源位置移除
    if (fromColumn != null) {
      final sourceColumn = newTableau[fromColumn];
      sourceColumn.removeLast();
      
      // 翻开下一张牌
      if (sourceColumn.isNotEmpty && !sourceColumn.last.isFaceUp) {
        sourceColumn[sourceColumn.length - 1] = 
            sourceColumn.last.copyWith(isFaceUp: true);
      }
    } else if (fromBuffer != null) {
      newBuffer.removeAt(fromBuffer);
    } else if (fromWaste) {
      newWaste.removeLast();
    }
    
    // 添加到核心区
    newFoundations[foundationIndex].add(card.copyWith(status: CardStatus.foundation));
    
    _saveHistory();
    setState(() {
      _gameState = _gameState.copyWith(
        tableauColumns: newTableau,
        bufferCards: newBuffer,
        waste: newWaste,
        foundationSlots: newFoundations,
        movesCount: _gameState.movesCount + 1,
      );
    });
    
    _checkWin();
  }

  // 移动卡牌到缓冲区
  void _moveToBuffer(CardModel card, int fromColumn) {
    if (_gameState.status != GameStatus.playing) return;
    if (!GameLogic.canMoveToBuffer(_gameState.bufferCards, _levelConfig.bufferSlots)) return;
    
    final newTableau = List<List<CardModel>>.from(
      _gameState.tableauColumns.map((col) => List<CardModel>.from(col)),
    );
    final newBuffer = List<CardModel>.from(_gameState.bufferCards);
    
    final sourceColumn = newTableau[fromColumn];
    final removedCard = sourceColumn.removeLast();
    
    // 翻开下一张牌
    if (sourceColumn.isNotEmpty && !sourceColumn.last.isFaceUp) {
      sourceColumn[sourceColumn.length - 1] = 
          sourceColumn.last.copyWith(isFaceUp: true);
    }
    
    newBuffer.add(removedCard.copyWith(status: CardStatus.buffer));
    
    _saveHistory();
    setState(() {
      _gameState = _gameState.copyWith(
        tableauColumns: newTableau,
        bufferCards: newBuffer,
        movesCount: _gameState.movesCount + 1,
      );
    });
  }

  // 双击自动移动到核心区
  void _autoMoveToFoundation(CardModel card, {int? fromColumn, int? fromBuffer, bool fromWaste = false}) {
    for (int i = 0; i < _gameState.foundationSlots.length; i++) {
      if (GameLogic.canMoveToFoundation(card, _gameState.foundationSlots[i])) {
        _moveToFoundation(card, i, fromColumn: fromColumn, fromBuffer: fromBuffer, fromWaste: fromWaste);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/18481766503220_.pic_hd.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildModernHUD(),
                  const SizedBox(height: 16),
                  _buildUpperZone(),
                  const SizedBox(height: 12),
                  Expanded(child: _buildTableau()),
                  _buildModernDock(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
    
  }

  Widget _buildModernHUD() {
    Duration? remainingTime;
    Color timeColor = AppTheme.deepBlue;
    
    if (_levelConfig.timeLimit != null) {
      remainingTime = _levelConfig.timeLimit! - _gameState.elapsedTime;
      if (remainingTime.isNegative) {
        remainingTime = Duration.zero;
        timeColor = AppTheme.deepRed;
      } else if (remainingTime.inSeconds < 60) {
        timeColor = AppTheme.deepRed;
      } else if (remainingTime.inSeconds < 120) {
        timeColor = AppTheme.deepAccent;
      }
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 暂停按钮
            _buildModernIconButton(
              _gameState.status == GameStatus.paused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
              _pauseGame,
              AppTheme.deepBlue,
            ),
            const SizedBox(width: 12),
            // 时间和步数
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 时间
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          timeColor.withOpacity(0.2),
                          timeColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: timeColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _levelConfig.timeLimit != null
                              ? Icons.timer_rounded
                              : Icons.access_time_rounded,
                          size: 16,
                          color: timeColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _levelConfig.timeLimit != null
                              ? _formatDuration(remainingTime!)
                              : _formatDuration(_gameState.elapsedTime),
                          style: AppFonts.orbitron(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: timeColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 步数
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.deepAccent.withOpacity(0.2),
                          AppTheme.deepAccent.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.deepAccent.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          size: 16,
                          color: AppTheme.deepAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_gameState.movesCount}',
                          style: AppFonts.orbitron(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.deepAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 重置按钮
            _buildModernIconButton(
              Icons.refresh_rounded,
              _resetGame,
              AppTheme.deepRed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernIconButton(
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.3),
              color.withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _buildUpperZone() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 牌堆和翻牌堆区域
          Row(
            children: [
              _buildDeckArea(),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          // 缓冲区和核心区
          Row(
            children: [
              Expanded(child: _buildBufferZone()),
              const SizedBox(width: 16),
              Expanded(child: _buildFoundationZone()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeckArea() {
    return Row(
      children: [
        // 牌堆（未翻开的牌）
        GestureDetector(
          onTap: _drawCard,
          child: Container(
            width: 54,
            height: 76,
            decoration: BoxDecoration(
              gradient: _gameState.deck.isEmpty
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.deepBlue.withOpacity(0.3),
                        AppTheme.deepBlue.withOpacity(0.15),
                      ],
                    ),
              color: _gameState.deck.isEmpty
                  ? Colors.transparent
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _gameState.deck.isEmpty
                    ? Colors.white.withOpacity(0.15)
                    : AppTheme.deepBlue.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: _gameState.deck.isNotEmpty
                  ? [
                      BoxShadow(
                        color: AppTheme.deepBlue.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: _gameState.deck.isEmpty
                ? Icon(
                    Icons.refresh_rounded,
                    color: Colors.white.withOpacity(0.3),
                    size: 28,
                  )
                : Stack(
                    children: [
                      // 背景装饰
                      Positioned(
                        top: -10,
                        right: -10,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.deepBlue.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 数字
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.layers_rounded,
                              color: AppTheme.deepBlue,
                              size: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_gameState.deck.length}',
                              style: AppFonts.orbitron(
                                fontSize: 18,
                                color: AppTheme.deepBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: 12),
        // 翻牌堆（已翻开的牌）
        GestureDetector(
          onTap: _drawCard,
          child: Container(
            width: 54,
            height: 76,
            decoration: BoxDecoration(
              gradient: _gameState.waste.isEmpty
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ],
                    ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _gameState.waste.isEmpty
                    ? Colors.white.withOpacity(0.15)
                    : Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: _gameState.waste.isEmpty
                ? Center(
                    child: Icon(
                      Icons.crop_square_rounded,
                      color: Colors.white.withOpacity(0.1),
                      size: 32,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildDraggableCard(
                      _gameState.waste.last,
                      fromWaste: true,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBufferZone() {
    final maxBufferSlots = _levelConfig.bufferSlots;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.deepBlue.withOpacity(0.3),
                      AppTheme.deepBlue.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.deepBlue.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.storage_rounded,
                      size: 12,
                      color: AppTheme.deepBlue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'BUFFER',
                      style: AppFonts.orbitron(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.deepBlue,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.deepBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$maxBufferSlots/4',
                  style: AppFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.5 / 3.5,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(4, (index) {
              final isSlotAvailable = index < maxBufferSlots;
              
              if (index < _gameState.bufferCards.length) {
                final card = _gameState.bufferCards[index];
                return _buildDraggableCard(
                  card,
                  fromBuffer: index,
                  isHighlighted: _showingHint && 
                      _currentHint?['type'] == 'buffer_to_foundation' &&
                      _currentHint?['from'] == index,
                );
              } else if (!isSlotAvailable) {
                return _buildLockedSlot();
              } else {
                return _buildEmptySlot(
                  onAccept: (card) {
                    if (_draggedFromColumn != null) {
                      _moveToBuffer(card, _draggedFromColumn!);
                    }
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFoundationZone() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.deepAccent.withOpacity(0.08),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.deepAccent.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepAccent.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.deepAccent.withOpacity(0.3),
                  AppTheme.deepAccent.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.deepAccent.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.stars_rounded,
                  size: 12,
                  color: AppTheme.deepAccent,
                ),
                const SizedBox(width: 4),
                Text(
                  'FOUNDATION',
                  style: AppFonts.orbitron(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepAccent,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.5 / 3.5,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(4, (index) {
              final foundation = _gameState.foundationSlots[index];
              final suit = CardSuit.values[index];
              return _buildFoundationSlot(
                suit,
                foundation,
                index,
                isHighlighted: _showingHint && 
                    (_currentHint?['type'] == 'tableau_to_foundation' ||
                     _currentHint?['type'] == 'buffer_to_foundation') &&
                    _currentHint?['to'] == index,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFoundationSlot(
    CardSuit suit,
    List<CardModel> foundation,
    int foundationIndex,
    {bool isHighlighted = false}
  ) {
    final icon = _getSuitIcon(suit);
    final color = (suit == CardSuit.heart || suit == CardSuit.diamond) 
        ? AppTheme.deepRed 
        : AppTheme.deepBlack;
    
    return DragTarget<CardModel>(
      onWillAccept: (card) {
        if (card == null) return false;
        return GameLogic.canMoveToFoundation(card, foundation);
      },
      onAccept: (card) {
        _moveToFoundation(
          card,
          foundationIndex,
          fromColumn: _draggedFromColumn,
          fromBuffer: _draggedFromBuffer,
          fromWaste: _draggedFromWaste,
        );
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: foundation.isEmpty 
                ? Colors.black.withOpacity(0.3)
                : Colors.transparent,
            border: Border.all(
              color: isHighlighted 
                  ? AppTheme.deepAccent
                  : (foundation.isNotEmpty 
                      ? color.withOpacity(0.5) 
                      : Colors.grey.withOpacity(0.7)),
              width: isHighlighted ? 2 : 1,
            ),
          ),
          child: foundation.isNotEmpty
              ? CardWidget(card: foundation.last)
              : Center(
                  child: Icon(
                    icon,
                    size: 12,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ),
        );
      },
    );
  }

  IconData _getSuitIcon(CardSuit suit) {
    switch (suit) {
      case CardSuit.spade:
        return Icons.filter_vintage;
      case CardSuit.heart:
        return Icons.favorite;
      case CardSuit.diamond:
        return Icons.change_history;
      case CardSuit.club:
        return Icons.spa;
    }
  }

  Widget _buildTableau() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 获取可用的纵向空间
        final availableHeight = constraints.maxHeight;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              7,
              (colIndex) => Expanded(
                child: _buildTableauColumn(colIndex, availableHeight),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableauColumn(int columnIndex, double availableHeight) {
    final column = _gameState.tableauColumns[columnIndex];
    
    return DragTarget<CardModel>(
      onWillAccept: (card) {
        if (card == null) return false;
        return GameLogic.canMoveToTableau(card, column);
      },
      onAccept: (card) {
        _moveToTableau(
          card,
          columnIndex,
          fromColumn: _draggedFromColumn,
          fromBuffer: _draggedFromBuffer,
          fromWaste: _draggedFromWaste,
        );
      },
      builder: (context, candidateData, rejectedData) {
        if (column.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: _buildEmptyColumnSlot(),
          );
        }

        // 计算智能偏移量
        final cardHeight = 64.0;
        final minOffset = 16.0;  // 最小偏移（紧凑模式）- 从8增加到16
        final maxOffset = 48.0;  // 最大偏移（宽松模式）- 从24增加到48
        
        // 计算如果使用最大偏移时的总高度
        final maxTotalHeight = cardHeight + (column.length - 1) * maxOffset;
        
        // 根据可用空间动态调整偏移量
        double cardOffset;
        if (maxTotalHeight <= availableHeight) {
          // 空间充足，使用最大偏移
          cardOffset = maxOffset;
        } else {
          // 空间不足，动态计算偏移量
          final availableForOffset = availableHeight - cardHeight;
          cardOffset = (availableForOffset / (column.length - 1)).clamp(minOffset, maxOffset);
        }
        
        // 计算实际总高度
        double totalHeight = cardHeight;
        for (int i = 1; i < column.length; i++) {
          // 背面卡片使用较小偏移，正面卡片使用计算出的偏移
          totalHeight += column[i].isFaceUp ? cardOffset : (cardOffset * 0.5);
        }

        // 使用Stack实现卡牌重叠效果
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: SizedBox(
            height: totalHeight.clamp(0, availableHeight),
            child: Stack(
              children: List.generate(column.length, (cardIndex) {
                final card = column[cardIndex];
                final isHighlighted = _showingHint &&
                    _currentHint?['type'] == 'tableau_to_tableau' &&
                    _currentHint?['from'] == columnIndex &&
                    _currentHint?['cardIndex'] == cardIndex;
                
                // 计算当前卡牌的偏移量
                double offset = 0;
                for (int i = 0; i < cardIndex; i++) {
                  // 背面卡片偏移量是正面的一半
                  offset += column[i].isFaceUp ? cardOffset : (cardOffset * 0.5);
                }
                
                return Positioned(
                  top: offset,
                  left: 0,
                  right: 0,
                  child: _buildDraggableCard(
                    card,
                    fromColumn: columnIndex,
                    cardIndex: cardIndex,
                    isHighlighted: isHighlighted,
                    cardOffset: cardOffset,
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraggableCard(
    CardModel card, {
    int? fromColumn,
    int? fromBuffer,
    bool fromWaste = false,
    int? cardIndex,
    bool isHighlighted = false,
    double cardOffset = 16.0,
  }) {
    if (!card.isFaceUp) {
      return CardWidget(card: card);
    }

    // 检查是否可以拖动整个序列
    final canDragSequence = fromColumn != null && 
                           cardIndex != null && 
                           cardIndex < _gameState.tableauColumns[fromColumn].length - 1;

    return LongPressDraggable<CardModel>(
      data: card,
      onDragStarted: () {
        setState(() {
          _draggedFromColumn = fromColumn;
          _draggedFromBuffer = fromBuffer;
          _draggedFromWaste = fromWaste;
        });
      },
      onDragEnd: (_) {
        setState(() {
          _draggedFromColumn = null;
          _draggedFromBuffer = null;
          _draggedFromWaste = false;
        });
      },
      feedback: Material(
        color: Colors.transparent,
        child: canDragSequence
            ? _buildCardSequenceFeedback(fromColumn, cardIndex, cardOffset)
            : Transform.scale(
                scale: 1.2,
                child: CardWidget(card: card, isLifted: true),
              ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: CardWidget(card: card),
      ),
      child: GestureDetector(
        onDoubleTap: () {
          _autoMoveToFoundation(
            card,
            fromColumn: fromColumn,
            fromBuffer: fromBuffer,
            fromWaste: fromWaste,
          );
        },
        child: Container(
          decoration: isHighlighted
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.deepAccent,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                )
              : null,
          child: CardWidget(card: card),
        ),
      ),
    );
  }

  // 构建拖拽时的卡牌序列反馈
  Widget _buildCardSequenceFeedback(int columnIndex, int startCardIndex, double cardOffset) {
    final column = _gameState.tableauColumns[columnIndex];
    final sequence = column.sublist(startCardIndex);
    
    // 计算序列的总高度
    double totalHeight = 64.0;
    for (int i = 1; i < sequence.length; i++) {
      totalHeight += sequence[i].isFaceUp ? cardOffset : (cardOffset * 0.5);
    }
    
    return SizedBox(
      width: 46,
      height: totalHeight,
      child: Stack(
        children: List.generate(sequence.length, (index) {
          double offset = 0;
          for (int i = 0; i < index; i++) {
            offset += sequence[i].isFaceUp ? cardOffset : (cardOffset * 0.5);
          }
          
          return Positioned(
            top: offset,
            child: Transform.scale(
              scale: 1.2,
              child: CardWidget(card: sequence[index], isLifted: true),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptySlot({Function(CardModel)? onAccept}) {
    return DragTarget<CardModel>(
      onWillAccept: (card) => card != null && _gameState.bufferCards.length < 3,
      onAccept: onAccept ?? (_) {},
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isHovering
                  ? [
                      AppTheme.deepBlue.withOpacity(0.3),
                      AppTheme.deepBlue.withOpacity(0.15),
                    ]
                  : [
                      Colors.white.withOpacity(0.03),
                      Colors.white.withOpacity(0.01),
                    ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isHovering
                  ? AppTheme.deepBlue.withOpacity(0.6)
                  : Colors.white.withOpacity(0.15),
              width: 2,
              style: BorderStyle.solid,
            ),
            boxShadow: isHovering
                ? [
                    BoxShadow(
                      color: AppTheme.deepBlue.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.crop_square_rounded,
                  size: 24,
                  color: isHovering
                      ? AppTheme.deepBlue
                      : Colors.white.withOpacity(0.2),
                ),
                const SizedBox(height: 2),
                Text(
                  'Empty',
                  style: AppFonts.inter(
                    fontSize: 8,
                    color: isHovering
                        ? AppTheme.deepBlue
                        : Colors.white.withOpacity(0.25),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLockedSlot() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.5),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_rounded,
              size: 18,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 2),
            Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyColumnSlot() {
    return Container(
      width: 46,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.03),
            Colors.white.withOpacity(0.01),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.crop_square_rounded,
          size: 24,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildModernDock() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildModernDockButton(
            Icons.info_outline_rounded,
            'Info',
            _showHint,
            AppTheme.deepBlue,
          ),
          _buildModernDockButton(
            Icons.undo_rounded,
            'Undo',
            _undo,
            AppTheme.deepAccent,
          ),
          // 主按钮 - Home
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.deepAccent,
                    AppTheme.deepAccent.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.deepAccent.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDockButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
    Color color,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
