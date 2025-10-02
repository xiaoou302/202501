import 'package:flutter/material.dart';
import '../models/arrow_tile.dart';
import '../models/game_level.dart';
import '../models/obstacle_tile.dart';
import 'constants.dart';
import 'level_generator.dart';

/// Extended level generator with more levels and obstacles
class ExtendedLevelGenerator {
  /// Call a method by name
  static GameLevel? callMethod(String methodName) {
    switch (methodName) {
      case 'createBeginnerLevel1':
        return getLevelById(101);
      case 'createBeginnerLevel2':
        return getLevelById(102);
      case 'createBeginnerLevel3':
        return getLevelById(103);
      case 'createBeginnerLevel4':
        return getLevelById(104);
      case 'createBeginnerLevel5':
        return _createLevel105();
      case 'createBeginnerLevel6':
        return _createLevel106();
      case 'createBeginnerLevel7':
        return _createLevel107();
      case 'createBeginnerLevel8':
        return _createLevel108();
      case 'createBeginnerLevel9':
        return _createLevel109();
      case 'createBeginnerLevel10':
        return _createLevel110();
      case 'createBeginnerLevel11':
        return _createLevel111();
      case 'createBeginnerLevel12':
        return _createLevel112();
      case 'createIntermediateLevel1':
        return getLevelById(201);
      case 'createIntermediateLevel2':
        return getLevelById(202);
      case 'createIntermediateLevel3':
        return getLevelById(203);
      case 'createIntermediateLevel4':
        return getLevelById(204);
      case 'createIntermediateLevel5':
        return _createLevel205();
      case 'createIntermediateLevel6':
        return _createLevel206();
      case 'createIntermediateLevel7':
        return _createLevel207();
      case 'createIntermediateLevel8':
        return _createLevel208();
      case 'createIntermediateLevel9':
        return _createLevel209();
      case 'createIntermediateLevel10':
        return _createLevel210();
      case 'createIntermediateLevel11':
        return _createLevel211();
      case 'createIntermediateLevel12':
        return _createLevel212();
      case 'createAdvancedLevel1':
        return getLevelById(301);
      case 'createAdvancedLevel2':
        return getLevelById(302);
      case 'createAdvancedLevel3':
        return getLevelById(303);
      case 'createAdvancedLevel4':
        return _createLevel304();
      case 'createAdvancedLevel5':
        return _createLevel305();
      case 'createAdvancedLevel6':
        return _createLevel306();
      case 'createAdvancedLevel7':
        return _createLevel307();
      case 'createAdvancedLevel8':
        return _createLevel308();
      case 'createAdvancedLevel9':
        return _createLevel309();
      case 'createAdvancedLevel10':
        return _createLevel310();
      case 'createAdvancedLevel11':
        return _createLevel311();
      case 'createAdvancedLevel12':
        return _createLevel312();
      default:
        return null;
    }
  }

  /// Get level packs from the base generator
  static List<String> getLevelPacks() {
    return LevelGenerator.getLevelPacks();
  }

  /// Get all levels for a specific pack
  static List<GameLevel> getLevelsForPack(String packName) {
    switch (packName) {
      case 'Tranquil Beginnings':
        return _getBeginnerLevels();
      case 'Colorful Maze':
        return _getIntermediateLevels();
      case 'Core Challenge':
        return _getAdvancedLevels();
      default:
        return [];
    }
  }

  /// Get level by ID
  static GameLevel? getLevelById(int levelId) {
    // Check beginner levels
    for (final level in _getBeginnerLevels()) {
      if (level.id == levelId) return level;
    }

    // Check intermediate levels
    for (final level in _getIntermediateLevels()) {
      if (level.id == levelId) return level;
    }

    // Check advanced levels
    for (final level in _getAdvancedLevels()) {
      if (level.id == levelId) return level;
    }

    return null;
  }

  /// Generate beginner levels
  static List<GameLevel> _getBeginnerLevels() {
    final List<GameLevel> levels = [];

    // Level 1-1: Use our own implementation instead of calling LevelGenerator
    // to avoid circular dependencies
    levels.add(_createLevel101());

    // Level 1-2: Use our own implementation instead of calling LevelGenerator
    // to avoid circular dependencies
    levels.add(_createLevel102());

    // Level 1-3: Introduction to obstacles
    levels.add(_createLevel103());

    // Level 1-4: More obstacles
    levels.add(_createLevel104());

    // Level 1-5: Circle pattern
    levels.add(_createLevel105());

    // Level 1-6: Cross pattern
    levels.add(_createLevel106());

    // Level 1-7: Zigzag pattern
    levels.add(_createLevel107());

    // Level 1-8: Diamond pattern
    levels.add(_createLevel108());

    // Level 1-9: Spiral pattern
    levels.add(_createLevel109());

    // Level 1-10: Star pattern
    levels.add(_createLevel110());

    // Level 1-11: Checkerboard pattern
    levels.add(_createLevel111());

    // Level 1-12: Mixed pattern
    levels.add(_createLevel112());

    return levels;
  }

  /// Create Level 1-1: Introduction level
  static GameLevel _createLevel101() {
    // This is a copy of LevelGenerator._createLevel1
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create tiles with reduced outward-pointing arrows
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

    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    // Empty cell at [2, 2]
    layout[13] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    layout[15] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 17,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    layout[20] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 21,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 22,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      9,
      10,
      13,
      14,
      16,
      17,
      18,
      19,
      7,
      8,
      11,
      15,
      20,
      21,
      22,
      23,
      24,
      12,
    ];

