import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/level_select_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/settings_screen.dart';
import '../utils/constants.dart';

/// 主导航界面，管理三个主要标签页
class MainNavigationScreen extends StatefulWidget {
  /// 初始选中的标签索引
  final int initialTabIndex;

  const MainNavigationScreen({Key? key, this.initialTabIndex = 0})
    : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedTabIndex;
  late PageController _pageController;

  // 保存三个主界面，避免重复创建
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    _pageController = PageController(initialPage: _selectedTabIndex);

    // 初始化三个主界面
    _screens = [
      const LevelSelectScreen(),
      const AchievementsScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 切换到指定标签
  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
      // 使用动画切换页面
      _pageController.animateToPage(
        index,
        duration: AnimationDurations.medium,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 拦截返回按钮，如果不是在第一个标签，则切换到第一个标签
      onWillPop: () async {
        if (_selectedTabIndex != 0) {
          _selectTab(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // 禁用滑动切换
          children: _screens,
          onPageChanged: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.6),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.7),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Levels',
                  isSelected: _selectedTabIndex == 0,
                  onTap: () => _selectTab(0),
                ),
                _buildNavItem(
                  icon: Icons.emoji_events_rounded,
                  label: 'Achievements',
                  isSelected: _selectedTabIndex == 1,
                  onTap: () => _selectTab(1),
                ),
                _buildNavItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: _selectedTabIndex == 2,
                  onTap: () => _selectTab(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AnimationDurations.medium,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentCoral.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentCoral.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? AppColors.accentCoral
                  : AppColors.textGraphite.withOpacity(0.7),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.accentCoral
                    : AppColors.textGraphite.withOpacity(0.7),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
