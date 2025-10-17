import '../../data/models/game_state_model.dart';
import '../../data/models/mahjong_tile_model.dart';

/// Interface for game repository
abstract class IGameRepository {
  /// Generates a new board state for a given level
  Future<List<MahjongTile>> generateBoard(int level);

  /// Generates a solvable board state for a given level
  Future<List<MahjongTile>> generateSolvableBoard(int level);

  /// Saves the current game state
  Future<void> saveGameState(GameState state);

  /// Loads the saved game state
  Future<GameState?> loadGameState();

  /// Saves the highest completed level
  Future<void> saveHighestLevel(int level);

  /// Gets the highest completed level
  Future<int> getHighestLevel();
}
