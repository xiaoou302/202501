import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../utils/arrow_validator.dart';
import '../utils/constants.dart';
import '../utils/level_generator.dart';

/// 关卡检查界面
class LevelCheckScreen extends StatefulWidget {
  const LevelCheckScreen({Key? key}) : super(key: key);

  @override
  State<LevelCheckScreen> createState() => _LevelCheckScreenState();
}

class _LevelCheckScreenState extends State<LevelCheckScreen> {
  bool _isLoading = true;
  Map<int, List<List<int>>> _problemLevels = {};
  List<GameLevel> _fixedLevels = [];
  bool _isFixing = false;

  @override
  void initState() {
    super.initState();
    _checkLevels();
  }

  /// 检查所有关卡
  Future<void> _checkLevels() async {
    setState(() {
      _isLoading = true;
    });

    // 检查所有关卡中的相邻箭头问题
    final problemLevels = <int, List<List<int>>>{};

    for (int i = 1; i <= 12; i++) {
      final level = LevelGenerator.getLevelById(i);
      if (level != null) {
        final opposingPairs = ArrowValidator.findAdjacentOpposingArrows(level);
        if (opposingPairs.isNotEmpty) {
          problemLevels[i] = opposingPairs;
        }
      }
    }

    setState(() {
      _problemLevels = problemLevels;
      _isLoading = false;
    });
  }

  /// 修复所有问题关卡
  Future<void> _fixLevels() async {
    setState(() {
      _isFixing = true;
    });

    final fixedLevels = <GameLevel>[];

    for (final entry in _problemLevels.entries) {
      final levelId = entry.key;
      final level = LevelGenerator.getLevelById(levelId);
      if (level != null) {
        final fixedLevel = ArrowValidator.fixAdjacentOpposingArrows(level);
        fixedLevels.add(fixedLevel);
      }
    }

    setState(() {
      _fixedLevels = fixedLevels;
      _isFixing = false;
    });

    // 显示修复完成提示
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('所有问题关卡已修复！'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关卡检查')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
      floatingActionButton: _problemLevels.isNotEmpty
          ? FloatingActionButton(
              onPressed: _isFixing ? null : _fixLevels,
              child: _isFixing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.auto_fix_high),
            )
          : null,
    );
  }

  /// 构建内容
  Widget _buildContent() {
    if (_problemLevels.isEmpty) {
      return const Center(
        child: Text(
          '所有关卡检查通过！\n没有发现相邻且方向相反的箭头。',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '发现 ${_problemLevels.length} 个关卡存在问题:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._problemLevels.entries.map((entry) {
            final levelId = entry.key;
            final pairs = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '关卡 $levelId: ${pairs.length} 对相邻且方向相反的箭头',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...pairs.map((pair) {
                      return Text('问题箭头索引: ${pair[0]} 和 ${pair[1]}');
                    }),
                  ],
                ),
              ),
            );
          }),
          if (_fixedLevels.isNotEmpty) ...[
            const Divider(),
            const Text(
              '已修复的关卡:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._fixedLevels.map((level) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '关卡 ${level.id}: ${level.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('描述: ${level.description}'),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
