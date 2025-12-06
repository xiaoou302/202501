import 'dart:math';
import '../models/tile_model.dart';
import '../core/constants.dart';

class GameLogic {
  static bool isMatch(int handNumber, int tileNumber) {
    final diff = (handNumber - tileNumber).abs();
    return diff == 1 || diff == 8; // Neighbor or wrap (9-1)
  }

  static MahjongTile generateRandomTile({int? id}) {
    final random = Random();
    final types = TileType.values;
    final type = types[random.nextInt(types.length)];
    final number = GameConstants.numbers[random.nextInt(GameConstants.numbers.length)];
    
    return MahjongTile(
      id: id ?? 0,
      type: type,
      number: number,
    );
  }

  static List<MahjongTile> generateGrid({
    int? gridSize,
    int? columns,
  }) {
    final size = gridSize ?? GameConstants.gridSize;
    return List.generate(
      size,
      (index) => generateRandomTile(id: index),
    );
  }

  static bool hasValidMoves(MahjongTile handTile, List<MahjongTile> gridTiles) {
    return gridTiles.any(
      (tile) => tile.isActive && isMatch(handTile.number, tile.number),
    );
  }

  static MahjongTile? findValidMove(MahjongTile handTile, List<MahjongTile> gridTiles) {
    try {
      return gridTiles.firstWhere(
        (tile) => tile.isActive && !tile.isRevealed && isMatch(handTile.number, tile.number),
      );
    } catch (e) {
      return null;
    }
  }

  static List<MahjongTile> reshuffleGrid(
    List<MahjongTile> gridTiles,
    MahjongTile handTile,
  ) {
    final activeIndices = <int>[];
    for (int i = 0; i < gridTiles.length; i++) {
      if (gridTiles[i].isActive) {
        activeIndices.add(i);
      }
    }

    if (activeIndices.isEmpty) return gridTiles;

    // Reshuffle active tiles
    final newTiles = List<MahjongTile>.from(gridTiles);
    for (final idx in activeIndices) {
      final newTile = generateRandomTile(id: idx);
      newTiles[idx] = newTile.copyWith(
        isActive: true,
        isRevealed: false,
      );
    }

    // Force at least one valid match
    final luckyIdx = activeIndices[Random().nextInt(activeIndices.length)];
    final neighbor = handTile.number == 9 ? 1 : handTile.number + 1;
    newTiles[luckyIdx] = newTiles[luckyIdx].copyWith(number: neighbor);

    return newTiles;
  }

  static int calculateScore(int baseScore, int streak) {
    return baseScore + (streak * GameConstants.streakBonus);
  }
}
