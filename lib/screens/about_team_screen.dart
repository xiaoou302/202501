import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';

class AboutTeamScreen extends StatelessWidget {
  const AboutTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: 'Development Team',
        onHomePressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.xl),
            _buildTeamMember(
              name: 'Lead Developer',
              role: 'Game Design & Programming',
              icon: Icons.code,
              color: AppColors.alchemicalGold,
              description:
                  'Responsible for core game mechanics, puzzle design, and overall architecture.',
            ),
            _buildTeamMember(
              name: 'UI/UX Designer',
              role: 'Interface & Experience',
              icon: Icons.palette,
              color: Colors.purple,
              description:
                  'Crafted the alchemical aesthetic and ensured intuitive gameplay flow.',
            ),
            _buildTeamMember(
              name: 'Narrative Designer',
              role: 'Story & Lore',
              icon: Icons.auto_stories,
              color: Colors.blue,
              description:
                  'Wrote the compelling backstory and encrypted journal clues.',
            ),
            _buildTeamMember(
              name: 'Sound Designer',
              role: 'Audio & Atmosphere',
              icon: Icons.music_note,
              color: Colors.orange,
              description:
                  'Created the immersive soundscape and atmospheric music.',
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
          color: AppColors.alchemicalGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.groups,
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
            'The Alchemists Behind the Work',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.alchemicalGold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'A small team dedicated to crafting meaningful puzzle experiences',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.alabasterWhite,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), Colors.black.withOpacity(0.3)],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: color.withOpacity(0.4), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: AppTextStyles.serifFont,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.alabasterWhite,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.neutralSteel.withOpacity(0.3)),
      ),
      child: const Text(
        'Thank you for playing Cognifex. We hope you enjoy unraveling the mysteries of the Great Work.',
        style: TextStyle(
          fontFamily: AppTextStyles.serifFont,
          fontSize: 14,
          color: AppColors.alabasterWhite,
          fontStyle: FontStyle.italic,
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
