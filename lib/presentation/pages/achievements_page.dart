import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/achievement_model.dart';
import '../../data/repositories/achievement_repository.dart';

/// Achievements screen
class AchievementsPage extends StatefulWidget {
  /// Constructor
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage>
    with SingleTickerProviderStateMixin {
  final AchievementRepository _repository = AchievementRepository();
  List<Achievement> _achievements = [];
  bool _isLoading = true;
  late TabController _tabController;
  Achievement? _selectedAchievement;

  final Map<String, String> _categoryLabels = {
    'beginner': 'Beginner',
    'intermediate': 'Intermediate',
    'advanced': 'Advanced',
    'hidden': 'Hidden',
  };

  final Map<String, Color> _categoryColors = {
    'beginner': AppColors.carvedJadeGreen,
    'intermediate': AppColors.beeswaxAmber,
    'advanced': AppColors.mahjongRed,
    'hidden': AppColors.mahjongBlue,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAchievements();

    // Simulate some achievements being unlocked for demo purposes
    _simulateAchievementProgress();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Simulates achievement progress for demo purposes
  Future<void> _simulateAchievementProgress() async {
    // Wait for achievements to load
    await Future.delayed(const Duration(milliseconds: 500));

    // Unlock some achievements
    await _repository.unlockAchievement('first_win');
    await _repository.unlockAchievement('three_games');
    await _repository.unlockAchievement('quick_win');

    // Reload achievements
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
    });

    final achievements = await _repository.getAchievements();

    setState(() {
      _achievements = achievements;
      _isLoading = false;
    });
  }

  List<Achievement> _getAchievementsByCategory(String category) {
    return _achievements
        .where((a) => a.category == category && (!a.isHidden || a.isUnlocked))
        .toList();
  }

  int _getUnlockedCount(String category) {
    return _achievements
        .where((a) => a.category == category && a.isUnlocked)
        .length;
  }

