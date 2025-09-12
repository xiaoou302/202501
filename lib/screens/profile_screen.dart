import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../services/storage.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/achievement_card.dart';

import '../widgets/tab_bar.dart';

/// 个人档案界面
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentTabIndex = 2; // 默认选中档案标签
  Player? _player;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    // 根据选中的标签切换页面
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.leaderboard);
        break;
      case 2:
        // 已经在档案，不需要导航
        break;
    }
  }

  Future<void> _loadPlayerData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storageService = StorageService(prefs);
      final player = await storageService.getPlayer();

      setState(() {
        _player = player;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgDeepSpaceGray,
              AppColors.bgDeepSpaceGray.withBlue(70),
            ],
            stops: const [0.2, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics_rounded,
                      color: AppColors.accentMintGreen,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Player Stats',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentMintGreen,
                        ),
                      )
                    : _buildProfileContent(),
              ),
              CustomTabBar(
                currentIndex: _currentTabIndex,
                onTap: _onTabTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_player == null) {
      return const Center(
        child: Text(
          'Unable to load player data',
          style: TextStyle(
            color: AppColors.textMoonWhite,
            fontSize: 16,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Player avatar and info
          _buildPlayerInfo(),
          const SizedBox(height: 32),

          // Stats data
          _buildStatsGrid(),

          const SizedBox(height: 32),

          // Achievements
          _buildAchievementsSection(),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accentMintGreen.withOpacity(0.8),
                  AppColors.accentMintGreen.withOpacity(0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentMintGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Player',
                  style: TextStyle(
                    color: AppColors.textMoonWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: AppColors.gold,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_player!.achievements.length} Achievements',
                      style: TextStyle(
                        color: AppColors.textMoonWhite.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color:
                          _player!.gamesWon > 0 ? AppColors.gold : Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Rank: ${_getRankTitle()}',
                      style: TextStyle(
                        color: AppColors.textMoonWhite.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRankTitle() {
    if (_player!.gamesPlayed == 0) return 'Novice';
    if (_player!.gamesWon >= 10) return 'Master';
    if (_player!.gamesWon >= 5) return 'Expert';
    if (_player!.gamesWon >= 1) return 'Beginner';
    return 'Novice';
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Games Played',
          _player!.gamesPlayed.toString(),
          Icons.gamepad_rounded,
        ),
        _buildStatCard(
          'Win Rate',
          calculateWinRate(_player!.gamesWon, _player!.gamesPlayed),
          Icons.percent_rounded,
        ),
        _buildStatCard(
          'Best Time (6x6)',
          _player!.bestTime6x6 != null
              ? formatDuration(Duration(seconds: _player!.bestTime6x6!))
              : 'N/A',
          Icons.timer_outlined,
        ),
        _buildStatCard(
          'Best Time (8x8)',
          _player!.bestTime8x8 != null
              ? formatDuration(Duration(seconds: _player!.bestTime8x8!))
              : 'N/A',
          Icons.timer_outlined,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentMintGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.accentMintGreen,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.accentMintGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMoonWhite.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    // Define achievement list
    final achievements = [
      {
        'id': 'first_win',
        'name': 'First Victory',
        'description': 'Win your first game',
        'icon': Icons.emoji_events_outlined,
        'isUnlocked': _player!.achievements.contains('first_win'),
      },
      {
        'id': 'strategy_master',
        'name': 'Strategy Master',
        'description': 'Win 5 games',
        'icon': Icons.psychology,
        'isUnlocked': _player!.achievements.contains('strategy_master'),
      },
      {
        'id': 'speed_demon',
        'name': 'Speed Demon',
        'description': 'Complete a 6x6 game in under 60 seconds',
        'icon': Icons.speed,
        'isUnlocked': _player!.achievements.contains('speed_demon'),
      },
      {
        'id': 'perfectionist',
        'name': 'Perfectionist',
        'description': 'Maintain 80% win rate after 10+ games',
        'icon': Icons.stars,
        'isUnlocked': _player!.achievements.contains('perfectionist'),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: AppColors.gold,
                size: 24,
              ),
              const SizedBox(width: 10),
              const Text(
                'Achievements',
                style: TextStyle(
                  color: AppColors.textMoonWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return AchievementCard(
                id: achievement['id'] as String,
                name: achievement['name'] as String,
                icon: achievement['icon'] as IconData,
                isUnlocked: achievement['isUnlocked'] as bool,
              );
            },
          ),
        ],
      ),
    );
  }
}
