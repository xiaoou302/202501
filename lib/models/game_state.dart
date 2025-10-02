import 'arrow_tile.dart';
import 'direction_changer.dart';
import 'game_level.dart';

/// Model class representing the current state of a game session
class GameState {
  /// The current level being played
  final GameLevel currentLevel;

  /// Number of moves the player has made
  int playerMoves;

  /// Number of correct moves made (tiles removed)
  int correctMoves;

  /// Whether the game has been won
  bool isGameWon;

  /// Current layout of the tiles (changes as tiles are removed)
  List<ArrowTile?> currentLayout;

  /// History of moves made (for undo functionality)
  final List<int> moveHistory;

  /// 箭头方向修改器
  final DirectionChanger directionChanger;

  GameState({
    required this.currentLevel,
    this.playerMoves = 0,
    this.correctMoves = 0,
    this.isGameWon = false,
    required this.currentLayout,
    List<int>? moveHistory,
    DirectionChanger? directionChanger,
  }) : moveHistory = moveHistory ?? [],
       directionChanger = directionChanger ?? DirectionChanger();

  /// Check if the game is complete
  bool get isComplete => isGameWon;

  /// Get the next tile ID that should be clicked according to the solution
  /// Note: This is now only used for reference or hint systems, not for validating moves
  int? get nextCorrectTileId {
    if (correctMoves < currentLevel.solution.length) {
      return currentLevel.solution[correctMoves];
    }
    return null;
  }

  /// Create a copy of this game state with updated properties
  GameState copyWith({
    GameLevel? currentLevel,
    int? playerMoves,
    int? correctMoves,
    bool? isGameWon,
    List<ArrowTile?>? currentLayout,
    List<int>? moveHistory,
    DirectionChanger? directionChanger,
  }) {
    return GameState(
      currentLevel: currentLevel ?? this.currentLevel,
      playerMoves: playerMoves ?? this.playerMoves,
      correctMoves: correctMoves ?? this.correctMoves,
      isGameWon: isGameWon ?? this.isGameWon,
      currentLayout: currentLayout ?? this.currentLayout,
      moveHistory: moveHistory ?? this.moveHistory,
      directionChanger: directionChanger ?? this.directionChanger,
    );
  }
}
