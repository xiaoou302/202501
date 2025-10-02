import 'package:flutter/material.dart';
import '../models/arrow_tile.dart';
import '../models/game_level.dart';
import '../models/obstacle_tile.dart';
import 'constants.dart';
import 'level_cache.dart';

/// Class for generating and managing game levels
class LevelGenerator {
  /// Get all levels metadata
  static List<GameLevelMetadata> getAllLevelMetadata() {
    final cache = LevelCache();
    final List<GameLevelMetadata> metadata = [];

    // Generate metadata for all 12 levels
    for (int i = 1; i <= 12; i++) {
      final levelId = i;
      final cachedMetadata = cache.getLevelMetadataById(levelId);

      if (cachedMetadata != null) {
        metadata.add(cachedMetadata);
        continue;
      }

      // Create new metadata
      final levelMetadata = GameLevelMetadata(
        id: levelId,
        name: 'Level $levelId',
        description: _getLevelDescription(levelId),
        totalMoves: _getApproximateMoveCount(levelId),
        levelPack: 'Glyphion',
      );

      // Cache the metadata
      cache.cacheLevelMetadata(levelId, levelMetadata);
      metadata.add(levelMetadata);
    }

    return metadata;
  }

  /// Get approximate move count based on level difficulty
  static int _getApproximateMoveCount(int levelId) {
    // Moves increase with level difficulty
    if (levelId <= 4) {
      return 15; // Easy levels
    } else if (levelId <= 8) {
      return 20; // Medium levels
    } else {
      return 25; // Hard levels
    }
  }

  /// Get level description based on level number
  static String _getLevelDescription(int levelId) {
    switch (levelId) {
      case 1:
        return 'Begin your journey with a simple arrangement of arrows.';
      case 2:
        return 'Navigate around a central obstacle to clear the board.';
      case 3:
        return 'Navigate around four stone obstacles to clear the board.';
      case 4:
        return 'Navigate around stone, ice, and metal obstacles.';
      case 5:
        return 'Navigate a complex spiral pattern around stone obstacles.';
      case 6:
        return 'Navigate around a cross of unbreakable metal obstacles.';
      case 7:
        return 'Find your way through a complex maze of ice obstacles.';
      case 8:
        return 'Navigate through a complex pattern of different obstacle types.';
      case 9:
        return 'Navigate a complex spiral pattern with mixed obstacle types.';
      case 10:
        return 'Navigate an advanced maze with all three obstacle types.';
      case 11:
        return 'Navigate a complex symmetric pattern with strategic obstacles.';
      case 12:
        return 'The ultimate challenge with strategic obstacle placement.';
      default:
        return 'A unique puzzle challenge';
    }
  }

  /// Legacy method for backward compatibility
  static List<String> getLevelPacks() {
    return ['Glyphion'];
  }

  /// Legacy method for backward compatibility
  static List<GameLevel> getLevelsForPack(String packName) {
    final List<GameLevel> levels = [];

    for (int i = 1; i <= 12; i++) {
      final level = getLevelById(i);
      if (level != null) {
        levels.add(level);
      }
    }

    return levels;
  }

  /// Legacy method for backward compatibility
  static List<GameLevelMetadata> getLevelMetadataForPack(String packName) {
    return getAllLevelMetadata();
  }

  /// Get level by ID with optimized generation and caching
  static GameLevel? getLevelById(int levelId) {
    final cache = LevelCache();

    // Check if level is already cached
    final cachedLevel = cache.getLevelById(levelId);
    if (cachedLevel != null) {
      return cachedLevel;
    }

    // If not cached, generate the level directly
    GameLevel? level;

    // Generate level based on ID (1-12)
    switch (levelId) {
      case 1:
        level = _createLevel1();
        break;
      case 2:
        level = _createLevel2();
        break;
      case 3:
        level = _createLevel3();
        break;
      case 4:
        level = _createLevel4();
        break;
      case 5:
        level = _createLevel5();
        break;
      case 6:
        level = _createLevel6();
        break;
      case 7:
        level = _createLevel7();
        break;
      case 8:
        level = _createLevel8();
        break;
      case 9:
        level = _createLevel9();
        break;
      case 10:
        level = _createLevel10();
        break;
      case 11:
        level = _createLevel11();
        break;
      case 12:
        level = _createLevel12();
        break;
      default:
        // Fallback for invalid level IDs
        return null;
    }

    // Cache the level
    cache.cacheLevel(level);

    return level;
  }

  /// Level 5: Spiral Labyrinth - A challenging spiral pattern with obstacles
  static GameLevel _createLevel5() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a spiral pattern with arrows

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    layout[6] = ObstacleTile(
      id: 90,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 1,
    );
    layout[7] = ObstacleTile(
      id: 91,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 2,
    );
    layout[8] = ObstacleTile(
      id: 92,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 0,
    );
    layout[16] = ObstacleTile(
      id: 93,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 1,
    );
    layout[17] = ObstacleTile(
      id: 94,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 2,
    );
    layout[18] = ObstacleTile(
      id: 95,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 19,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      4,
      5,
      7,
      12,
      14,
      19,
      18,
      17,
      16,
      15,
      13,
      8,
      9,
      10,
      11,
      6,
    ];

