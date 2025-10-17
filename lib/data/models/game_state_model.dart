import 'mahjong_tile_model.dart';
import 'move_history_model.dart';
import '../../core/constants/app_constants.dart';

/// Model representing the current state of the game
class GameState {
  /// Current level number (1-12)
  final int currentLevel;

  /// List of tiles on the board
  final List<MahjongTile> boardState;

  /// List of tiles in the player's hand
  final List<MahjongTile> handState;

  /// Last move made (for undo functionality)
  final MoveHistory? lastMove;

  /// Whether the undo power-up has been used in this level
  final bool undoUsed;

  /// Whether the shuffle power-up has been used in this level
  final bool shuffleUsed;

  /// Number of tiles remaining on the board
  int get tilesRemaining => boardState.length;

  /// Whether the hand is full
  bool get isHandFull => handState.length >= AppConstants.maxHandSize;

  /// Whether the player has won (all tiles cleared)
  bool get isWin => boardState.isEmpty;

  /// Whether the player has lost (hand full with no matches)
  bool get isLoss => isHandFull && !_hasMatches();

  /// Constructor
  const GameState({
    required this.currentLevel,
    required this.boardState,
    required this.handState,
    this.lastMove,
    this.undoUsed = false,
    this.shuffleUsed = false,
  });

  /// Creates a copy of this game state with the given fields replaced with new values
  GameState copyWith({
    int? currentLevel,
    List<MahjongTile>? boardState,
    List<MahjongTile>? handState,
    MoveHistory? lastMove,
    bool? undoUsed,
    bool? shuffleUsed,
  }) {
    return GameState(
      currentLevel: currentLevel ?? this.currentLevel,
      boardState: boardState ?? this.boardState,
      handState: handState ?? this.handState,
      lastMove: lastMove ?? this.lastMove,
      undoUsed: undoUsed ?? this.undoUsed,
      shuffleUsed: shuffleUsed ?? this.shuffleUsed,
    );
  }

  /// Checks if there are matches in the hand
  bool _hasMatches() {
    final counts = <String, int>{};

    for (final tile in handState) {
      counts[tile.type] = (counts[tile.type] ?? 0) + 1;
    }

    for (final count in counts.values) {
      if (count >= 3) {
        return true;
      }
    }

    return false;
  }

  /// Creates a GameState from a map
  factory GameState.fromMap(Map<String, dynamic> map) {
    return GameState(
      currentLevel: map['currentLevel'] as int,
      boardState: (map['boardState'] as List<dynamic>)
          .map((e) => MahjongTile.fromMap(e as Map<String, dynamic>))
          .toList(),
      handState: (map['handState'] as List<dynamic>)
          .map((e) => MahjongTile.fromMap(e as Map<String, dynamic>))
          .toList(),
      lastMove: map['lastMove'] != null
          ? MoveHistory.fromMap(map['lastMove'] as Map<String, dynamic>)
          : null,
      undoUsed: map['undoUsed'] as bool? ?? false,
      shuffleUsed: map['shuffleUsed'] as bool? ?? false,
    );
  }

  /// Converts this GameState to a map
  Map<String, dynamic> toMap() {
    return {
      'currentLevel': currentLevel,
      'boardState': boardState.map((e) => e.toMap()).toList(),
      'handState': handState.map((e) => e.toMap()).toList(),
      'lastMove': lastMove?.toMap(),
      'undoUsed': undoUsed,
      'shuffleUsed': shuffleUsed,
    };
  }

  /// Creates an initial empty game state for a given level
  factory GameState.initial(int level) {
    return GameState(currentLevel: level, boardState: [], handState: []);
  }
}
