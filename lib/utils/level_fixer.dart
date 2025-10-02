import '../models/arrow_tile.dart';
import '../models/game_level.dart';
import 'constants.dart';
import 'game_logic.dart';

/// A utility class to fix issues in level designs
class LevelFixer {
  /// Fix a level to comply with all game rules
  static GameLevel fixLevel(GameLevel level) {
    // Make a copy of the level layout to work with
    List<ArrowTile?> fixedLayout = List<ArrowTile?>.from(level.layout);

    // Fix arrows pointing at obstacles
    if (GameLogic.hasArrowsPointingToObstacles(level)) {
      fixedLayout = GameLogic.fixArrowsPointingToObstacles(
        fixedLayout,
        level.gridSize,
      );
    }

    // 修复所有相对的箭头（不仅仅是相邻的）
    if (!GameLogic.validateNoOpposingArrowsAnywhere(
      fixedLayout,
      level.gridSize,
    )) {
      fixedLayout = _fixOpposingArrowsAnywhere(fixedLayout, level.gridSize);
    }

    // 修复外围箭头朝外的数量
    if (!GameLogic.validateOutwardPointingArrows(fixedLayout, level.gridSize)) {
      // 使用新的generateSolvableLayout方法来修复箭头布局
      fixedLayout = GameLogic.generateSolvableLayout(
        fixedLayout,
        level.gridSize,
      );
    }

    // Fix empty spaces if needed
    final emptySpacesRatio = _calculateEmptySpacesRatio(
      fixedLayout,
      level.gridSize,
    );
    if (emptySpacesRatio > 0.3) {
      fixedLayout = _fillEmptySpaces(fixedLayout, level.gridSize);
    }

    // Return a new GameLevel with the fixed layout
    return GameLevel(
      id: level.id,
      name: level.name,
      description: level.description,
      totalMoves: level.totalMoves,
      layout: fixedLayout,
      solution: level.solution, // Note: solution may need to be recalculated
      levelPack: level.levelPack,
    );
  }

  // 注意：_fixOpposingArrows方法已被_fixOpposingArrowsAnywhere替代，不再使用

  // 注意：_findSafeDirection方法已不再使用，被_findSafeDirectionForNewArrow替代

  /// Calculate the ratio of empty spaces to total grid size
  static double _calculateEmptySpacesRatio(
    List<ArrowTile?> layout,
    int gridSize,
  ) {
    int emptySpaces = 0;

    for (final tile in layout) {
      if (tile == null) {
        emptySpaces++;
      }
    }

    return emptySpaces / (gridSize * gridSize);
  }