  int _getTotalCount(String category) {
    return _achievements
        .where((a) => a.category == category && (!a.isHidden || a.isUnlocked))
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/6.jpg'),
            fit: BoxFit.cover,
            opacity: 1,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Container(
                padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                decoration: BoxDecoration(
                  color: AppColors.xuanPaperWhite.withOpacity(0.85),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.ebonyBrown,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Achievements',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ebonyBrown,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.carvedJadeGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events_outlined,
                        color: AppColors.xuanPaperWhite,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Overall progress
              _buildOverallProgress(),

              // Tab bar
              Container(
                color: AppColors.xuanPaperWhite.withOpacity(0.85),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.carvedJadeGreen,
                  unselectedLabelColor: AppColors.ebonyBrown.withOpacity(0.6),
                  indicatorColor: AppColors.carvedJadeGreen,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontSize: 12, // Smaller font size
                    fontWeight: FontWeight.bold,
                  ),
                  isScrollable: false, // Ensure tabs don't scroll
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ), // Smaller padding
                  tabs: [
                    _buildTabWithCount('BEGINNER', 'beginner'),
                    _buildTabWithCount(
                      'INTER',
                      'intermediate',
                    ), // Shortened label
                    _buildTabWithCount('ADVANCED', 'advanced'),
                    _buildTabWithCount('HIDDEN', 'hidden'),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.carvedJadeGreen,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          TabBarView(
                            controller: _tabController,
                            children: [
                              _buildAchievementsGrid('beginner'),
                              _buildAchievementsGrid('intermediate'),
                              _buildAchievementsGrid('advanced'),
                              _buildAchievementsGrid('hidden'),
                            ],
                          ),

                          // Achievement details overlay
                          if (_selectedAchievement != null)
                            _buildAchievementDetails(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabWithCount(String label, String category) {
    if (_isLoading) {
      return Tab(text: label);
    }

    final unlocked = _getUnlockedCount(category);
    final total = _getTotalCount(category);

    return Tab(
      height: 48, // Set a fixed height for the tab to prevent overflow
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum space needed
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(height: 1), // Reduced spacing
          Text(
            '$unlocked/$total',
            style: TextStyle(
              fontSize: 9,
              color: _categoryColors[category],
            ), // Slightly smaller font
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress() {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: AppColors.xuanPaperWhite.withOpacity(0.85),
        child: const LinearProgressIndicator(),
      );
    }

    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;
    final totalCount = _achievements
        .where((a) => !a.isHidden || a.isUnlocked)
        .length;
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.xuanPaperWhite.withOpacity(0.85),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Journey',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ebonyBrown,
                ),
              ),
              Text(
                '$unlockedCount/$totalCount Achievements',
                style: TextStyle(fontSize: 14, color: AppColors.ebonyBrown),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.birchWood.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.carvedJadeGreen,
            ),
            borderRadius: BorderRadius.circular(4),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid(String category) {
    final achievements = _getAchievementsByCategory(category);

    if (achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 48,
              color: AppColors.ebonyBrown.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              category == 'hidden'
                  ? 'Continue playing to discover hidden achievements'
                  : 'No achievements in this category yet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.ebonyBrown.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementItem(achievement);
      },
    );
  }

  Widget _buildAchievementItem(Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;
    final categoryColor =
        _categoryColors[achievement.category] ?? AppColors.carvedJadeGreen;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAchievement = achievement;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.xuanPaperWhite.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: isUnlocked
              ? Border.all(color: categoryColor, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? categoryColor.withOpacity(0.2)
                    : AppColors.birchWood.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? categoryColor
                            : AppColors.birchWood.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isUnlocked
                            ? _getIconData(achievement.icon)
                            : Icons.lock,
                        size: 28,
                        color: AppColors.xuanPaperWhite,
                      ),
                    ),
                  ),
                  if (isUnlocked)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: categoryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 12,
                          color: AppColors.xuanPaperWhite,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isUnlocked || !achievement.isHidden
                          ? achievement.title
                          : 'Hidden Achievement',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked
                            ? AppColors.ebonyBrown
                            : AppColors.ebonyBrown.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isUnlocked || !achievement.isHidden
                          ? achievement.description
                          : 'Keep playing to discover this achievement',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.ebonyBrown.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Progress indicator
            if (!isUnlocked &&
                achievement.progress > 0 &&
                achievement.progress < 100)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${achievement.progress}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: achievement.progress / 100,
                      backgroundColor: AppColors.birchWood.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 4,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementDetails() {
    final achievement = _selectedAchievement!;
    final isUnlocked = achievement.isUnlocked;
    final categoryColor =
        _categoryColors[achievement.category] ?? AppColors.carvedJadeGreen;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAchievement = null;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.xuanPaperWhite,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? categoryColor
                              : AppColors.birchWood.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isUnlocked
                              ? _getIconData(achievement.icon)
                              : Icons.lock,
                          size: 48,
                          color: AppColors.xuanPaperWhite,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isUnlocked || !achievement.isHidden
                            ? achievement.title
                            : 'Hidden Achievement',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ebonyBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _categoryLabels[achievement.category] ??
                              'Achievement',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        isUnlocked || !achievement.isHidden
                            ? achievement.description
                            : 'Keep playing to discover this achievement',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.ebonyBrown,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isUnlocked && achievement.unlockedAt != null)
                        Text(
                          'Unlocked on ${_formatDate(achievement.unlockedAt!)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: AppColors.ebonyBrown.withOpacity(0.7),
                          ),
                        ),
                      if (!isUnlocked && achievement.progress > 0)
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Progress: ${achievement.progress}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: achievement.progress / 100,
                              backgroundColor: AppColors.birchWood.withOpacity(
                                0.3,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                categoryColor,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              minHeight: 8,
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAchievement = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: categoryColor,
                          foregroundColor: AppColors.xuanPaperWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'seedling':
        return Icons.spa;
      case 'book-open':
        return Icons.menu_book;
      case 'bolt':
        return Icons.bolt;
      case 'trophy':
        return Icons.emoji_events;
      case 'random':
        return Icons.shuffle;
      case 'chess-knight':
        return Icons.psychology;
      case 'gamepad':
        return Icons.videogame_asset;
      case 'hand':
        return Icons.pan_tool;
      case 'crown':
        return Icons.stars;
      case 'fire':
        return Icons.local_fire_department;
      case 'star':
        return Icons.star;
      case 'moon':
        return Icons.nightlight_round;
      default:
        return Icons.emoji_events;
    }
  }
}
