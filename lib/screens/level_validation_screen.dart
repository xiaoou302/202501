import 'package:flutter/material.dart';
import '../utils/game_logic.dart';
import '../utils/level_generator.dart';
import '../utils/level_fixer.dart';
import '../models/game_level.dart';
import '../models/arrow_tile.dart';

/// A screen to validate all levels against game rules
class LevelValidationScreen extends StatefulWidget {
  const LevelValidationScreen({Key? key}) : super(key: key);

  @override
  State<LevelValidationScreen> createState() => _LevelValidationScreenState();
}

class _LevelValidationScreenState extends State<LevelValidationScreen> {
  Map<int, List<String>> _issues = {};
  bool _isValidating = true;
  bool _isFixing = false;

  @override
  void initState() {
    super.initState();
    _validateAllLevels();
  }

  /// Validate all levels against the game rules
  Future<void> _validateAllLevels() async {
    final Map<int, List<String>> issues = {};

    // Validate all 12 levels
    for (int i = 1; i <= 12; i++) {
      final level = LevelGenerator.getLevelById(i);
      if (level != null) {
        final levelIssues = _validateLevel(level);
        if (levelIssues.isNotEmpty) {
          issues[i] = levelIssues;
        }
      }
    }

    setState(() {
      _issues = issues;
      _isValidating = false;
    });
  }

  /// Validate a single level against all game rules
  List<String> _validateLevel(GameLevel level) {
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

    // 检查外围箭头朝外的数量是否在1-3个之间
    if (!GameLogic.validateOutwardPointingArrows(
      level.layout,
      level.gridSize,
    )) {
      final outwardCount = _countOutwardPointingArrows(level);
      if (outwardCount < 1) {
        issues.add('Level has no outward-pointing arrows on the border');
      } else if (outwardCount > 3) {
        issues.add(
          'Level has too many outward-pointing arrows on the border (${outwardCount}, max allowed is 3)',
        );
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
  int _countOutwardPointingArrows(GameLevel level) {
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
  double _calculateEmptySpacesRatio(GameLevel level) {
    int emptySpaces = 0;

    for (final tile in level.layout) {
      if (tile == null) {
        emptySpaces++;
      }
    }

    return emptySpaces / (level.gridSize * level.gridSize);
  }

  /// Fix a level that has issues
  Future<void> _fixLevel(int levelId) async {
    setState(() {
      _isFixing = true;
    });

    try {
      // Get the level
      final level = LevelGenerator.getLevelById(levelId);
      if (level == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Level not found')));
        return;
      }

      // Fix the level
      final fixedLevel = LevelFixer.fixLevel(level);

      // Validate the fixed level
      final issues = _validateLevel(fixedLevel);

      if (issues.isEmpty) {
        // Update the issues map
        setState(() {
          _issues.remove(levelId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Level $levelId fixed successfully')),
        );
      } else {
        // Update the issues map with the remaining issues
        setState(() {
          _issues[levelId] = issues;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Some issues could not be fixed in Level $levelId'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fixing level: $e')));
    } finally {
      setState(() {
        _isFixing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level Validation'),
        actions: [
          if (!_isValidating)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _isValidating = true;
                });
                _validateAllLevels();
              },
              tooltip: 'Refresh validation',
            ),
        ],
      ),
      body: _isValidating
          ? const Center(child: CircularProgressIndicator())
          : _buildValidationResults(),
    );
  }

  Widget _buildValidationResults() {
    if (_issues.isEmpty) {
      return const Center(
        child: Text(
          'All levels pass validation!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _issues.length,
      itemBuilder: (context, index) {
        final levelId = _issues.keys.elementAt(index);
        final levelIssues = _issues[levelId]!;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level $levelId',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...levelIssues.map(
                  (issue) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(issue)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _isFixing ? null : () => _fixLevel(levelId),
                  child: _isFixing
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Fixing...'),
                          ],
                        )
                      : const Text('Fix Level'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
