import '../models/arrow_tile.dart';
import '../models/game_state.dart';
import '../models/game_level.dart';

/// Class containing the core game logic
class GameLogic {
  /// Check if a tile can be clicked (has a clear path in its direction)
  static bool canTileBeClicked(GameState gameState, int tileId) {
    // Find the tile by ID
    ArrowTile? tile;

    for (int i = 0; i < gameState.currentLayout.length; i++) {
      if (gameState.currentLayout[i]?.id == tileId) {
        tile = gameState.currentLayout[i];
        break;
      }
    }

    // If tile not found, already removed, or is an obstacle, it can't be clicked
    if (tile == null || tile.isRemoved || tile.isObstacle) {
      return false;
    }

    final gridSize = gameState.currentLevel.gridSize;
    final row = tile.row;
    final col = tile.column;

    // Check if the path is clear in the direction the arrow is pointing
    switch (tile.direction) {
      case ArrowDirection.up:
        // Check all tiles above this one
        for (int r = row - 1; r >= 0; r--) {
          final checkIndex = r * gridSize + col;
          if (checkIndex < gameState.currentLayout.length &&
              gameState.currentLayout[checkIndex] != null &&
              !gameState.currentLayout[checkIndex]!.isRemoved) {
            return false;
          }
        }
        return true;

      case ArrowDirection.down:
        // Check all tiles below this one
        for (int r = row + 1; r < gridSize; r++) {
          final checkIndex = r * gridSize + col;
          if (checkIndex < gameState.currentLayout.length &&
              gameState.currentLayout[checkIndex] != null &&
              !gameState.currentLayout[checkIndex]!.isRemoved) {
            return false;
          }
        }
        return true;

      case ArrowDirection.left:
        // Check all tiles to the left of this one
        for (int c = col - 1; c >= 0; c--) {
          final checkIndex = row * gridSize + c;
          if (checkIndex < gameState.currentLayout.length &&
              gameState.currentLayout[checkIndex] != null &&
              !gameState.currentLayout[checkIndex]!.isRemoved) {
            return false;
          }
        }
        return true;

      case ArrowDirection.right:
        // Check all tiles to the right of this one
        for (int c = col + 1; c < gridSize; c++) {
          final checkIndex = row * gridSize + c;
          if (checkIndex < gameState.currentLayout.length &&
              gameState.currentLayout[checkIndex] != null &&
              !gameState.currentLayout[checkIndex]!.isRemoved) {
            return false;
          }
        }
        return true;
    }
  }