    return GameLevel(
      id: 101,
      name: 'First Steps',
      description: 'Begin your journey with a simple puzzle.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Tranquil Beginnings',
    );
  }

  /// Create Level 1-2: More challenging level
  static GameLevel _createLevel102() {
    // This is a copy of LevelGenerator._createLevel2
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
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
      direction: ArrowDirection.down,
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
      direction: ArrowDirection.down,
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
    // Empty cell at [2, 2]
    layout[13] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 21,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 22,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final solution = [
      1,
      2,
      3,
      4,
      5,
      7,
      10,
      13,
      14,
      16,
      18,
      19,
      6,
      8,
      9,
      12,
      17,
      15,
      20,
      21,
      22,
      23,
      24,
      11,
    ];

    return GameLevel(
      id: 102,
      name: 'Strategic Thinking',
      description: 'Plan your moves carefully to clear the board.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Tranquil Beginnings',
    );
  }

  /// Create Level 2-1: Intermediate level with complex paths
  static GameLevel _createLevel201() {
    // This is a copy of LevelGenerator._createLevel3
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
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
    // Empty cell at [0, 2]
    layout[3] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 3,
    );
    // Empty cell at [1, 4]

    // Middle row
    // Empty cell at [2, 0]
    layout[11] = ArrowTile(
      id: 9,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    // Empty cell at [3, 1]
    layout[17] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 15,
      direction: ArrowDirection.down,
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

    // Bottom row
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
    // Empty cell at [4, 3]
    layout[24] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final solution = [
      1,
      2,
      3,
      4,
      7,
      9,
      14,
      11,
      15,
      16,
      12,
      5,
      6,
      8,
      10,
      13,
      17,
      18,
      19,
      20,
    ];

    return GameLevel(
      id: 201,
      name: 'Maze Runner',
      description: 'Navigate through a complex maze of arrows.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Colorful Maze',
    );
  }

  /// Generate intermediate levels
  static List<GameLevel> _getIntermediateLevels() {
    final List<GameLevel> levels = [];

    // Level 2-1: Use our own implementation instead of calling LevelGenerator
    // to avoid circular dependencies
    levels.add(_createLevel201());

    // Level 2-2: Intermediate level with obstacles
    levels.add(_createLevel202());

    // Level 2-3: Complex paths with obstacles
    levels.add(_createLevel203());

    // Level 2-4: Maze-like level
    levels.add(_createLevel204());

    // Level 2-5: Hexagon pattern
    levels.add(_createLevel205());

    // Level 2-6: Octagon pattern
    levels.add(_createLevel206());

    // Level 2-7: Hourglass pattern
    levels.add(_createLevel207());

    // Level 2-8: Pyramid pattern
    levels.add(_createLevel208());

    // Level 2-9: Labyrinth pattern
    levels.add(_createLevel209());

    // Level 2-10: Flower pattern
    levels.add(_createLevel210());

    // Level 2-11: Butterfly pattern
    levels.add(_createLevel211());

    // Level 2-12: Snowflake pattern
    levels.add(_createLevel212());

    return levels;
  }

  /// Generate advanced levels
  static List<GameLevel> _getAdvancedLevels() {
    final List<GameLevel> levels = [];

    // Level 3-1: Advanced level with obstacles
    levels.add(_createLevel301());

    // Level 3-2: Complex maze with obstacles
    levels.add(_createLevel302());

    // Level 3-3: Very challenging level
    levels.add(_createLevel303());

    // Level 3-4: Castle pattern
    levels.add(_createLevel304());

    // Level 3-5: Fortress pattern
    levels.add(_createLevel305());

    // Level 3-6: Mandala pattern
    levels.add(_createLevel306());

    // Level 3-7: Fractal pattern
    levels.add(_createLevel307());

    // Level 3-8: Puzzle box pattern
    levels.add(_createLevel308());

    // Level 3-9: Maze runner pattern
    levels.add(_createLevel309());

    // Level 3-10: Impossible path pattern
    levels.add(_createLevel310());

    // Level 3-11: Master challenge pattern
    levels.add(_createLevel311());

    // Level 3-12: Ultimate challenge pattern
    levels.add(_createLevel312());

    return levels;
  }

  /// Create Level 1-3: Introduction to obstacles
  static GameLevel _createLevel103() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
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
    layout[2] = ObstacleTile(
      id: 3,
      type: ObstacleType.stone,
      color: Colors.grey,
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
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[11] = ObstacleTile(
      id: 12,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 1,
    );
    // Empty cell at [2, 2]
    layout[13] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ObstacleTile(
      id: 18,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 21,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 22,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final solution = [
      1,
      2,
      4,
      5,
      9,
      10,
      13,
      14,
      19,
      6,
      7,
      8,
      15,
      16,
      17,
      20,
      21,
      22,
      23,
      24,
      11,
    ];

    return GameLevel(
      id: 103,
      name: 'Stone Barriers',
      description: 'Navigate around stone obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Tranquil Beginnings',
    );
  }

  /// Create Level 1-4: More obstacles
  static GameLevel _createLevel104() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ObstacleTile(
      id: 2,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
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
    layout[3] = ObstacleTile(
      id: 4,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[10] = ObstacleTile(
      id: 11,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[12] = ObstacleTile(
      id: 13,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
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
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ObstacleTile(
      id: 19,
      type: ObstacleType.stone,
      color: Colors.grey,
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
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final solution = [
      1,
      3,
      5,
      9,
      10,
      14,
      15,
      20,
      6,
      7,
      8,
      12,
      16,
      17,
      18,
      21,
      22,
      23,
      24,
      25,
    ];

    return GameLevel(
      id: 104,
      name: 'Ice and Stone',
      description: 'Navigate through a mix of obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Tranquil Beginnings',
    );
  }

  /// Create Level 2-2: Intermediate level with obstacles
  static GameLevel _createLevel202() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
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
    // Empty cell at [0, 2]
    layout[3] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ObstacleTile(
      id: 5,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 3,
    );
    layout[9] = ObstacleTile(
      id: 9,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[12] = ObstacleTile(
      id: 12,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    // Empty cell at [3, 1]
    layout[17] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ObstacleTile(
      id: 17,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 21,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    // Empty cell at [4, 3]
    layout[24] = ArrowTile(
      id: 22,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final solution = [
      1,
      2,
      3,
      4,
      7,
      11,
      16,
      18,
      10,
      13,
      14,
      6,
      8,
      15,
      19,
      20,
      21,
      22,
    ];

    return GameLevel(
      id: 202,
      name: 'Metal Blocks',
      description: 'Navigate through metal and stone obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Colorful Maze',
    );
  }

  /// Create Level 2-3: Complex paths with obstacles
  static GameLevel _createLevel203() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ObstacleTile(
      id: 2,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[3] = ObstacleTile(
      id: 4,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
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
    layout[7] = ObstacleTile(
      id: 8,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[10] = ObstacleTile(
      id: 11,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );
    layout[14] = ObstacleTile(
      id: 15,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ObstacleTile(
      id: 17,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
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
    layout[23] = ObstacleTile(
      id: 24,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      1,
      3,
      5,
      9,
      10,
      14,
      19,
      20,
      6,
      7,
      12,
      13,
      16,
      18,
      21,
      22,
      23,
      25,
    ];

    return GameLevel(
      id: 203,
      name: 'Complex Paths',
      description: 'Navigate through a complex maze of obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Colorful Maze',
    );
  }

  /// Create Level 2-4: Maze-like level
  static GameLevel _createLevel204() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
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
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[2] = ObstacleTile(
      id: 3,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[4] = ObstacleTile(
      id: 5,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ObstacleTile(
      id: 6,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
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
    layout[11] = ObstacleTile(
      id: 12,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 2,
    );
    layout[13] = ObstacleTile(
      id: 14,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[15] = ObstacleTile(
      id: 16,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
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
    layout[21] = ObstacleTile(
      id: 22,
      type: ObstacleType.stone,
      color: Colors.grey,
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
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      1,
      2,
      4,
      7,
      8,
      9,
      10,
      13,
      15,
      17,
      18,
      19,
      20,
      11,
      21,
      23,
      24,
      25,
    ];

    return GameLevel(
      id: 204,
      name: 'The Maze',
      description: 'Find your way through the maze.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Colorful Maze',
    );
  }

  /// Create Level 3-1: Advanced level with obstacles
  static GameLevel _createLevel301() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Top row
    layout[0] = ObstacleTile(
      id: 1,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[2] = ObstacleTile(
      id: 3,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[4] = ObstacleTile(
      id: 5,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
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
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[8] = ObstacleTile(
      id: 9,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[10] = ObstacleTile(
      id: 11,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 0,
    );
    layout[11] = ObstacleTile(
      id: 12,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
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
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ObstacleTile(
      id: 18,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 2,
    );
    layout[18] = ObstacleTile(
      id: 19,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[24] = ObstacleTile(
      id: 25,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      2,
      4,
      8,
      10,
      15,
      17,
      20,
      6,
      7,
      13,
      14,
      16,
      21,
      22,
      23,
      24,
    ];

    return GameLevel(
      id: 301,
      name: 'Advanced Challenge',
      description: 'A challenging level with obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create Level 3-2: Complex maze with obstacles
  static GameLevel _createLevel302() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ObstacleTile(
      id: 2,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[3] = ObstacleTile(
      id: 4,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[7] = ObstacleTile(
      id: 8,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
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
    layout[9] = ObstacleTile(
      id: 10,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ObstacleTile(
      id: 11,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
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
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ObstacleTile(
      id: 17,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 1,
    );
    layout[17] = ObstacleTile(
      id: 18,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
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
    layout[23] = ObstacleTile(
      id: 24,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      1,
      3,
      5,
      9,
      12,
      15,
      19,
      20,
      6,
      7,
      13,
      14,
      16,
      21,
      22,
      23,
      25,
    ];

    return GameLevel(
      id: 302,
      name: 'Complex Maze',
      description: 'A complex maze with many obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create Level 3-3: Very challenging level
  static GameLevel _createLevel303() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Top row
    layout[0] = ObstacleTile(
      id: 1,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[2] = ObstacleTile(
      id: 3,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
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
    layout[4] = ObstacleTile(
      id: 5,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 0,
    );
    layout[6] = ObstacleTile(
      id: 7,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );
    layout[8] = ObstacleTile(
      id: 9,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[10] = ObstacleTile(
      id: 11,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
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
    layout[12] = ObstacleTile(
      id: 13,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
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
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ObstacleTile(
      id: 19,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[20] = ObstacleTile(
      id: 21,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[24] = ObstacleTile(
      id: 25,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      2,
      4,
      8,
      10,
      12,
      14,
      15,
      17,
      18,
      20,
      6,
      16,
      22,
      23,
      24,
    ];

    return GameLevel(
      id: 303,
      name: 'Master Challenge',
      description: 'The ultimate test of your skills.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create a template level with a specific pattern
  static GameLevel _createTemplateLevel(
    int levelId,
    String name,
    String description,
    String levelPack,
    List<ArrowTile?> layout,
    List<int> solution,
  ) {
    return GameLevel(
      id: levelId,
      name: name,
      description: description,
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: levelPack,
    );
  }

  /// Create a circle pattern layout
  static List<ArrowTile?> _createCirclePatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a circle pattern of arrows
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

    // Right column
    layout[9] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );
    layout[14] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[24] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );
    layout[23] = ArrowTile(
      id: 10,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[22] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[21] = ArrowTile(
      id: 12,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[20] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );

    // Left column
    layout[15] = ArrowTile(
      id: 14,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[10] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[5] = ArrowTile(
      id: 16,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );

    // Add some obstacles in the middle
    layout[12] = ObstacleTile(
      id: 17,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 2,
    );

    return layout;
  }

  /// Create Level 1-5: Circle pattern
  static GameLevel _createLevel105() {
    final layout = _createCirclePatternLayout(105);
    final solution = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

    return _createTemplateLevel(
      105,
      'Circle Pattern',
      'Navigate around in a circle.',
      'Tranquil Beginnings',
      layout,
      solution,
    );
  }

  /// Create a cross pattern layout
  static List<ArrowTile?> _createCrossPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a cross pattern of arrows
    // Middle row
    layout[10] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 3,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 4,
    );

    // Middle column
    layout[2] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 2,
    );
    layout[7] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );
    // Center is already filled
    layout[17] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[22] = ArrowTile(
      id: 9,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );

    // Add some obstacles in the corners
    layout[0] = ObstacleTile(
      id: 10,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 0,
    );
    layout[4] = ObstacleTile(
      id: 11,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 0,
      column: 4,
    );
    layout[20] = ObstacleTile(
      id: 12,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 0,
    );
    layout[24] = ObstacleTile(
      id: 13,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 4,
    );

    return layout;
  }

  /// Create Level 1-6: Cross pattern
  static GameLevel _createLevel106() {
    final layout = _createCrossPatternLayout(106);
    final solution = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    return _createTemplateLevel(
      106,
      'Cross Pattern',
      'Navigate through a cross pattern.',
      'Tranquil Beginnings',
      layout,
      solution,
    );
  }

  /// Create a zigzag pattern layout
  static List<ArrowTile?> _createZigzagPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a zigzag pattern of arrows
    // Top row zigzag
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

    // Second row zigzag
    layout[7] = ArrowTile(
      id: 4,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[6] = ArrowTile(
      id: 5,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 0,
    );

    // Third row zigzag
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
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );

    // Fourth row zigzag
    layout[17] = ArrowTile(
      id: 10,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[16] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 1,
    );
    layout[15] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );

    // Bottom row zigzag
    layout[20] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
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

    // Add some obstacles
    layout[4] = ObstacleTile(
      id: 16,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 4,
    );
    layout[14] = ObstacleTile(
      id: 17,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 4,
    );
    layout[24] = ObstacleTile(
      id: 18,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 4,
    );

    return layout;
  }

  /// Create Level 1-7: Zigzag pattern
  static GameLevel _createLevel107() {
    final layout = _createZigzagPatternLayout(107);
    final solution = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

    return _createTemplateLevel(
      107,
      'Zigzag Pattern',
      'Navigate through a zigzag pattern.',
      'Tranquil Beginnings',
      layout,
      solution,
    );
  }

  /// Create a diamond pattern layout
  static List<ArrowTile?> _createDiamondPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a diamond pattern of arrows
    // Top point
    layout[2] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 2,
    );

    // Upper sides
    layout[6] = ArrowTile(
      id: 2,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 1,
    );
    layout[8] = ArrowTile(
      id: 3,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );

    // Middle point
    layout[7] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 2,
    );
    layout[12] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );

    // Lower sides
    layout[16] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 1,
    );
    layout[18] = ArrowTile(
      id: 7,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );

    // Bottom point
    layout[17] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[22] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );

    // Add obstacles at the corners
    layout[0] = ObstacleTile(
      id: 10,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 0,
    );
    layout[4] = ObstacleTile(
      id: 11,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 0,
      column: 4,
    );
    layout[20] = ObstacleTile(
      id: 12,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 0,
    );
    layout[24] = ObstacleTile(
      id: 13,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 4,
    );

    return layout;
  }

  /// Create Level 1-8: Diamond pattern
  static GameLevel _createLevel108() {
    final layout = _createDiamondPatternLayout(108);
    final solution = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    return _createTemplateLevel(
      108,
      'Diamond Pattern',
      'Navigate through a diamond pattern.',
      'Tranquil Beginnings',
      layout,
      solution,
    );
  }

  /// Create a spiral pattern layout
  static List<ArrowTile?> _createSpiralPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a spiral pattern of arrows
    // Outer spiral - top row
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

    // Outer spiral - right column
    layout[9] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );
    layout[14] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );
    layout[24] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // Outer spiral - bottom row
    layout[23] = ArrowTile(
      id: 10,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[22] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[21] = ArrowTile(
      id: 12,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[20] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );

    // Outer spiral - left column
    layout[15] = ArrowTile(
      id: 14,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[10] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[5] = ArrowTile(
      id: 16,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );

    // Inner spiral - second row
    layout[6] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );

    // Inner spiral - third row
    layout[13] = ArrowTile(
      id: 20,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 2,
      column: 3,
    );
    layout[12] = ArrowTile(
      id: 21,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );
    layout[11] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );

    // Center
    layout[16] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 25,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );

    return layout;
  }

  /// Create Level 1-9: Spiral pattern
  static GameLevel _createLevel109() {
    final layout = _createSpiralPatternLayout(109);
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
    ];

    return _createTemplateLevel(
      109,
      'Spiral Pattern',
      'Navigate through a spiral pattern.',
      'Tranquil Beginnings',
      layout,
      solution,
    );
  }

  /// Create a star pattern layout
  static List<ArrowTile?> _createStarPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a star pattern of arrows
    // Center
    layout[12] = ArrowTile(
      id: 1,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );

    // Top point
    layout[2] = ArrowTile(
      id: 2,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 2,
    );
    layout[7] = ArrowTile(
      id: 3,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );

    // Right point
    layout[14] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );
    layout[13] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );

    // Bottom point
    layout[22] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[17] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 2,
    );

    // Left point
    layout[10] = ArrowTile(
      id: 8,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 2,
      column: 1,
    );

    // Diagonal points
    // Top-left
    layout[0] = ArrowTile(
      id: 10,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 11,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );

    // Top-right
    layout[4] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 4,
    );
    layout[8] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 3,
    );

    // Bottom-right
    layout[24] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 4,
    );
    layout[18] = ArrowTile(
      id: 15,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );

    // Bottom-left
    layout[20] = ArrowTile(
      id: 16,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );

    return layout;
  }

  /// Create Level 1-10: Star pattern
  static GameLevel _createLevel110() {
    final layout = _createStarPatternLayout(110);
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
    ];

    return _createTemplateLevel(
      110,
      'Star Pattern',
      'Navigate through a star pattern.',
      'Tranquil Beginnings',
      layout,
      solution,
    );
  }

  /// Create a checkerboard pattern layout
  static List<ArrowTile?> _createCheckerboardPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a checkerboard pattern of arrows and obstacles
    // First row
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

    // Second row
    layout[5] = ObstacleTile(
      id: 4,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 0,
    );
    layout[7] = ObstacleTile(
      id: 5,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 2,
    );
    layout[9] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );

    // Third row
    layout[10] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );
    layout[12] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 2,
    );
    layout[14] = ArrowTile(
      id: 9,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ObstacleTile(
      id: 10,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 0,
    );
    layout[17] = ObstacleTile(
      id: 11,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 2,
    );
    layout[19] = ArrowTile(
      id: 12,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    // Fifth row
    layout[20] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[22] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[24] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 4,
    );

    return layout;
  }

  /// Create Level 1-11: Checkerboard pattern
  static GameLevel _createLevel111() {
    final layout = _createCheckerboardPatternLayout(111);
    final solution = [1, 2, 3, 6, 7, 8, 9, 12, 13, 14, 15];

    return _createTemplateLevel(
      111,
      'Checkerboard Pattern',
      'Navigate through a checkerboard pattern.',
      'Tranquil Beginnings',
      layout,
      solution,
    );
  }

  /// Create a mixed pattern layout
  static List<ArrowTile?> _createMixedPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a mixed pattern of arrows and obstacles
    // Top row - horizontal line
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

    // Right side - vertical line
    layout[9] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );
    layout[14] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );

    // Middle - diagonal line
    layout[6] = ArrowTile(
      id: 9,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );

    // Bottom row - horizontal line
    layout[20] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Add some obstacles
    layout[8] = ObstacleTile(
      id: 17,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 3,
    );
    layout[10] = ObstacleTile(
      id: 18,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 0,
    );
    layout[16] = ObstacleTile(
      id: 19,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 1,
    );

    return layout;
  }

  /// Create Level 1-12: Mixed pattern
  static GameLevel _createLevel112() {
    final layout = _createMixedPatternLayout(112);
    final solution = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

    return _createTemplateLevel(
      112,
      'Mixed Pattern',
      'Navigate through a mixed pattern of arrows.',
      'Tranquil Beginnings',
      layout,
      solution,
    );
  }

  /// Create a hexagon pattern layout
  static List<ArrowTile?> _createHexagonPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a hexagon pattern of arrows
    // Top side
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

    // Upper-right side
    layout[8] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 3,
    );
    layout[13] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );

    // Lower-right side
    layout[18] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 3,
    );

    // Bottom side
    layout[21] = ArrowTile(
      id: 7,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 8,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 4,
      column: 3,
    );

    // Lower-left side
    layout[16] = ArrowTile(
      id: 10,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 1,
    );
    layout[11] = ArrowTile(
      id: 11,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 2,
      column: 1,
    );

    // Upper-left side
    layout[6] = ArrowTile(
      id: 12,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 1,
    );

    // Add obstacles in the corners and center
    layout[0] = ObstacleTile(
      id: 13,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 0,
    );
    layout[4] = ObstacleTile(
      id: 14,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 0,
      column: 4,
    );
    layout[12] = ObstacleTile(
      id: 15,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 2,
    );
    layout[20] = ObstacleTile(
      id: 16,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 0,
    );
    layout[24] = ObstacleTile(
      id: 17,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 4,
      column: 4,
    );

    return layout;
  }

  /// Create Level 2-5: Hexagon pattern
  static GameLevel _createLevel205() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a spiral pattern with metal obstacles

    // Metal obstacles forming a spiral barrier
    layout[1] = ObstacleTile(
      id: 90,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 1,
    );

    layout[2] = ObstacleTile(
      id: 91,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 2,
    );

    layout[3] = ObstacleTile(
      id: 92,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 3,
    );

    layout[8] = ObstacleTile(
      id: 93,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 3,
    );

    layout[13] = ObstacleTile(
      id: 94,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 3,
    );

    layout[18] = ObstacleTile(
      id: 95,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 3,
    );

    layout[17] = ObstacleTile(
      id: 96,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 2,
    );

    layout[16] = ObstacleTile(
      id: 97,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 1,
    );

    layout[11] = ObstacleTile(
      id: 98,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 1,
    );

    // Arrow tiles forming a spiral path
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );

    layout[4] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 4,
    );

    layout[9] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 4,
    );

    layout[14] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );

    layout[19] = ArrowTile(
      id: 5,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 3,
      column: 4,
    );

    layout[24] = ArrowTile(
      id: 6,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 4,
    );

    layout[23] = ArrowTile(
      id: 7,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );

    layout[22] = ArrowTile(
      id: 8,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 2,
    );

    layout[21] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );

    layout[20] = ArrowTile(
      id: 10,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 0,
    );

    layout[15] = ArrowTile(
      id: 11,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 3,
      column: 0,
    );

    layout[10] = ArrowTile(
      id: 12,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 2,
      column: 0,
    );

    layout[5] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 0,
    );

    layout[6] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 1,
    );

    layout[7] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );

    layout[12] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 2,
    );

    // A carefully designed solution sequence that creates a satisfying spiral flow
    final solution = [
      1, // Start at top-left
      13, // Move right along inner path
      14,
      15,
      3, // Continue down
      4,
      5, // Move left
      6,
      7,
      8,
      9,
      10, // Move up
      11,
      12,
      2, // Complete the spiral
    ];

    return GameLevel(
      id: 205,
      name: 'Metal Spiral',
      description: 'Navigate through a challenging spiral of metal obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Colorful Maze',
    );
  }

  /// Create an octagon pattern layout
  static List<ArrowTile?> _createOctagonPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create an octagon pattern of arrows
    // Top side
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

    // Upper-right side
    layout[4] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 0,
      column: 4,
    );
    layout[9] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 1,
      column: 4,
    );

    // Right side
    layout[14] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 4,
    );

    // Lower-right side
    layout[19] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );
    layout[24] = ArrowTile(
      id: 8,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Bottom side
    layout[23] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 4,
      column: 3,
    );
    layout[22] = ArrowTile(
      id: 10,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[21] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 1,
    );

    // Lower-left side
    layout[20] = ArrowTile(
      id: 12,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[15] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 0,
    );

    // Left side
    layout[10] = ArrowTile(
      id: 14,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 0,
    );

    // Upper-left side
    layout[5] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 1,
      column: 0,
    );
    layout[0] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 0,
      column: 0,
    );

    // Add obstacles in the center
    layout[7] = ObstacleTile(
      id: 17,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 2,
    );
    layout[12] = ObstacleTile(
      id: 18,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 2,
    );
    layout[17] = ObstacleTile(
      id: 19,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 2,
    );

    return layout;
  }

  /// Create Level 2-6: Octagon pattern
  static GameLevel _createLevel206() {
    final layout = _createOctagonPatternLayout(206);
    final solution = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

    return _createTemplateLevel(
      206,
      'Octagon Pattern',
      'Navigate through an octagon pattern.',
      'Colorful Maze',
      layout,
      solution,
    );
  }

  /// Create an hourglass pattern layout
  static List<ArrowTile?> _createHourglassPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create an hourglass pattern of arrows
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

    // Upper diagonal
    layout[6] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 1,
    );
    layout[8] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );

    // Middle point
    layout[12] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 2,
    );

    // Lower diagonal
    layout[16] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[18] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 3,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 4,
    );

    // Add obstacles
    layout[5] = ObstacleTile(
      id: 16,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 0,
    );
    layout[7] = ObstacleTile(
      id: 17,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 2,
    );
    layout[9] = ObstacleTile(
      id: 18,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 4,
    );
    layout[10] = ObstacleTile(
      id: 19,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 0,
    );
    layout[14] = ObstacleTile(
      id: 20,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 4,
    );
    layout[15] = ObstacleTile(
      id: 21,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 0,
    );
    layout[17] = ObstacleTile(
      id: 22,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 2,
    );
    layout[19] = ObstacleTile(
      id: 23,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 4,
    );

    return layout;
  }

  /// Create Level 2-7: Hourglass pattern
  static GameLevel _createLevel207() {
    final layout = _createHourglassPatternLayout(207);
    final solution = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

    return _createTemplateLevel(
      207,
      'Hourglass Pattern',
      'Navigate through an hourglass pattern.',
      'Colorful Maze',
      layout,
      solution,
    );
  }

  /// Create a pyramid pattern layout
  static List<ArrowTile?> _createPyramidPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a pyramid pattern of arrows
    // Top of pyramid
    layout[2] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 2,
    );

    // Second row
    layout[6] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 3,
    );

    // Third row
    layout[10] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 9,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
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
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 4,
    );

    // Add obstacles
    layout[0] = ObstacleTile(
      id: 20,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 0,
    );
    layout[4] = ObstacleTile(
      id: 21,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 0,
      column: 4,
    );

    return layout;
  }

  /// Create Level 2-8: Pyramid pattern
  static GameLevel _createLevel208() {
    final layout = _createPyramidPatternLayout(208);
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
    ];

    return _createTemplateLevel(
      208,
      'Pyramid Pattern',
      'Navigate through a pyramid pattern.',
      'Colorful Maze',
      layout,
      solution,
    );
  }

  /// Create a labyrinth pattern layout
  static List<ArrowTile?> _createLabyrinthPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a labyrinth pattern of arrows
    // Outer path - top row
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

    // Outer path - right column
    layout[9] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );
    layout[14] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );
    layout[24] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // Outer path - bottom row
    layout[23] = ArrowTile(
      id: 10,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[22] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[21] = ArrowTile(
      id: 12,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[20] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );

    // Outer path - left column
    layout[15] = ArrowTile(
      id: 14,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[10] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[5] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );

    // Inner path - second row
    layout[6] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 19,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );

    // Inner path - third row
    layout[13] = ArrowTile(
      id: 20,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 2,
      column: 3,
    );
    layout[12] = ArrowTile(
      id: 21,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );
    layout[11] = ArrowTile(
      id: 22,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );

    // Inner path - fourth row
    layout[16] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 24,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 25,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );

    return layout;
  }

  /// Create Level 2-9: Labyrinth pattern
  static GameLevel _createLevel209() {
    final layout = _createLabyrinthPatternLayout(209);
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
    ];

    return _createTemplateLevel(
      209,
      'Labyrinth Pattern',
      'Navigate through a labyrinth pattern.',
      'Colorful Maze',
      layout,
      solution,
    );
  }

  /// Create a flower pattern layout
  static List<ArrowTile?> _createFlowerPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a flower pattern of arrows
    // Center
    layout[12] = ArrowTile(
      id: 1,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );

    // Top petal
    layout[2] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 2,
    );
    layout[7] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );

    // Right petal
    layout[14] = ArrowTile(
      id: 4,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );
    layout[13] = ArrowTile(
      id: 5,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 2,
      column: 3,
    );

    // Bottom petal
    layout[22] = ArrowTile(
      id: 6,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[17] = ArrowTile(
      id: 7,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 3,
      column: 2,
    );

    // Left petal
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

    // Diagonal petals
    // Top-left
    layout[0] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 0,
    );
    layout[1] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 1,
    );
    layout[6] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 1,
    );

    // Top-right
    layout[4] = ArrowTile(
      id: 13,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 0,
      column: 4,
    );
    layout[3] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 3,
    );
    layout[8] = ArrowTile(
      id: 15,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );

    // Bottom-right
    layout[24] = ArrowTile(
      id: 16,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );
    layout[23] = ArrowTile(
      id: 17,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 3,
    );
    layout[18] = ArrowTile(
      id: 18,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 3,
    );

    // Bottom-left
    layout[20] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[16] = ArrowTile(
      id: 21,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );

    return layout;
  }

  /// Create Level 2-10: Flower pattern
  static GameLevel _createLevel210() {
    final layout = _createFlowerPatternLayout(210);
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
    ];

    return _createTemplateLevel(
      210,
      'Flower Pattern',
      'Navigate through a flower pattern.',
      'Colorful Maze',
      layout,
      solution,
    );
  }

  /// Create a butterfly pattern layout
  static List<ArrowTile?> _createButterflyPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a butterfly pattern of arrows
    // Center body
    layout[12] = ArrowTile(
      id: 1,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );

    // Upper body
    layout[7] = ArrowTile(
      id: 2,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 0,
      column: 2,
    );

    // Lower body
    layout[17] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[22] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );

    // Upper left wing
    layout[1] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[5] = ArrowTile(
      id: 7,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 1,
    );

    // Upper right wing
    layout[3] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 0,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );
    layout[8] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );

    // Lower left wing
    layout[21] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[15] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 1,
    );

    // Lower right wing
    layout[23] = ArrowTile(
      id: 15,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );
    layout[18] = ArrowTile(
      id: 17,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 3,
      column: 3,
    );

    // Add obstacles at corners
    layout[0] = ObstacleTile(
      id: 18,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 0,
    );
    layout[4] = ObstacleTile(
      id: 19,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 0,
      column: 4,
    );
    layout[20] = ObstacleTile(
      id: 20,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 0,
    );
    layout[24] = ObstacleTile(
      id: 21,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 4,
    );

    return layout;
  }

  /// Create Level 2-11: Butterfly pattern
  static GameLevel _createLevel211() {
    final layout = _createButterflyPatternLayout(211);
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
    ];

    return _createTemplateLevel(
      211,
      'Butterfly Pattern',
      'Navigate through a butterfly pattern.',
      'Colorful Maze',
      layout,
      solution,
    );
  }

  /// Create a snowflake pattern layout
  static List<ArrowTile?> _createSnowflakePatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a snowflake pattern of arrows
    // Center
    layout[12] = ArrowTile(
      id: 1,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 2,
      column: 2,
    );

    // Vertical axis
    layout[2] = ArrowTile(
      id: 2,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 2,
    );
    layout[7] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );
    layout[17] = ArrowTile(
      id: 4,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[22] = ArrowTile(
      id: 5,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );

    // Horizontal axis
    layout[10] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 1,
    );
    layout[13] = ArrowTile(
      id: 8,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 2,
      column: 4,
    );

    // Diagonal axes
    // Top-left to bottom-right
    layout[0] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 1,
    );
    layout[18] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // Top-right to bottom-left
    layout[4] = ArrowTile(
      id: 14,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 4,
    );
    layout[8] = ArrowTile(
      id: 15,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );
    layout[16] = ArrowTile(
      id: 16,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 3,
      column: 1,
    );
    layout[20] = ArrowTile(
      id: 17,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );

    // Secondary branches
    layout[1] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 1,
    );
    layout[3] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 3,
    );
    layout[5] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );
    layout[9] = ArrowTile(
      id: 21,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 1,
      column: 4,
    );
    layout[15] = ArrowTile(
      id: 22,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[19] = ArrowTile(
      id: 23,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );
    layout[21] = ArrowTile(
      id: 24,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[23] = ArrowTile(
      id: 25,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 3,
    );

    return layout;
  }

  /// Create Level 2-12: Snowflake pattern
  static GameLevel _createLevel212() {
    final layout = _createSnowflakePatternLayout(212);
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
    ];

    return _createTemplateLevel(
      212,
      'Snowflake Pattern',
      'Navigate through a snowflake pattern.',
      'Colorful Maze',
      layout,
      solution,
    );
  }

  /// Create a castle pattern layout
  static List<ArrowTile?> _createCastlePatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a castle pattern of arrows
    // Top battlements
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
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

    // Upper walls
    layout[5] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );

    // Middle section - towers
    layout[10] = ArrowTile(
      id: 9,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );
    // Main hall
    layout[12] = ObstacleTile(
      id: 10,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 2,
    );
    layout[14] = ArrowTile(
      id: 11,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 4,
    );

    // Lower walls
    layout[15] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 16,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );

    // Base/foundation
    layout[20] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 21,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // Additional obstacles for difficulty
    layout[1] = ObstacleTile(
      id: 22,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 0,
      column: 1,
    );
    layout[3] = ObstacleTile(
      id: 23,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 3,
    );
    layout[11] = ObstacleTile(
      id: 24,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 1,
    );
    layout[13] = ObstacleTile(
      id: 25,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 3,
    );

    return layout;
  }

  /// Create Level 3-4: Castle pattern
  static GameLevel _createLevel304() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a complex maze with all three types of obstacles

    // Stone obstacles forming the outer walls of the maze
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

    layout[5] = ObstacleTile(
      id: 92,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 0,
    );

    layout[7] = ObstacleTile(
      id: 93,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 2,
    );

    layout[9] = ObstacleTile(
      id: 94,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 4,
    );

    // Metal obstacles forming the inner structure of the maze
    layout[11] = ObstacleTile(
      id: 95,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 1,
    );

    layout[13] = ObstacleTile(
      id: 96,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 3,
    );

    // Ice obstacles adding complexity
    layout[15] = ObstacleTile(
      id: 97,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 0,
    );

    layout[17] = ObstacleTile(
      id: 98,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 2,
    );

    layout[19] = ObstacleTile(
      id: 99,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 4,
    );

    // Arrow tiles forming a challenging path through the maze
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

    layout[6] = ArrowTile(
      id: 4,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 1,
    );

    layout[8] = ArrowTile(
      id: 5,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 3,
    );

    layout[10] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 0,
    );

    layout[12] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );

    layout[14] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );

    layout[16] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );

    layout[18] = ArrowTile(
      id: 10,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 3,
    );

    layout[20] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 0,
    );

    layout[21] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );

    layout[22] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );

    layout[23] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );

    layout[24] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 4,
    );

    // A challenging solution sequence requiring careful planning
    final solution = [
      1, // Start at top-left
      2, // Move down through center
      7, // Continue down
      9, // Navigate right
      10, // Continue right
      8, // Move down right side
      15, // Move up from bottom-right
      14, // Navigate left along bottom
      13,
      12,
      11, // Bottom-left
      6, // Move up left side
      4, // Navigate right in middle
      5, // Continue right
      3, // Complete at top-right
    ];

    return GameLevel(
      id: 304,
      name: 'Triple Obstacle Maze',
      description:
          'Master this complex maze with stone, ice, and metal obstacles.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create a fortress pattern layout
  static List<ArrowTile?> _createFortressPatternLayout(int levelId) {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Create a fortress pattern of arrows
    // Outer wall - top
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

    // Outer wall - right
    layout[9] = ArrowTile(
      id: 6,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 4,
    );
    layout[14] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 2,
      column: 4,
    );
    layout[19] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 3,
      column: 4,
    );
    layout[24] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // Outer wall - bottom
    layout[23] = ArrowTile(
      id: 10,
      direction: ArrowDirection.left,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[22] = ArrowTile(
      id: 11,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[21] = ArrowTile(
      id: 12,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[20] = ArrowTile(
      id: 13,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );

    // Outer wall - left
    layout[15] = ArrowTile(
      id: 14,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 0,
    );
    layout[10] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 2,
      column: 0,
    );
    layout[5] = ArrowTile(
      id: 16,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );

    // Inner fortress - corners
    layout[6] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[8] = ArrowTile(
      id: 18,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 3,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );
    layout[16] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 3,
      column: 1,
    );

    // Inner fortress - center obstacles
    layout[7] = ObstacleTile(
      id: 21,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 2,
    );
    layout[11] = ObstacleTile(
      id: 22,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 1,
    );
    layout[12] = ObstacleTile(
      id: 23,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 2,
    );
    layout[13] = ObstacleTile(
      id: 24,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 3,
    );
    layout[17] = ObstacleTile(
      id: 25,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 2,
    );

    return layout;
  }

  /// Create Level 3-5: Fortress pattern
  static GameLevel _createLevel305() {
    final layout = _createFortressPatternLayout(305);
    final solution = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
    ];

    return _createTemplateLevel(
      305,
      'Fortress Pattern',
      'Navigate through a fortress pattern.',
      'Core Challenge',
      layout,
      solution,
    );
  }

  /// Create Level 3-6: Mandala pattern
  static GameLevel _createLevel306() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Top row
    layout[0] = ObstacleTile(
      id: 1,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[2] = ObstacleTile(
      id: 3,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
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
    layout[4] = ObstacleTile(
      id: 5,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 0,
    );
    layout[6] = ObstacleTile(
      id: 7,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );
    layout[8] = ObstacleTile(
      id: 9,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[10] = ObstacleTile(
      id: 11,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
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
    layout[12] = ObstacleTile(
      id: 13,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
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
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 2,
    );
    layout[18] = ObstacleTile(
      id: 19,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[20] = ObstacleTile(
      id: 21,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[24] = ObstacleTile(
      id: 25,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      2,
      4,
      8,
      10,
      12,
      14,
      15,
      17,
      18,
      20,
      6,
      16,
      22,
      23,
      24,
    ];

    return GameLevel(
      id: 303,
      name: 'Master Challenge',
      description: 'The ultimate test of your skills.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create Level 3-7: Mirror pattern
  static GameLevel _createLevel307() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
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
    layout[2] = ObstacleTile(
      id: 3,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 2,
    );
    layout[3] = ArrowTile(
      id: 4,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
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
      color: AppColors.arrowGreen,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 1,
    );
    layout[7] = ObstacleTile(
      id: 8,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ObstacleTile(
      id: 11,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 2,
      column: 0,
    );
    layout[11] = ObstacleTile(
      id: 12,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 1,
    );
    // Empty cell at [2, 2]
    layout[13] = ObstacleTile(
      id: 13,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 3,
    );
    layout[14] = ObstacleTile(
      id: 14,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[17] = ObstacleTile(
      id: 17,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 18,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
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
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 21,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ObstacleTile(
      id: 22,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 23,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 24,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      1,
      2,
      4,
      5,
      20,
      21,
      23,
      24,
      6,
      7,
      9,
      10,
      15,
      16,
      18,
      19,
    ];

    return GameLevel(
      id: 307,
      name: 'Mirror Pattern',
      description: 'Navigate through a symmetrical mirror pattern.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create Level 3-8: Infinity pattern
  static GameLevel _createLevel308() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
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
    layout[5] = ObstacleTile(
      id: 6,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
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
    layout[9] = ObstacleTile(
      id: 10,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 0,
    );
    layout[11] = ObstacleTile(
      id: 12,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 1,
    );
    // Empty cell at [2, 2]
    layout[13] = ObstacleTile(
      id: 13,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
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
    layout[15] = ObstacleTile(
      id: 15,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 16,
      direction: ArrowDirection.left,
      color: AppColors.arrowBlue,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 17,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 18,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 3,
    );
    layout[19] = ObstacleTile(
      id: 19,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 20,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 21,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 23,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 24,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      1,
      2,
      3,
      4,
      5,
      7,
      8,
      9,
      16,
      17,
      18,
      11,
      14,
      20,
      21,
      22,
      23,
      24,
    ];

    return GameLevel(
      id: 308,
      name: 'Infinity Pattern',
      description: 'Navigate through an infinity-shaped pattern.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create Level 3-9: Vortex pattern
  static GameLevel _createLevel309() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
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
      id: 7,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 1,
    );
    layout[7] = ObstacleTile(
      id: 8,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 2,
    );
    layout[8] = ObstacleTile(
      id: 9,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 2,
      column: 0,
    );
    layout[11] = ObstacleTile(
      id: 12,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 1,
    );
    // Empty cell at [2, 2]
    layout[13] = ObstacleTile(
      id: 13,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 14,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 15,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 3,
      column: 0,
    );
    layout[16] = ObstacleTile(
      id: 16,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 1,
    );
    layout[17] = ObstacleTile(
      id: 17,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 3,
      column: 2,
    );
    layout[18] = ObstacleTile(
      id: 18,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 19,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 20,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 21,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 22,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 23,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 24,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      1,
      2,
      3,
      4,
      5,
      10,
      14,
      19,
      24,
      6,
      11,
      15,
      20,
      21,
      22,
      23,
    ];

    return GameLevel(
      id: 309,
      name: 'Vortex Pattern',
      description: 'Navigate through a spiral vortex pattern.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create Level 3-10: Diamond pattern
  static GameLevel _createLevel310() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Top row
    layout[0] = ObstacleTile(
      id: 1,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 0,
    );
    layout[1] = ObstacleTile(
      id: 2,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 2,
    );
    layout[3] = ObstacleTile(
      id: 4,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 0,
      column: 3,
    );
    layout[4] = ObstacleTile(
      id: 5,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ObstacleTile(
      id: 6,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 1,
      column: 3,
    );
    layout[9] = ObstacleTile(
      id: 10,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ObstacleTile(
      id: 16,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 3,
      column: 3,
    );
    layout[19] = ObstacleTile(
      id: 20,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ObstacleTile(
      id: 21,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 0,
    );
    layout[21] = ObstacleTile(
      id: 22,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 23,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 2,
    );
    layout[23] = ObstacleTile(
      id: 24,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 4,
      column: 3,
    );
    layout[24] = ObstacleTile(
      id: 25,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [3, 7, 8, 9, 17, 18, 19, 23, 11, 12, 13, 14, 15];

    return GameLevel(
      id: 310,
      name: 'Diamond Pattern',
      description: 'Navigate through a diamond-shaped pattern.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create Level 3-11: Cross pattern
  static GameLevel _createLevel311() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
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
    layout[6] = ObstacleTile(
      id: 7,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 1,
      column: 2,
    );
    layout[8] = ObstacleTile(
      id: 9,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 1,
      column: 3,
    );
    layout[9] = ArrowTile(
      id: 10,
      direction: ArrowDirection.left,
      color: AppColors.arrowPink,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ArrowTile(
      id: 11,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 2,
      column: 0,
    );
    layout[11] = ArrowTile(
      id: 12,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 2,
      column: 1,
    );
    layout[12] = ObstacleTile(
      id: 13,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 2,
    );
    layout[13] = ArrowTile(
      id: 14,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 2,
      column: 3,
    );
    layout[14] = ArrowTile(
      id: 15,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 0,
    );
    layout[16] = ObstacleTile(
      id: 17,
      type: ObstacleType.stone,
      color: Colors.grey,
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
    layout[18] = ObstacleTile(
      id: 19,
      type: ObstacleType.stone,
      color: Colors.grey,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 20,
      direction: ArrowDirection.left,
      color: AppColors.arrowGreen,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ArrowTile(
      id: 21,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowBlue,
      row: 4,
      column: 1,
    );
    layout[22] = ArrowTile(
      id: 23,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 24,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      1,
      2,
      3,
      4,
      5,
      8,
      18,
      21,
      22,
      23,
      24,
      25,
      6,
      10,
      11,
      12,
      14,
      15,
      16,
      20,
    ];

    return GameLevel(
      id: 311,
      name: 'Cross Pattern',
      description: 'Navigate through a cross-shaped pattern.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }

  /// Create Level 3-12: Maze pattern
  static GameLevel _createLevel312() {
    final gridSize = 5;
    final List<ArrowTile?> layout = List.generate(
      gridSize * gridSize,
      (index) => null,
    );

    // Top row
    layout[0] = ArrowTile(
      id: 1,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 0,
      column: 0,
    );
    layout[1] = ObstacleTile(
      id: 2,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 1,
    );
    layout[2] = ArrowTile(
      id: 3,
      direction: ArrowDirection.down,
      color: AppColors.arrowTerracotta,
      row: 0,
      column: 2,
    );
    layout[3] = ObstacleTile(
      id: 4,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 0,
      column: 3,
    );
    layout[4] = ArrowTile(
      id: 5,
      direction: ArrowDirection.down,
      color: AppColors.arrowGreen,
      row: 0,
      column: 4,
    );

    // Second row
    layout[5] = ArrowTile(
      id: 6,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 1,
      column: 0,
    );
    layout[6] = ArrowTile(
      id: 7,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 1,
      column: 1,
    );
    layout[7] = ArrowTile(
      id: 8,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 1,
      column: 2,
    );
    layout[8] = ArrowTile(
      id: 9,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 1,
      column: 3,
    );
    layout[9] = ObstacleTile(
      id: 10,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 1,
      column: 4,
    );

    // Middle row
    layout[10] = ObstacleTile(
      id: 11,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 0,
    );
    layout[11] = ObstacleTile(
      id: 12,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 1,
    );
    layout[12] = ArrowTile(
      id: 13,
      direction: ArrowDirection.down,
      color: AppColors.arrowPink,
      row: 2,
      column: 2,
    );
    layout[13] = ObstacleTile(
      id: 14,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 2,
      column: 3,
    );
    layout[14] = ObstacleTile(
      id: 15,
      type: ObstacleType.metal,
      color: Colors.grey[400]!,
      row: 2,
      column: 4,
    );

    // Fourth row
    layout[15] = ArrowTile(
      id: 16,
      direction: ArrowDirection.right,
      color: AppColors.arrowBlue,
      row: 3,
      column: 0,
    );
    layout[16] = ArrowTile(
      id: 17,
      direction: ArrowDirection.right,
      color: AppColors.arrowTerracotta,
      row: 3,
      column: 1,
    );
    layout[17] = ArrowTile(
      id: 18,
      direction: ArrowDirection.right,
      color: AppColors.arrowGreen,
      row: 3,
      column: 2,
    );
    layout[18] = ArrowTile(
      id: 19,
      direction: ArrowDirection.right,
      color: AppColors.arrowPink,
      row: 3,
      column: 3,
    );
    layout[19] = ArrowTile(
      id: 20,
      direction: ArrowDirection.down,
      color: AppColors.arrowBlue,
      row: 3,
      column: 4,
    );

    // Bottom row
    layout[20] = ObstacleTile(
      id: 21,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 4,
      column: 0,
    );
    layout[21] = ArrowTile(
      id: 22,
      direction: ArrowDirection.up,
      color: AppColors.arrowTerracotta,
      row: 4,
      column: 1,
    );
    layout[22] = ObstacleTile(
      id: 23,
      type: ObstacleType.ice,
      color: Colors.lightBlue[100]!,
      row: 4,
      column: 2,
    );
    layout[23] = ArrowTile(
      id: 24,
      direction: ArrowDirection.up,
      color: AppColors.arrowGreen,
      row: 4,
      column: 3,
    );
    layout[24] = ArrowTile(
      id: 25,
      direction: ArrowDirection.up,
      color: AppColors.arrowPink,
      row: 4,
      column: 4,
    );

    // A possible solution sequence for this layout
    final List<int> solution = [
      1,
      3,
      5,
      13,
      20,
      22,
      24,
      25,
      6,
      7,
      8,
      9,
      16,
      17,
      18,
      19,
    ];

    return GameLevel(
      id: 312,
      name: 'Maze Pattern',
      description: 'Navigate through a complex maze pattern.',
      totalMoves: solution.length,
      layout: layout,
      solution: solution,
      levelPack: 'Core Challenge',
    );
  }
}
