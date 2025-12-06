import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
          'Terms of Service',
          style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Acceptance of Terms',
              'By playing PAIKO, you agree to these terms of service. If you do not agree, please discontinue use of the game.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'License',
              'PAIKO grants you a personal, non-transferable license to use this game for entertainment purposes.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'User Conduct',
              'You agree to use PAIKO in accordance with all applicable laws and regulations. Do not attempt to reverse engineer or modify the game.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Disclaimer',
              'PAIKO is provided "as is" without warranties of any kind. We do not guarantee uninterrupted or error-free operation.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Limitation of Liability',
              'The developers of PAIKO shall not be liable for any damages arising from the use or inability to use this game.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Modifications',
              'We reserve the right to modify these terms at any time. Continued use constitutes acceptance of modified terms.',
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
