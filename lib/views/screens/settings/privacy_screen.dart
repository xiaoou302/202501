import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
          'Privacy Policy',
          style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Data Collection',
              'PAIKO does not collect, store, or transmit any personal information. All game data is stored locally on your device.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Game Statistics',
              'Your game statistics, achievements, and progress are saved locally and never shared with external servers.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Third-Party Services',
              'This game does not use any third-party analytics, advertising, or tracking services.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Children\'s Privacy',
              'PAIKO is safe for all ages. We do not knowingly collect information from children or any users.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Changes to Policy',
              'Any updates to this privacy policy will be reflected in future app versions.',
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Last Updated: December 2024',
                style: TextStyle(
                  color: AppColors.ivory.withValues(alpha: 0.5),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sandalwood.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.antiqueGold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.antiqueGold,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: AppColors.ivory.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
