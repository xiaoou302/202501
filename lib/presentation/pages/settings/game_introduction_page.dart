import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Game introduction page
class GameIntroductionPage extends StatelessWidget {
  /// Constructor
  const GameIntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Game Introduction',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/5.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Use constraints to adapt to different screen sizes
              final double contentWidth = constraints.maxWidth > 700
                  ? 700
                  : constraints.maxWidth;
              final double horizontalPadding =
                  (constraints.maxWidth - contentWidth) / 2;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding > 0 ? horizontalPadding : 16.0,
                  vertical: 16.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        title: 'About ${AppConstants.appName}',
                        content:
                            '${AppConstants.appName} is a strategic puzzle game inspired by the traditional tile-matching mechanics of Mahjong Solitaire. The game combines beautiful aesthetics with engaging gameplay to create a relaxing yet challenging experience.',
                        icon: Icons.spa,
                        iconColor: AppColors.carvedJadeGreen,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Important Notice',
                        content:
                            '${AppConstants.appName} is purely a puzzle game that uses Mahjong tile elements for its visual theme and mechanics. This game is NOT related to gambling in any way. It is designed as an entertainment puzzle experience focusing on strategy and pattern recognition.',
                        icon: Icons.warning_amber,
                        iconColor: AppColors.beeswaxAmber,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'How to Play',
                        content:
                            'Select unblocked tiles to add them to your hand. When you collect three identical tiles, they will automatically be removed. Clear all tiles from the board to win the level. Be careful - if your hand becomes full with no possible matches, the game ends!',
                        icon: Icons.help,
                        iconColor: AppColors.mahjongBlue,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Game Features',
                        content:
                            '• 12 challenging levels across 3 chapters\n• Strategic gameplay requiring planning and foresight\n• Beautiful zen-inspired visuals and animations\n• Power-ups to help you in difficult situations\n• Achievement system to track your progress',
                        icon: Icons.stars,
                        iconColor: AppColors.mahjongRed,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
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
}
