import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/game_state.dart';
import '../models/tile_model.dart';
import '../models/player_data.dart';
import '../services/game_logic.dart';
import '../services/gemini_api.dart';
import '../core/constants.dart';

class GameViewModel extends ChangeNotifier {
  GameState _state = GameState();
  GameScreen _currentScreen = GameScreen.home;
  LevelConfig _currentLevel = GameLevels.levels[2]; // Default to level 3
  PlayerData _playerData = PlayerData();
  DateTime? _gameStartTime;
  int _initialShuffleCount = 3;
  int _initialSwapCount = 3;

  GameState get state => _state;
  GameScreen get currentScreen => _currentScreen;
  LevelConfig get currentLevel => _currentLevel;
  PlayerData get playerData => _playerData;

  int get score => _state.score;
  MahjongTile? get handTile => _state.handTile;
  List<MahjongTile> get gridTiles => _state.gridTiles;
  int get suitStreak => _state.suitStreak;
  bool get isProcessing => _state.isProcessing;
  GameStatus get status => _state.status;
  int get remainingSeconds => _state.remainingSeconds;
  int get shuffleCount => _state.shuffleCount;
  int get swapHandCount => _state.swapHandCount;
  bool get isPaused => _state.isPaused;
  String? get statusMessage => _state.statusMessage;
  String? get sageMessage => _state.sageMessage;
  bool get isSageLoading => _state.isSageLoading;

  void navigateToHome() {
    _currentScreen = GameScreen.home;
    notifyListeners();
  }

  void returnToHome() {
    _currentScreen = GameScreen.home;
    notifyListeners();
  }

  void showLevelSelect() {
    _currentScreen = GameScreen.levelSelect;
    notifyListeners();
  }

  void showAchievements() {
    _currentScreen = GameScreen.achievements;
    notifyListeners();
  }

  void showStats() {
    _currentScreen = GameScreen.stats;
    notifyListeners();
  }

  void showSettings() {
    _currentScreen = GameScreen.settings;
    notifyListeners();
  }

  void navigateToGame() {
    _currentScreen = GameScreen.game;
    notifyListeners();
  }

  Future<void> initializeGame({int? levelIndex}) async {
    if (levelIndex != null && levelIndex < GameLevels.levels.length) {
      _currentLevel = GameLevels.levels[levelIndex];
    }
    
    navigateToGame();
    
    // Record game start
    _playerData.recordGameStart();
    _gameStartTime = DateTime.now();
    _initialShuffleCount = 3;
    _initialSwapCount = 3;
    
    _state = GameState(
      score: 0,
      suitStreak: 0,
      status: GameStatus.memorizing,
      isProcessing: true,
      remainingSeconds: _currentLevel.timeLimit.inSeconds,
    );

    // Generate hand tile
    _state = _state.copyWith(handTile: GameLogic.generateRandomTile());

    // Generate grid - all tiles start face-up for memorization
    final tiles = GameLogic.generateGrid(
      gridSize: _currentLevel.gridSize,
      columns: _currentLevel.gridColumns,
    );
    final revealedTiles = tiles.map((tile) => tile.copyWith(isRevealed: true)).toList();
    _state = _state.copyWith(gridTiles: revealedTiles);
    
    _state = _state.copyWith(statusMessage: AppStrings.memorize);
    notifyListeners();

    // Memorize phase (varies by level)
    await Future.delayed(_currentLevel.memorizeDuration);

    // Hide all grid tiles (flip to back) - create new list to trigger rebuild
    final hiddenTiles = _state.gridTiles.map((tile) {
      return tile.copyWith(isRevealed: false);
    }).toList();
    
    _state = _state.copyWith(
      gridTiles: hiddenTiles,
      status: GameStatus.playing,
      isProcessing: false,
      statusMessage: AppStrings.gameStart,
    );
    notifyListeners();

    // Start countdown timer
    _startCountdown();

    // Clear status message
    await Future.delayed(const Duration(milliseconds: 1500));
    _state = _state.copyWith(clearStatusMessage: true);
    notifyListeners();

    _checkDeadlock();
    _resetIdleTimer();
  }

