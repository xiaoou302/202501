import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../pages/level_selection_page.dart';
import 'tips_page.dart';
import 'achievements_page.dart';
import 'settings_page.dart';

/// Main menu screen of the app
class MainMenuPage extends StatelessWidget {
  /// Constructor
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/1.jpg',
            ), // Ensure this asset is in your pubspec.yaml
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 3), // Provides flexible top spacing
                _buildTitleSection(),
                const Spacer(
                  flex: 2,
                ), // Provides space between title and content

                const SizedBox(
                  height: 200,
                ), // A fixed space for clear separation
                _buildMenuOptions(context),
                const Spacer(flex: 3), // Pushes content towards the center
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建标题部分
  Widget _buildTitleSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0), width: 1.5),
          ),
          child: Column(
            children: [
              // Logo Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.carvedJadeGreen.withOpacity(0.7),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.spa, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 5.0,
                      color: Color.fromARGB(180, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                AppConstants.appSubtitle,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.2,
                  shadows: const [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建游戏描述部分

  // 构建功能特点项
  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.beeswaxAmber, size: 16),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 构建菜单选项
  Widget _buildMenuOptions(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0), width: 1.5),
          ),
          child: Column(
            children: [
              // Start Game Button
              _buildMenuButton(
                context,
                icon: Icons.play_arrow,
                label: "START GAME",
                color: AppColors.carvedJadeGreen,
                onTap: () => _navigateToLevelSelection(context),
              ),
              const SizedBox(height: 15),

              // Achievements Button
              _buildMenuButton(
                context,
                icon: Icons.emoji_events,
                label: "ACHIEVEMENTS",
                color: AppColors.beeswaxAmber,
                onTap: () => _navigateToAchievements(context),
              ),
              const SizedBox(height: 15),

              // Tips Button
              _buildMenuButton(
                context,
                icon: Icons.lightbulb,
                label: "TIPS & HELP",
                color: Colors.purple.shade300,
                onTap: () => _navigateToTips(context),
              ),
              const SizedBox(height: 15),
              _buildMenuButton(
                context,
                icon: Icons.settings,
                label: "SETTINGS",
                color: Colors.blueGrey.shade400,
                onTap: () => _navigateToSettings(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建菜单按钮
  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Row(
          // CHANGE: Changed alignment from center to start.
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // CHANGE: Added a fixed-width SizedBox to act as padding,
            // ensuring the icon's position is consistent across all buttons.
            const SizedBox(width: 50),
            Icon(icon, size: 24),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLevelSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LevelSelectionPage()),
    );
  }

  void _navigateToTips(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TipsPage()),
    );
  }

  void _navigateToAchievements(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AchievementsPage()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }
}
