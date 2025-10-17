import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state_model.dart';
import '../models/mahjong_tile_model.dart';
import '../models/level_layout_model.dart';
import '../../core/constants/mahjong_constants.dart';
import '../../core/utils/game_utils.dart';
import '../../domain/repositories/game_repository_interface.dart';

/// Repository for game-related data and operations
class GameRepository implements IGameRepository {
  @override
  /// Generates a new board state for a given level
  Future<List<MahjongTile>> generateBoard(int level) async {
    // Get the appropriate layout for this level
    final layout = LevelLayout.forLevel(level);

    // Generate the tiles for this level
    final tileTypes = GameUtils.generateLevelTiles(layout.tileCount);

    // Create the board state
    final boardState = <MahjongTile>[];

    for (int i = 0; i < layout.coordinates.length; i++) {
      final coord = layout.coordinates[i];
      boardState.add(
        MahjongTile(
          id: 'tile_$i',
          type: tileTypes[i],
          x: coord['x']!,
          y: coord['y']!,
          z: coord['z']!.toInt(),
          isSelectable: false, // Will be updated later
        ),
      );
    }

    // Update which tiles are selectable
    return GameUtils.updateSelectableTiles(boardState);
  }

  @override
  /// Generates a solvable board state for a given level
  Future<List<MahjongTile>> generateSolvableBoard(int level) async {
    // Get the appropriate layout for this level
    final layout = LevelLayout.forLevel(level);

    // Create an empty board with the layout coordinates
    final board = layout.coordinates.asMap().entries.map((entry) {
      return MahjongTile(
        id: 'tile_${entry.key}',
        type: '', // Empty for now
        x: entry.value['x']!,
        y: entry.value['y']!,
        z: entry.value['z']!.toInt(),
        isSelectable: false,
      );
    }).toList();

    // Generate the tile types needed for this level
    final neededTypes = layout.tileCount ~/ 3;
    final shuffledSet = List<String>.from(MahjongConstants.allTiles)..shuffle();
    final selectedTypes = shuffledSet.take(neededTypes).toList();

    // Create triplets of each type
    final triplets = <List<String>>[];
    for (final type in selectedTypes) {
      triplets.add([type, type, type]);
    }

    // Randomly place triplets on the board
    final random = Random();

    // Fill the board in a solvable way
    while (triplets.isNotEmpty) {
      // Find all placeable slots (not blocked by other empty slots)
      final emptySlots = board.where((slot) => slot.type.isEmpty).toList();

      // Find slots that are not blocked by other empty slots
      final placeableSlots = emptySlots.where((slot) {
        bool isBlocked = false;
        for (final otherSlot in emptySlots) {
          if (slot.id != otherSlot.id &&
              otherSlot.z > slot.z &&
              GameUtils.isOverlapping(slot, otherSlot)) {
            isBlocked = true;
            break;
          }
        }
        return !isBlocked;
      }).toList();

      // If we don't have enough placeable slots, use any empty slots
      final slotsToUse = placeableSlots.length >= 3
          ? placeableSlots
          : emptySlots;

      if (slotsToUse.length < 3) break; // Safety check

      // Randomly select 3 slots
      slotsToUse.shuffle(random);
      final selectedSlots = slotsToUse.take(3).toList();

      // Get a triplet
      final triplet = triplets.removeLast();

      // Place the triplet
      for (int i = 0; i < 3; i++) {
        final slotIndex = board.indexWhere(
          (tile) => tile.id == selectedSlots[i].id,
        );
        if (slotIndex != -1) {
          board[slotIndex] = board[slotIndex].copyWith(type: triplet[i]);
        }
      }
    }

    // Update which tiles are selectable
    return GameUtils.updateSelectableTiles(
      board.where((tile) => tile.type.isNotEmpty).toList(),
    );
  }

  @override
  /// Saves the current game state
  Future<void> saveGameState(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = state.toMap();
    await prefs.setString('game_state', stateJson.toString());
  }

  @override
  /// Loads the saved game state
  Future<GameState?> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = prefs.getString('game_state');

    if (stateJson == null) return null;

    try {
      // This is a simplified approach - in a real app, you'd need proper JSON parsing
      return GameState.fromMap({});
    } catch (e) {
      return null;
    }
  }

  @override
  /// Saves the highest completed level
  Future<void> saveHighestLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHighest = prefs.getInt('highest_level') ?? 0;
    if (level > currentHighest) {
      await prefs.setInt('highest_level', level);
    }
  }

  @override
  /// Gets the highest completed level
  Future<int> getHighestLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('highest_level') ?? 0;
  }
}
