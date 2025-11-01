import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';

class GameSecurityScreen extends StatelessWidget {
  const GameSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: 'Game Security',
        onHomePressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.xl),
            _buildSecurityCard(
              icon: Icons.lock,
              color: Colors.green,
              title: 'Data Privacy',
              description:
                  'All game progress is stored locally on your device. We do not collect, transmit, or store any personal information on external servers.',
            ),
            _buildSecurityCard(
              icon: Icons.cloud_off,
              color: Colors.blue,
              title: 'Offline First',
              description:
                  'Cognifex is designed to work completely offline. No internet connection is required to play, and your data never leaves your device.',
            ),
            _buildSecurityCard(
              icon: Icons.verified_user,
              color: Colors.purple,
              title: 'No Tracking',
              description:
                  'We do not use analytics, tracking pixels, or any form of user monitoring. Your gameplay is entirely private.',
            ),
            _buildSecurityCard(
              icon: Icons.save,
              color: Colors.orange,
              title: 'Local Storage',
              description:
                  'Game saves are stored using secure local storage mechanisms provided by your device\'s operating system.',
            ),
            _buildSecurityCard(
              icon: Icons.delete_forever,
              color: AppColors.rubedoRed,
              title: 'Data Deletion',
              description:
                  'You have full control over your data. Use the "Reset Progress" button in Settings to permanently delete all game data.',
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
            Colors.green.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        borderRadius: AppRadius.largeRadius,
        border: Border.all(
          color: Colors.green.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.security,
            size: 64,
            color: Colors.green,
            shadows: [
              Shadow(
                color: Colors.green.withOpacity(0.6),
                blurRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Your Privacy Matters',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'We believe in respecting player privacy and maintaining complete transparency about data handling.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.alabasterWhite,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard({
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: AppColors.neutralSteel.withOpacity(0.3),
        ),
      ),
      child: const Text(
        'If you have any security concerns or questions, please contact us through the Bug Report feature.',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.alabasterWhite,
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

