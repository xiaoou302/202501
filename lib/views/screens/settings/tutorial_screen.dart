import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inkGreen,
      appBar: AppBar(
        backgroundColor: AppColors.sandalwood,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.antiqueGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'How to Play',
          style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepCard(
              step: '1',
              icon: Icons.visibility,
              iconColor: AppColors.jadeBlue,
              title: 'Memorize Phase',
              description: 'At the start, all tiles are revealed. Study their positions and numbers carefully. You have limited time based on the difficulty level.',
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              step: '2',
              icon: Icons.touch_app,
              iconColor: AppColors.jadeGreen,
              title: 'Match Tiles',
              description: 'After memorization, tiles flip face-down. Tap tiles to reveal them and match with your hand tile. Numbers must match exactly!',
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              step: '3',
              icon: Icons.auto_awesome,
              iconColor: AppColors.antiqueGold,
              title: 'Build Streaks',
              description: 'Match tiles of the same suit consecutively to build streaks. Higher streaks earn bonus points!',
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              step: '4',
              icon: Icons.timer,
              iconColor: AppColors.vermillion,
              title: 'Beat the Clock',
              description: 'Complete the board before time runs out. Use power-ups wisely: shuffle the grid or swap your hand tile.',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.antiqueGold.withValues(alpha: 0.2),
                    AppColors.jadeGreen.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.antiqueGold.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lightbulb,
                    color: AppColors.antiqueGold,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'PRO TIPS',
                    style: TextStyle(
                      color: AppColors.antiqueGold,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTip('Focus on tile positions during memorization'),
                  _buildTip('Group tiles by suit for easier recall'),
                  _buildTip('Use the idle hint system when stuck'),
                  _buildTip('Save power-ups for difficult situations'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String step,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sandalwood.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.antiqueGold.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        step,
                        style: const TextStyle(
                          color: AppColors.inkGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.antiqueGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.ivory.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: AppColors.antiqueGold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: AppColors.ivory.withValues(alpha: 0.9),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
