import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Privacy Policy screen
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.parchmentLight,
                          AppColors.parchmentMedium.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.borderMedium,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIntro(),
                        const SizedBox(height: 24),
                        _buildSection(
                          'Information We Collect',
                          'We collect minimal information necessary to provide the Game experience:\n\n• Game progress and statistics (stored locally)\n• Device information for compatibility\n• Crash reports to improve stability',
                        ),
                        _buildSection(
                          'How We Use Your Information',
                          'Your information is used solely to:\n\n• Save your game progress\n• Improve game performance\n• Fix bugs and enhance user experience',
                        ),
                        _buildSection(
                          'Data Storage',
                          'All game data is stored locally on your device. We do not transmit your personal information or game data to external servers.',
                        ),
                        _buildSection(
                          'Third-Party Services',
                          'This game does not use third-party analytics, advertising, or tracking services.',
                        ),
                        _buildSection(
                          'Children\'s Privacy',
                          'The Game is suitable for all ages. We do not knowingly collect personal information from children.',
                        ),
                        _buildSection(
                          'Your Rights',
                          'You have the right to:\n\n• Access your data (via game settings)\n• Delete your data (Reset Progress)\n• Stop using the Game at any time',
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Last Updated: January 2025',
                          style: TextStyle(
                            color: AppColors.inkFaded,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
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
                  'Privacy Policy',
                  style: TextStyle(
                    color: AppColors.inkBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Data Protection',
                  style: TextStyle(
                    color: AppColors.inkFaded,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.shield_rounded, color: AppColors.arcaneGreen, size: 28),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.arcaneGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.arcaneGreen.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.security_rounded, color: AppColors.arcaneGreen, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Your privacy is important to us. This policy explains how we handle your data.',
              style: TextStyle(
                color: AppColors.inkBrown,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.arcaneGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: AppColors.inkBrown,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
