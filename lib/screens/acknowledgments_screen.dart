import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';

class AcknowledgmentsScreen extends StatelessWidget {
  const AcknowledgmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: 'Special Thanks',
        onHomePressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.xl),
            _buildThanksCard(
              icon: Icons.flutter_dash,
              color: Colors.blue,
              title: 'Flutter Framework',
              description:
                  'Built with Flutter, Google\'s open-source UI toolkit. Thank you to the Flutter team and community for creating such a powerful framework.',
            ),
            _buildThanksCard(
              icon: Icons.code,
              color: Colors.purple,
              title: 'Open Source Community',
              description:
                  'Special thanks to all open-source contributors whose packages and tools made this game possible.',
            ),
            _buildThanksCard(
              icon: Icons.history_edu,
              color: AppColors.alchemicalGold,
              title: 'Historical Alchemists',
              description:
                  'Inspired by the works of Paracelsus, Nicolas Flamel, and countless medieval alchemists who pursued the impossible.',
            ),
            _buildThanksCard(
              icon: Icons.book,
              color: Colors.orange,
              title: 'Literary Influences',
              description:
                  'Drawing inspiration from "The Name of the Rose" by Umberto Eco, "The Alchemist" by Paulo Coelho, and various historical texts on alchemy.',
            ),
            _buildThanksCard(
              icon: Icons.people,
              color: Colors.green,
              title: 'Beta Testers',
              description:
                  'Heartfelt thanks to our dedicated beta testers who spent countless hours solving puzzles and providing invaluable feedback.',
            ),
            _buildThanksCard(
              icon: Icons.favorite,
              color: AppColors.rubedoRed,
              title: 'You, the Player',
              description:
                  'Most importantly, thank you for playing Cognifex. Your willingness to engage with challenging puzzles makes all the effort worthwhile.',
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppColors.alchemicalGold.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        borderRadius: AppRadius.largeRadius,
        border: Border.all(
          color: AppColors.alchemicalGold.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            size: 64,
            color: AppColors.alchemicalGold,
            shadows: [
              Shadow(
                color: AppColors.alchemicalGold.withOpacity(0.6),
                blurRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Gratitude & Recognition',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.alchemicalGold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'No work is created in isolation. We stand on the shoulders of giants.',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.alabasterWhite,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildThanksCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.15),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTextStyles.serifFont,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.alabasterWhite,
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

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.rubedoRed.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: AppColors.rubedoRed.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: const [
          Icon(
            Icons.favorite,
            color: AppColors.rubedoRed,
            size: 32,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '"The Great Work is never the achievement of one, but the culmination of many."',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.alabasterWhite,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '— The Cognifex Team',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.alchemicalGold,
            ),
          ),
        ],
      ),
    );
  }
}

