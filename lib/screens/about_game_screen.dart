import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';

class AboutGameScreen extends StatelessWidget {
  const AboutGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: 'About the Game',
        onHomePressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.xl),
            _buildInfoSection(
              icon: Icons.psychology,
              color: AppColors.alchemicalGold,
              title: 'Game Concept',
              content:
                  'Cognifex is a logic puzzle game that challenges players to decipher an encrypted alchemical recipe. Through careful observation, deductive reasoning, and pattern recognition, you must uncover the correct sequence of 12 steps to create the legendary Philosopher\'s Stone.',
            ),
            _buildInfoSection(
              icon: Icons.auto_stories,
              color: Colors.purple,
              title: 'Narrative Design',
              content:
                  'Set in 18th century Prague, you inherit your mentor\'s life work—a cryptic journal containing the secrets of the Great Work. The story explores themes of obsession, legacy, and the price of knowledge.',
            ),
            _buildInfoSection(
              icon: Icons.extension,
              color: Colors.blue,
              title: 'Puzzle Mechanics',
              content:
                  'The game features three unique recipe variants, each with its own encrypted clues. Players must combine four alchemical actions with seven sacred materials in the correct sequence. With billions of possible combinations, only careful analysis will reveal the truth.',
            ),
            _buildInfoSection(
              icon: Icons.school,
              color: Colors.orange,
              title: 'Educational Value',
              content:
                  'While fictional, Cognifex draws inspiration from real alchemical symbolism and historical practices. The game encourages critical thinking, pattern recognition, and systematic problem-solving.',
            ),
            _buildInfoSection(
              icon: Icons.palette,
              color: AppColors.rubedoRed,
              title: 'Art Direction',
              content:
                  'The visual design is inspired by the four stages of alchemy: Nigredo (blackening), Albedo (whitening), Citrinitas (yellowing), and Rubedo (reddening). Every color choice reinforces the alchemical theme.',
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
            AppColors.rubedoRed.withOpacity(0.1),
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
            Icons.diamond,
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
            'The Alchemist\'s Paradox',
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
            'A puzzle game about deduction, patience, and the pursuit of impossible knowledge.',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.alabasterWhite,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTextStyles.serifFont,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: const TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 15,
              color: AppColors.alabasterWhite,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: AppColors.neutralSteel.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: const [
          Text(
            'Development Philosophy',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.alchemicalGold,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'We believe in creating games that respect player intelligence. Cognifex offers no hand-holding, no pay-to-win mechanics, and no artificial difficulty. Just pure, challenging puzzle design.',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 14,
              color: AppColors.alabasterWhite,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

