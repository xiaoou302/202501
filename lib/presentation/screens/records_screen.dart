import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/local/local_storage.dart';
import '../widgets/particle_background.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen>
    with SingleTickerProviderStateMixin {
  int _totalGames = 0;
  int _totalWins = 0;
  int _totalStars = 0;
  int _perfectClears = 0;
  int _totalScore = 0;
  List<_LevelRecord> _levelRecords = [];
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    _loadRecords();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _loadRecords() {
    _totalGames = LocalStorage.getTotalGames();
    _totalWins = LocalStorage.getTotalWins();

    int totalStars = 0;
    int perfectClears = 0;
    int totalScore = 0;

    _levelRecords = GameLevels.levels.map((level) {
      final stars = LocalStorage.getLevelStars(level.id);
      final score = LocalStorage.getLevelBestScore(level.id);
      final time = LocalStorage.getLevelBestTime(level.id);

      totalStars += stars;
      if (stars == 3) perfectClears++;
      totalScore += score;

      return _LevelRecord(
        levelId: level.id,
        levelName: level.name,
        stars: stars,
        bestScore: score,
        bestTime: time,
        totalTime: level.time,
        pairs: level.pairs,
      );
    }).toList();

    _totalStars = totalStars;
    _perfectClears = perfectClears;
    _totalScore = totalScore;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildJourneyProgress(),
                        const SizedBox(height: 16),
                        _buildOverallStats(),
                        const SizedBox(height: 16),
                        _buildPerformanceInsights(),
                        const SizedBox(height: 24),
                        _buildLevelRecords(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.midnight, AppColors.midnight.withOpacity(0)],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticUtils.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2ECC71).withOpacity(0.3),
                    AppColors.slate,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF2ECC71).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF2ECC71),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.chartLine,
                      size: 12,
                      color: Color(0xFF2ECC71),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'YOUR JOURNEY',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFF2ECC71),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Game Records',
                  style: AppTextStyles.h2.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
          const FaIcon(
            FontAwesomeIcons.trophy,
            size: 24,
            color: Color(0xFFF1C40F),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyProgress() {
    final maxStars = GameLevels.levels.length * 3;
    final starPercentage = maxStars > 0 ? (_totalStars / maxStars) : 0.0;
    final levelsCompleted = _levelRecords.where((r) => r.stars > 0).length;
    final totalLevels = GameLevels.levels.length;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.3),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animController,
                curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
              ),
            ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3498DB).withOpacity(0.2),
                const Color(0xFF9B59B6).withOpacity(0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF3498DB).withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3498DB).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3498DB).withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.mapLocation,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Journey Progress',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 20,
                            color: const Color(0xFF3498DB),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$levelsCompleted of $totalLevels levels explored',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: AppColors.mica.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Star Collection Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stars Collected',
                    style: AppTextStyles.label.copyWith(
                      color: const Color(0xFFF1C40F),
                      fontSize: 11,
                    ),
                  ),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.solidStar,
                        size: 14,
                        color: Color(0xFFF1C40F),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$_totalStars / $maxStars',
                        style: AppTextStyles.stat.copyWith(
                          fontSize: 18,
                          color: const Color(0xFFF1C40F),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: starPercentage,
                  minHeight: 12,
                  backgroundColor: AppColors.midnight.withOpacity(0.5),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFF1C40F),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Perfect Clears
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.crown,
                        size: 14,
                        color: Color(0xFFE67E22),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Perfect Clears (3★)',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.mica.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$_perfectClears',
                    style: AppTextStyles.stat.copyWith(
                      fontSize: 18,
                      color: const Color(0xFFE67E22),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStats() {
    final winRate = _totalGames > 0
        ? (_totalWins / _totalGames * 100).toInt()
        : 0;
    final avgScore = _totalWins > 0 ? (_totalScore / _totalWins).round() : 0;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.4),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animController,
                curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
              ),
            ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF2ECC71).withOpacity(0.15),
                AppColors.slate.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF2ECC71).withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2ECC71).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2ECC71).withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.paw,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Statistics',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 20,
                            color: const Color(0xFF2ECC71),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your adventure in nature',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: AppColors.mica.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Games',
                      _totalGames.toString(),
                      FontAwesomeIcons.gamepad,
                      const Color(0xFF3498DB),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Victories',
                      _totalWins.toString(),
                      FontAwesomeIcons.trophy,
                      const Color(0xFFF1C40F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Win Rate',
                      '$winRate%',
                      FontAwesomeIcons.chartLine,
                      const Color(0xFF2ECC71),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Avg Score',
                      avgScore.toString(),
                      FontAwesomeIcons.bullseye,
                      const Color(0xFF9B59B6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceInsights() {
    final totalAttempts = _totalGames;
    final successRate = totalAttempts > 0 ? (_totalWins / totalAttempts) : 0.0;

    // Calculate best performance level
    final sortedByScore = List<_LevelRecord>.from(_levelRecords)
      ..sort((a, b) => b.bestScore.compareTo(a.bestScore));
    final topLevel = sortedByScore.isNotEmpty ? sortedByScore.first : null;

    // Calculate average star rating
    final totalStarsEarned = _levelRecords.fold(0, (sum, r) => sum + r.stars);
    final levelsPlayed = _levelRecords.where((r) => r.bestScore > 0).length;
    final avgStars = levelsPlayed > 0 ? (totalStarsEarned / levelsPlayed) : 0.0;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.5),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animController,
                curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
              ),
            ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF9B59B6).withOpacity(0.15),
                AppColors.slate.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF9B59B6).withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9B59B6).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9B59B6).withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.chartBar,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Performance Insights',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 20,
                            color: const Color(0xFF9B59B6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your strengths and achievements',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: AppColors.mica.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Success Rate Indicator
              _buildInsightRow(
                'Success Rate',
                '${(successRate * 100).toStringAsFixed(1)}%',
                successRate,
                FontAwesomeIcons.bullseye,
                _getSuccessRateColor(successRate),
              ),
              const SizedBox(height: 16),

              // Average Stars
              _buildInsightRow(
                'Average Stars',
                avgStars.toStringAsFixed(1),
                avgStars / 3,
                FontAwesomeIcons.solidStar,
                const Color(0xFFF1C40F),
              ),

              if (topLevel != null && topLevel.bestScore > 0) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.midnight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFF1C40F).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.medal,
                        size: 28,
                        color: Color(0xFFF1C40F),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Best Performance',
                              style: AppTextStyles.label.copyWith(
                                color: const Color(0xFFF1C40F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Level ${topLevel.levelId}: ${topLevel.levelName}',
                              style: AppTextStyles.h3.copyWith(
                                fontSize: 16,
                                color: AppColors.mica,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Score: ${topLevel.bestScore}',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 13,
                                color: AppColors.mica.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightRow(
    String label,
    String value,
    double progress,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(icon, size: 14, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.mica.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: AppTextStyles.stat.copyWith(fontSize: 18, color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppColors.midnight.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Color _getSuccessRateColor(double rate) {
    if (rate >= 0.8) return const Color(0xFF2ECC71);
    if (rate >= 0.6) return const Color(0xFF3498DB);
    if (rate >= 0.4) return const Color(0xFFF1C40F);
    return const Color(0xFFE67E22);
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.midnight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          FaIcon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.stat.copyWith(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 9,
              color: AppColors.mica.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelRecords() {
    // Group levels by difficulty
    final easyLevels = _levelRecords.where((r) => r.levelId <= 3).toList();
    final mediumLevels = _levelRecords
        .where((r) => r.levelId > 3 && r.levelId <= 6)
        .toList();
    final hardLevels = _levelRecords
        .where((r) => r.levelId > 6 && r.levelId <= 9)
        .toList();
    final expertLevels = _levelRecords.where((r) => r.levelId > 9).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.listCheck,
              size: 16,
              color: Color(0xFF2ECC71),
            ),
            const SizedBox(width: 10),
            Text(
              'Level Records',
              style: AppTextStyles.h3.copyWith(
                fontSize: 20,
                color: const Color(0xFF2ECC71),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Track your progress through each level',
          style: AppTextStyles.body.copyWith(
            fontSize: 12,
            color: AppColors.mica.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 20),

        _buildDifficultySection(
          'Easy Levels',
          easyLevels,
          const Color(0xFF2ECC71),
          FontAwesomeIcons.seedling,
        ),
        const SizedBox(height: 16),
        _buildDifficultySection(
          'Medium Levels',
          mediumLevels,
          const Color(0xFF3498DB),
          FontAwesomeIcons.tree,
        ),
        const SizedBox(height: 16),
        _buildDifficultySection(
          'Hard Levels',
          hardLevels,
          const Color(0xFFE67E22),
          FontAwesomeIcons.fire,
        ),
        const SizedBox(height: 16),
        _buildDifficultySection(
          'Expert Levels',
          expertLevels,
          const Color(0xFF9B59B6),
          FontAwesomeIcons.bolt,
        ),
      ],
    );
  }

  Widget _buildDifficultySection(
    String title,
    List<_LevelRecord> levels,
    Color color,
    IconData icon,
  ) {
    if (levels.isEmpty) return const SizedBox.shrink();

    final completedCount = levels.where((l) => l.stars > 0).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Row(
            children: [
              FaIcon(icon, size: 16, color: color),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.h3.copyWith(fontSize: 16, color: color),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.midnight.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completedCount/${levels.length}',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...levels.map((record) => _buildLevelRecordCard(record)),
      ],
    );
  }

  Widget _buildLevelRecordCard(_LevelRecord record) {
    final levelColor = _getLevelColor(record.levelId);
    final animalIcon = _getLevelAnimalIcon(record.levelId);
    final hasPlayed = record.bestScore > 0;
    final efficiency = hasPlayed
        ? (record.bestScore / (record.pairs * 200)).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: hasPlayed
              ? [
                  levelColor.withOpacity(0.15),
                  AppColors.slate.withOpacity(0.85),
                ]
              : [
                  AppColors.slate.withOpacity(0.3),
                  AppColors.slate.withOpacity(0.2),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasPlayed
              ? levelColor.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: 2,
        ),
        boxShadow: hasPlayed
            ? [
                BoxShadow(
                  color: levelColor.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Level icon with animal theme
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: hasPlayed
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [levelColor, levelColor.withOpacity(0.7)],
                        )
                      : LinearGradient(
                          colors: [
                            AppColors.textSecondary.withOpacity(0.5),
                            AppColors.textSecondary.withOpacity(0.3),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: hasPlayed
                      ? [
                          BoxShadow(
                            color: levelColor.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Opacity(
                        opacity: 0.25,
                        child: FaIcon(
                          animalIcon,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '${record.levelId}',
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Level info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            record.levelName,
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 19,
                              color: hasPlayed
                                  ? AppColors.mica
                                  : AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (hasPlayed && record.stars == 3)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF1C40F), Color(0xFFF39C12)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFF1C40F,
                                  ).withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.crown,
                                  size: 10,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'PERFECT',
                                  style: AppTextStyles.label.copyWith(
                                    fontSize: 9,
                                    color: Colors.white,
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
                      '${record.pairs} pairs • ${record.totalTime}s time limit',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 11,
                        color: AppColors.mica.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (hasPlayed) ...[
            const SizedBox(height: 16),
            // Stats row
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.midnight.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: levelColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailStat(
                        'Score',
                        record.bestScore.toString(),
                        FontAwesomeIcons.bullseye,
                        const Color(0xFFF1C40F),
                      ),
                      Container(
                        width: 1,
                        height: 32,
                        color: AppColors.mica.withOpacity(0.1),
                      ),
                      _buildDetailStat(
                        'Time Left',
                        '${record.bestTime}s',
                        FontAwesomeIcons.clock,
                        levelColor,
                      ),
                      Container(
                        width: 1,
                        height: 32,
                        color: AppColors.mica.withOpacity(0.1),
                      ),
                      _buildDetailStat(
                        'Efficiency',
                        '${(efficiency * 100).toInt()}%',
                        FontAwesomeIcons.chartLine,
                        const Color(0xFF2ECC71),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildStars(record.stars, levelColor),
                ],
              ),
            ),
          ] else
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.midnight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.lock,
                    size: 12,
                    color: AppColors.textSecondary.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Not played yet - Start your adventure!',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        FaIcon(icon, size: 16, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.stat.copyWith(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            fontSize: 9,
            color: AppColors.mica.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildStars(int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: FaIcon(
            index < count ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
            size: 12,
            color: index < count
                ? const Color(0xFFF1C40F)
                : Colors.grey.shade700,
          ),
        );
      }),
    );
  }

  Color _getLevelColor(int levelId) {
    final colors = [
      const Color(0xFF2ECC71),
      const Color(0xFF3498DB),
      const Color(0xFFE67E22),
      const Color(0xFF9B59B6),
      const Color(0xFF1ABC9C),
      const Color(0xFFE74C3C),
      const Color(0xFFF1C40F),
      const Color(0xFF16A085),
      const Color(0xFF27AE60),
      const Color(0xFF2980B9),
      const Color(0xFFD35400),
      const Color(0xFF8E44AD),
    ];
    return colors[(levelId - 1) % colors.length];
  }

  IconData _getLevelAnimalIcon(int levelId) {
    final icons = [
      FontAwesomeIcons.dog,
      FontAwesomeIcons.cat,
      FontAwesomeIcons.crow,
      FontAwesomeIcons.fish,
      FontAwesomeIcons.frog,
      FontAwesomeIcons.dragon,
      FontAwesomeIcons.dove,
      FontAwesomeIcons.horse,
      FontAwesomeIcons.hippo,
      FontAwesomeIcons.otter,
      FontAwesomeIcons.spider,
      FontAwesomeIcons.shrimp,
    ];
    return icons[(levelId - 1) % icons.length];
  }
}

class _LevelRecord {
  final int levelId;
  final String levelName;
  final int stars;
  final int bestScore;
  final int bestTime;
  final int totalTime;
  final int pairs;

  _LevelRecord({
    required this.levelId,
    required this.levelName,
    required this.stars,
    required this.bestScore,
    required this.bestTime,
    required this.totalTime,
    required this.pairs,
  });
}