  void _startCountdown() {
    _state.countdownTimer?.cancel();
    
    if (_state.isPaused) return; // Don't start if paused
    
    _state = _state.copyWith(
      countdownTimer: Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_state.isPaused) {
          timer.cancel();
          return;
        }
        
        if (_state.remainingSeconds > 0) {
          _state = _state.copyWith(remainingSeconds: _state.remainingSeconds - 1);
          notifyListeners();
          
          // Warning when 30 seconds left
          if (_state.remainingSeconds == 30) {
            _state = _state.copyWith(statusMessage: 'Time running out!');
            notifyListeners();
            Future.delayed(const Duration(seconds: 2), () {
              if (!_state.isPaused) {
                _state = _state.copyWith(clearStatusMessage: true);
                notifyListeners();
              }
            });
          }
        } else {
          // Time's up!
          timer.cancel();
          _gameOver();
        }
      }),
    );
  }

  void _gameOver() {
    _state.countdownTimer?.cancel();
    _state.idleTimer?.cancel();
    _state = _state.copyWith(
      status: GameStatus.defeat,
      isProcessing: true,
    );
    notifyListeners();
  }

  void playNextLevel() {
    final currentIndex = GameLevels.levels.indexOf(_currentLevel);
    if (currentIndex < GameLevels.levels.length - 1) {
      initializeGame(levelIndex: currentIndex + 1);
    } else {
      // Last level completed, go back to level select
      showLevelSelect();
    }
  }

  void handleTileTap(int tileId) {
    if (_state.isProcessing || _state.status != GameStatus.playing || _state.isPaused) return;

    final tileIndex = _state.gridTiles.indexWhere((t) => t.id == tileId);
    if (tileIndex == -1) return;
    
    final tile = _state.gridTiles[tileIndex];
    if (!tile.isActive || tile.isRevealed) return;

    _resetIdleTimer();

    // Reveal tile - create new tile object
    final updatedTiles = List<MahjongTile>.from(_state.gridTiles);
    updatedTiles[tileIndex] = tile.copyWith(isRevealed: true, isHinted: false);
    
    _state = _state.copyWith(
      isProcessing: true,
      gridTiles: updatedTiles,
    );
    notifyListeners();

    // Wait for flip animation
    Future.delayed(const Duration(milliseconds: 600), () {
      _checkMatch(updatedTiles[tileIndex]);
    });
  }

  void _checkMatch(MahjongTile tile) {
    if (GameLogic.isMatch(_state.handTile!.number, tile.number)) {
      // Success
      if (tile.type == _state.handTile!.type) {
        _state = _state.copyWith(suitStreak: _state.suitStreak + 1);
      } else {
        _state = _state.copyWith(suitStreak: 0);
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        _state = _state.copyWith(handTile: tile.copyWith());
        tile.isActive = false;

        final bonus = GameLogic.calculateScore(
          GameConstants.baseScore,
          _state.suitStreak,
        );
        _state = _state.copyWith(score: _state.score + bonus);
        notifyListeners();

        // Check win
        if (_state.gridTiles.every((t) => !t.isActive)) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _state.countdownTimer?.cancel();
            _state.idleTimer?.cancel();
            _state = _state.copyWith(status: GameStatus.victory);
            
            // Record victory
            if (_gameStartTime != null) {
              final gameDuration = DateTime.now().difference(_gameStartTime!);
              final usedPowerUps = (_initialShuffleCount - _state.shuffleCount) > 0 ||
                  (_initialSwapCount - _state.swapHandCount) > 0;
              
              _playerData.recordVictory(
                score: _state.score,
                streak: _state.suitStreak,
                time: gameDuration,
                levelNumber: _currentLevel.levelNumber,
                usedPowerUps: usedPowerUps,
              );
            }
            
            notifyListeners();
          });
        } else {
          _checkDeadlock();
          _state = _state.copyWith(isProcessing: false);
          _resetIdleTimer();
          notifyListeners();
        }
      });
    } else {
      // Fail - flip back to hidden
      _state = _state.copyWith(suitStreak: 0);
      notifyListeners();
      
      Future.delayed(const Duration(milliseconds: 1000), () {
        // Create new tile list with tile flipped back
        final tileIndex = _state.gridTiles.indexWhere((t) => t.id == tile.id);
        if (tileIndex != -1) {
          final updatedTiles = List<MahjongTile>.from(_state.gridTiles);
          updatedTiles[tileIndex] = updatedTiles[tileIndex].copyWith(isRevealed: false);
          
          _state = _state.copyWith(
            gridTiles: updatedTiles,
            isProcessing: false,
          );
        } else {
          _state = _state.copyWith(isProcessing: false);
        }
        _resetIdleTimer();
        notifyListeners();
      });
    }
  }

  void _checkDeadlock() {
    if (_state.handTile == null) return;

    final hasValidMoves = GameLogic.hasValidMoves(_state.handTile!, _state.gridTiles);

    if (!hasValidMoves && _state.gridTiles.any((t) => t.isActive)) {
      _state = _state.copyWith(statusMessage: AppStrings.noMoves);
      notifyListeners();

      Future.delayed(const Duration(milliseconds: 1500), () {
        final newTiles = GameLogic.reshuffleGrid(_state.gridTiles, _state.handTile!);
        _state = _state.copyWith(
          gridTiles: newTiles,
          statusMessage: AppStrings.reshuffled,
        );
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 1500), () {
          _state = _state.copyWith(clearStatusMessage: true);
          notifyListeners();
        });
      });
    }
  }

  void manualShuffle() {
    if (_state.isProcessing || _state.status != GameStatus.playing) return;
    if (_state.handTile == null || _state.shuffleCount <= 0) return;

    _state = _state.copyWith(
      shuffleCount: _state.shuffleCount - 1,
      statusMessage: 'Shuffled! (${_state.shuffleCount - 1} left)',
    );
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final newTiles = GameLogic.reshuffleGrid(_state.gridTiles, _state.handTile!);
      _state = _state.copyWith(gridTiles: newTiles);
      notifyListeners();

      Future.delayed(const Duration(milliseconds: 1500), () {
        _state = _state.copyWith(clearStatusMessage: true);
        notifyListeners();
      });
    });
  }

  void swapHandTile() {
    if (_state.isProcessing || _state.status != GameStatus.playing) return;
    if (_state.swapHandCount <= 0) return;

    _state = _state.copyWith(
      swapHandCount: _state.swapHandCount - 1,
      handTile: GameLogic.generateRandomTile(),
      statusMessage: 'Hand swapped! (${_state.swapHandCount - 1} left)',
    );
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 1500), () {
      _state = _state.copyWith(clearStatusMessage: true);
      notifyListeners();
    });
  }

  void togglePause() {
    if (_state.status != GameStatus.playing) return;

    if (_state.isPaused) {
      // Resume
      _state = _state.copyWith(isPaused: false);
      _startCountdown();
      _resetIdleTimer();
    } else {
      // Pause
      _state.countdownTimer?.cancel();
      _state.idleTimer?.cancel();
      _state = _state.copyWith(isPaused: true);
    }
    notifyListeners();
  }

  Future<void> requestAIHint() async {
    if (_state.status != GameStatus.playing) return;

    _state = _state.copyWith(isSageLoading: true);
    notifyListeners();

    final hint = await GeminiAPI.generateHint(_state);

    _state = _state.copyWith(
      isSageLoading: false,
      sageMessage: hint,
    );
    notifyListeners();

    // Auto-hide after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      _state = _state.copyWith(clearSageMessage: true);
      notifyListeners();
    });
  }

  void hideSageMessage() {
    _state = _state.copyWith(clearSageMessage: true);
    notifyListeners();
  }

  void _resetIdleTimer() {
    _state.idleTimer?.cancel();
    
    // Clear existing hints
    for (var tile in _state.gridTiles) {
      tile.isHinted = false;
    }

    if (_state.status == GameStatus.playing) {
      _state = _state.copyWith(
        idleTimer: Timer(GameConstants.idleHintDuration, _triggerSmartHint),
      );
    }
  }

  void _triggerSmartHint() {
    if (_state.status != GameStatus.playing || _state.isProcessing) return;
    if (_state.handTile == null) return;

    final validMove = GameLogic.findValidMove(_state.handTile!, _state.gridTiles);
    if (validMove != null) {
      validMove.isHinted = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _state.idleTimer?.cancel();
    _state.countdownTimer?.cancel();
    super.dispose();
  }
}
