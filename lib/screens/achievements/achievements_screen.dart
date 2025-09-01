import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/achievement.dart';
import '../../services/achievement_service.dart';
import '../../widgets/common/neumorphic_card.dart';

/// Achievements screen to display player's unlocked achievements
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final AchievementService _achievementService = AchievementService();
  List<Achievement> _achievements = [];
  bool _isLoading = true;

  // Filter options
  String _selectedFilter = 'all';

  // Sorting options
  String _selectedSort = 'progress';

  // Category counts
  int _completedCount = 0;
  int _inProgressCount = 0;
  int _lockedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  /// Load achievements data
  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get all achievements with current progress
      final achievements = await _achievementService.getAllAchievements();

      // Update counts
      _completedCount = achievements.where((a) => a.isCompleted).length;
      _inProgressCount = achievements
          .where((a) => !a.isCompleted && a.progress > 0)
          .length;
      _lockedCount = achievements.where((a) => a.progress == 0).length;

      // Apply sorting
      _sortAchievements(achievements);

      setState(() {
        _achievements = achievements;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading achievements: $e');
      setState(() {
        _achievements = [];
        _isLoading = false;
      });
    }
  }

  /// Apply filters to achievements
  List<Achievement> _getFilteredAchievements() {
    switch (_selectedFilter) {
      case 'completed':
        return _achievements.where((a) => a.isCompleted).toList();
      case 'in_progress':
        return _achievements
            .where((a) => !a.isCompleted && a.progress > 0)
            .toList();
      case 'locked':
        return _achievements.where((a) => a.progress == 0).toList();
      case 'all':
      default:
        return _achievements;
    }
  }

  /// Sort achievements based on selected option
  void _sortAchievements(List<Achievement> achievements) {
    switch (_selectedSort) {
      case 'progress':
        // Sort by completion (completed first, then by progress percentage)
        achievements.sort((a, b) {
          if (a.isCompleted && !b.isCompleted) return -1;
          if (!a.isCompleted && b.isCompleted) return 1;

          final aProgress = a.progress / a.maxProgress;
          final bProgress = b.progress / b.maxProgress;
          return bProgress.compareTo(aProgress);
        });
        break;

      case 'alphabetical':
        // Sort alphabetically by title
        achievements.sort((a, b) => a.title.compareTo(b.title));
        break;

      case 'game':
        // Sort by game category
        achievements.sort((a, b) {
          final aCategory = _getAchievementCategory(a);
          final bCategory = _getAchievementCategory(b);
          return aCategory.compareTo(bCategory);
        });
        break;
    }
  }

  /// Get achievement category based on ID
  String _getAchievementCategory(Achievement achievement) {
    final id = achievement.id;
    if (id.startsWith('memory_')) return 'Memory Match';
    if (id.startsWith('rhythm_') || id.startsWith('flow_')) return 'Flow Rush';
    if (id.startsWith('number_') || id.startsWith('sequence_'))
      return 'Number Memory';
    return 'General';
  }

  @override
  Widget build(BuildContext context) {
    final filteredAchievements = _getFilteredAchievements();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Achievements'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAchievements,
            tooltip: 'Refresh achievements',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Column(
              children: [
                // Achievement stats
                _buildAchievementStats(),

                // Filter and sort options
                _buildFilterOptions(),

                // Achievement list
                Expanded(
                  child: filteredAchievements.isEmpty
                      ? Center(
                          child: Text(
                            'No achievements found',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: filteredAchievements.length,
                          itemBuilder: (context, index) {
                            final achievement = filteredAchievements[index];
                            return _buildAchievementCard(achievement);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  /// Build achievement statistics summary
  Widget _buildAchievementStats() {
    final totalAchievements = _achievements.length;
    final completionPercentage = totalAchievements > 0
        ? (_completedCount / totalAchievements * 100).round()
        : 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: NeumorphicCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: totalAchievements > 0
                  ? _completedCount / totalAchievements
                  : 0,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              borderRadius: BorderRadius.circular(4),
              minHeight: 10,
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Completed',
                  _completedCount.toString(),
                  Colors.green,
                ),
                _buildStatItem(
                  'In Progress',
                  _inProgressCount.toString(),
                  Colors.orange,
                ),
                _buildStatItem('Locked', _lockedCount.toString(), Colors.grey),
                _buildStatItem(
                  'Completion',
                  '$completionPercentage%',
                  AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build a stat item
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }

  /// Build filter and sort options
  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Filter dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                labelText: 'Filter',
                labelStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
              ),
              dropdownColor: AppColors.cardBackground,
              items: [
                DropdownMenuItem(
                  value: 'all',
                  child: Text('All (${_achievements.length})'),
                ),
                DropdownMenuItem(
                  value: 'completed',
                  child: Text('Completed ($_completedCount)'),
                ),
                DropdownMenuItem(
                  value: 'in_progress',
                  child: Text('In Progress ($_inProgressCount)'),
                ),
                DropdownMenuItem(
                  value: 'locked',
                  child: Text('Locked ($_lockedCount)'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedFilter = value;
                  });
                }
              },
            ),
          ),

          const SizedBox(width: 8),

          // Sort dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedSort,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                labelText: 'Sort by',
                labelStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
              ),
              dropdownColor: AppColors.cardBackground,
              items: const [
                DropdownMenuItem(value: 'progress', child: Text('Progress')),
                DropdownMenuItem(value: 'alphabetical', child: Text('A-Z')),
                DropdownMenuItem(value: 'game', child: Text('Game')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSort = value;
                    _sortAchievements(_achievements);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final bool isLocked = achievement.progress == 0;
    final bool isCompleted = achievement.isCompleted;
    final double progressPercentage = achievement.maxProgress > 0
        ? achievement.progress / achievement.maxProgress
        : 0.0;

    Color iconColor;
    Color backgroundColor;
    Color progressColor;

    if (isLocked) {
      iconColor = Colors.grey;
      backgroundColor = Colors.grey[700]!;
      progressColor = Colors.grey;
    } else if (isCompleted) {
      iconColor = Colors.green;
      backgroundColor = Colors.green;
      progressColor = Colors.green;
    } else {
      iconColor = AppColors.primary;
      backgroundColor = AppColors.primary;
      progressColor = AppColors.primary;
    }

    // Get category badge color
    final category = _getAchievementCategory(achievement);
    Color categoryColor;
    switch (category) {
      case 'Memory Match':
        categoryColor = Colors.blue;
        break;
      case 'Flow Rush':
        categoryColor = Colors.purple;
        break;
      case 'Number Memory':
        categoryColor = Colors.green;
        break;
      default:
        categoryColor = Colors.amber;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: NeumorphicCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: backgroundColor, width: 2),
                  ),
                  child: Center(
                    child: Icon(
                      _getIconForAchievement(achievement.icon),
                      color: iconColor,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: categoryColor.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 10,
                                color: categoryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Completion status
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.5),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'COMPLETED',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        achievement.title,
                        style: TextStyle(
                          color: isLocked ? Colors.grey : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (!isLocked) ...[
              const SizedBox(height: 16),
              // Progress bar
              LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Text(
                '${achievement.progress}/${achievement.maxProgress}',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForAchievement(String iconName) {
    switch (iconName) {
      case 'check':
        return Icons.check_circle;
      case 'brain':
      case 'psychology':
        return Icons.psychology;
      case 'bolt':
        return Icons.bolt;
      case 'lock':
        return Icons.lock;
      case 'star':
        return Icons.star;
      case 'music_note':
        return Icons.music_note;
      case 'piano':
        return Icons.piano;
      case 'grid_view':
        return Icons.grid_view;
      case 'gamepad':
        return Icons.gamepad;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'score':
        return Icons.score;
      case 'format_list_numbered':
        return Icons.format_list_numbered;
      case 'numbers':
        return Icons.numbers;
      case 'memory':
        return Icons.memory;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'timer':
        return Icons.timer;
      case 'diversity_3':
        return Icons.diversity_3;
      default:
        return Icons.emoji_events;
    }
  }
}
