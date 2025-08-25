import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../models/player_stats.dart';
import '../../services/storage.dart';
import '../../widgets/common/glass_card.dart';

/// 记录界面
class RecordsScreen extends StatefulWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  PlayerStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  // 加载统计数据
  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await StorageService.instance.loadPlayerStats();
      setState(() {
        _stats = stats;
      });
    } catch (e) {
      print('Error loading stats: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // 格式化时间
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 返回按钮
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 16),

              // 标题
              const Center(
                child: Text('PLAYER RECORDS', style: AppStyles.titleLarge),
              ),

              const SizedBox(height: 32),

              // 统计数据
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryAccent,
                        ),
                      )
                    : ListView(
                        children: [
                          _buildStatCard(
                            'Total Play Time',
                            _formatDuration(
                              _stats?.totalPlaytime ?? Duration.zero,
                            ),
                            Icons.timer,
                          ),
                          _buildStatCard(
                            'Units Eliminated',
                            '${_stats?.totalUnitsEliminated ?? 0}',
                            Icons.grid_view,
                          ),
                          _buildStatCard(
                            'Perfect Matches',
                            '${_stats?.totalPlexiMatches ?? 0}',
                            Icons.auto_awesome,
                            borderColor: AppColors.secondaryAccent,
                          ),
                          _buildStatCard(
                            'Longest Combo Chain',
                            '${_stats?.longestComboChain ?? 0}x',
                            Icons.bolt,
                          ),
                          _buildStatCard(
                            'Highest Score',
                            '${_stats?.highestScore ?? 0}',
                            Icons.emoji_events,
                          ),

                          const SizedBox(height: 16),

                          // 关卡最高分
                          const Text(
                            'Level High Scores',
                            style: AppStyles.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          ..._buildLevelHighScores(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建统计卡片
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon, {
    Color? borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        borderColor: borderColor ?? Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: borderColor ?? AppColors.textColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: borderColor ?? AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建关卡最高分
  List<Widget> _buildLevelHighScores() {
    final levelHighScores = _stats?.levelHighScores ?? {};
    if (levelHighScores.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No level records yet',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      ];
    }

    final levelNames = [
      'Awakening',
      'Perfect Combination',
      'Geometric Maze',
      'Chameleon Hunter',
      'Purification Master',
      'Ultimate Challenge',
    ];

    return levelHighScores.entries.map((entry) {
      final levelId = entry.key;
      final score = entry.value;
      final levelName = levelId <= levelNames.length
          ? levelNames[levelId - 1]
          : 'Level $levelId';

      return ListTile(
        title: Text(
          levelName,
          style: const TextStyle(color: AppColors.textColor, fontSize: 16),
        ),
        trailing: Text(
          '$score',
          style: const TextStyle(
            color: AppColors.primaryAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }
}
