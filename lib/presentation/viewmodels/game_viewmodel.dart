import 'package:flutter/foundation.dart';
import '../../data/models/game_state_model.dart';
import '../../data/models/mahjong_tile_model.dart';
import '../../data/models/move_history_model.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../domain/usecases/generate_level_usecase.dart';
import '../../domain/usecases/check_match_usecase.dart';
import '../../domain/usecases/update_selectable_tiles_usecase.dart';

/// View model for the game board
class GameViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  final AchievementRepository _achievementRepository;
  final GenerateLevelUseCase _generateLevelUseCase;
  final CheckMatchUseCase _checkMatchUseCase;
  final UpdateSelectableTilesUseCase _updateSelectableTilesUseCase;

  GameState _gameState;
  bool _isLoading = true;
  bool _skipWinCheck = false; // 跳过胜利检查的标志

  /// Constructor
  GameViewModel(
    this._gameRepository,
    this._achievementRepository,
    this._generateLevelUseCase,
    this._checkMatchUseCase,
    this._updateSelectableTilesUseCase,
    int level,
  ) : _gameState = GameState.initial(level) {
    _initGame(level);
  }

  /// Current game state
  GameState get gameState => _gameState;

  /// Whether the game is loading
  bool get isLoading => _isLoading;

  /// Initializes the game for a given level
  Future<void> _initGame(int level) async {
    _isLoading = true;
    _skipWinCheck = true; // 初始化时跳过胜利检查
    notifyListeners();

    try {
      final boardState = await _generateLevelUseCase.execute(level);

      _gameState = GameState(
        currentLevel: level,
        boardState: boardState,
        handState: [],
        undoUsed: false,
        shuffleUsed: false,
      );

      _isLoading = false;
      _skipWinCheck = false; // 初始化完成后恢复胜利检查
      notifyListeners();

      // Unlock achievement for starting first level
      if (level == 1) {
        await _achievementRepository.unlockAchievement('first_win');
      }
    } catch (e) {
      _isLoading = false;
      _skipWinCheck = false; // 出错时也恢复胜利检查
      notifyListeners();
    }
  }

  /// Selects a tile and moves it to the hand
  void selectTile(MahjongTile tile) {
    if (!tile.isSelectable) return;

    // Save for undo
    final lastMove = MoveHistory(tile: tile, from: 'board');

    // Move from board to hand
    final updatedHandState = [..._gameState.handState, tile];
    final updatedBoardState = _gameState.boardState
        .where((t) => t.id != tile.id)
        .toList();

    _gameState = _gameState.copyWith(
      boardState: updatedBoardState,
      handState: updatedHandState,
      lastMove: lastMove,
    );

    // Update selectable tiles
    _updateSelectableTiles();

    // Check for matches
    _checkMatches();

    notifyListeners();
  }

  /// Updates which tiles are selectable
  void _updateSelectableTiles() {
    final updatedBoardState = _updateSelectableTilesUseCase.execute(
      _gameState.boardState,
    );
    _gameState = _gameState.copyWith(boardState: updatedBoardState);
  }

  /// Checks for matches in the hand and removes them
  void _checkMatches() {
    final updatedHandState = _checkMatchUseCase.execute(_gameState.handState);

    if (updatedHandState.length != _gameState.handState.length) {
      _gameState = _gameState.copyWith(handState: updatedHandState);

      // Check if the game is won
      if (_gameState.boardState.isEmpty && !_skipWinCheck) {
        _onWin();
      }
    } else {
      // Check if the game is lost
      if (_gameState.isLoss && !_skipWinCheck) {
        _onLoss();
      }
    }
  }

  /// Uses the undo power-up
  void useUndo() {
    if (_gameState.undoUsed || _gameState.lastMove == null) return;

    final lastMove = _gameState.lastMove!;

    if (lastMove.from == 'board') {
      // Return the last tile from hand to board
      final updatedHandState = List<MahjongTile>.from(_gameState.handState)
        ..removeLast();

      final updatedBoardState = List<MahjongTile>.from(_gameState.boardState)
        ..add(lastMove.tile);

      _gameState = _gameState.copyWith(
        boardState: updatedBoardState,
        handState: updatedHandState,
        lastMove: null,
        undoUsed: true,
      );

      _updateSelectableTiles();
      notifyListeners();
    }
  }

  /// Uses the shuffle power-up
  void useShuffle() {
    if (_gameState.shuffleUsed) return;

    // Get all selectable tiles
    final selectableTiles = _gameState.boardState
        .where((tile) => tile.isSelectable)
        .toList();

    if (selectableTiles.isEmpty) return;

    // Get their types and shuffle them
    final selectableTypes = selectableTiles.map((tile) => tile.type).toList();
    selectableTypes.shuffle();

    // Apply the shuffled types
    final updatedBoardState = List<MahjongTile>.from(_gameState.boardState);

    for (int i = 0; i < selectableTiles.length; i++) {
      final tileIndex = updatedBoardState.indexWhere(
        (tile) => tile.id == selectableTiles[i].id,
      );

      if (tileIndex != -1) {
        updatedBoardState[tileIndex] = updatedBoardState[tileIndex].copyWith(
          type: selectableTypes[i],
        );
      }
    }

    _gameState = _gameState.copyWith(
      boardState: updatedBoardState,
      shuffleUsed: true,
    );

    notifyListeners();

    // Unlock achievement for using shuffle
    _achievementRepository.unlockAchievement('shuffle_win');
  }

  /// Called when the player wins
  void _onWin() async {
    // Save highest level
    await _gameRepository.saveHighestLevel(_gameState.currentLevel);

    // Unlock achievements
    if (_gameState.currentLevel == 3) {
      await _achievementRepository.unlockAchievement('chapter_one');
    }

    if (!_gameState.undoUsed && !_gameState.shuffleUsed) {
      await _achievementRepository.unlockAchievement('no_powerup');
    }
  }

  /// Called when the player loses
  void _onLoss() {
    // Nothing to do here for now
  }

  /// Restarts the current level
  void restartLevel() {
    _skipWinCheck = true; // 重启关卡时跳过胜利检查
    _initGame(_gameState.currentLevel);
  }

  /// Advances to the next level
  void nextLevel() {
    if (_gameState.currentLevel < 12) {
      _skipWinCheck = true; // 进入下一关时跳过胜利检查
      _initGame(_gameState.currentLevel + 1);
    }
  }
}
