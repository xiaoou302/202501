import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

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
          'User Agreement',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: AppConstants.offwhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.description,
                    color: Color(0xFF2196F3),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Last updated: January 13, 2026',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.metalgray.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using MeeMi, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these terms, please do not use this application.',
            ),
            _buildSection(
              '2. Use License',
              'Permission is granted to temporarily use MeeMi for personal, non-commercial purposes. This license shall automatically terminate if you violate any of these restrictions.',
            ),
            _buildSection(
              '3. User Content',
              'You retain all rights to the artwork and content you create using MeeMi. By sharing content within the app, you grant us a license to display and distribute your content within the platform.',
            ),
            _buildSection(
              '4. Account Responsibilities',
              'You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use.',
            ),
            _buildSection(
              '5. Prohibited Uses',
              'You may not use MeeMi to:\n'
              '• Upload harmful, offensive, or illegal content\n'
              '• Violate intellectual property rights\n'
              '• Harass or harm other users\n'
              '• Attempt to gain unauthorized access to the system',
            ),
            _buildSection(
              '6. AI Services',
              'Our AI mentor feature provides guidance based on general art principles. The advice is for educational purposes and should not be considered professional instruction.',
            ),
            _buildSection(
              '7. Modifications',
              'We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.',
            ),
            _buildSection(
              '8. Termination',
              'We may terminate or suspend your account immediately, without prior notice, for conduct that we believe violates these terms or is harmful to other users.',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.contact_support,
                    color: AppConstants.gold,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Questions about these terms?',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.offwhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Contact us through the Feedback section',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.metalgray.withValues(alpha: 0.8),
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

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.gold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppConstants.offwhite,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
