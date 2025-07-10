import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

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
                title: 'Privacy Policy',
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
                        icon: Icons.security,
                        iconColor: AppColors.accentPurple,
                        title: 'Data Collection',
                        content:
                            'We collect minimal personal information necessary for app functionality. This includes:'
                            '\n\n• Story ideas and chapters'
                            '\n• Task management data'
                            '\n• App preferences and settings'
                            '\n\nAll data is stored locally on your device by default.',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.cloud_upload,
                        iconColor: AppColors.accentBlue,
                        title: 'Data Storage',
                        content:
                            'Your data is primarily stored locally on your device. If you choose to enable cloud backup:'
                            '\n\n• Data is encrypted before transmission'
                            '\n• We use industry-standard security measures'
                            '\n• You can delete your data at any time'
                            '\n\nWe never share your data with third parties.',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.brush,
                        iconColor: AppColors.accentGreen,
                        title: 'AI Features',
                        content: 'When using AI-powered features:'
                            '\n\n• Your prompts are processed securely'
                            '\n• Generated content remains your property'
                            '\n• No personal data is used for training'
                            '\n\nYou maintain full control over AI-generated content.',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.cookie,
                        iconColor: AppColors.warning,
                        title: 'Analytics & Cookies',
                        content: 'We use minimal analytics to improve the app:'
                            '\n\n• Anonymous usage statistics'
                            '\n• Crash reports'
                            '\n• Performance metrics'
                            '\n\nYou can opt-out of analytics in settings.',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildSection(
                        icon: Icons.support_agent,
                        iconColor: AppColors.info,
                        title: 'Your Rights',
                        content: 'You have the right to:'
                            '\n\n• Access your data'
                            '\n• Request data deletion'
                            '\n• Export your data'
                            '\n• Opt-out of features'
                            '\n\nContact us for any privacy-related concerns.',
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
                  Icons.shield,
                  color: AppColors.accentPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppStyles.paddingMedium),
              const Expanded(
                child: Text(
                  'Your Privacy Matters',
                  style: AppStyles.heading3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'We are committed to protecting your privacy and ensuring you have a secure and enjoyable experience using our app.',
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
            'Contact Us',
            style: AppStyles.heading3,
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'If you have any questions about our privacy policy or how we handle your data, please contact us:',
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          _buildContactItem(
            icon: Icons.email,
            text: 'privacy@ventrixalor.com',
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
