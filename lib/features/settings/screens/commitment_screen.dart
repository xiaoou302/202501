import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class CommitmentScreen extends StatelessWidget {
  const CommitmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppConstants.deepPlum : AppConstants.shellWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Commitment & Terms'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppConstants.darkGray
                      : AppConstants.panelWhite,
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.verified_user,
                      size: 64,
                      color: const Color(0xFF9C27B0),
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      'Our Promise to You',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'We are committed to providing a safe, reliable, and transparent service.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingL),

              Text('Our Commitments', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppConstants.spacingM),

              _buildCommitmentCard(
                context: context,
                isDark: isDark,
                icon: Icons.shield,
                iconColor: const Color(0xFF4CAF50),
                title: 'Privacy Protection',
                description:
                    'We will never sell your personal data to third parties. Your information is stored securely and used only to improve your experience.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildCommitmentCard(
                context: context,
                isDark: isDark,
                icon: Icons.update,
                iconColor: const Color(0xFF2196F3),
                title: 'Continuous Improvement',
                description:
                    'We commit to regularly updating the app with new features, bug fixes, and performance improvements based on user feedback.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildCommitmentCard(
                context: context,
                isDark: isDark,
                icon: Icons.support_agent,
                iconColor: const Color(0xFFFF9800),
                title: 'User Support',
                description:
                    'We are here to help. Our support team is committed to responding to your questions and concerns promptly.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildCommitmentCard(
                context: context,
                isDark: isDark,
                icon: Icons.visibility,
                iconColor: const Color(0xFF9C27B0),
                title: 'Transparency',
                description:
                    'We believe in open communication. Any changes to our terms or privacy policy will be clearly communicated to you.',
              ),
              const SizedBox(height: AppConstants.spacingL),

              Text('Terms of Service', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppConstants.spacingM),

              _buildTermSection(
                context: context,
                isDark: isDark,
                title: '1. Acceptance of Terms',
                content:
                    'By using Leno, you agree to these terms of service. If you do not agree, please do not use the app.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildTermSection(
                context: context,
                isDark: isDark,
                title: '2. User Responsibilities',
                content:
                    'You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account. You agree to provide accurate information.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildTermSection(
                context: context,
                isDark: isDark,
                title: '3. Content Ownership',
                content:
                    'You retain all rights to the content you create and upload. However, you grant us a license to use this content to provide and improve our services.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildTermSection(
                context: context,
                isDark: isDark,
                title: '4. Prohibited Activities',
                content:
                    'You may not use the app for illegal purposes, to harm others, or to violate intellectual property rights. We reserve the right to suspend accounts that violate these terms.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildTermSection(
                context: context,
                isDark: isDark,
                title: '5. Limitation of Liability',
                content:
                    'Leno is provided "as is" without warranties. We are not liable for any damages arising from your use of the app. Always consult professionals for pet health advice.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildTermSection(
                context: context,
                isDark: isDark,
                title: '6. Changes to Terms',
                content:
                    'We may update these terms from time to time. Continued use of the app after changes constitutes acceptance of the new terms.',
              ),
              const SizedBox(height: AppConstants.spacingL),

              // Contact Section
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9C27B0).withOpacity(0.1),
                      const Color(0xFF2196F3).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                ),
                child: Column(
                  children: [
                    Icon(Icons.email, size: 48, color: const Color(0xFF9C27B0)),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      'Questions?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'If you have any questions about our terms or commitments, please contact us at support@pawsona.com',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommitmentCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Icon(icon, color: iconColor, size: AppConstants.iconL),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppConstants.mediumGray,
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

  Widget _buildTermSection({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppConstants.mediumGray,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
