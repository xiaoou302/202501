import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Credits screen - Development team information
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.parchmentGradient,
          ),
          image: DecorationImage(
            image: NetworkImage(
              'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAFElEQVQI12P4//8/AwMDAwMDAwMAFwMBAweciQsAAAAASUVORK5CYII=',
            ),
            repeat: ImageRepeat.repeat,
            opacity: 0.03,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildIntro(),
                      const SizedBox(height: 24),
                      _buildTeamSection(),
                      const SizedBox(height: 24),
                      _buildThanksSection(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentDark.withOpacity(0.3),
            AppColors.parchmentMedium.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBrown.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.inkBlack.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              iconSize: 20,
              onPressed: () => Navigator.pop(context),
              color: AppColors.inkBrown,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Credits',
                  style: TextStyle(
                    color: AppColors.inkBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Meet the Team',
                  style: TextStyle(
                    color: AppColors.inkFaded,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.people_rounded, color: AppColors.magicBlue, size: 28),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.magicBlue.withOpacity(0.1),
            AppColors.magicPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.magicBlue.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_stories_rounded,
            color: AppColors.magicGold,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Zenion: The Fading Codex',
            style: TextStyle(
              color: AppColors.inkBlack,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'A journey through fading memories,\nwhere every word matters.',
            style: TextStyle(
              color: AppColors.inkFaded,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentLight,
            AppColors.parchmentMedium.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.groups_rounded, color: AppColors.magicBlue, size: 24),
              const SizedBox(width: 12),
              Text(
                'Development Team',
                style: TextStyle(
                  color: AppColors.inkBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTeamMember(
            role: 'Game Design & Concept',
            name: 'Creative Director',
            icon: Icons.palette_rounded,
            color: AppColors.magicPurple,
          ),
          _buildTeamMember(
            role: 'Development & Engineering',
            name: 'Lead Developer',
            icon: Icons.code_rounded,
            color: AppColors.magicBlue,
          ),
          _buildTeamMember(
            role: 'Story & Narrative',
            name: 'Story Writer',
            icon: Icons.create_rounded,
            color: AppColors.magicGold,
          ),
          _buildTeamMember(
            role: 'UI/UX Design',
            name: 'Design Team',
            icon: Icons.brush_rounded,
            color: AppColors.arcaneGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String role,
    required String name,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: TextStyle(color: AppColors.inkFaded, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.inkBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThanksSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.magicGold.withOpacity(0.1),
            AppColors.glowAmber.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.magicGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.favorite_rounded, color: AppColors.dangerRed, size: 32),
          const SizedBox(height: 16),
          Text(
            'Special Thanks',
            style: TextStyle(
              color: AppColors.inkBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'To all the players who embark on this journey to preserve the fading memories. Your dedication keeps the stories alive.',
            style: TextStyle(
              color: AppColors.inkBrown,
              fontSize: 14,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '© 2025 Zenion Team. All rights reserved.',
            style: TextStyle(
              color: AppColors.inkFaded.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
