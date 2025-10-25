import 'package:flutter/material.dart';
import '../../core/models/user_stats_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/chapter_repository.dart';
import '../../data/local/storage_service.dart';
import '../theme/app_colors.dart';

/// Records screen - Game statistics and achievements
class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  late UserRepository _userRepository;
  late ChapterRepository _chapterRepository;
  UserStats _userStats = const UserStats();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final storage = await StorageService.init();
    _userRepository = UserRepository(storage);
    _chapterRepository = ChapterRepository();

    setState(() {
      _userStats = _userRepository.getUserStats();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.parchmentGradient,
          ),
          image: DecorationImage(
            image: NetworkImage(
              'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAFElEQVQI12P4//8/AwMDAwMDAwMAFwMBAweciQsAAAAASUVORK5CYII=',
            ),
            repeat: ImageRepeat.repeat,
            opacity: 0.03,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.parchmentDark.withOpacity(0.3),
                      AppColors.parchmentMedium.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderMedium, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowBrown.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inkBlack.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                        iconSize: 20,
                        onPressed: () => Navigator.pop(context),
                        color: AppColors.inkBrown,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guardian Records',
                            style: TextStyle(
                              color: AppColors.inkBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Your Journey Statistics',
                            style: TextStyle(
                              color: AppColors.inkFaded,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.magicGold,
                      size: 28,
                    ),
                  ],
                ),
              ),

              // Stats content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Overview Stats Card
                            _buildOverviewCard(),
                            const SizedBox(height: 16),

                            // Detailed Stats
                            _buildDetailedStatsSection(),
                            const SizedBox(height: 16),

                            // Chapter Progress
                            _buildChapterProgressSection(),
                            const SizedBox(height: 16),

                            // Achievements
                            _buildAchievementsSection(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Overview Card with main stats
  Widget _buildOverviewCard() {
    final totalChapters = _chapterRepository.getAllChapters().length;
    final completionPercentage = totalChapters > 0
        ? (_userStats.chaptersCompleted / totalChapters) * 100
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.magicGold.withOpacity(0.15),
            AppColors.magicBlue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.magicGold.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.magicGold.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.magicGold,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Guardian Level ${_calculateGuardianLevel()}',
            style: TextStyle(
              color: AppColors.magicGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getGuardianTitle(),
            style: TextStyle(
              color: AppColors.inkFaded,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat(
                Icons.auto_stories_rounded,
                '${_userStats.chaptersCompleted}/$totalChapters',
                'Chapters',
                AppColors.magicBlue,
              ),
              Container(width: 1, height: 40, color: AppColors.borderLight),
              _buildQuickStat(
                Icons.star_rounded,
                _calculateAverageStars().toStringAsFixed(1),
                'Avg Stars',
                AppColors.magicGold,
              ),
              Container(width: 1, height: 40, color: AppColors.borderLight),
              _buildQuickStat(
                Icons.catching_pokemon_rounded,
                '${completionPercentage.toStringAsFixed(0)}%',
                'Complete',
                AppColors.magicPurple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: AppColors.inkFaded, fontSize: 11)),
      ],
    );
  }

  // Detailed Stats Section
  Widget _buildDetailedStatsSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentLight,
            AppColors.parchmentMedium.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBrown.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: AppColors.magicBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Detailed Statistics',
                style: TextStyle(
                  color: AppColors.inkBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatRow(
            'Keywords Collected',
            '${_getTotalKeywordsSaved()}',
            Icons.edit_note_rounded,
            AppColors.magicBlue,
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Total Playtime',
            _formatDuration(_userStats.totalTimePlayed),
            Icons.access_time_rounded,
            AppColors.magicPurple,
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Perfect Chapters',
            '${_getPerfectChaptersCount()}',
            Icons.check_circle_rounded,
            AppColors.arcaneGreen,
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Total Stars Earned',
            '${_getTotalStarsEarned()}',
            Icons.star_rounded,
            AppColors.magicGold,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: AppColors.inkFaded, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.inkBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Chapter Progress Section
  Widget _buildChapterProgressSection() {
    final allChapters = _chapterRepository.getAllChapters();
    final completedChapters = _userStats.chapterProgress.entries
        .where((entry) => entry.value.isCompleted)
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentLight,
            AppColors.parchmentMedium.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBrown.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: AppColors.magicGold,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Chapter Mastery',
                style: TextStyle(
                  color: AppColors.inkBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (completedChapters.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Icon(
                      Icons.bookmark_border_rounded,
                      color: AppColors.inkFaded.withOpacity(0.3),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No chapters completed yet',
                      style: TextStyle(
                        color: AppColors.inkFaded,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start your journey to become a Guardian!',
                      style: TextStyle(
                        color: AppColors.inkFaded.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...completedChapters.take(5).map((entry) {
              final chapter = allChapters.firstWhere(
                (c) => c.id == entry.key,
                orElse: () => allChapters.first,
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildChapterProgressItem(chapter, entry.value),
              );
            }),
          if (completedChapters.length > 5)
            Center(
              child: Text(
                '+${completedChapters.length - 5} more chapters completed',
                style: TextStyle(
                  color: AppColors.inkFaded,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChapterProgressItem(chapter, ChapterProgress progress) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.parchmentDark.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.magicGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${chapter.id}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.title,
                  style: TextStyle(
                    color: AppColors.inkBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  chapter.subtitle,
                  style: TextStyle(
                    color: AppColors.inkFaded,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(3, (index) {
              return Icon(
                index < progress.starRating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: index < progress.starRating
                    ? AppColors.magicGold
                    : AppColors.borderMedium,
                size: 18,
              );
            }),
          ),
        ],
      ),
    );
  }

  // Achievements Section
  Widget _buildAchievementsSection() {
    final achievements = _getAchievements();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentLight,
            AppColors.parchmentMedium.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBrown.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: AppColors.magicGold,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Achievements',
                style: TextStyle(
                  color: AppColors.inkBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: achievements.map((achievement) {
              return _buildAchievementBadge(
                achievement['icon'] as IconData,
                achievement['title'] as String,
                achievement['unlocked'] as bool,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(IconData icon, String title, bool unlocked) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: unlocked
            ? LinearGradient(
                colors: [
                  AppColors.magicGold.withOpacity(0.2),
                  AppColors.magicBlue.withOpacity(0.1),
                ],
              )
            : null,
        color: unlocked ? null : AppColors.parchmentDark.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked
              ? AppColors.magicGold.withOpacity(0.5)
              : AppColors.borderLight,
          width: unlocked ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: unlocked
                ? AppColors.magicGold
                : AppColors.inkFaded.withOpacity(0.3),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: unlocked
                  ? AppColors.inkBlack
                  : AppColors.inkFaded.withOpacity(0.5),
              fontSize: 10,
              fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  int _calculateGuardianLevel() {
    return (_userStats.chaptersCompleted / 3).floor() + 1;
  }

  String _getGuardianTitle() {
    final level = _calculateGuardianLevel();
    if (level >= 11) return 'Master Guardian';
    if (level >= 8) return 'Elite Guardian';
    if (level >= 5) return 'Advanced Guardian';
    if (level >= 3) return 'Veteran Guardian';
    if (level >= 2) return 'Junior Guardian';
    return 'Apprentice Guardian';
  }

  int _getTotalKeywordsSaved() {
    return _userStats.chapterProgress.values.fold<int>(
      0,
      (sum, progress) => sum + progress.savedKeywords.length,
    );
  }

  int _getPerfectChaptersCount() {
    return _userStats.chapterProgress.values.where((p) => p.isCompleted).length;
  }

  int _getTotalStarsEarned() {
    return _userStats.chapterProgress.values.fold<int>(
      0,
      (sum, progress) => sum + progress.starRating,
    );
  }

  double _calculateAverageStars() {
    if (_userStats.chapterProgress.isEmpty) return 0.0;
    return _getTotalStarsEarned() / _userStats.chapterProgress.length;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  List<Map<String, dynamic>> _getAchievements() {
    return [
      {
        'icon': Icons.star_rounded,
        'title': 'First Steps',
        'unlocked': _userStats.chaptersCompleted >= 1,
      },
      {
        'icon': Icons.auto_awesome_rounded,
        'title': 'Perfect Run',
        'unlocked': _getPerfectChaptersCount() >= 1,
      },
      {
        'icon': Icons.collections_bookmark_rounded,
        'title': 'Collector',
        'unlocked': _getTotalKeywordsSaved() >= 50,
      },
      {
        'icon': Icons.speed_rounded,
        'title': 'Speed Reader',
        'unlocked': _userStats.totalTimePlayed.inMinutes >= 30,
      },
      {
        'icon': Icons.workspace_premium_rounded,
        'title': 'Elite',
        'unlocked': _userStats.chaptersCompleted >= 10,
      },
      {
        'icon': Icons.military_tech_rounded,
        'title': 'Master',
        'unlocked': _userStats.chaptersCompleted >= 33,
      },
    ];
  }
}
