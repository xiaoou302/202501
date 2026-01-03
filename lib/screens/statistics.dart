import 'package:flutter/material.dart';
import '../core/app_fonts.dart';
import '../core/app_theme.dart';

import '../services/player_data_service.dart';
import '../models/player_stats.dart';
import '../models/level_config.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  final PlayerDataService _dataService = PlayerDataService();
  PlayerStats? _stats;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final stats = await _dataService.getPlayerStats();
    
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.5,
              colors: [Color(0xFF2D3748), AppTheme.deepBg, Colors.black],
              stops: [0.0, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                //const SizedBox(height: 48),
                _buildHeader(context),
                const SizedBox(height: 24),
                if (_isLoading)
                  Expanded(child: _buildLoadingState())
                else ...[
                  _buildOverallStats(),
                  const SizedBox(height: 20),
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPerformanceTab(),
                        _buildLevelsTab(),
                        _buildRecordsTab(),
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.deepAccent),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Statistics...',
            style: AppFonts.inter(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.01),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Icon(Icons.chevron_left, size: 14, color: Colors.white),
            ),
          ),
          Column(
            children: [
              Text(
                'STATISTICS',
                style: AppFonts.orbitron(
                  fontSize: 14,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Your Performance',
                style: AppFonts.inter(
                  fontSize: 9,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4CAF50).withValues(alpha: 0.3),
                  const Color(0xFF4CAF50).withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.5)),
            ),
            child: const Icon(Icons.bar_chart, size: 16, color: Color(0xFF4CAF50)),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStats() {
    if (_stats == null) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4CAF50).withValues(alpha: 0.2),
              const Color(0xFF2196F3).withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildQuickStat(
                    icon: Icons.emoji_events,
                    value: '${_stats!.totalWins}',
                    label: 'Total Wins',
                    color: const Color(0xFFFFD700),
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                Expanded(
                  child: _buildQuickStat(
                    icon: Icons.local_fire_department,
                    value: '${_stats!.currentStreak}',
                    label: 'Streak',
                    color: const Color(0xFFFF6B6B),
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                Expanded(
                  child: _buildQuickStat(
                    icon: Icons.star,
                    value: '${_getTotalStars()}',
                    label: 'Stars',
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completion Rate',
                    style: AppFonts.inter(
                      fontSize: 11,
                      color: Colors.grey[300],
                    ),
                  ),
                  Text(
                    '${_stats!.completionPercentage.toStringAsFixed(1)}%',
                    style: AppFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4CAF50),
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

  Widget _buildQuickStat({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: AppFonts.inter(
            fontSize: 8,
            color: Colors.grey,
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  int _getTotalStars() {
    int total = 0;
    _stats?.levelProgress.forEach((key, progress) {
      total += progress.stars;
    });
    return total;
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.deepAccent.withValues(alpha: 0.3),
              AppTheme.deepAccent.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.deepAccent.withValues(alpha: 0.5)),
        ),
        labelColor: AppTheme.deepAccent,
        unselectedLabelColor: Colors.grey,
        labelStyle: AppFonts.orbitron(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        unselectedLabelStyle: AppFonts.orbitron(
          fontSize: 10,
          letterSpacing: 1,
        ),
        tabs: const [
          Tab(text: 'PERFORMANCE'),
          Tab(text: 'LEVELS'),
          Tab(text: 'RECORDS'),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    if (_stats == null) return const SizedBox();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard(
            title: 'Win Statistics',
            icon: Icons.emoji_events,
            color: const Color(0xFFFFD700),
            children: [
              _buildStatRow('Total Wins', '${_stats!.totalWins}'),
              _buildStatRow('Current Streak', '${_stats!.currentStreak}'),
              _buildStatRow('Longest Streak', '${_stats!.longestStreak}'),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: 'Time Statistics',
            icon: Icons.access_time,
            color: const Color(0xFF2196F3),
            children: [
              _buildStatRow('Total Play Time', _formatTotalTime(_stats!.totalPlayTime)),
              _buildStatRow('Average Time', _formatDuration(_stats!.averageTimePerLevel)),
              _buildStatRow('Fastest Win', _getFastestTime()),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: 'Progress',
            icon: Icons.trending_up,
            color: const Color(0xFF4CAF50),
            children: [
              _buildStatRow('Completion', '${_stats!.completionPercentage.toStringAsFixed(1)}%'),
              _buildStatRow('Total Stars', '${_getTotalStars()}/18'),
              _buildStatRow('Levels Completed', '${_getCompletedLevels()}/${LevelData.levels.length}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelsTab() {
    if (_stats == null) return const SizedBox();
    
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: LevelData.levels.length,
      itemBuilder: (context, index) {
        final level = LevelData.levels[index];
        final progress = _stats!.levelProgress[level.id];
        
        return _buildLevelCard(level, progress);
      },
    );
  }

  Widget _buildRecordsTab() {
    if (_stats == null) return const SizedBox();
    
    final bestLevels = _getBestLevels();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecordCard(
            title: 'Personal Bests',
            icon: Icons.military_tech,
            color: const Color(0xFFFFD700),
            child: Column(
              children: [
                _buildRecordItem(
                  'Fastest Level',
                  bestLevels['fastest']?['name'] ?? 'N/A',
                  bestLevels['fastest']?['time'] ?? 'N/A',
                  Icons.flash_on,
                  const Color(0xFFFF9800),
                ),
                const SizedBox(height: 12),
                _buildRecordItem(
                  'Most Attempts',
                  bestLevels['mostAttempts']?['name'] ?? 'N/A',
                  '${bestLevels['mostAttempts']?['attempts'] ?? 0} tries',
                  Icons.replay,
                  const Color(0xFF2196F3),
                ),
                const SizedBox(height: 12),
                _buildRecordItem(
                  'Perfect Score',
                  '${_getPerfectScoreLevels()} levels',
                  '3 stars each',
                  Icons.star,
                  const Color(0xFF4CAF50),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildRecordCard(
            title: 'Milestones',
            icon: Icons.flag,
            color: const Color(0xFF9C27B0),
            child: Column(
              children: _buildMilestones(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title.toUpperCase(),
                style: AppFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFonts.inter(
              fontSize: 12,
              color: Colors.grey[300],
            ),
          ),
          Text(
            value,
            style: AppFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(dynamic level, LevelProgress? progress) {
    final isCompleted = progress?.completed ?? false;
    final stars = progress?.stars ?? 0;
    final attempts = progress?.attempts ?? 0;
    final bestTime = progress?.bestTime;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isCompleted
                ? const Color(0xFF4CAF50).withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.name.toUpperCase(),
                      style: AppFonts.orbitron(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.sector,
                      style: AppFonts.inter(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Row(
                  children: List.generate(3, (index) {
                    return Icon(
                      index < stars ? Icons.star : Icons.star_border,
                      size: 16,
                      color: index < stars
                          ? const Color(0xFFFFD700)
                          : Colors.grey.withValues(alpha: 0.3),
                    );
                  }),
                ),
            ],
          ),
          if (isCompleted) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildLevelStat(
                    Icons.timer,
                    'Best Time',
                    bestTime != null ? _formatDuration(bestTime) : 'N/A',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLevelStat(
                    Icons.replay,
                    'Attempts',
                    '$attempts',
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 12, color: Colors.grey.withValues(alpha: 0.6)),
                  const SizedBox(width: 6),
                  Text(
                    'Not Completed',
                    style: AppFonts.inter(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLevelStat(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.deepBlue),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppFonts.inter(
                fontSize: 9,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: AppFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecordCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title.toUpperCase(),
                style: AppFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildRecordItem(
    String title,
    String subtitle,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.inter(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppFonts.orbitron(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMilestones() {
    final milestones = <Widget>[];
    
    if (_stats!.totalWins >= 1) {
      milestones.add(_buildMilestoneItem('First Victory', 'Complete your first level', true));
    }
    if (_stats!.totalWins >= 5) {
      milestones.add(_buildMilestoneItem('5 Wins', 'Win 5 levels', true));
    }
    if (_stats!.currentStreak >= 3) {
      milestones.add(_buildMilestoneItem('3 Win Streak', 'Win 3 levels in a row', true));
    }
    if (_getTotalStars() >= 10) {
      milestones.add(_buildMilestoneItem('10 Stars', 'Collect 10 stars', true));
    }
    if (_stats!.completionPercentage >= 50) {
      milestones.add(_buildMilestoneItem('Half Way', 'Complete 50% of levels', true));
    }
    if (_stats!.completionPercentage >= 100) {
      milestones.add(_buildMilestoneItem('Completionist', 'Complete all levels', true));
    }
    
    if (milestones.isEmpty) {
      milestones.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Complete levels to unlock milestones!',
              style: AppFonts.inter(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    
    return milestones;
  }

  Widget _buildMilestoneItem(String title, String description, bool achieved) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achieved
            ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achieved
              ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            achieved ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: achieved ? const Color(0xFF4CAF50) : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: achieved ? Colors.white : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppFonts.inter(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatDuration(Duration duration) {
    if (duration.inMinutes == 0) return '${duration.inSeconds}s';
    return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
  }

  String _formatTotalTime(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    return '${duration.inMinutes}m';
  }

  String _getFastestTime() {
    Duration? fastest;
    _stats?.levelProgress.forEach((key, progress) {
      if (progress.bestTime != null) {
        if (fastest == null || progress.bestTime!.inSeconds < fastest!.inSeconds) {
          fastest = progress.bestTime;
        }
      }
    });
    return fastest != null ? _formatDuration(fastest!) : 'N/A';
  }

  int _getCompletedLevels() {
    int count = 0;
    _stats?.levelProgress.forEach((key, progress) {
      if (progress.completed) count++;
    });
    return count;
  }

  int _getPerfectScoreLevels() {
    int count = 0;
    _stats?.levelProgress.forEach((key, progress) {
      if (progress.stars == 3) count++;
    });
    return count;
  }

  Map<String, Map<String, dynamic>> _getBestLevels() {
    Duration? fastestTime;
    String? fastestLevel;
    int mostAttempts = 0;
    String? mostAttemptsLevel;
    
    _stats?.levelProgress.forEach((levelId, progress) {
      final level = LevelData.levels.firstWhere((l) => l.id == levelId);
      
      if (progress.bestTime != null) {
        if (fastestTime == null || progress.bestTime!.inSeconds < fastestTime!.inSeconds) {
          fastestTime = progress.bestTime;
          fastestLevel = level.name;
        }
      }
      
      if (progress.attempts > mostAttempts) {
        mostAttempts = progress.attempts;
        mostAttemptsLevel = level.name;
      }
    });
    
    return {
      'fastest': {
        'name': fastestLevel ?? 'N/A',
        'time': fastestTime != null ? _formatDuration(fastestTime!) : 'N/A',
      },
      'mostAttempts': {
        'name': mostAttemptsLevel ?? 'N/A',
        'attempts': mostAttempts,
      },
    };
  }
}
