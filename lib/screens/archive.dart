import 'package:flutter/material.dart';
import '../core/app_fonts.dart';
import '../core/app_theme.dart';

import '../services/achievement_service.dart';
import '../models/achievement_model.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> with SingleTickerProviderStateMixin {
  final AchievementService _achievementService = AchievementService();
  List<AchievementModel> _achievements = [];
  Map<String, int> _stats = {};
  bool _isLoading = true;
  late TabController _tabController;
  String _selectedFilter = 'all';

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
    final achievements = await _achievementService.getPlayerAchievements();
    final stats = await _achievementService.getAchievementStats();
    
    setState(() {
      _achievements = achievements;
      _stats = stats;
      _isLoading = false;
    });
  }

  List<AchievementModel> get _filteredAchievements {
    if (_selectedFilter == 'all') return _achievements;
    if (_selectedFilter == 'unlocked') {
      return _achievements.where((a) => a.isUnlocked).toList();
    }
    return _achievements.where((a) => !a.isUnlocked).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  _buildStatsOverview(),
                  const SizedBox(height: 20),
                  _buildFilterTabs(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildAchievementsList(),
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
            'Loading Achievements...',
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
                'ACHIEVEMENTS',
                style: AppFonts.orbitron(
                  fontSize: 14,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Hall of Glory',
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
                  const Color(0xFFFFD700).withValues(alpha: 0.3),
                  const Color(0xFFFFD700).withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.5)),
            ),
            child: const Icon(Icons.emoji_events, size: 16, color: Color(0xFFFFD700)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFD700).withValues(alpha: 0.15),
              const Color(0xFFFF9800).withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.emoji_events,
                value: '${_stats['unlocked'] ?? 0}/${_stats['total'] ?? 0}',
                label: 'Unlocked',
                color: const Color(0xFFFFD700),
              ),
            ),
            Container(
              width: 1,
              height: 50,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.stars,
                value: '${_stats['points'] ?? 0}',
                label: 'Points',
                color: const Color(0xFFFF9800),
              ),
            ),
            Container(
              width: 1,
              height: 50,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.percent,
                value: '${_stats['percentage'] ?? 0}%',
                label: 'Complete',
                color: const Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppFonts.orbitron(
            fontSize: 18,
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

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildFilterButton('All', 'all'),
          const SizedBox(width: 12),
          _buildFilterButton('Unlocked', 'unlocked'),
          const SizedBox(width: 12),
          _buildFilterButton('Locked', 'locked'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String filter) {
    final isSelected = _selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = filter),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppTheme.deepAccent.withValues(alpha: 0.3),
                      AppTheme.deepAccent.withValues(alpha: 0.1),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.deepAccent.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            label.toUpperCase(),
            style: AppFonts.orbitron(
              fontSize: 10,
              color: isSelected ? AppTheme.deepAccent : Colors.grey,
              letterSpacing: 1,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsList() {
    final filtered = _filteredAchievements;
    
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No achievements found',
              style: AppFonts.inter(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildAchievementCard(filtered[index]);
      },
    );
  }

  Widget _buildAchievementCard(AchievementModel achievement) {
    return GestureDetector(
      onTap: () => _showAchievementDetails(achievement),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: achievement.isUnlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    achievement.color.withValues(alpha: 0.2),
                    achievement.color.withValues(alpha: 0.05),
                  ],
                )
              : null,
          color: achievement.isUnlocked ? null : AppTheme.deepSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: achievement.isUnlocked
                ? achievement.color.withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.2),
            width: achievement.isUnlocked ? 2 : 1,
          ),
          boxShadow: achievement.isUnlocked
              ? [
                  BoxShadow(
                    color: achievement.color.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: achievement.isUnlocked
                    ? RadialGradient(
                        colors: [
                          achievement.color.withValues(alpha: 0.4),
                          achievement.color.withValues(alpha: 0.1),
                        ],
                      )
                    : null,
                color: achievement.isUnlocked ? null : Colors.grey.withValues(alpha: 0.1),
              ),
              child: Icon(
                achievement.isUnlocked ? achievement.icon : Icons.lock,
                size: 28,
                color: achievement.isUnlocked
                    ? achievement.color
                    : Colors.grey.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.name.toUpperCase(),
                          style: AppFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: achievement.isUnlocked ? Colors.white : Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      _buildRarityBadge(achievement.rarity),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: AppFonts.inter(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (!achievement.isUnlocked) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: achievement.progress,
                        minHeight: 4,
                        backgroundColor: Colors.grey.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(achievement.color),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${achievement.currentValue}/${achievement.targetValue}',
                      style: AppFonts.inter(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 12,
                          color: achievement.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'UNLOCKED',
                          style: AppFonts.inter(
                            fontSize: 9,
                            color: achievement.color,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '+${achievement.points} pts',
                          style: AppFonts.orbitron(
                            fontSize: 10,
                            color: const Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRarityBadge(AchievementRarity rarity) {
    Color color;
    String label;
    
    switch (rarity) {
      case AchievementRarity.common:
        color = const Color(0xFF9E9E9E);
        label = 'COMMON';
        break;
      case AchievementRarity.rare:
        color = const Color(0xFF2196F3);
        label = 'RARE';
        break;
      case AchievementRarity.epic:
        color = const Color(0xFF9C27B0);
        label = 'EPIC';
        break;
      case AchievementRarity.legendary:
        color = const Color(0xFFFFD700);
        label = 'LEGENDARY';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: AppFonts.inter(
          fontSize: 7,
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showAchievementDetails(AchievementModel achievement) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.deepSurface,
                Colors.black.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: achievement.isUnlocked
                  ? achievement.color.withValues(alpha: 0.5)
                  : Colors.grey.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: achievement.isUnlocked
                      ? RadialGradient(
                          colors: [
                            achievement.color.withValues(alpha: 0.5),
                            achievement.color.withValues(alpha: 0.1),
                          ],
                        )
                      : null,
                  color: achievement.isUnlocked ? null : Colors.grey.withValues(alpha: 0.2),
                  boxShadow: achievement.isUnlocked
                      ? [
                          BoxShadow(
                            color: achievement.color.withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  achievement.isUnlocked ? achievement.icon : Icons.lock,
                  size: 50,
                  color: achievement.isUnlocked
                      ? achievement.color
                      : Colors.grey.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                achievement.name.toUpperCase(),
                style: AppFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              _buildRarityBadge(achievement.rarity),
              const SizedBox(height: 16),
              Text(
                achievement.description,
                style: AppFonts.inter(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'REQUIREMENT:',
                          style: AppFonts.orbitron(
                            fontSize: 9,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          '+${achievement.points} POINTS',
                          style: AppFonts.orbitron(
                            fontSize: 9,
                            color: const Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      achievement.requirement,
                      style: AppFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (!achievement.isUnlocked) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: achievement.progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(achievement.color),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: AppFonts.inter(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${achievement.currentValue}/${achievement.targetValue}',
                            style: AppFonts.orbitron(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: achievement.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'UNLOCKED',
                            style: AppFonts.orbitron(
                              fontSize: 12,
                              color: achievement.color,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      if (achievement.unlockedAt != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(achievement.unlockedAt!),
                          style: AppFonts.inter(
                            fontSize: 9,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.deepAccent.withValues(alpha: 0.3),
                        AppTheme.deepAccent.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.deepAccent.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    'CLOSE',
                    style: AppFonts.orbitron(
                      fontSize: 11,
                      color: AppTheme.deepAccent,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
