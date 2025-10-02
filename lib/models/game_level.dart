import 'arrow_tile.dart';

/// Model class representing a game level
class GameLevel {
  /// Unique identifier for the level
  final int id;

  /// Level name
  final String name;

  /// Level description
  final String description;

  /// Optimal number of moves to complete the level
  final int totalMoves;

  /// Initial layout of arrow tiles
  final List<ArrowTile?> layout;

  /// Correct solution sequence (list of tile IDs in order)
  final List<int> solution;

  /// Whether the level is locked
  bool isLocked;

  /// Whether the level has been completed
  bool isCompleted;

  /// Player's best move count for this level
  int playerBestMoves;

  /// Level pack this level belongs to (e.g., "Beginner", "Advanced")
  final String levelPack;

  /// Grid size (default is 5x5)
  final int gridSize;

  GameLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.totalMoves,
    required this.layout,
    required this.solution,
    required this.levelPack,
    this.gridSize = 5,
    this.isLocked = false,
    this.isCompleted = false,
    this.playerBestMoves = 0,
  });

  /// Create a copy of this level with updated properties
  GameLevel copyWith({
    int? id,
    String? name,
    String? description,
    int? totalMoves,
    List<ArrowTile?>? layout,
    List<int>? solution,
    bool? isLocked,
    bool? isCompleted,
    int? playerBestMoves,
    String? levelPack,
    int? gridSize,
  }) {
    return GameLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      totalMoves: totalMoves ?? this.totalMoves,
      layout: layout ?? this.layout,
      solution: solution ?? this.solution,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      playerBestMoves: playerBestMoves ?? this.playerBestMoves,
      levelPack: levelPack ?? this.levelPack,
      gridSize: gridSize ?? this.gridSize,
    );
  }
}
