import 'dart:developer';
import '../models/game_level.dart';
import 'arrow_validator.dart';
import 'level_generator.dart';

/// 关卡检查工具
class LevelChecker {
  /// 检查所有关卡中是否有相邻且方向相反的箭头
  static Map<int, List<List<int>>> checkAllLevelsForOpposingArrows() {
    final Map<int, List<List<int>>> problemLevels = {};

    // 检查所有12个关卡
    for (int i = 1; i <= 12; i++) {
      final level = LevelGenerator.getLevelById(i);
      if (level != null) {
        final opposingPairs = ArrowValidator.findAdjacentOpposingArrows(level);
        if (opposingPairs.isNotEmpty) {
          problemLevels[i] = opposingPairs;
          log('关卡 $i 中发现 ${opposingPairs.length} 对相邻且方向相反的箭头');
        }
      }
    }

    return problemLevels;
  }

  /// 修复所有关卡中相邻且方向相反的箭头
  static List<GameLevel> fixAllLevelsWithOpposingArrows() {
    final List<GameLevel> fixedLevels = [];

    // 检查并修复所有12个关卡
    for (int i = 1; i <= 12; i++) {
      final level = LevelGenerator.getLevelById(i);
      if (level != null) {
        final opposingPairs = ArrowValidator.findAdjacentOpposingArrows(level);
        if (opposingPairs.isNotEmpty) {
          log('修复关卡 $i 中的 ${opposingPairs.length} 对相邻且方向相反的箭头');
          final fixedLevel = ArrowValidator.fixAdjacentOpposingArrows(level);
          fixedLevels.add(fixedLevel);
        }
      }
    }

    return fixedLevels;
  }

  /// 运行检查并打印结果
  static void runCheck() {
    log('开始检查所有关卡中的相邻箭头问题...');
    final problemLevels = checkAllLevelsForOpposingArrows();

    if (problemLevels.isEmpty) {
      log('所有关卡检查通过！没有发现相邻且方向相反的箭头。');
    } else {
      log('发现 ${problemLevels.length} 个关卡存在问题:');
      problemLevels.forEach((levelId, pairs) {
        log('关卡 $levelId: ${pairs.length} 对相邻且方向相反的箭头');
      });
    }
  }
}