  /// Validate that no arrows face each other directly
  static bool validateNoOpposingArrows(List<ArrowTile?> layout, int gridSize) {
    // Check rows for opposing arrows
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize - 1; col++) {
        final currentTile = layout[row * gridSize + col];

        // Skip empty cells or obstacles
        if (currentTile == null || currentTile.isObstacle) continue;

        // Check all cells to the right in the same row
        for (int nextCol = col + 1; nextCol < gridSize; nextCol++) {
          final nextTile = layout[row * gridSize + nextCol];

          // Skip empty cells or obstacles
          if (nextTile == null || nextTile.isObstacle) continue;

          // If we found a non-empty cell, check if it's opposing
          if (currentTile.direction == ArrowDirection.right &&
              nextTile.direction == ArrowDirection.left) {
            return false; // Opposing arrows found
          }

          // We check ALL cells, not just the first non-empty one
          // (removed the break statement here)
        }
      }
    }

    // Check columns for opposing arrows
    for (int col = 0; col < gridSize; col++) {
      for (int row = 0; row < gridSize - 1; row++) {
        final currentTile = layout[row * gridSize + col];

        // Skip empty cells or obstacles
        if (currentTile == null || currentTile.isObstacle) continue;

        // Check all cells below in the same column
        for (int nextRow = row + 1; nextRow < gridSize; nextRow++) {
          final nextTile = layout[nextRow * gridSize + col];

          // Skip empty cells or obstacles
          if (nextTile == null || nextTile.isObstacle) continue;

          // If we found a non-empty cell, check if it's opposing
          if (currentTile.direction == ArrowDirection.down &&
              nextTile.direction == ArrowDirection.up) {
            return false; // Opposing arrows found
          }

          // We check ALL cells, not just the first non-empty one
          // (removed the break statement here)
        }
      }
    }

    return true; // No opposing arrows found
  }

  /// 检查所有箭头是否有相对的情况（不仅仅是相邻的）
  static bool validateNoOpposingArrowsAnywhere(
    List<ArrowTile?> layout,
    int gridSize,
  ) {
    // 检查每一行中是否有相对的箭头
    for (int row = 0; row < gridSize; row++) {
      List<ArrowTile> rightArrows = [];
      List<ArrowTile> leftArrows = [];

      for (int col = 0; col < gridSize; col++) {
        final tile = layout[row * gridSize + col];
        if (tile == null || tile.isObstacle) continue;

        if (tile.direction == ArrowDirection.right) {
          rightArrows.add(tile);
        } else if (tile.direction == ArrowDirection.left) {
          leftArrows.add(tile);
        }
      }

      // 如果同一行既有向右的箭头又有向左的箭头，则存在相对箭头
      if (rightArrows.isNotEmpty && leftArrows.isNotEmpty) {
        return false;
      }
    }

    // 检查每一列中是否有相对的箭头
    for (int col = 0; col < gridSize; col++) {
      List<ArrowTile> downArrows = [];
      List<ArrowTile> upArrows = [];

      for (int row = 0; row < gridSize; row++) {
        final tile = layout[row * gridSize + col];
        if (tile == null || tile.isObstacle) continue;

        if (tile.direction == ArrowDirection.down) {
          downArrows.add(tile);
        } else if (tile.direction == ArrowDirection.up) {
          upArrows.add(tile);
        }
      }

      // 如果同一列既有向下的箭头又有向上的箭头，则存在相对箭头
      if (downArrows.isNotEmpty && upArrows.isNotEmpty) {
        return false;
      }
    }

    return true; // 没有找到相对的箭头
  }

  /// 检查外围箭头是否只指向外侧
  static bool validateOutwardPointingArrows(
    List<ArrowTile?> layout,
    int gridSize,
  ) {
    int outwardPointingCount = 0;
    bool isValid = true;

    // 检查顶行的箭头 - 只能向上
    for (int col = 0; col < gridSize; col++) {
      final tile = layout[col]; // 顶行
      if (tile != null && !tile.isObstacle) {
        // 顶行箭头只能向上
        if (tile.direction != ArrowDirection.up) {
          isValid = false;
        }

        // 计算朝外的箭头数量
        if (tile.direction == ArrowDirection.up) {
          outwardPointingCount++;
        }
      }
    }

    // 检查底行的箭头 - 只能向下
    for (int col = 0; col < gridSize; col++) {
      final tile = layout[(gridSize - 1) * gridSize + col]; // 底行
      if (tile != null && !tile.isObstacle) {
        // 底行箭头只能向下
        if (tile.direction != ArrowDirection.down) {
          isValid = false;
        }

        // 计算朝外的箭头数量
        if (tile.direction == ArrowDirection.down) {
          outwardPointingCount++;
        }
      }
    }

    // 检查左列的箭头 - 只能向左
    for (int row = 1; row < gridSize - 1; row++) {
      // 排除已检查的角落
      final tile = layout[row * gridSize]; // 左列
      if (tile != null && !tile.isObstacle) {
        // 左列箭头只能向左
        if (tile.direction != ArrowDirection.left) {
          isValid = false;
        }

        // 计算朝外的箭头数量
        if (tile.direction == ArrowDirection.left) {
          outwardPointingCount++;
        }
      }
    }

    // 检查右列的箭头 - 只能向右
    for (int row = 1; row < gridSize - 1; row++) {
      // 排除已检查的角落
      final tile = layout[row * gridSize + gridSize - 1]; // 右列
      if (tile != null && !tile.isObstacle) {
        // 右列箭头只能向右
        if (tile.direction != ArrowDirection.right) {
          isValid = false;
        }

        // 计算朝外的箭头数量
        if (tile.direction == ArrowDirection.right) {
          outwardPointingCount++;
        }
      }
    }

    // 确保朝外箭头数量至少有3个，且所有边缘箭头方向有效
    return isValid && outwardPointingCount >= 3;
  }

  /// 生成可解的箭头布局，确保关卡可通关
  static List<ArrowTile?> generateSolvableLayout(
    List<ArrowTile?> layout,
    int gridSize,
  ) {
    final fixedLayout = List<ArrowTile?>.from(layout);

    // 第一步：确保外围箭头都朝外，这样可以保证有起点
    // 修复顶行箭头 - 向上
    for (int col = 0; col < gridSize; col++) {
      final index = col;
      final tile = layout[index];
      if (tile != null && !tile.isObstacle) {
        if (tile.direction != ArrowDirection.up) {
          fixedLayout[index] = ArrowTile(
            id: tile.id,
            direction: ArrowDirection.up,
            color: tile.color,
            row: tile.row,
            column: tile.column,
          );
        }
      }
    }

    // 修复底行箭头 - 向下
    for (int col = 0; col < gridSize; col++) {
      final index = (gridSize - 1) * gridSize + col;
      final tile = layout[index];
      if (tile != null && !tile.isObstacle) {
        if (tile.direction != ArrowDirection.down) {
          fixedLayout[index] = ArrowTile(
            id: tile.id,
            direction: ArrowDirection.down,
            color: tile.color,
            row: tile.row,
            column: tile.column,
          );
        }
      }
    }

    // 修复左列箭头 - 向左
    for (int row = 1; row < gridSize - 1; row++) {
      final index = row * gridSize;
      final tile = layout[index];
      if (tile != null && !tile.isObstacle) {
        if (tile.direction != ArrowDirection.left) {
          fixedLayout[index] = ArrowTile(
            id: tile.id,
            direction: ArrowDirection.left,
            color: tile.color,
            row: tile.row,
            column: tile.column,
          );
        }
      }
    }

    // 修复右列箭头 - 向右
    for (int row = 1; row < gridSize - 1; row++) {
      final index = row * gridSize + gridSize - 1;
      final tile = layout[index];
      if (tile != null && !tile.isObstacle) {
        if (tile.direction != ArrowDirection.right) {
          fixedLayout[index] = ArrowTile(
            id: tile.id,
            direction: ArrowDirection.right,
            color: tile.color,
            row: tile.row,
            column: tile.column,
          );
        }
      }
    }

    // 第二步：确保内部箭头形成可解的路径
    // 创建一个访问标记数组，用于追踪哪些箭头已经可以被消除
    List<bool> canBeRemoved = List.filled(gridSize * gridSize, false);

    // 标记所有边缘箭头为可移除（它们是起点）
    for (int i = 0; i < gridSize; i++) {
      // 顶行
      if (fixedLayout[i] != null && !fixedLayout[i]!.isObstacle) {
        canBeRemoved[i] = true;
      }

      // 底行
      int bottomIdx = (gridSize - 1) * gridSize + i;
      if (fixedLayout[bottomIdx] != null &&
          !fixedLayout[bottomIdx]!.isObstacle) {
        canBeRemoved[bottomIdx] = true;
      }

      // 左列
      int leftIdx = i * gridSize;
      if (fixedLayout[leftIdx] != null && !fixedLayout[leftIdx]!.isObstacle) {
        canBeRemoved[leftIdx] = true;
      }

      // 右列
      int rightIdx = i * gridSize + gridSize - 1;
      if (fixedLayout[rightIdx] != null && !fixedLayout[rightIdx]!.isObstacle) {
        canBeRemoved[rightIdx] = true;
      }
    }

    // 迭代修复内部箭头，直到所有箭头都可以被消除
    bool madeChanges;
    do {
      madeChanges = false;

      // 检查每个内部箭头
      for (int row = 1; row < gridSize - 1; row++) {
        for (int col = 1; col < gridSize - 1; col++) {
          int index = row * gridSize + col;

          // 跳过空位置或已经可以被消除的箭头
          if (fixedLayout[index] == null ||
              fixedLayout[index]!.isObstacle ||
              canBeRemoved[index]) {
            continue;
          }

          // 获取当前箭头的方向
          ArrowDirection currentDirection = fixedLayout[index]!.direction;

          // 检查当前方向是否有清晰的路径
          bool hasPath = false;
          int targetIndex = -1;

          switch (currentDirection) {
            case ArrowDirection.up:
              // 向上检查
              for (int r = row - 1; r >= 0; r--) {
                targetIndex = r * gridSize + col;
                if (fixedLayout[targetIndex] != null) {
                  // 如果找到的箭头可以被消除，那么当前箭头也可以被消除
                  if (canBeRemoved[targetIndex]) {
                    hasPath = true;
                  }
                  break;
                }
              }
              break;

            case ArrowDirection.down:
              // 向下检查
              for (int r = row + 1; r < gridSize; r++) {
                targetIndex = r * gridSize + col;
                if (fixedLayout[targetIndex] != null) {
                  if (canBeRemoved[targetIndex]) {
                    hasPath = true;
                  }
                  break;
                }
              }
              break;

            case ArrowDirection.left:
              // 向左检查
              for (int c = col - 1; c >= 0; c--) {
                targetIndex = row * gridSize + c;
                if (fixedLayout[targetIndex] != null) {
                  if (canBeRemoved[targetIndex]) {
                    hasPath = true;
                  }
                  break;
                }
              }
              break;

            case ArrowDirection.right:
              // 向右检查
              for (int c = col + 1; c < gridSize; c++) {
                targetIndex = row * gridSize + c;
                if (fixedLayout[targetIndex] != null) {
                  if (canBeRemoved[targetIndex]) {
                    hasPath = true;
                  }
                  break;
                }
              }
              break;
          }

          if (hasPath) {
            // 如果有路径，标记当前箭头为可消除
            canBeRemoved[index] = true;
            madeChanges = true;
          } else {
            // 如果没有路径，尝试修改方向
            // 尝试四个方向，找到一个可以连接到可消除箭头的方向
            List<ArrowDirection> directions = [
              ArrowDirection.up,
              ArrowDirection.down,
              ArrowDirection.left,
              ArrowDirection.right,
            ];

            // 打乱方向顺序，增加随机性
            directions.shuffle();

            for (ArrowDirection newDirection in directions) {
              if (newDirection == currentDirection) continue; // 跳过当前方向

              bool foundPath = false;

              switch (newDirection) {
                case ArrowDirection.up:
                  for (int r = row - 1; r >= 0; r--) {
                    targetIndex = r * gridSize + col;
                    if (fixedLayout[targetIndex] != null) {
                      if (canBeRemoved[targetIndex]) {
                        foundPath = true;
                      }
                      break;
                    }
                  }
                  break;

                case ArrowDirection.down:
                  for (int r = row + 1; r < gridSize; r++) {
                    targetIndex = r * gridSize + col;
                    if (fixedLayout[targetIndex] != null) {
                      if (canBeRemoved[targetIndex]) {
                        foundPath = true;
                      }
                      break;
                    }
                  }
                  break;

                case ArrowDirection.left:
                  for (int c = col - 1; c >= 0; c--) {
                    targetIndex = row * gridSize + c;
                    if (fixedLayout[targetIndex] != null) {
                      if (canBeRemoved[targetIndex]) {
                        foundPath = true;
                      }
                      break;
                    }
                  }
                  break;

                case ArrowDirection.right:
                  for (int c = col + 1; c < gridSize; c++) {
                    targetIndex = row * gridSize + c;
                    if (fixedLayout[targetIndex] != null) {
                      if (canBeRemoved[targetIndex]) {
                        foundPath = true;
                      }
                      break;
                    }
                  }
                  break;
              }

              if (foundPath) {
                // 找到了一个可行的方向，修改箭头
                fixedLayout[index] = ArrowTile(
                  id: fixedLayout[index]!.id,
                  direction: newDirection,
                  color: fixedLayout[index]!.color,
                  row: row,
                  column: col,
                );
                canBeRemoved[index] = true;
                madeChanges = true;
                break;
              }
            }
          }
        }
      }
    } while (madeChanges);

    // 确保所有箭头都可以被消除
    bool allRemovable = true;
    for (int i = 0; i < fixedLayout.length; i++) {
      if (fixedLayout[i] != null &&
          !fixedLayout[i]!.isObstacle &&
          !canBeRemoved[i]) {
        allRemovable = false;
        break;
      }
    }

    // 如果仍有无法消除的箭头，尝试更激进的修复
    if (!allRemovable) {
      // 找出所有无法消除的箭头
      for (int i = 0; i < fixedLayout.length; i++) {
        if (fixedLayout[i] != null &&
            !fixedLayout[i]!.isObstacle &&
            !canBeRemoved[i]) {
          // 获取行列位置
          int row = i ~/ gridSize;
          int col = i % gridSize;

          // 找到最近的可消除箭头
          int closestRemovableIndex = -1;
          int minDistance = gridSize * 2; // 初始化为一个较大的值

          for (int j = 0; j < fixedLayout.length; j++) {
            if (canBeRemoved[j] &&
                fixedLayout[j] != null &&
                !fixedLayout[j]!.isObstacle) {
              int targetRow = j ~/ gridSize;
              int targetCol = j % gridSize;

              int distance = (row - targetRow).abs() + (col - targetCol).abs();
              if (distance < minDistance) {
                minDistance = distance;
                closestRemovableIndex = j;
              }
            }
          }

          if (closestRemovableIndex != -1) {
            // 计算方向
            int targetRow = closestRemovableIndex ~/ gridSize;
            int targetCol = closestRemovableIndex % gridSize;

            ArrowDirection newDirection;

            if (row > targetRow) {
              newDirection = ArrowDirection.up;
            } else if (row < targetRow) {
              newDirection = ArrowDirection.down;
            } else if (col > targetCol) {
              newDirection = ArrowDirection.left;
            } else {
              newDirection = ArrowDirection.right;
            }

            // 修改箭头方向
            fixedLayout[i] = ArrowTile(
              id: fixedLayout[i]!.id,
              direction: newDirection,
              color: fixedLayout[i]!.color,
              row: row,
              column: col,
            );
          }
        }
      }
    }

    return fixedLayout;
  }

  /// Check if the current state has any valid moves left
  static bool hasValidMoves(GameState gameState) {
    for (final tile in gameState.currentLayout) {
      if (tile != null && !tile.isRemoved && !tile.isObstacle) {
        if (canTileBeClicked(gameState, tile.id)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Check if the game is in a dead-end state (no valid moves but not all tiles removed)
  static bool isDeadEnd(GameState gameState) {
    // Count remaining removable tiles
    int remainingTiles = 0;
    for (final tile in gameState.currentLayout) {
      if (tile != null && !tile.isRemoved && !tile.isObstacle) {
        remainingTiles++;
      }
    }

    // If there are remaining tiles but no valid moves, it's a dead end
    return remainingTiles > 0 && !hasValidMoves(gameState);
  }

  /// Check if all removable tiles have been removed
  static bool areAllRemovableTilesRemoved(GameState gameState) {
    for (final tile in gameState.currentLayout) {
      if (tile != null && !tile.isRemoved && !tile.isObstacle) {
        return false;
      }
    }
    return true;
  }

  /// Process a tile click and update the game state
  static GameState processTileClick(GameState gameState, int tileId) {
    if (!canTileBeClicked(gameState, tileId)) {
      // Invalid move, return unchanged state
      return gameState;
    }

    // Find the tile and mark it as removed
    final updatedLayout = List<ArrowTile?>.from(gameState.currentLayout);
    int tileIndex = -1;

    for (int i = 0; i < updatedLayout.length; i++) {
      if (updatedLayout[i]?.id == tileId) {
        tileIndex = i;
        updatedLayout[i] = updatedLayout[i]!.copyWith(isRemoved: true);
        break;
      }
    }

    if (tileIndex == -1) {
      // Tile not found, return unchanged state
      return gameState;
    }

    // Update move history
    final updatedMoveHistory = List<int>.from(gameState.moveHistory)
      ..add(tileId);

    // Game is won when all removable tiles are removed
    final isGameWon = areAllRemovableTilesRemoved(
      gameState.copyWith(currentLayout: updatedLayout),
    );

    // Return updated game state
    return gameState.copyWith(
      playerMoves: gameState.playerMoves + 1,
      correctMoves: gameState.correctMoves + 1,
      isGameWon: isGameWon,
      currentLayout: updatedLayout,
      moveHistory: updatedMoveHistory,
    );
  }

  /// Reset the game state to start the level over
  static GameState resetLevel(GameState gameState) {
    // Reset the layout to the initial state
    final resetLayout = gameState.currentLevel.layout.map((tile) {
      if (tile != null) {
        return tile.copyWith(isRemoved: false);
      }
      return null;
    }).toList();

    // Return a fresh game state
    return GameState(
      currentLevel: gameState.currentLevel,
      playerMoves: 0,
      correctMoves: 0,
      isGameWon: false,
      currentLayout: resetLayout,
      moveHistory: [],
    );
  }

  /// Check if any arrow in the level points towards an obstacle
  static bool hasArrowsPointingToObstacles(GameLevel level) {
    final gridSize = level.gridSize;
    final layout = level.layout;

    for (int i = 0; i < layout.length; i++) {
      final tile = layout[i];

      // Skip if not an arrow tile or if it's null
      if (tile == null || tile.isObstacle) {
        continue;
      }

      final arrowTile = tile;
      final row = arrowTile.row;
      final col = arrowTile.column;

      // Check if this arrow points to an obstacle
      switch (arrowTile.direction) {
        case ArrowDirection.up:
          // Check tiles above
          for (int r = row - 1; r >= 0; r--) {
            final checkIndex = r * gridSize + col;
            if (checkIndex >= 0 &&
                checkIndex < layout.length &&
                layout[checkIndex] != null) {
              // If we find an obstacle, this arrow points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                return true;
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
              // If we find an obstacle, this arrow points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                return true;
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
              // If we find an obstacle, this arrow points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                return true;
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
              // If we find an obstacle, this arrow points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                return true;
              }
              break; // Stop at the first tile we find
            }
          }
          break;
      }
    }

    return false; // No arrows pointing to obstacles found
  }

  /// Fix arrows pointing towards obstacles by changing their direction
  static List<ArrowTile?> fixArrowsPointingToObstacles(
    List<ArrowTile?> layout,
    int gridSize,
  ) {
    final fixedLayout = List<ArrowTile?>.from(layout);

    for (int i = 0; i < layout.length; i++) {
      final tile = layout[i];

      // Skip if not an arrow tile or if it's null
      if (tile == null || tile.isObstacle) {
        continue;
      }

      final arrowTile = tile;
      final row = arrowTile.row;
      final col = arrowTile.column;
      bool pointsToObstacle = false;

      // Check if this arrow points to an obstacle
      switch (arrowTile.direction) {
        case ArrowDirection.up:
          // Check tiles above
          for (int r = row - 1; r >= 0; r--) {
            final checkIndex = r * gridSize + col;
            if (checkIndex >= 0 &&
                checkIndex < layout.length &&
                layout[checkIndex] != null) {
              // If we find an obstacle, this arrow points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                pointsToObstacle = true;
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
              // If we find an obstacle, this arrow points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                pointsToObstacle = true;
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
              // If we find an obstacle, this arrow points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                pointsToObstacle = true;
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
              // If we find an obstacle, this arrow points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                pointsToObstacle = true;
              }
              break; // Stop at the first tile we find
            }
          }
          break;
      }

      // If this arrow points to an obstacle, change its direction
      if (pointsToObstacle) {
        // Find a direction that doesn't point to an obstacle
        ArrowDirection newDirection = _findSafeDirection(
          layout,
          gridSize,
          row,
          col,
          arrowTile.direction,
        );

        // Update the arrow's direction
        fixedLayout[i] = ArrowTile(
          id: arrowTile.id,
          direction: newDirection,
          color: arrowTile.color,
          row: row,
          column: col,
          isRemoved: arrowTile.isRemoved,
        );
      }
    }

    return fixedLayout;
  }

  /// Find a direction for an arrow that doesn't point to an obstacle
  static ArrowDirection _findSafeDirection(
    List<ArrowTile?> layout,
    int gridSize,
    int row,
    int col,
    ArrowDirection currentDirection,
  ) {
    // Try all directions in a specific order
    final directions = [
      ArrowDirection.right,
      ArrowDirection.down,
      ArrowDirection.left,
      ArrowDirection.up,
    ];

    // Start with the direction after the current one
    int startIndex = directions.indexOf(currentDirection);
    if (startIndex == -1) startIndex = 0;

    // Try each direction in order
    for (int i = 0; i < directions.length; i++) {
      final dirIndex = (startIndex + i + 1) % directions.length;
      final direction = directions[dirIndex];

      bool pointsToObstacle = false;

      // Check if this direction points to an obstacle
      switch (direction) {
        case ArrowDirection.up:
          // Check tiles above
          for (int r = row - 1; r >= 0; r--) {
            final checkIndex = r * gridSize + col;
            if (checkIndex >= 0 &&
                checkIndex < layout.length &&
                layout[checkIndex] != null) {
              // If we find an obstacle, this direction points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                pointsToObstacle = true;
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
              // If we find an obstacle, this direction points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                pointsToObstacle = true;
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
              // If we find an obstacle, this direction points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                pointsToObstacle = true;
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
              // If we find an obstacle, this direction points to an obstacle
              if (layout[checkIndex]!.isObstacle) {
                pointsToObstacle = true;
              }
              break; // Stop at the first tile we find
            }
          }
          break;
      }

      // If this direction doesn't point to an obstacle, use it
      if (!pointsToObstacle) {
        return direction;
      }
    }

    // If all directions point to obstacles, just return the original direction
    return currentDirection;
  }
}
