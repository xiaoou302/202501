import '../models/game_level.dart';
import '../models/game_state.dart';
import 'game_logic.dart';

/// Utility class to test if levels are solvable
class LevelTester {
  /// Test if a level can be solved by simulating gameplay
  static bool isLevelSolvable(GameLevel level) {
    // Create a game state for the level
    var gameState = GameState(
      currentLevel: level,
      currentLayout: List.from(level.layout),
    );

    // Keep track of visited tile IDs to avoid infinite loops
    final visitedTileIds = <int>{};

    // Try to solve the level
    while (!_isGameComplete(gameState)) {
      // Find a tile that can be clicked
      final clickableTileId = _findClickableTileId(gameState);

      // If no clickable tile is found, the level is not solvable
      if (clickableTileId == null) {
        return false;
      }

      // If we've already clicked this tile, we're in a loop
      if (visitedTileIds.contains(clickableTileId)) {
        return false;
      }

      // Mark the tile as visited
      visitedTileIds.add(clickableTileId);

      // Click the tile
      gameState = GameLogic.processTileClick(gameState, clickableTileId);
    }

    // If we've removed all tiles, the level is solvable
    return true;
  }

  /// Check if all tiles have been removed
  static bool _isGameComplete(GameState gameState) {
    for (final tile in gameState.currentLayout) {
      if (tile != null && !tile.isRemoved) {
        return false;
      }
    }
    return true;
  }

  /// Find a tile that can be clicked
  static int? _findClickableTileId(GameState gameState) {
    for (final tile in gameState.currentLayout) {
      if (tile != null && !tile.isRemoved) {
        if (GameLogic.canTileBeClicked(gameState, tile.id)) {
          return tile.id;
        }
      }
    }
    return null;
  }

  /// Print a report of the level's solvability
  static void printLevelReport(GameLevel level) {
    final solvable = isLevelSolvable(level);
    print(
      'Level ${level.id} (${level.name}): ${solvable ? 'Solvable' : 'NOT SOLVABLE'}',
    );
  }
}
