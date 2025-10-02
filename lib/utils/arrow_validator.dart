import '../models/arrow_tile.dart';
import '../models/game_level.dart';

/// 箭头验证工具类
class ArrowValidator {
  /// 检查游戏关卡中是否有相邻且方向相反的箭头
  static bool hasAdjacentOpposingArrows(GameLevel level) {
    final gridSize = level.gridSize;
    final layout = level.layout;

    // 检查每个箭头与其相邻箭头
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final index = row * gridSize + col;
        final tile = layout[index];

        // 跳过空格和障碍物
        if (tile == null || tile.isObstacle) continue;

        // 获取当前箭头
        final arrowTile = tile;

        // 检查上方相邻箭头
        if (row > 0) {
          final upIndex = (row - 1) * gridSize + col;
          final upTile = layout[upIndex];
          if (upTile != null && !upTile.isObstacle) {
            // 如果当前箭头向上，上方箭头向下，则方向相反
            if (arrowTile.direction == ArrowDirection.up &&
                upTile.direction == ArrowDirection.down) {
              return true;
            }
          }
        }

        // 检查下方相邻箭头
        if (row < gridSize - 1) {
          final downIndex = (row + 1) * gridSize + col;
          final downTile = layout[downIndex];
          if (downTile != null && !downTile.isObstacle) {
            // 如果当前箭头向下，下方箭头向上，则方向相反
            if (arrowTile.direction == ArrowDirection.down &&
                downTile.direction == ArrowDirection.up) {
              return true;
            }
          }
        }

        // 检查左侧相邻箭头
        if (col > 0) {
          final leftIndex = row * gridSize + (col - 1);
          final leftTile = layout[leftIndex];
          if (leftTile != null && !leftTile.isObstacle) {
            // 如果当前箭头向左，左侧箭头向右，则方向相反
            if (arrowTile.direction == ArrowDirection.left &&
                leftTile.direction == ArrowDirection.right) {
              return true;
            }
          }
        }

        // 检查右侧相邻箭头
        if (col < gridSize - 1) {
          final rightIndex = row * gridSize + (col + 1);
          final rightTile = layout[rightIndex];
          if (rightTile != null && !rightTile.isObstacle) {
            // 如果当前箭头向右，右侧箭头向左，则方向相反
            if (arrowTile.direction == ArrowDirection.right &&
                rightTile.direction == ArrowDirection.left) {
              return true;
            }
          }
        }
      }
    }

    // 没有找到相邻且方向相反的箭头
    return false;
  }

  /// 获取游戏关卡中所有相邻且方向相反的箭头对
  static List<List<int>> findAdjacentOpposingArrows(GameLevel level) {
    final gridSize = level.gridSize;
    final layout = level.layout;
    final List<List<int>> opposingPairs = [];

    // 检查每个箭头与其相邻箭头
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final index = row * gridSize + col;
        final tile = layout[index];

        // 跳过空格和障碍物
        if (tile == null || tile.isObstacle) continue;

        // 获取当前箭头
        final arrowTile = tile;

        // 检查上方相邻箭头
        if (row > 0) {
          final upIndex = (row - 1) * gridSize + col;
          final upTile = layout[upIndex];
          if (upTile != null && !upTile.isObstacle) {
            // 如果当前箭头向上，上方箭头向下，则方向相反
            if (arrowTile.direction == ArrowDirection.up &&
                upTile.direction == ArrowDirection.down) {
              opposingPairs.add([index, upIndex]);
            }
          }
        }

        // 检查下方相邻箭头
        if (row < gridSize - 1) {
          final downIndex = (row + 1) * gridSize + col;
          final downTile = layout[downIndex];
          if (downTile != null && !downTile.isObstacle) {
            // 如果当前箭头向下，下方箭头向上，则方向相反
            if (arrowTile.direction == ArrowDirection.down &&
                downTile.direction == ArrowDirection.up) {
              opposingPairs.add([index, downIndex]);
            }
          }
        }

        // 检查左侧相邻箭头
        if (col > 0) {
          final leftIndex = row * gridSize + (col - 1);
          final leftTile = layout[leftIndex];
          if (leftTile != null && !leftTile.isObstacle) {
            // 如果当前箭头向左，左侧箭头向右，则方向相反
            if (arrowTile.direction == ArrowDirection.left &&
                leftTile.direction == ArrowDirection.right) {
              opposingPairs.add([index, leftIndex]);
            }
          }
        }

        // 检查右侧相邻箭头
        if (col < gridSize - 1) {
          final rightIndex = row * gridSize + (col + 1);
          final rightTile = layout[rightIndex];
          if (rightTile != null && !rightTile.isObstacle) {
            // 如果当前箭头向右，右侧箭头向左，则方向相反
            if (arrowTile.direction == ArrowDirection.right &&
                rightTile.direction == ArrowDirection.left) {
              opposingPairs.add([index, rightIndex]);
            }
          }
        }
      }
    }

    return opposingPairs;
  }

  /// 修复游戏关卡中相邻且方向相反的箭头
  static GameLevel fixAdjacentOpposingArrows(GameLevel level) {
    final layout = List<ArrowTile?>.from(level.layout);
    final opposingPairs = findAdjacentOpposingArrows(level);

    // 修复每对相邻且方向相反的箭头
    for (final pair in opposingPairs) {
      final index1 = pair[0];
      final index2 = pair[1];

      // 获取两个箭头
      final tile1 = layout[index1];
      final tile2 = layout[index2];

      if (tile1 == null ||
          tile2 == null ||
          tile1.isObstacle ||
          tile2.isObstacle) {
        continue;
      }

      // 修改第二个箭头的方向，使其不再与第一个箭头方向相反
      // 选择一个安全的方向（不会导致新的相邻箭头方向相反）
      final row2 = tile2.row;
      final col2 = tile2.column;

      // 尝试不同的方向
      final directions = [
        ArrowDirection.up,
        ArrowDirection.down,
        ArrowDirection.left,
        ArrowDirection.right,
      ];

      // 移除当前方向和相反方向
      directions.remove(tile2.direction);

      // 根据第一个箭头的方向，移除相反方向
      switch (tile1.direction) {
        case ArrowDirection.up:
          directions.remove(ArrowDirection.down);
          break;
        case ArrowDirection.down:
          directions.remove(ArrowDirection.up);
          break;
        case ArrowDirection.left:
          directions.remove(ArrowDirection.right);
          break;
        case ArrowDirection.right:
          directions.remove(ArrowDirection.left);
          break;
      }

      // 如果还有可用方向，选择第一个
      if (directions.isNotEmpty) {
        final newDirection = directions.first;
        layout[index2] = ArrowTile(
          id: tile2.id,
          direction: newDirection,
          color: tile2.color,
          row: row2,
          column: col2,
        );
      }
    }

    // 创建修复后的关卡
    return GameLevel(
      id: level.id,
      name: level.name,
      description: level.description,
      totalMoves: level.totalMoves,
      layout: layout,
      solution: level.solution, // 注意：修改箭头方向后，原有解决方案可能不再有效
      levelPack: level.levelPack,
      gridSize: level.gridSize,
      isLocked: level.isLocked,
      isCompleted: level.isCompleted,
      playerBestMoves: level.playerBestMoves,
    );
  }
}