  /// Fill empty spaces with arrow tiles
  static List<ArrowTile?> _fillEmptySpaces(
    List<ArrowTile?> layout,
    int gridSize,
  ) {
    final filledLayout = List<ArrowTile?>.from(layout);
    int nextId = _findMaxId(layout) + 1;

    // Colors to use for new arrow tiles
    final colors = [
      AppColors.arrowBlue,
      AppColors.arrowTerracotta,
      AppColors.arrowGreen,
      AppColors.arrowPink,
    ];
    int colorIndex = 0;

    // Fill empty spaces
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final index = row * gridSize + col;

        // If this cell is empty, fill it with an arrow tile
        if (filledLayout[index] == null) {
          // Find a safe direction for this new arrow
          final safeDirection = _findSafeDirectionForNewArrow(
            filledLayout,
            gridSize,
            row,
            col,
          );

          // Create a new arrow tile
          filledLayout[index] = ArrowTile(
            id: nextId++,
            direction: safeDirection,
            color: colors[colorIndex % colors.length],
            row: row,
            column: col,
          );

          // Use the next color for the next arrow
          colorIndex++;
        }
      }
    }

    return filledLayout;
  }

  /// Find a safe direction for a new arrow at the given position
  static ArrowDirection _findSafeDirectionForNewArrow(
    List<ArrowTile?> layout,
    int gridSize,
    int row,
    int col,
  ) {
    // Try all directions
    final directions = [
      ArrowDirection.right,
      ArrowDirection.down,
      ArrowDirection.left,
      ArrowDirection.up,
    ];

    // Check each direction for safety
    for (final direction in directions) {
      bool isSafe = true;

      // Check if this direction points to an obstacle
      switch (direction) {
        case ArrowDirection.up:
          // Check tiles above
          for (int r = row - 1; r >= 0; r--) {
            final checkIndex = r * gridSize + col;
            if (checkIndex >= 0 &&
                checkIndex < layout.length &&
                layout[checkIndex] != null) {
              // If we find an obstacle, this direction is not safe
              if (layout[checkIndex]!.isObstacle) {
                isSafe = false;
              }
              // If we find an arrow pointing down, this creates opposing arrows
              else if (layout[checkIndex] is ArrowTile &&
                  (layout[checkIndex] as ArrowTile).direction ==
                      ArrowDirection.down) {
                isSafe = false;
              }
              break; // Stop at the first tile we find
            }
          }
          break;

        case ArrowDirection.down:
          // Check tiles below
          for (int r = row + 1; r < gridSize; r++) {
            final checkIndex = r * gridSize + col;
            if (checkIndex >= 0 &&
                checkIndex < layout.length &&
                layout[checkIndex] != null) {
              // If we find an obstacle, this direction is not safe
              if (layout[checkIndex]!.isObstacle) {
                isSafe = false;
              }
              // If we find an arrow pointing up, this creates opposing arrows
              else if (layout[checkIndex] is ArrowTile &&
                  (layout[checkIndex] as ArrowTile).direction ==
                      ArrowDirection.up) {
                isSafe = false;
              }
              break; // Stop at the first tile we find
            }
          }
          break;

        case ArrowDirection.left:
          // Check tiles to the left
          for (int c = col - 1; c >= 0; c--) {
            final checkIndex = row * gridSize + c;
            if (checkIndex >= 0 &&
                checkIndex < layout.length &&
                layout[checkIndex] != null) {
              // If we find an obstacle, this direction is not safe
              if (layout[checkIndex]!.isObstacle) {
                isSafe = false;
              }
              // If we find an arrow pointing right, this creates opposing arrows
              else if (layout[checkIndex] is ArrowTile &&
                  (layout[checkIndex] as ArrowTile).direction ==
                      ArrowDirection.right) {
                isSafe = false;
              }
              break; // Stop at the first tile we find
            }
          }
          break;

        case ArrowDirection.right:
          // Check tiles to the right
          for (int c = col + 1; c < gridSize; c++) {
            final checkIndex = row * gridSize + c;
            if (checkIndex >= 0 &&
                checkIndex < layout.length &&
                layout[checkIndex] != null) {
              // If we find an obstacle, this direction is not safe
              if (layout[checkIndex]!.isObstacle) {
                isSafe = false;
              }
              // If we find an arrow pointing left, this creates opposing arrows
              else if (layout[checkIndex] is ArrowTile &&
                  (layout[checkIndex] as ArrowTile).direction ==
                      ArrowDirection.left) {
                isSafe = false;
              }
              break; // Stop at the first tile we find
            }
          }
          break;
      }

      // If this direction is safe, use it
      if (isSafe) {
        return direction;
      }
    }

    // If no direction is completely safe, default to right
    // (this is a fallback and should be rare)
    return ArrowDirection.right;
  }

  /// 修复任何位置的相对箭头（不仅仅是相邻的）
  static List<ArrowTile?> _fixOpposingArrowsAnywhere(
    List<ArrowTile?> layout,
    int gridSize,
  ) {
    final fixedLayout = List<ArrowTile?>.from(layout);

    // 修复每一行中的相对箭头
    for (int row = 0; row < gridSize; row++) {
      List<ArrowTile> rightArrows = [];
      List<ArrowTile> leftArrows = [];
      List<int> rightIndices = [];
      List<int> leftIndices = [];

      // 收集该行中所有的向右和向左箭头
      for (int col = 0; col < gridSize; col++) {
        final index = row * gridSize + col;
        final tile = layout[index];
        if (tile == null || tile.isObstacle) continue;

        if (tile.direction == ArrowDirection.right) {
          rightArrows.add(tile);
          rightIndices.add(index);
        } else if (tile.direction == ArrowDirection.left) {
          leftArrows.add(tile);
          leftIndices.add(index);
        }
      }

      // 如果同一行既有向右的箭头又有向左的箭头，则需要修复
      if (rightArrows.isNotEmpty && leftArrows.isNotEmpty) {
        // 决定保留哪个方向的箭头（选择数量较多的方向）
        if (rightArrows.length >= leftArrows.length) {
          // 保留向右的箭头，修改向左的箭头
          for (final index in leftIndices) {
            final tile = layout[index];
            if (tile == null) continue;

            // 修改为向上或向下方向
            final newDirection = _getRandomVerticalDirection();
            fixedLayout[index] = ArrowTile(
              id: tile.id,
              direction: newDirection,
              color: tile.color,
              row: tile.row,
              column: tile.column,
              isRemoved: tile.isRemoved,
            );
          }
        } else {
          // 保留向左的箭头，修改向右的箭头
          for (final index in rightIndices) {
            final tile = layout[index];
            if (tile == null) continue;

            // 修改为向上或向下方向
            final newDirection = _getRandomVerticalDirection();
            fixedLayout[index] = ArrowTile(
              id: tile.id,
              direction: newDirection,
              color: tile.color,
              row: tile.row,
              column: tile.column,
              isRemoved: tile.isRemoved,
            );
          }
        }
      }
    }

    // 修复每一列中的相对箭头
    for (int col = 0; col < gridSize; col++) {
      List<ArrowTile> downArrows = [];
      List<ArrowTile> upArrows = [];
      List<int> downIndices = [];
      List<int> upIndices = [];

      // 收集该列中所有的向下和向上箭头
      for (int row = 0; row < gridSize; row++) {
        final index = row * gridSize + col;
        final tile = layout[index];
        if (tile == null || tile.isObstacle) continue;

        if (tile.direction == ArrowDirection.down) {
          downArrows.add(tile);
          downIndices.add(index);
        } else if (tile.direction == ArrowDirection.up) {
          upArrows.add(tile);
          upIndices.add(index);
        }
      }

      // 如果同一列既有向下的箭头又有向上的箭头，则需要修复
      if (downArrows.isNotEmpty && upArrows.isNotEmpty) {
        // 决定保留哪个方向的箭头（选择数量较多的方向）
        if (downArrows.length >= upArrows.length) {
          // 保留向下的箭头，修改向上的箭头
          for (final index in upIndices) {
            final tile = layout[index];
            if (tile == null) continue;

            // 修改为向左或向右方向
            final newDirection = _getRandomHorizontalDirection();
            fixedLayout[index] = ArrowTile(
              id: tile.id,
              direction: newDirection,
              color: tile.color,
              row: tile.row,
              column: tile.column,
              isRemoved: tile.isRemoved,
            );
          }
        } else {
          // 保留向上的箭头，修改向下的箭头
          for (final index in downIndices) {
            final tile = layout[index];
            if (tile == null) continue;

            // 修改为向左或向右方向
            final newDirection = _getRandomHorizontalDirection();
            fixedLayout[index] = ArrowTile(
              id: tile.id,
              direction: newDirection,
              color: tile.color,
              row: tile.row,
              column: tile.column,
              isRemoved: tile.isRemoved,
            );
          }
        }
      }
    }

    return fixedLayout;
  }

  /// 获取随机的垂直方向（上或下）
  static ArrowDirection _getRandomVerticalDirection() {
    final directions = [ArrowDirection.up, ArrowDirection.down];
    directions.shuffle();
    return directions.first;
  }

  /// 获取随机的水平方向（左或右）
  static ArrowDirection _getRandomHorizontalDirection() {
    final directions = [ArrowDirection.left, ArrowDirection.right];
    directions.shuffle();
    return directions.first;
  }

  /// Find the maximum ID used in the layout
  static int _findMaxId(List<ArrowTile?> layout) {
    int maxId = 0;

    for (final tile in layout) {
      if (tile != null && tile.id > maxId) {
        maxId = tile.id;
      }
    }

    return maxId;
  }
}
