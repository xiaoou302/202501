import 'game_logic.dart';
import 'level_generator.dart';
import '../models/arrow_tile.dart';
import '../models/game_level.dart';

/// A utility class to validate levels against game rules
class LevelValidator {
  /// Validate all levels against the game rules
  static Map<int, List<String>> validateAllLevels() {
    final Map<int, List<String>> issues = {};

    // Validate all 12 levels
    for (int i = 1; i <= 12; i++) {
      final level = LevelGenerator.getLevelById(i);
      if (level != null) {
        final levelIssues = validateLevel(level);
        if (levelIssues.isNotEmpty) {
          issues[i] = levelIssues;
        }
      }
    }

    return issues;
  }

  /// Validate a single level against all game rules
  static List<String> validateLevel(GameLevel level) {
    final List<String> issues = [];

    // 检查所有箭头是否有相对的情况（不仅仅是相邻的）
    if (!GameLogic.validateNoOpposingArrowsAnywhere(
      level.layout,
      level.gridSize,
    )) {
      issues.add(
        'Level has opposing arrows anywhere in the same row or column',
      );
    }

    // 检查箭头是否指向障碍物
    if (GameLogic.hasArrowsPointingToObstacles(level)) {
      issues.add('Level has arrows pointing at obstacles');
    }

    // 检查外围箭头是否都朝外，且至少有3个朝外箭头
    if (!GameLogic.validateOutwardPointingArrows(
      level.layout,
      level.gridSize,
    )) {
      final outwardCount = _countOutwardPointingArrows(level);
      if (outwardCount < 3) {
        issues.add(
          'Level has too few outward-pointing arrows on the border (${outwardCount}, minimum required is 3)',
        );
      } else {
        issues.add('Level has border arrows not pointing outward');
      }
    }

    // 检查空格比例
    final emptySpacesRatio = _calculateEmptySpacesRatio(level);
    if (emptySpacesRatio > 0.3) {
      // More than 30% empty spaces is too many
      issues.add(
        'Level has too many empty spaces (${(emptySpacesRatio * 100).toStringAsFixed(1)}%)',
      );
    }

    return issues;
  }

  /// 计算外围朝外箭头的数量
  static int _countOutwardPointingArrows(GameLevel level) {
    final layout = level.layout;
    final gridSize = level.gridSize;
    int outwardPointingCount = 0;

    // 检查顶行的向上箭头
    for (int col = 0; col < gridSize; col++) {
      final tile = layout[col]; // 顶行
      if (tile != null &&
          !tile.isObstacle &&
          tile.direction == ArrowDirection.up) {
        outwardPointingCount++;
      }
    }

    // 检查底行的向下箭头
    for (int col = 0; col < gridSize; col++) {
      final tile = layout[(gridSize - 1) * gridSize + col]; // 底行
      if (tile != null &&
          !tile.isObstacle &&
          tile.direction == ArrowDirection.down) {
        outwardPointingCount++;
      }
    }

    // 检查左列的向左箭头
    for (int row = 0; row < gridSize; row++) {
      final tile = layout[row * gridSize]; // 左列
      if (tile != null &&
          !tile.isObstacle &&
          tile.direction == ArrowDirection.left) {
        outwardPointingCount++;
      }
    }

    // 检查右列的向右箭头
    for (int row = 0; row < gridSize; row++) {
      final tile = layout[row * gridSize + gridSize - 1]; // 右列
      if (tile != null &&
          !tile.isObstacle &&
          tile.direction == ArrowDirection.right) {
        outwardPointingCount++;
      }
    }

    return outwardPointingCount;
  }

  /// Calculate the ratio of empty spaces to total grid size
  static double _calculateEmptySpacesRatio(GameLevel level) {
    int emptySpaces = 0;

    for (final tile in level.layout) {
      if (tile == null) {
        emptySpaces++;
      }
    }

    return emptySpaces / (level.gridSize * level.gridSize);
  }

  /// Print validation results to console
  static void printValidationResults() {
    final issues = validateAllLevels();

    if (issues.isEmpty) {
      print('All levels pass validation!');
      return;
    }

    print('Found issues in ${issues.length} levels:');
    issues.forEach((levelId, levelIssues) {
      print('Level $levelId:');
      for (final issue in levelIssues) {
        print('  - $issue');
      }
    });
  }
}