    return GameLevel(
      id: 5,
      name: 'Spiral Labyrinth',
      description: 'Navigate a complex spiral pattern around stone obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
    );
  }

  /// Create advanced level 1 - Cosmic Vortex
  static GameLevel _createAdvancedLevel1() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a cosmic vortex pattern with arrows spiraling inward

    // Ice obstacles representing cosmic anomalies
    layout[6] = ObstacleTile(
      id: 90,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 1,
    );

    layout[8] = ObstacleTile(
      id: 91,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 3,
    );

    layout[16] = ObstacleTile(
      id: 92,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 1,
    );

    layout[18] = ObstacleTile(
      id: 93,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 3,
    );

    // Arrow tiles forming a spiral pattern
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );

    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );

    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );

    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );

    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );

    layout[7] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );

    layout[9] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );

    layout[10] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );

    layout[11] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );

    layout[12] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );

    layout[13] = ArrowTile(
      id: 12,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 2,
      column: 3,
    );

    layout[14] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 4,
    );

    layout[15] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );

    layout[17] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 3,
      column: 2,
    );

    layout[19] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    layout[20] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );

    layout[21] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );

    layout[22] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );

    layout[23] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );

    layout[24] = ArrowTile(
      id: 21,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      4,
      5,
      8,
      13,
      16,
      21,
      20,
      19,
      18,
      17,
      14,
      9,
      10,
      12,
      11,
      15,
      7,
      6,
    ];

    return GameLevel(
      id: 301,
      name: 'Cosmic Vortex',
      description: _getAdvancedLevelDescription(1),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Celestial Puzzles',
    );
  }

  /// Level 6: Metal Cross - A challenging pattern with metal obstacles
  static GameLevel _createLevel6() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a cross pattern with metal obstacles

    // Add metal obstacles in a cross pattern
    layout[7] = ObstacleTile(
      id: 90,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 2,
    );

    layout[11] = ObstacleTile(
      id: 91,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 1,
    );

    layout[12] = ObstacleTile(
      id: 92,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 2,
    );

    layout[13] = ObstacleTile(
      id: 93,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 3,
    );

    layout[17] = ObstacleTile(
      id: 94,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 2,
    );

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );
    // Obstacle at [1, 2]
    layout[8] = ArrowTile(
      id: 8,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 9,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 0,
    );
    // Obstacles at [2, 1], [2, 2], [2, 3]
    layout[14] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 12,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    // Obstacle at [3, 2]
    layout[18] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 15,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 18,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      3,
      18,
      19,
      20,
      15,
      14,
      11,
      10,
      6,
      7,
      12,
      13,
      8,
      9,
      4,
      5,
      1,
      2,
    ];

    return GameLevel(
      id: 6,
      name: 'Metal Cross',
      description: 'Navigate around a cross of unbreakable metal obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
    );
  }

  /// Create advanced level 2 - Asteroid Field
  static GameLevel _createAdvancedLevel2() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create an asteroid field pattern with scattered obstacles

    // Stone obstacles representing asteroids
    layout[2] = ObstacleTile(
      id: 90,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 2,
    );

    layout[6] = ObstacleTile(
      id: 91,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 1,
    );

    layout[8] = ObstacleTile(
      id: 92,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 3,
    );

    layout[12] = ObstacleTile(
      id: 93,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 2,
    );

    layout[16] = ObstacleTile(
      id: 94,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 1,
    );

    layout[18] = ObstacleTile(
      id: 95,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 3,
    );

    layout[22] = ObstacleTile(
      id: 96,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 2,
    );

    // Arrow tiles navigating through the asteroid field
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );

    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );

    layout[3] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 3,
    );

    layout[4] = ArrowTile(
      id: 4,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 0,
      column: 4,
    );

    layout[5] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 1,
      column: 0,
    );

    layout[7] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );

    layout[9] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 4,
    );

    layout[10] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 0,
    );

    layout[11] = ArrowTile(
      id: 9,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 2,
      column: 1,
    );

    layout[13] = ArrowTile(
      id: 10,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 3,
    );

    layout[14] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    layout[15] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );

    layout[17] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 2,
    );

    layout[19] = ArrowTile(
      id: 14,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );

    layout[20] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 0,
    );

    layout[21] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );

    layout[23] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 3,
    );

    layout[24] = ArrowTile(
      id: 18,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      5,
      8,
      9,
      6,
      13,
      10,
      3,
      4,
      7,
      11,
      14,
      18,
      17,
      16,
      15,
      12,
    ];

    return GameLevel(
      id: 302,
      name: 'Asteroid Field',
      description: _getAdvancedLevelDescription(2),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Celestial Puzzles',
    );
  }

  /// Level 7: Spiral Maze - A challenging 7x7 grid with a spiral pattern
  static GameLevel _createLevel7() {
    final gridSize = 7;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a spiral pattern in a 7x7 grid without obstacles

    // Top row (row 0)
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 5,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 6,
    );

    // Row 1
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 1,
      column: 5,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 6,
    );

    // Row 2
    layout[14] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 3,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 20,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 2,
      column: 5,
    );
    layout[20] = ArrowTile(
      id: 21,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 6,
    );

    // Row 3
    layout[21] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[22] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 1,
    );
    layout[23] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );
    layout[25] = ArrowTile(
      id: 26,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );
    layout[26] = ArrowTile(
      id: 27,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 5,
    );
    layout[27] = ArrowTile(
      id: 28,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 6,
    );

    // Row 4
    layout[28] = ArrowTile(
      id: 29,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[29] = ArrowTile(
      id: 30,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[30] = ArrowTile(
      id: 31,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[31] = ArrowTile(
      id: 32,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[32] = ArrowTile(
      id: 33,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );
    layout[33] = ArrowTile(
      id: 34,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 5,
    );
    layout[34] = ArrowTile(
      id: 35,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 4,
      column: 6,
    );

    // Row 5
    layout[35] = ArrowTile(
      id: 36,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 5,
      column: 0,
    );
    layout[36] = ArrowTile(
      id: 37,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 5,
      column: 1,
    );
    layout[37] = ArrowTile(
      id: 38,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 2,
    );
    layout[38] = ArrowTile(
      id: 39,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 5,
      column: 3,
    );
    layout[39] = ArrowTile(
      id: 40,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 5,
      column: 4,
    );
    layout[40] = ArrowTile(
      id: 41,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 5,
      column: 5,
    );
    layout[41] = ArrowTile(
      id: 42,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 6,
    );

    // Bottom row (row 6)
    layout[42] = ArrowTile(
      id: 43,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 6,
      column: 0,
    );
    layout[43] = ArrowTile(
      id: 44,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 6,
      column: 1,
    );
    layout[44] = ArrowTile(
      id: 45,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 6,
      column: 2,
    );
    layout[45] = ArrowTile(
      id: 46,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 6,
      column: 3,
    );
    layout[46] = ArrowTile(
      id: 47,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 6,
      column: 4,
    );
    layout[47] = ArrowTile(
      id: 48,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 6,
      column: 5,
    );
    layout[48] = ArrowTile(
      id: 49,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 6,
      column: 6,
    );

    // Solution sequence - spiral pattern from outside to inside
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      14,
      21,
      28,
      35,
      42,
      49,
      48,
      47,
      46,
      45,
      44,
      43,
      36,
      29,
      22,
      15,
      8,
      9,
      10,
      11,
      12,
      13,
      20,
      27,
      34,
      41,
      40,
      39,
      38,
      37,
      30,
      23,
      16,
      17,
      18,
      19,
      26,
      33,
      32,
      31,
      24,
      25,
    ];

    return GameLevel(
      id: 7,
      name: 'Spiral Maze',
      description:
          'Navigate through a complex spiral pattern in a larger grid.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
      gridSize: gridSize, // Explicitly set the grid size to 7
    );
  }

  /// Create advanced level 3 - Galactic Core
  static GameLevel _createAdvancedLevel3() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a galactic core pattern with a central black hole and surrounding stars

    // Metal obstacle representing a black hole in the center
    layout[12] = ObstacleTile(
      id: 90,
      type: ObstacleType.metal,
      color: Colors.grey[800]!,
      row: 2,
      column: 2,
    );

    // Ice obstacles representing stars
    layout[6] = ObstacleTile(
      id: 91,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 1,
    );

    layout[8] = ObstacleTile(
      id: 92,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 3,
    );

    layout[16] = ObstacleTile(
      id: 93,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 1,
    );

    layout[18] = ObstacleTile(
      id: 94,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 3,
    );

    // Arrow tiles forming a spiral around the galactic core
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );

    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );

    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );

    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );

    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );

    layout[7] = ArrowTile(
      id: 7,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );

    layout[9] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );

    layout[10] = ArrowTile(
      id: 9,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );

    layout[11] = ArrowTile(
      id: 10,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );

    layout[13] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 3,
    );

    layout[14] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );

    layout[15] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 0,
    );

    layout[17] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );

    layout[19] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );

    layout[20] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );

    layout[21] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );

    layout[22] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );

    layout[23] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );

    layout[24] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      4,
      5,
      8,
      12,
      15,
      20,
      19,
      18,
      17,
      16,
      13,
      14,
      11,
      7,
      10,
      9,
      6,
    ];

    return GameLevel(
      id: 303,
      name: 'Galactic Core',
      description: _getAdvancedLevelDescription(3),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Celestial Puzzles',
    );
  }

  /// Level 8: Checkerboard Challenge - A challenging pattern with alternating directions in a 7x7 grid
  static GameLevel _createLevel8() {
    final gridSize = 7;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a checkerboard pattern with alternating arrow directions

    // Top row (row 0)
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 5,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 0,
      column: 6,
    );

    // Row 1
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 5,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 6,
    );

    // Row 2
    layout[14] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 3,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 20,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 5,
    );
    layout[20] = ArrowTile(
      id: 21,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 2,
      column: 6,
    );

    // Row 3
    layout[21] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[22] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 1,
    );
    layout[23] = ArrowTile(
      id: 24,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );
    layout[25] = ArrowTile(
      id: 26,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );
    layout[26] = ArrowTile(
      id: 27,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 5,
    );
    layout[27] = ArrowTile(
      id: 28,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 3,
      column: 6,
    );

    // Row 4
    layout[28] = ArrowTile(
      id: 29,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[29] = ArrowTile(
      id: 30,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[30] = ArrowTile(
      id: 31,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[31] = ArrowTile(
      id: 32,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[32] = ArrowTile(
      id: 33,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );
    layout[33] = ArrowTile(
      id: 34,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 5,
    );
    layout[34] = ArrowTile(
      id: 35,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 6,
    );

    // Row 5
    layout[35] = ArrowTile(
      id: 36,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 5,
      column: 0,
    );
    layout[36] = ArrowTile(
      id: 37,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 5,
      column: 1,
    );
    layout[37] = ArrowTile(
      id: 38,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 2,
    );
    layout[38] = ArrowTile(
      id: 39,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 5,
      column: 3,
    );
    layout[39] = ArrowTile(
      id: 40,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 5,
      column: 4,
    );
    layout[40] = ArrowTile(
      id: 41,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 5,
      column: 5,
    );
    layout[41] = ArrowTile(
      id: 42,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 6,
    );

    // Bottom row (row 6)
    layout[42] = ArrowTile(
      id: 43,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 6,
      column: 0,
    );
    layout[43] = ArrowTile(
      id: 44,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 6,
      column: 1,
    );
    layout[44] = ArrowTile(
      id: 45,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 6,
      column: 2,
    );
    layout[45] = ArrowTile(
      id: 46,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 6,
      column: 3,
    );
    layout[46] = ArrowTile(
      id: 47,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 6,
      column: 4,
    );
    layout[47] = ArrowTile(
      id: 48,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 6,
      column: 5,
    );
    layout[48] = ArrowTile(
      id: 49,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 6,
      column: 6,
    );

    // Solution sequence - a zigzag pattern through the grid
    final solution = [
      1,
      2,
      9,
      10,
      17,
      18,
      25,
      26,
      33,
      34,
      41,
      42,
      49,
      48,
      47,
      46,
      45,
      44,
      43,
      36,
      37,
      38,
      39,
      40,
      35,
      28,
      27,
      20,
      21,
      14,
      13,
      12,
      11,
      4,
      3,
      5,
      6,
      7,
      8,
      15,
      16,
      23,
      24,
      31,
      32,
      29,
      30,
      22,
      19,
    ];

    return GameLevel(
      id: 8,
      name: 'Checkerboard Challenge',
      description:
          'Navigate through a complex checkerboard pattern in a larger grid.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
      gridSize: gridSize, // Explicitly set the grid size to 7
    );
  }

  /// Level 10: Master Grid - An advanced challenge with a 7x7 grid
  static GameLevel _createLevel10() {
    final gridSize = 7;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a diamond pattern in a 7x7 grid without obstacles

    // Top row (row 0)
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 5,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 0,
      column: 6,
    );

    // Row 1
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 1,
      column: 5,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 6,
    );

    // Row 2
    layout[14] = ArrowTile(
      id: 15,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 3,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 2,
      column: 5,
    );
    layout[20] = ArrowTile(
      id: 21,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 2,
      column: 6,
    );

    // Row 3
    layout[21] = ArrowTile(
      id: 22,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[22] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 1,
    );
    layout[23] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );
    layout[25] = ArrowTile(
      id: 26,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );
    layout[26] = ArrowTile(
      id: 27,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 5,
    );
    layout[27] = ArrowTile(
      id: 28,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 6,
    );

    // Row 4
    layout[28] = ArrowTile(
      id: 29,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[29] = ArrowTile(
      id: 30,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[30] = ArrowTile(
      id: 31,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[31] = ArrowTile(
      id: 32,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[32] = ArrowTile(
      id: 33,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );
    layout[33] = ArrowTile(
      id: 34,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 5,
    );
    layout[34] = ArrowTile(
      id: 35,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 4,
      column: 6,
    );

    // Row 5
    layout[35] = ArrowTile(
      id: 36,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 5,
      column: 0,
    );
    layout[36] = ArrowTile(
      id: 37,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 5,
      column: 1,
    );
    layout[37] = ArrowTile(
      id: 38,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 2,
    );
    layout[38] = ArrowTile(
      id: 39,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 5,
      column: 3,
    );
    layout[39] = ArrowTile(
      id: 40,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 5,
      column: 4,
    );
    layout[40] = ArrowTile(
      id: 41,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 5,
      column: 5,
    );
    layout[41] = ArrowTile(
      id: 42,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 6,
    );

    // Bottom row (row 6)
    layout[42] = ArrowTile(
      id: 43,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 6,
      column: 0,
    );
    layout[43] = ArrowTile(
      id: 44,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 6,
      column: 1,
    );
    layout[44] = ArrowTile(
      id: 45,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 6,
      column: 2,
    );
    layout[45] = ArrowTile(
      id: 46,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 6,
      column: 3,
    );
    layout[46] = ArrowTile(
      id: 47,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 6,
      column: 4,
    );
    layout[47] = ArrowTile(
      id: 48,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 6,
      column: 5,
    );
    layout[48] = ArrowTile(
      id: 49,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 6,
      column: 6,
    );

    // Solution sequence - a diamond pattern through the grid
    final solution = [
      1,
      2,
      3,
      4,
      11,
      18,
      25,
      32,
      39,
      40,
      41,
      34,
      27,
      20,
      13,
      6,
      5,
      12,
      19,
      26,
      33,
      40,
      47,
      48,
      49,
      42,
      35,
      28,
      21,
      14,
      7,
      8,
      15,
      22,
      29,
      36,
      43,
      44,
      45,
      46,
      39,
      38,
      31,
      24,
      17,
      10,
      9,
      16,
      23,
      30,
      37,
    ];

    return GameLevel(
      id: 10,
      name: 'Diamond Challenge',
      description:
          'Navigate through a complex diamond pattern in a larger grid.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
      gridSize: gridSize, // Explicitly set the grid size to 7
    );
  }

  /// Level 9: Vortex Flow - A challenging flow pattern in a 7x7 grid
  static GameLevel _createLevel9() {
    final gridSize = 7;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a flow pattern in a 7x7 grid without obstacles

    // Top row (row 0)
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 5,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 6,
    );

    // Row 1
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 5,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 6,
    );

    // Row 2
    layout[14] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 3,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 20,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 2,
      column: 5,
    );
    layout[20] = ArrowTile(
      id: 21,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 6,
    );

    // Row 3
    layout[21] = ArrowTile(
      id: 22,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[22] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 1,
    );
    layout[23] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );
    layout[25] = ArrowTile(
      id: 26,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );
    layout[26] = ArrowTile(
      id: 27,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 5,
    );
    layout[27] = ArrowTile(
      id: 28,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 6,
    );

    // Row 4
    layout[28] = ArrowTile(
      id: 29,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[29] = ArrowTile(
      id: 30,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[30] = ArrowTile(
      id: 31,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[31] = ArrowTile(
      id: 32,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[32] = ArrowTile(
      id: 33,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );
    layout[33] = ArrowTile(
      id: 34,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 5,
    );
    layout[34] = ArrowTile(
      id: 35,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 4,
      column: 6,
    );

    // Row 5
    layout[35] = ArrowTile(
      id: 36,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 5,
      column: 0,
    );
    layout[36] = ArrowTile(
      id: 37,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 5,
      column: 1,
    );
    layout[37] = ArrowTile(
      id: 38,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 2,
    );
    layout[38] = ArrowTile(
      id: 39,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 5,
      column: 3,
    );
    layout[39] = ArrowTile(
      id: 40,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 5,
      column: 4,
    );
    layout[40] = ArrowTile(
      id: 41,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 5,
      column: 5,
    );
    layout[41] = ArrowTile(
      id: 42,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 6,
    );

    // Bottom row (row 6)
    layout[42] = ArrowTile(
      id: 43,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 6,
      column: 0,
    );
    layout[43] = ArrowTile(
      id: 44,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 6,
      column: 1,
    );
    layout[44] = ArrowTile(
      id: 45,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 6,
      column: 2,
    );
    layout[45] = ArrowTile(
      id: 46,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 6,
      column: 3,
    );
    layout[46] = ArrowTile(
      id: 47,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 6,
      column: 4,
    );
    layout[47] = ArrowTile(
      id: 48,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 6,
      column: 5,
    );
    layout[48] = ArrowTile(
      id: 49,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 6,
      column: 6,
    );

    // Solution sequence - a flow pattern through the grid
    final solution = [
      1,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      21,
      28,
      35,
      42,
      49,
      48,
      47,
      46,
      45,
      44,
      43,
      36,
      37,
      38,
      39,
      40,
      41,
      34,
      33,
      32,
      31,
      30,
      29,
      22,
      23,
      24,
      25,
      26,
      27,
      20,
      19,
      18,
      17,
      16,
      15,
      2,
      3,
      4,
      5,
      6,
      7,
    ];

    return GameLevel(
      id: 9,
      name: 'Vortex Flow',
      description:
          'Navigate through a flowing vortex pattern in a larger grid.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
      gridSize: gridSize, // Explicitly set the grid size to 7
    );
  }

  /// Level 11: Symmetry - A complex symmetric pattern with strategic obstacles
  static GameLevel _createLevel11() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a complex pattern with obstacles forming a pattern

    // Add obstacles in a complex pattern
    layout[0] = ObstacleTile(
      id: 90,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 0,
    );

    layout[4] = ObstacleTile(
      id: 91,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 4,
    );

    layout[6] = ObstacleTile(
      id: 92,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 1,
    );

    layout[8] = ObstacleTile(
      id: 93,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 3,
    );

    layout[12] = ObstacleTile(
      id: 94,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 2,
    );

    layout[16] = ObstacleTile(
      id: 95,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 1,
    );

    layout[18] = ObstacleTile(
      id: 96,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 3,
    );

    layout[20] = ObstacleTile(
      id: 97,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 0,
    );

    layout[24] = ObstacleTile(
      id: 98,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 4,
    );

    // Top row
    // Obstacle at [0, 0]
    layout[1] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 3,
    );
    // Obstacle at [0, 4]

    // Second row
    layout[5] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );
    // Obstacle at [1, 1]
    layout[7] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 1,
      column: 2,
    );
    // Obstacle at [1, 3]
    layout[9] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    // Obstacle at [2, 2]
    layout[13] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 11,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 3,
      column: 0,
    );
    // Obstacle at [3, 1]
    layout[17] = ArrowTile(
      id: 12,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    // Obstacle at [3, 3]
    layout[19] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 4,
    );

    // Bottom row
    // Obstacle at [4, 0]
    layout[21] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    // Obstacle at [4, 4]

    // Solution sequence
    final solution = [1, 2, 3, 6, 10, 13, 16, 15, 14, 11, 7, 8, 9, 12, 5, 4];

    return GameLevel(
      id: 11,
      name: 'Symmetry',
      description:
          'Navigate a complex symmetric pattern with strategic obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
    );
  }

  /// Level 12: Grand Finale - The ultimate challenge with a larger 7x7 grid
  static GameLevel _createLevel12() {
    final gridSize = 7;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a challenging 7x7 grid without obstacles
    // The larger grid size itself increases the difficulty

    // Top row (row 0)
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 5,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 6,
    );

    // Row 1
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 1,
      column: 5,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 6,
    );

    // Row 2
    layout[14] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 3,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 5,
    );
    layout[20] = ArrowTile(
      id: 21,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 6,
    );

    // Row 3
    layout[21] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[22] = ArrowTile(
      id: 23,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 1,
    );
    layout[23] = ArrowTile(
      id: 24,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );
    layout[25] = ArrowTile(
      id: 26,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );
    layout[26] = ArrowTile(
      id: 27,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 5,
    );
    layout[27] = ArrowTile(
      id: 28,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 6,
    );

    // Row 4
    layout[28] = ArrowTile(
      id: 29,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[29] = ArrowTile(
      id: 30,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[30] = ArrowTile(
      id: 31,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[31] = ArrowTile(
      id: 32,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[32] = ArrowTile(
      id: 33,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );
    layout[33] = ArrowTile(
      id: 34,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 5,
    );
    layout[34] = ArrowTile(
      id: 35,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 4,
      column: 6,
    );

    // Row 5
    layout[35] = ArrowTile(
      id: 36,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 5,
      column: 0,
    );
    layout[36] = ArrowTile(
      id: 37,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 5,
      column: 1,
    );
    layout[37] = ArrowTile(
      id: 38,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 2,
    );
    layout[38] = ArrowTile(
      id: 39,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 5,
      column: 3,
    );
    layout[39] = ArrowTile(
      id: 40,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 5,
      column: 4,
    );
    layout[40] = ArrowTile(
      id: 41,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 5,
      column: 5,
    );
    layout[41] = ArrowTile(
      id: 42,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 5,
      column: 6,
    );

    // Bottom row (row 6)
    layout[42] = ArrowTile(
      id: 43,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 6,
      column: 0,
    );
    layout[43] = ArrowTile(
      id: 44,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 6,
      column: 1,
    );
    layout[44] = ArrowTile(
      id: 45,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 6,
      column: 2,
    );
    layout[45] = ArrowTile(
      id: 46,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 6,
      column: 3,
    );
    layout[46] = ArrowTile(
      id: 47,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 6,
      column: 4,
    );
    layout[47] = ArrowTile(
      id: 48,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 6,
      column: 5,
    );
    layout[48] = ArrowTile(
      id: 49,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 6,
      column: 6,
    );

    // Solution sequence - a challenging path through the 7x7 grid
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      14,
      21,
      28,
      35,
      42,
      49,
      48,
      47,
      46,
      45,
      44,
      43,
      36,
      37,
      38,
      39,
      40,
      41,
      34,
      33,
      32,
      31,
      30,
      29,
      22,
      23,
      24,
      25,
      26,
      27,
      20,
      19,
      18,
      17,
      16,
      15,
      8,
      9,
      10,
      11,
      12,
      13,
    ];

    return GameLevel(
      id: 12,
      name: 'Grand Finale',
      description: 'The ultimate challenge with a larger 7x7 grid.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
      gridSize: gridSize, // Explicitly set the grid size to 7
    );
  }

  /// Generate beginner levels
  static List<GameLevel> _getBeginnerLevels() {
    final List<GameLevel> levels = [];

    // Add beginner levels (12 total)
    for (int i = 1; i <= 12; i++) {
      try {
        // Try to use extended level generator first
        final level = _callExtendedLevelGenerator('createBeginnerLevel$i');
        if (level != null) {
          levels.add(level);
          continue;
        }

        // Fall back to basic levels for the first few
        if (i == 1) {
          levels.add(_createLevel1());
        } else if (i == 2) {
          levels.add(_createLevel2());
        } else {
          // For any remaining levels, create a placeholder
          levels.add(
            _createPlaceholderLevel(
              100 + i,
              'Beginner Level $i',
              'A beginner friendly puzzle.',
              'Tranquil Beginnings',
            ),
          );
        }
      } catch (e) {
        print('Error creating beginner level $i: $e');
        // Create a placeholder level if method doesn't exist
        levels.add(
          _createPlaceholderLevel(
            100 + i,
            'Beginner Level $i',
            'A beginner friendly puzzle.',
            'Tranquil Beginnings',
          ),
        );
      }
    }

    return levels;
  }

  /// Generate intermediate levels
  static List<GameLevel> _getIntermediateLevels() {
    final List<GameLevel> levels = [];

    // Add intermediate levels (12 total)
    for (int i = 1; i <= 12; i++) {
      try {
        // Try to use extended level generator first
        final level = _callExtendedLevelGenerator('createIntermediateLevel$i');
        if (level != null) {
          levels.add(level);
          continue;
        }

        // Fall back to basic level for the first one
        if (i == 1) {
          levels.add(_createLevel3());
        } else {
          // For any remaining levels, create a placeholder
          levels.add(
            _createPlaceholderLevel(
              200 + i,
              'Intermediate Level $i',
              'A more challenging puzzle.',
              'Colorful Maze',
            ),
          );
        }
      } catch (e) {
        print('Error creating intermediate level $i: $e');
        // Create a placeholder level if method doesn't exist
        levels.add(
          _createPlaceholderLevel(
            200 + i,
            'Intermediate Level $i',
            'A more challenging puzzle.',
            'Colorful Maze',
          ),
        );
      }
    }

    return levels;
  }

  /// Generate advanced levels
  static List<GameLevel> _getAdvancedLevels() {
    final List<GameLevel> levels = [];

    // Add advanced levels (12 total)
    for (int i = 1; i <= 12; i++) {
      try {
        // Try to use extended level generator first
        final level = _callExtendedLevelGenerator('createAdvancedLevel$i');
        if (level != null) {
          levels.add(level);
          continue;
        }

        // Create placeholder levels
        levels.add(
          _createPlaceholderLevel(
            300 + i,
            'Advanced Level $i',
            'A challenging puzzle for experts.',
            'Core Challenge',
          ),
        );
      } catch (e) {
        print('Error creating advanced level $i: $e');
        // Create a placeholder level if method doesn't exist
        levels.add(
          _createPlaceholderLevel(
            300 + i,
            'Advanced Level $i',
            'A challenging puzzle for experts.',
            'Core Challenge',
          ),
        );
      }
    }

    return levels;
  }

  /// Check if a position is on the edge of the grid
  static bool _isEdgePosition(int row, int col, int gridSize) {
    return row == 0 || col == 0 || row == gridSize - 1 || col == gridSize - 1;
  }

  /// Check if a direction points outward from the edge
  static bool _isOutwardDirection(
    int row,
    int col,
    ArrowDirection direction,
    int gridSize,
  ) {
    if (row == 0 && direction == ArrowDirection.up) return true;
    if (row == gridSize - 1 && direction == ArrowDirection.down) return true;
    if (col == 0 && direction == ArrowDirection.left) return true;
    if (col == gridSize - 1 && direction == ArrowDirection.right) return true;
    return false;
  }

  /// Validate that no arrows face each other directly
  static bool _validateNoOpposingArrows(List<ArrowTile?> layout, int gridSize) {
    // Check rows for opposing arrows
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize - 1; col++) {
        final currentTile = layout[row * gridSize + col];

        // Skip empty cells
        if (currentTile == null) continue;

        // Check all cells to the right in the same row
        for (int nextCol = col + 1; nextCol < gridSize; nextCol++) {
          final nextTile = layout[row * gridSize + nextCol];

          // Skip empty cells
          if (nextTile == null) continue;

          // If we found a non-empty cell, check if it's opposing
          if (currentTile.direction == ArrowDirection.right &&
              nextTile.direction == ArrowDirection.left) {
            return false; // Opposing arrows found
          }

          // We only need to check the first non-empty cell to the right
          break;
        }
      }
    }

    // Check columns for opposing arrows
    for (int col = 0; col < gridSize; col++) {
      for (int row = 0; row < gridSize - 1; row++) {
        final currentTile = layout[row * gridSize + col];

        // Skip empty cells
        if (currentTile == null) continue;

        // Check all cells below in the same column
        for (int nextRow = row + 1; nextRow < gridSize; nextRow++) {
          final nextTile = layout[nextRow * gridSize + col];

          // Skip empty cells
          if (nextTile == null) continue;

          // If we found a non-empty cell, check if it's opposing
          if (currentTile.direction == ArrowDirection.down &&
              nextTile.direction == ArrowDirection.up) {
            return false; // Opposing arrows found
          }

          // We only need to check the first non-empty cell below
          break;
        }
      }
    }

    return true; // No opposing arrows found
  }

  /// Get themed description for beginner levels
  static String _getBeginnerLevelDescription(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return 'First steps into the tranquil garden.';
      case 2:
        return 'Follow the winding garden path.';
      case 3:
        return 'Navigate around stone markers.';
      case 4:
        return 'Find your way through the flower beds.';
      case 5:
        return 'A serene walk through the garden maze.';
      case 6:
        return 'Explore the garden\'s hidden corners.';
      case 7:
        return 'Wander among the flowering trees.';
      case 8:
        return 'Discover the garden\'s secret patterns.';
      case 9:
        return 'A peaceful journey through the garden.';
      case 10:
        return 'Traverse the garden\'s winding paths.';
      case 11:
        return 'Find harmony in the garden\'s design.';
      case 12:
        return 'Complete your garden exploration.';
      default:
        return 'A beginner-friendly garden puzzle.';
    }
  }

  /// Get themed description for intermediate levels
  static String _getIntermediateLevelDescription(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return 'Enter the ancient stone labyrinth.';
      case 2:
        return 'Navigate the twisting corridors.';
      case 3:
        return 'Find your path through crumbling walls.';
      case 4:
        return 'Discover hidden passages in the maze.';
      case 5:
        return 'Spiral through the metal-bound chambers.';
      case 6:
        return 'Traverse the labyrinth\'s inner sanctum.';
      case 7:
        return 'Unravel the secrets of the ancient maze.';
      case 8:
        return 'Navigate the labyrinth\'s forgotten halls.';
      case 9:
        return 'Find your way through shifting passages.';
      case 10:
        return 'Explore the labyrinth\'s deepest chambers.';
      case 11:
        return 'Overcome the maze\'s final challenges.';
      case 12:
        return 'Master the ancient labyrinth\'s secrets.';
      default:
        return 'A challenging labyrinth puzzle.';
    }
  }

  /// Get themed description for advanced levels
  static String _getAdvancedLevelDescription(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return 'Journey through the cosmic void.';
      case 2:
        return 'Navigate the stellar pathways.';
      case 3:
        return 'Traverse the constellation patterns.';
      case 4:
        return 'Find your way through the triple nebula.';
      case 5:
        return 'Master the gravitational anomalies.';
      case 6:
        return 'Chart a course through the asteroid field.';
      case 7:
        return 'Navigate the interstellar currents.';
      case 8:
        return 'Unravel the cosmic puzzle matrix.';
      case 9:
        return 'Explore the boundaries of space-time.';
      case 10:
        return 'Overcome the celestial challenge.';
      case 11:
        return 'Master the galactic pathways.';
      case 12:
        return 'Complete your cosmic journey.';
      default:
        return 'An expert-level celestial puzzle.';
    }
  }

  /// Count outward-pointing arrows in a layout
  static int _countOutwardPointingArrows(
    List<ArrowTile?> layout,
    int gridSize,
  ) {
    int count = 0;
    for (int i = 0; i < layout.length; i++) {
      if (layout[i] != null) {
        final row = layout[i]!.row;
        final col = layout[i]!.column;
        final direction = layout[i]!.direction;

        if (_isEdgePosition(row, col, gridSize) &&
            _isOutwardDirection(row, col, direction, gridSize)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Create a beginner level 3 - Garden Crossroads
  static GameLevel _createBeginnerLevel3() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Fill the grid with arrows in a crossroads pattern with minimal empty spaces

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    // Stone obstacle in the center
    layout[12] = ObstacleTile(
      id: 99,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 21,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 23,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 24,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      4,
      5,
      10,
      14,
      19,
      24,
      23,
      22,
      21,
      20,
      15,
      16,
      17,
      18,
      13,
      12,
      11,
      6,
      7,
      8,
      9,
    ];

    return GameLevel(
      id: 103,
      name: 'Garden Crossroads',
      description: _getBeginnerLevelDescription(3),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Mystic Gardens',
    );
  }

  /// Create a beginner level 4 - Garden Squares
  static GameLevel _createBeginnerLevel4() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Fill the grid with arrows in a square pattern

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 15,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 20,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 21,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 22,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      4,
      5,
      10,
      15,
      20,
      25,
      24,
      23,
      22,
      21,
      16,
      11,
      6,
      7,
      8,
      9,
      14,
      19,
      18,
      17,
      12,
      13,
    ];

    return GameLevel(
      id: 104,
      name: 'Garden Squares',
      description: _getBeginnerLevelDescription(4),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Mystic Gardens',
    );
  }

  /// Create a beginner level 6 - Garden Pathways
  static GameLevel _createBeginnerLevel6() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a pathway pattern with obstacles

    // Stone obstacles forming a path
    layout[1] = ObstacleTile(
      id: 90,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 1,
    );

    layout[3] = ObstacleTile(
      id: 91,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 3,
    );

    layout[7] = ObstacleTile(
      id: 92,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 2,
    );

    layout[11] = ObstacleTile(
      id: 93,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 1,
    );

    layout[13] = ObstacleTile(
      id: 94,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 3,
    );

    layout[17] = ObstacleTile(
      id: 95,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 2,
    );

    layout[21] = ObstacleTile(
      id: 96,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 1,
    );

    layout[23] = ObstacleTile(
      id: 97,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 3,
    );

    // Arrow tiles forming paths between obstacles
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );

    layout[2] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 2,
    );

    layout[4] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 4,
    );

    layout[5] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );

    layout[6] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );

    layout[8] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 3,
    );

    layout[9] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 4,
    );

    layout[10] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 0,
    );

    layout[12] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );

    layout[14] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 4,
    );

    layout[15] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 0,
    );

    layout[16] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 1,
    );

    layout[18] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );

    layout[19] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );

    layout[20] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 0,
    );

    layout[22] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 2,
    );

    layout[24] = ArrowTile(
      id: 17,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      7,
      10,
      14,
      24,
      17,
      16,
      13,
      9,
      6,
      5,
      12,
      15,
      11,
      8,
      4,
    ];

    return GameLevel(
      id: 106,
      name: 'Garden Pathways',
      description: _getBeginnerLevelDescription(6),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Mystic Gardens',
    );
  }

  /// Create a beginner level 7 - Garden Maze
  static GameLevel _createBeginnerLevel7() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a maze-like pattern with arrows

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    layout[6] = ObstacleTile(
      id: 90,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 1,
    );
    layout[7] = ObstacleTile(
      id: 91,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 2,
    );
    layout[8] = ObstacleTile(
      id: 92,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 0,
    );
    layout[16] = ObstacleTile(
      id: 93,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 1,
    );
    layout[17] = ObstacleTile(
      id: 94,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 2,
    );
    layout[18] = ObstacleTile(
      id: 95,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 19,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      4,
      5,
      7,
      12,
      14,
      19,
      18,
      17,
      16,
      15,
      13,
      8,
      9,
      10,
      11,
      6,
    ];

    return GameLevel(
      id: 107,
      name: 'Garden Maze',
      description: _getBeginnerLevelDescription(7),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Mystic Gardens',
    );
  }

  /// Create a beginner level 5 - Garden Bloom
  static GameLevel _createBeginnerLevel5() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a flower-like pattern with arrows pointing outward from center

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    // Garden feature in the center
    layout[12] = ObstacleTile(
      id: 98,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 14,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 17,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 19,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 21,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 23,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 24,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      4,
      5,
      7,
      8,
      9,
      12,
      13,
      16,
      17,
      18,
      20,
      21,
      22,
      23,
      24,
      6,
      10,
      11,
      14,
      15,
      19,
    ];

    return GameLevel(
      id: 105,
      name: 'Garden Bloom',
      description: _getBeginnerLevelDescription(5),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Mystic Gardens',
    );
  }

  /// Level 1: First Flight - A simple introduction level
  static GameLevel _createLevel1() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Fill the grid with a simple pattern for beginners
    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 15,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 20,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 21,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 22,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // Solution sequence - a logical order to clear the board
    final solution = [
      1,
      2,
      3,
      4,
      5,
      10,
      15,
      20,
      25,
      24,
      23,
      22,
      21,
      16,
      11,
      6,
      17,
      18,
      19,
      14,
      13,
      12,
      7,
      8,
      9,
    ];

    return GameLevel(
      id: 1,
      name: 'First Flight',
      description: 'Begin your journey with a simple arrangement of arrows.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
    );
  }

  /// Level 2: Cornerstone - Introduces a single obstacle in the center
  static GameLevel _createLevel2() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // 中心位置使用普通箭头，不再使用障碍物
    layout[12] = ArrowTile(
      id: 99,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    // Center has obstacle
    layout[13] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 21,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 23,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 24,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Solution sequence - a logical order to clear the board
    final solution = [
      1,
      2,
      3,
      4,
      5,
      10,
      14,
      19,
      24,
      23,
      22,
      21,
      20,
      15,
      16,
      17,
      18,
      13,
      12,
      11,
      6,
      7,
      8,
      9,
    ];

    return GameLevel(
      id: 2,
      name: 'Cornerstone',
      description: 'Navigate around a central obstacle to clear the board.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
    );
  }

  /// Try to call a method from the extended level generator
  static GameLevel? _callExtendedLevelGenerator(String methodName) {
    // We don't actually call the extended level generator directly anymore
    // to avoid circular dependencies that cause stack overflow

    // Instead, return null and let the fallback levels be used
    // This is more efficient and avoids the stack overflow errors
    return null;
  }

  /// Create a themed placeholder level when a specific level is not implemented
  static GameLevel _createPlaceholderLevel(
    int id,
    String name,
    String description,
    String levelPack,
  ) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a more interesting layout based on level pack
    if (levelPack == 'Mystic Gardens') {
      // Garden themed layout with a few stone obstacles

      // Add some stone obstacles representing garden features
      layout[7] = ObstacleTile(
        id: 90,
        type: ObstacleType.stone,
        color: Colors.grey,
        row: 1,
        column: 2,
      );

      layout[17] = ObstacleTile(
        id: 91,
        type: ObstacleType.stone,
        color: Colors.grey,
        row: 3,
        column: 2,
      );

      // Create a garden path pattern with arrows
      for (int i = 0; i < gridSize; i++) {
        // Top row - alternating directions
        layout[i] = ArrowTile(
          id: i + 1,
          direction: i % 2 == 0 ? ArrowDirection.down : ArrowDirection.right,
          color: i % 2 == 0 ? AppColors.arrowBlue : AppColors.arrowGreen,
          row: 0,
          column: i,
        );

        // Bottom row - all pointing up
        layout[(gridSize - 1) * gridSize + i] = ArrowTile(
          id: 20 - i,
          direction: ArrowDirection.up,
          color: i % 2 == 0 ? AppColors.arrowTerracotta : AppColors.arrowPink,
          row: gridSize - 1,
          column: i,
        );
      }

      // Add side columns
      for (int i = 1; i < gridSize - 1; i++) {
        // Left column - pointing right
        layout[i * gridSize] = ArrowTile(
          id: 10 + i,
          direction: ArrowDirection.right,
          color: AppColors.arrowBlue,
          row: i,
          column: 0,
        );

        // Right column - pointing left
        layout[i * gridSize + (gridSize - 1)] = ArrowTile(
          id: 15 + i,
          direction: ArrowDirection.left,
          color: AppColors.arrowTerracotta,
          row: i,
          column: gridSize - 1,
        );
      }
    } else if (levelPack == 'Ancient Labyrinth') {
      // Maze themed layout with more obstacles

      // Add maze walls as obstacles
      layout[1] = ObstacleTile(
        id: 90,
        type: ObstacleType.stone,
        color: Colors.grey,
        row: 0,
        column: 1,
      );

      layout[3] = ObstacleTile(
        id: 91,
        type: ObstacleType.stone,
        color: Colors.grey,
        row: 0,
        column: 3,
      );

      layout[6] = ObstacleTile(
        id: 92,
        type: ObstacleType.stone,
        color: Colors.grey,
        row: 1,
        column: 1,
      );

      layout[8] = ObstacleTile(
        id: 93,
        type: ObstacleType.stone,
        color: Colors.grey,
        row: 1,
        column: 3,
      );

      layout[11] = ObstacleTile(
        id: 94,
        type: ObstacleType.metal,
        color: Colors.grey[400]!,
        row: 2,
        column: 1,
      );

      layout[13] = ObstacleTile(
        id: 95,
        type: ObstacleType.metal,
        color: Colors.grey[400]!,
        row: 2,
        column: 3,
      );

      // Create a maze path with arrows
      layout[0] = ArrowTile(
        id: 1,
        direction: ArrowDirection.right,
        color: AppColors.arrowBlue,
        row: 0,
        column: 0,
      );

      layout[2] = ArrowTile(
        id: 2,
        direction: ArrowDirection.down,
        color: AppColors.arrowTerracotta,
        row: 0,
        column: 2,
      );

      layout[4] = ArrowTile(
        id: 3,
        direction: ArrowDirection.down,
        color: AppColors.arrowGreen,
        row: 0,
        column: 4,
      );

      layout[7] = ArrowTile(
        id: 4,
        direction: ArrowDirection.down,
        color: AppColors.arrowPink,
        row: 1,
        column: 2,
      );

      layout[9] = ArrowTile(
        id: 5,
        direction: ArrowDirection.left,
        color: AppColors.arrowBlue,
        row: 1,
        column: 4,
      );

      layout[12] = ArrowTile(
        id: 6,
        direction: ArrowDirection.right,
        color: AppColors.arrowTerracotta,
        row: 2,
        column: 2,
      );

      layout[14] = ArrowTile(
        id: 7,
        direction: ArrowDirection.down,
        color: AppColors.arrowGreen,
        row: 2,
        column: 4,
      );

      // Add more arrows to complete the maze
      for (int i = 0; i < gridSize; i++) {
        // Bottom row
        if (i != 2) {
          // Skip the middle column
          layout[(gridSize - 1) * gridSize + i] = ArrowTile(
            id: 15 + i,
            direction: i < 2 ? ArrowDirection.right : ArrowDirection.left,
            color: i % 2 == 0 ? AppColors.arrowPink : AppColors.arrowBlue,
            row: gridSize - 1,
            column: i,
          );
        }
      }
    } else {
      // Celestial Puzzles
      // Cosmic themed layout with ice obstacles

      // Add ice obstacles representing cosmic anomalies
      layout[6] = ObstacleTile(
        id: 90,
        type: ObstacleType.ice,
        color: Colors.lightBlue[100]!,
        row: 1,
        column: 1,
      );

      layout[8] = ObstacleTile(
        id: 91,
        type: ObstacleType.ice,
        color: Colors.lightBlue[100]!,
        row: 1,
        column: 3,
      );

      layout[16] = ObstacleTile(
        id: 92,
        type: ObstacleType.ice,
        color: Colors.lightBlue[100]!,
        row: 3,
        column: 1,
      );

      layout[18] = ObstacleTile(
        id: 93,
        type: ObstacleType.ice,
        color: Colors.lightBlue[100]!,
        row: 3,
        column: 3,
      );

      // Add metal obstacles representing space stations
      layout[12] = ObstacleTile(
        id: 94,
        type: ObstacleType.metal,
        color: Colors.grey[400]!,
        row: 2,
        column: 2,
      );

      // Create a cosmic pattern with arrows
      layout[0] = ArrowTile(
        id: 1,
        direction: ArrowDirection.right,
        color: AppColors.arrowBlue,
        row: 0,
        column: 0,
      );

      layout[1] = ArrowTile(
        id: 2,
        direction: ArrowDirection.right,
        color: AppColors.arrowTerracotta,
        row: 0,
        column: 1,
      );

      layout[2] = ArrowTile(
        id: 3,
        direction: ArrowDirection.right,
        color: AppColors.arrowGreen,
        row: 0,
        column: 2,
      );

      layout[3] = ArrowTile(
        id: 4,
        direction: ArrowDirection.right,
        color: AppColors.arrowPink,
        row: 0,
        column: 3,
      );

      layout[4] = ArrowTile(
        id: 5,
        direction: ArrowDirection.down,
        color: AppColors.arrowBlue,
        row: 0,
        column: 4,
      );

      layout[9] = ArrowTile(
        id: 6,
        direction: ArrowDirection.down,
        color: AppColors.arrowTerracotta,
        row: 1,
        column: 4,
      );

      layout[14] = ArrowTile(
        id: 7,
        direction: ArrowDirection.left,
        color: AppColors.arrowGreen,
        row: 2,
        column: 4,
      );

      layout[13] = ArrowTile(
        id: 8,
        direction: ArrowDirection.left,
        color: AppColors.arrowPink,
        row: 2,
        column: 3,
      );

      layout[11] = ArrowTile(
        id: 9,
        direction: ArrowDirection.left,
        color: AppColors.arrowBlue,
        row: 2,
        column: 1,
      );

      layout[10] = ArrowTile(
        id: 10,
        direction: ArrowDirection.left,
        color: AppColors.arrowTerracotta,
        row: 2,
        column: 0,
      );

      layout[5] = ArrowTile(
        id: 11,
        direction: ArrowDirection.up,
        color: AppColors.arrowGreen,
        row: 1,
        column: 0,
      );

      // Bottom row
      for (int i = 0; i < gridSize; i++) {
        layout[(gridSize - 1) * gridSize + i] = ArrowTile(
          id: 20 - i,
          direction: i % 2 == 0 ? ArrowDirection.up : ArrowDirection.right,
          color: i % 2 == 0 ? AppColors.arrowPink : AppColors.arrowBlue,
          row: gridSize - 1,
          column: i,
        );
      }
    }

    // Generate a solution based on the layout
    final List<int> solution = [];
    int maxId = 0;

    // Find the maximum ID to determine solution length
    for (final tile in layout) {
      if (tile != null && !tile.isObstacle && tile.id > maxId) {
        maxId = tile.id;
      }
    }

    // Create a solution with all tiles
    for (int i = 1; i <= maxId; i++) {
      solution.add(i);
    }

    return GameLevel(
      id: id,
      name: name,
      description: description,
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: levelPack,
    );
  }

  /// Create intermediate level 2 - Ancient Pillars
  static GameLevel _createIntermediateLevel2() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a pattern with stone pillars

    // Stone pillars in a pattern
    layout[1] = ObstacleTile(
      id: 90,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 1,
    );

    layout[3] = ObstacleTile(
      id: 91,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 3,
    );

    layout[6] = ObstacleTile(
      id: 92,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 1,
    );

    layout[8] = ObstacleTile(
      id: 93,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 3,
    );

    layout[12] = ObstacleTile(
      id: 94,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 2,
    );

    layout[16] = ObstacleTile(
      id: 95,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 1,
    );

    layout[18] = ObstacleTile(
      id: 96,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 3,
    );

    layout[21] = ObstacleTile(
      id: 97,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 1,
    );

    layout[23] = ObstacleTile(
      id: 98,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 3,
    );

    // Arrow tiles forming paths between pillars
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );

    layout[2] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 2,
    );

    layout[4] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 4,
    );

    layout[5] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );

    layout[7] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 2,
    );

    layout[9] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );

    layout[10] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );

    layout[11] = ArrowTile(
      id: 8,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );

    layout[13] = ArrowTile(
      id: 9,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );

    layout[14] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 4,
    );

    layout[15] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 0,
    );

    layout[17] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );

    layout[19] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 4,
    );

    layout[20] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 0,
    );

    layout[22] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );

    layout[24] = ArrowTile(
      id: 16,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [1, 2, 3, 6, 10, 13, 16, 15, 14, 11, 12, 9, 8, 7, 4, 5];

    return GameLevel(
      id: 202,
      name: 'Ancient Pillars',
      description: _getIntermediateLevelDescription(2),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Ancient Labyrinth',
    );
  }

  /// Create intermediate level 3 - Temple Ruins
  static GameLevel _createIntermediateLevel3() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a temple ruins pattern

    // Stone and metal obstacles forming temple ruins
    layout[0] = ObstacleTile(
      id: 90,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 0,
    );

    layout[4] = ObstacleTile(
      id: 91,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 4,
    );

    layout[6] = ObstacleTile(
      id: 92,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 1,
    );

    layout[8] = ObstacleTile(
      id: 93,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 3,
    );

    layout[20] = ObstacleTile(
      id: 94,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 0,
    );

    layout[24] = ObstacleTile(
      id: 95,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 4,
    );

    // Arrow tiles forming paths through the temple
    layout[1] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 1,
    );

    layout[2] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 2,
    );

    layout[3] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 3,
    );

    layout[5] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );

    layout[7] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 2,
    );

    layout[9] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );

    layout[10] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );

    layout[11] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );

    layout[12] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );

    layout[13] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 3,
    );

    layout[14] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    layout[15] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );

    layout[16] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );

    layout[17] = ArrowTile(
      id: 14,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );

    layout[18] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );

    layout[19] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    layout[21] = ArrowTile(
      id: 17,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );

    layout[22] = ArrowTile(
      id: 18,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );

    layout[23] = ArrowTile(
      id: 19,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      6,
      11,
      16,
      19,
      18,
      17,
      13,
      14,
      15,
      10,
      9,
      8,
      7,
      4,
      5,
    ];

    return GameLevel(
      id: 203,
      name: 'Temple Ruins',
      description: _getIntermediateLevelDescription(3),
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Ancient Labyrinth',
    );
  }

  /// Level 4: Material World - Introduces different obstacle types
  static GameLevel _createLevel4() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // 使用普通箭头替代不同类型的障碍物
    layout[6] = ArrowTile(
      id: 90,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );

    layout[8] = ArrowTile(
      id: 91,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 3,
    );

    layout[12] = ArrowTile(
      id: 92,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );

    layout[16] = ArrowTile(
      id: 93,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 3,
      column: 1,
    );

    layout[18] = ArrowTile(
      id: 94,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    // Obstacle at [1, 1]
    layout[7] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );
    // Obstacle at [1, 3]
    layout[9] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );

    // Middle row - navigate around the central metal obstacle
    layout[10] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );
    // Obstacle at [2, 2]
    layout[13] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 0,
    );
    // Obstacle at [3, 1]
    layout[17] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    // Obstacle at [3, 3]
    layout[19] = ArrowTile(
      id: 15,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 16,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 17,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 18,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 19,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Solution sequence
    final solution = [
      1,
      2,
      3,
      4,
      5,
      8,
      12,
      15,
      20,
      19,
      18,
      17,
      16,
      13,
      14,
      11,
      10,
      9,
      6,
      7,
    ];

    return GameLevel(
      id: 4,
      name: 'Material World',
      description: 'Navigate around stone, ice, and metal obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
    );
  }

  /// Level 3: Quadrant - Four obstacles create a challenging path
  static GameLevel _createLevel3() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // 使用普通箭头替代障碍物
    layout[6] = ArrowTile(
      id: 90,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );

    layout[8] = ArrowTile(
      id: 91,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 3,
    );

    layout[16] = ArrowTile(
      id: 92,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 1,
    );

    layout[18] = ArrowTile(
      id: 93,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );

    // Top row - all pointing down to avoid opposing arrows
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    // Obstacle at [1, 1]
    layout[7] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );
    // Obstacle at [1, 3]
    layout[9] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );

    // Middle row - all pointing right to create a clear path
    layout[10] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    // Obstacle at [3, 1]
    layout[17] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 2,
    );
    // Obstacle at [3, 3]
    layout[19] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    // Bottom row - all pointing up to create a clear path
    layout[20] = ArrowTile(
      id: 17,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 18,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 19,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 21,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // Solution sequence - carefully ordered to navigate around obstacles
    final solution = [
      1,
      2,
      3,
      4,
      5,
      8,
      13,
      16,
      21,
      20,
      19,
      18,
      17,
      14,
      15,
      12,
      11,
      10,
      9,
      6,
      7,
    ];

    return GameLevel(
      id: 3,
      name: 'Quadrant',
      description: 'Navigate around four stone obstacles to clear the board.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Glyphion',
    );
  }
}
