import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/leaderboard_entry.dart';
import '../services/storage.dart';
import '../utils/constants.dart';
import '../widgets/leaderboard_item.dart';

import '../widgets/tab_bar.dart';

/// 排行榜界面
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 1; // 默认选中排行榜标签
  late TabController _tabController;
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = true;
  String _selectedMode = GameConstants.classicMode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadLeaderboard();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedMode = _tabController.index == 0
            ? GameConstants.classicMode
            : GameConstants.challengeMode;
      });
      _loadLeaderboard();
    }
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
        // 已经在排行榜，不需要导航
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final storageService = StorageService(prefs);
      final leaderboard = await storageService.getLeaderboard();

      // 筛选当前模式的排行榜数据
      final filteredLeaderboard =
          leaderboard.where((entry) => entry.mode == _selectedMode).toList();

      // 按用时排序
      filteredLeaderboard
          .sort((a, b) => a.timeSeconds.compareTo(b.timeSeconds));

      // 重新计算排名
      for (int i = 0; i < filteredLeaderboard.length; i++) {
        filteredLeaderboard[i] = filteredLeaderboard[i].copyWith(rank: i + 1);
      }

      setState(() {
        _leaderboard = filteredLeaderboard;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Delete leaderboard entry
  Future<void> _deleteLeaderboardEntry(int dateTimeMillis) async {
    // Show confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.bgDeepSpaceGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          title: const Text(
            'Delete Record',
            style: TextStyle(
              color: AppColors.textMoonWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this record?',
            style: TextStyle(
              color: AppColors.textMoonWhite,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textMoonWhite,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.2),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final storageService = StorageService(prefs);

        // Delete the entry from leaderboard
        final leaderboard = await storageService.getLeaderboard();
        final updatedLeaderboard = leaderboard
            .where((entry) => entry.dateTimeMillis != dateTimeMillis)
            .toList();

        // Save the updated leaderboard
        await storageService.saveLeaderboard(updatedLeaderboard);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Record deleted successfully'),
                ],
              ),
              backgroundColor: Colors.green.withOpacity(0.8),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 100, left: 40, right: 40),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Reload leaderboard
        _loadLeaderboard();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Text('Error: ${e.toString()}'),
                ],
              ),
              backgroundColor: Colors.red.withOpacity(0.8),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 100, left: 40, right: 40),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
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
                      Icons.emoji_events,
                      color: AppColors.gold.withOpacity(0.8),
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Leaderboard',
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
              // Mode selection tabs
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  padding: const EdgeInsets.all(5),
                  labelPadding: EdgeInsets.zero,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.accentMintGreen,
                        AppColors.accentMintGreen.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentMintGreen.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  tabs: [
                    Tab(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.grid_3x3,
                              size: 16,
                              color: _tabController.index == 0
                                  ? AppColors.bgDeepSpaceGray
                                  : AppColors.textMoonWhite,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '6x6 Classic',
                              style: TextStyle(
                                color: _tabController.index == 0
                                    ? AppColors.bgDeepSpaceGray
                                    : AppColors.textMoonWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.grid_4x4,
                              size: 16,
                              color: _tabController.index == 1
                                  ? AppColors.bgDeepSpaceGray
                                  : AppColors.textMoonWhite,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '8x8 Challenge',
                              style: TextStyle(
                                color: _tabController.index == 1
                                    ? AppColors.bgDeepSpaceGray
                                    : AppColors.textMoonWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
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
                    : _buildLeaderboardList(),
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

  Widget _buildLeaderboardList() {
    if (_leaderboard.isEmpty) {
      return const Center(
        child: Text(
          'No Leaderboard Data',
          style: TextStyle(
            color: AppColors.textMoonWhite,
            fontSize: 16,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: AppColors.accentMintGreen,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Best Times',
                  style: TextStyle(
                    color: AppColors.accentMintGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: _leaderboard.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final entry = _leaderboard[index];
                // This is the current user (in a real app, get this from user data)
                final isCurrentUser = index == 24;

                // If this is the current user and not in top 3, show at the top
                if (isCurrentUser && index > 3) {
                  if (index == 24) {
                    return Column(
                      children: [
                        LeaderboardItem(
                          entry: entry,
                          isCurrentUser: true,
                          onDelete: _deleteLeaderboardEntry,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(
                            color: Colors.white24,
                            thickness: 1,
                          ),
                        ),
                        LeaderboardItem(
                          entry: _leaderboard[0],
                          isCurrentUser: false,
                          onDelete: _deleteLeaderboardEntry,
                        ),
                      ],
                    );
                  }
                  return Container(); // Skip duplicate display
                }

                return LeaderboardItem(
                  entry: entry,
                  isCurrentUser: isCurrentUser,
                  onDelete: _deleteLeaderboardEntry,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
