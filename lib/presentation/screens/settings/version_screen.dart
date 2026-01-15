import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.midnight,
      appBar: AppBar(
        backgroundColor: AppConstants.midnight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.offwhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Version Info',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: AppConstants.offwhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF607D8B).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone_android,
                size: 64,
                color: Color(0xFF607D8B),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'MeeMi',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 28,
                color: AppConstants.offwhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppConstants.gold.withValues(alpha: 0.3),
                ),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildInfoCard(
              icon: Icons.calendar_today,
              iconColor: const Color(0xFF4CAF50),
              title: 'Release Date',
              value: 'January 13, 2026',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.build,
              iconColor: const Color(0xFF2196F3),
              title: 'Build Number',
              value: '100',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.phone_iphone,
              iconColor: const Color(0xFF9C27B0),
              title: 'Platform',
              value: 'iOS & Android',
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.new_releases,
                        color: AppConstants.gold,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'What\'s New',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.offwhite,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem('🎨 Gallery: Browse and share artwork'),
                  _buildFeatureItem('✏️ Drawing Board: Create digital art'),
                  _buildFeatureItem('🤖 AI Mentor: Get personalized guidance'),
                  _buildFeatureItem('💬 Chat: Discuss art techniques'),
                  _buildFeatureItem('⚙️ Settings: Manage your preferences'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.update,
                    color: AppConstants.gold,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You\'re up to date!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.offwhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is the latest version of MeeMi',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.metalgray.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '© 2026 MeeMi. All rights reserved.',
              style: TextStyle(
                fontSize: 11,
                color: AppConstants.metalgray.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.metalgray.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.offwhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.substring(0, 2),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.substring(2),
              style: const TextStyle(
                fontSize: 13,
                color: AppConstants.offwhite,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
