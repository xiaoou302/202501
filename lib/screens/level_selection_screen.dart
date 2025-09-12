import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/level.dart';
import '../services/storage.dart';
import '../utils/constants.dart';

import '../widgets/tab_bar.dart';

/// 关卡选择界面
class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  late TabController _tabController;
  List<Level> _levels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadLevels();
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
        // 更新UI
      });
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
        Navigator.pushReplacementNamed(context, AppRoutes.leaderboard);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }

  Future<void> _loadLevels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storageService = StorageService(prefs);
      final levels = await storageService.getLevels();

      setState(() {
        _levels = levels;
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
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部标题栏
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppColors.textMoonWhite,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Text(
                      'Select Level',
                      style: TextStyle(
                        color: AppColors.textMoonWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    // 平衡布局的占位
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // 模式选择标签
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: _tabController.index == 0
                              ? LinearGradient(
                                  colors: [
                                    AppColors.accentMintGreen,
                                    AppColors.accentMintGreen.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: _tabController.index == 0
                              ? null
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: _tabController.index == 0
                              ? [
                                  BoxShadow(
                                    color: AppColors.accentMintGreen
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          '6x6 Classic',
                          style: TextStyle(
                            color: _tabController.index == 0
                                ? AppColors.bgDeepSpaceGray
                                : AppColors.textMoonWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: _tabController.index == 1
                              ? LinearGradient(
                                  colors: [
                                    AppColors.accentMintGreen,
                                    AppColors.accentMintGreen.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: _tabController.index == 1
                              ? null
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: _tabController.index == 1
                              ? [
                                  BoxShadow(
                                    color: AppColors.accentMintGreen
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          '8x8 Challenge',
                          style: TextStyle(
                            color: _tabController.index == 1
                                ? AppColors.bgDeepSpaceGray
                                : AppColors.textMoonWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentMintGreen,
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          // 6x6 经典模式关卡
                          _buildLevelGrid(GameConstants.classicMode),
                          // 8x8 挑战模式关卡
                          _buildLevelGrid(GameConstants.challengeMode),
                        ],
                      ),
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

  Widget _buildLevelGrid(String mode) {
    final modeLevels = _levels.where((level) => level.mode == mode).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 20,
          mainAxisSpacing: 24,
        ),
        itemCount: modeLevels.length,
        itemBuilder: (context, index) {
          final level = modeLevels[index];
          return _buildLevelCard(level);
        },
      ),
    );
  }

  Widget _buildLevelCard(Level level) {
    if (level.isUnlocked) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.game,
            arguments: level,
          );
        },
        child: Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentMintGreen.withOpacity(0.7),
                      AppColors.accentMintGreen.withOpacity(0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentMintGreen.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    level.name.split(' ').last,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildStars(level.stars),
              const SizedBox(height: 8),
              if (level.bestTimeSeconds != null)
                Text(
                  'Best: ${_formatTime(level.bestTimeSeconds!)}',
                  style: const TextStyle(
                    color: AppColors.textMoonWhite,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: Colors.white30,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Locked',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildStars(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(GameConstants.maxStars, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Icon(
            index < stars ? Icons.star_rounded : Icons.star_border_rounded,
            color:
                index < stars ? AppColors.gold : Colors.white.withOpacity(0.3),
            size: 18,
            shadows: index < stars
                ? [
                    Shadow(
                      color: AppColors.gold.withOpacity(0.6),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
