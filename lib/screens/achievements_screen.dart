import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/achievement_service.dart';
import '../utils/constants.dart';
import '../utils/preferences_manager.dart';
import '../widgets/achievement_card.dart';

/// Screen for displaying achievements
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  final List<Achievement> _achievements =
      AchievementService.getAllAchievements();
  final Map<String, bool> _unlockedAchievements = {};
  final Map<String, double> _achievementProgress = {}; //sadasdasdasdwdwdwd
  // 移除选中标签索引，因为不再需要底部导航栏

  // Filter options
  String _currentFilter = 'all';

  // Animation controller for achievement cards
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadAchievements();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: AnimationDurations.medium,
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    final unlockedIds = await PreferencesManager.getUnlockedAchievements();

    for (final achievement in _achievements) {
      _unlockedAchievements[achievement.id] = unlockedIds.contains(
        achievement.id,
      );
      _achievementProgress[achievement.id] =
          await PreferencesManager.getAchievementProgress(achievement.id);
    }

    if (mounted) {
      setState(() {});
    }
  }

  // Get filtered achievements based on current filter
  List<Achievement> get _filteredAchievements {
    switch (_currentFilter) {
      case 'unlocked':
        return _achievements
            .where((a) => _unlockedAchievements[a.id] == true)
            .toList();
      case 'locked':
        return _achievements
            .where((a) => _unlockedAchievements[a.id] != true)
            .toList();
      case 'in_progress':
        return _achievements.where((a) {
          final progress = _achievementProgress[a.id] ?? 0.0;
          final unlocked = _unlockedAchievements[a.id] ?? false;
          return progress > 0.0 && !unlocked;
        }).toList();
      case 'all':
      default:
        return _achievements;
    }
  }

  // Calculate achievement statistics
  int get _totalAchievements => _achievements.length;
  int get _unlockedCount => _unlockedAchievements.values.where((v) => v).length;
  double get _completionPercentage => _totalAchievements > 0
      ? (_unlockedCount / _totalAchievements) * 100
      : 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Color(0xFFEAE5E1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      // 返回按钮，如果是从主导航界面进入的，则不应该有返回按钮
                      // 但由于这个界面可能被直接导航到，所以保留返回按钮
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.textGraphite,
                    ),
                    const Expanded(
                      child: Text(
                        'Achievements',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGraphite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the header
                  ],
                ),
              ),

              // Achievement statistics
              _buildStatisticsCard(),

              // Filter options
              _buildFilterOptions(),

              // Achievements list
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _filteredAchievements.isEmpty
                      ? _buildEmptyState()
                      : _buildAchievementsList(),
                ),
              ),

              // 底部填充，为主导航栏留出空间
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.emoji_events,
                color: AppColors.arrowBlue,
                title: 'Total',
                value: _totalAchievements.toString(),
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                color: AppColors.arrowGreen,
                title: 'Unlocked',
                value: _unlockedCount.toString(),
              ),
              _buildStatItem(
                icon: Icons.lock_outline,
                color: AppColors.arrowTerracotta,
                title: 'Locked',
                value: (_totalAchievements - _unlockedCount).toString(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Overall progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Overall Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGraphite,
                    ),
                  ),
                  Text(
                    '${_completionPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentCoral,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  // Background
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  // Progress
                  FractionallySizedBox(
                    widthFactor: _completionPercentage / 100,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: const LinearGradient(
                          colors: [AppColors.accentCoral, Color(0xFFFF8F7D)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textGraphite,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: AppColors.disabledGray),
        ),
      ],
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildFilterChip('All', 'all'),
          _buildFilterChip('Unlocked', 'unlocked'),
          _buildFilterChip('In Progress', 'in_progress'),
          _buildFilterChip('Locked', 'locked'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String filter) {
    final isSelected = _currentFilter == filter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = filter;
          // Reset animation and play again when filter changes
          _animationController.reset();
          _animationController.forward();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentCoral
              : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.accentCoral
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textGraphite,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (_currentFilter) {
      case 'unlocked':
        message = 'No achievements unlocked yet.\nKeep playing to earn some!';
        icon = Icons.emoji_events_outlined;
        break;
      case 'in_progress':
        message =
            'No achievements in progress.\nStart playing to make progress!';
        icon = Icons.pending_outlined;
        break;
      case 'locked':
        message = 'All achievements are unlocked!\nYou\'re a master!';
        icon = Icons.celebration;
        break;
      default:
        message = 'No achievements found';
        icon = Icons.error_outline;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.disabledGray.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.disabledGray.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList() {
    return ListView.builder(
      itemCount: _filteredAchievements.length,
      itemBuilder: (context, index) {
        // Create staggered animation for each card
        final animation =
            Tween<Offset>(
              begin: const Offset(0.0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  (index / _filteredAchievements.length) * 0.7,
                  math.min(
                    1.0,
                    ((index + 1) / _filteredAchievements.length) * 0.7 + 0.3,
                  ),
                  curve: Curves.easeOutQuart,
                ),
              ),
            );

        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (index / _filteredAchievements.length) * 0.7,
              math.min(
                1.0,
                ((index + 1) / _filteredAchievements.length) * 0.7 + 0.3,
              ),
              curve: Curves.easeOut,
            ),
          ),
        );

        final achievement = _filteredAchievements[index];
        final isUnlocked = _unlockedAchievements[achievement.id] ?? false;
        final progress = _achievementProgress[achievement.id] ?? 0.0;

        return SlideTransition(
          position: animation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: AchievementCard(
              achievement: achievement,
              progress: progress,
              isUnlocked: isUnlocked,
            ),
          ),
        );
      },
    );
  }

  // 移除底部导航栏项目构建方法
}
