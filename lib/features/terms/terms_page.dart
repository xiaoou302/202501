import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_app_bar.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Terms of Service',
                showBackButton: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppStyles.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.description,
                        iconColor: AppColors.accentPurple,
                        title: 'Acceptance of Terms',
                        content:
                            'By accessing or using Ventrixalor, you agree to be bound by these Terms of Service. If you disagree with any part of the terms, you may not access the service.',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.account_circle,
                        iconColor: AppColors.accentBlue,
                        title: 'User Accounts',
                        content:
                            '• You are responsible for maintaining the security of your account\n'
                            '• You must not share your account credentials\n'
                            '• You must be at least 13 years old to use this service\n'
                            '• You are responsible for all activities under your account',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.brush,
                        iconColor: AppColors.accentGreen,
                        title: 'Content Rights',
                        content: '• You retain all rights to your content\n'
                            '• You grant us a license to use your content for service operation\n'
                            '• You must not violate others\' intellectual property rights\n'
                            '• AI-generated content is subject to our fair use policy',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.security,
                        iconColor: AppColors.warning,
                        title: 'Prohibited Activities',
                        content: 'You must not:\n'
                            '• Upload malicious content or code\n'
                            '• Attempt to breach system security\n'
                            '• Use the service for illegal activities\n'
                            '• Harass or harm other users',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.cloud_done,
                        iconColor: AppColors.info,
                        title: 'Service Availability',
                        content:
                            '• We strive for 99.9% uptime but don\'t guarantee it\n'
                            '• We may modify or discontinue features\n'
                            '• We will notify you of significant changes\n'
                            '• Service may be interrupted for maintenance',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.gavel,
                        iconColor: AppColors.error,
                        title: 'Termination',
                        content:
                            'We may terminate or suspend your account if you violate these terms. Upon termination:\n'
                            '• Your access will be revoked\n'
                            '• You can export your data within 30 days\n'
                            '• Some terms survive termination',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.update,
                        iconColor: AppColors.accentPurple,
                        title: 'Changes to Terms',
                        content: '• We may update these terms at any time\n'
                            '• We will notify you of material changes\n'
                            '• Continued use means acceptance of new terms\n'
                            '• You should review terms periodically',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildContactSection(),
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

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.gavel,
                  color: AppColors.accentPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppStyles.paddingMedium),
              const Expanded(
                child: Text(
                  'Terms of Service',
                  style: AppStyles.heading3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'Please read these terms carefully before using Ventrixalor.',
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'Last updated: March 2024',
            style: AppStyles.caption.copyWith(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppStyles.paddingMedium),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.heading3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            content,
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Questions?',
            style: AppStyles.heading3,
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'If you have any questions about these terms, please contact us:',
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          _buildContactItem(
            icon: Icons.email,
            text: 'legal@ventrixalor.com',
            color: AppColors.accentPurple,
          ),
          const SizedBox(height: AppStyles.paddingSmall),
          _buildContactItem(
            icon: Icons.support,
            text: 'Support Center',
            color: AppColors.accentBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: AppStyles.paddingMedium),
        Text(
          text,
          style: AppStyles.bodyText.copyWith(
            color: color,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
