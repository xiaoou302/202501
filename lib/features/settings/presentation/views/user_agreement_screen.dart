import 'package:flutter/material.dart';
import '../../../../app/theme/color_palette.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Agreement'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF10B981).withValues(alpha: 0.15),
                    const Color(0xFF10B981).withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Color(0xFF10B981),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Agreement',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Last updated: December 2024',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grayDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using Capu, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these terms, please do not use our service.',
            ),
            _buildSection(
              '2. User Account',
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
            ),
            _buildSection(
              '3. User Content',
              'You retain all rights to the content you post on Capu. By posting content, you grant us a worldwide, non-exclusive, royalty-free license to use, display, and distribute your content on our platform.',
            ),
            _buildSection(
              '4. Prohibited Activities',
              'You agree not to:\n• Post inappropriate or offensive content\n• Violate any laws or regulations\n• Infringe on intellectual property rights\n• Harass or harm other users\n• Attempt to hack or disrupt the service',
            ),
            _buildSection(
              '5. Content Moderation',
              'We reserve the right to review, moderate, and remove content that violates our community guidelines. Content may be subject to automatic review before being published.',
            ),
            _buildSection(
              '6. Termination',
              'We may terminate or suspend your account immediately, without prior notice, for conduct that we believe violates this Agreement or is harmful to other users, us, or third parties.',
            ),
            _buildSection(
              '7. Changes to Terms',
              'We reserve the right to modify these terms at any time. We will notify users of any material changes. Your continued use of the service after changes constitutes acceptance of the new terms.',
            ),
            _buildSection(
              '8. Contact',
              'If you have any questions about this Agreement, please contact us at support@zylo.app',
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'By using Capu, you agree to these terms',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
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
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
