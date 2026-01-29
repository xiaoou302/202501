import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oravie/core/constants/app_colors.dart';
import 'package:oravie/presentation/screens/ai_discourse_screen.dart';
import 'package:oravie/presentation/screens/ai_visualization_screen.dart';
import 'package:oravie/presentation/screens/inspiration_gallery_screen.dart';
import 'package:oravie/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    InspirationGalleryScreen(),
    AIDiscourseScreen(),
    AIVisualizationScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent bottom bar from moving up when keyboard opens
      extendBody: true, // Allow body to extend behind bottom bar
      body: Stack(
        children: [
          // Main Content
          IndexedStack(index: _currentIndex, children: _screens),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 24,
            right: 24,
            bottom: 34,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(
                          0,
                          FontAwesomeIcons.layerGroup,
                          'Inspiration',
                        ),
                        _buildNavItem(
                          1,
                          FontAwesomeIcons.comments,
                          'Discourse',
                        ),
                        _buildNavItem(
                          2,
                          FontAwesomeIcons.wandMagicSparkles,
                          'Visualize',
                        ),
                        _buildNavItem(3, FontAwesomeIcons.user, 'Profile'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.slateGreen.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.slateGreen : AppColors.coolGray,
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.slateGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
