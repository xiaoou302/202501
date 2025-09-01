import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/neumorphic_card.dart';

/// Game Introduction Screen
class GameIntroductionScreen extends StatelessWidget {
  const GameIntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Game Introduction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sports_esports,
                      color: AppColors.primary,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Hyquinoxa',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A collection of brain training games',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Game Descriptions
            const Text(
              'Our Games',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Memory Match Game
            _buildGameCard(
              title: 'Memory Match',
              description:
                  'Test and improve your memory by matching pairs of cards. '
                  'With increasing difficulty levels and special cards, this game '
                  'challenges your recall abilities in a fun and engaging way.',
              icon: Icons.grid_view_rounded,
              color: Colors.blue,
            ),

            // Flow Rush Game
            _buildGameCard(
              title: 'Flow Rush',
              description:
                  'A rhythm-based game where you tap on the correct tiles '
                  'as they appear. Improve your reflexes and rhythm sense as you '
                  'progress through increasingly challenging levels.',
              icon: Icons.music_note_rounded,
              color: Colors.purple,
            ),

            // Number Memory Game
            _buildGameCard(
              title: 'Number Memory',
              description:
                  'Challenge your short-term memory by remembering sequences '
                  'of numbers and letters. This game helps improve your concentration '
                  'and sequential memory skills.',
              icon: Icons.format_list_numbered_rounded,
              color: Colors.green,
            ),

            const SizedBox(height: 32),

            // Benefits Section
            const Text(
              'Benefits of Brain Training',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBenefitItem(
                      icon: Icons.psychology,
                      title: 'Improved Memory',
                      description:
                          'Regular play can help enhance both short-term and working memory.',
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem(
                      icon: Icons.speed,
                      title: 'Faster Reaction Time',
                      description:
                          'Games like Flow Rush can improve your processing speed and reflexes.',
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem(
                      icon: Icons.lightbulb,
                      title: 'Better Problem-Solving',
                      description:
                          'Brain games can enhance cognitive flexibility and problem-solving skills.',
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem(
                      icon: Icons.timer,
                      title: 'Enhanced Focus',
                      description:
                          'Regular mental exercise can improve concentration and attention span.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // How to Play
            const Text(
              'How to Get Started',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Select a game from the home screen',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '2. Choose your difficulty level',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '3. Complete levels to unlock new challenges',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '4. Track your progress in the Statistics screen',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '5. Earn achievements as you improve',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build a game description card
  Widget _buildGameCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return NeumorphicCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(width: 16),

            // Game description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      height: 1.5,
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

  /// Build a benefit item with icon and description
  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.psychology,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
