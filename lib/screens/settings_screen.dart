import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import 'settings/about_screen.dart';
import 'settings/user_agreement_screen.dart';
import 'settings/disclaimer_screen.dart';
import 'settings/terms_of_service_screen.dart';
import 'settings/feedback_screen.dart';
import 'settings/version_screen.dart';
import 'settings/features_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              Text(
                'Settings',
                style: AppTextStyles.poemTitle.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your app preferences',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // About Section
              _buildSectionCard(
                context,
                title: 'About',
                items: [
                  _SettingItem(
                    title: 'About Zina',
                    subtitle: 'Learn more about our app',
                    icon: Icons.info_rounded,
                    iconColor: const Color(0xFF5B9BD5),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutScreen()),
                    ),
                  ),
                  _SettingItem(
                    title: 'Features',
                    subtitle: 'Discover what Zina can do',
                    icon: Icons.star_rounded,
                    iconColor: const Color(0xFFFFC107),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeaturesScreen()),
                    ),
                  ),
                  _SettingItem(
                    title: 'Version',
                    subtitle: 'v1.0.0 - Latest',
                    icon: Icons.system_update_rounded,
                    iconColor: const Color(0xFF4CAF50),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VersionScreen()),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Legal Section
              _buildSectionCard(
                context,
                title: 'Legal',
                items: [
                  _SettingItem(
                    title: 'User Agreement',
                    subtitle: 'Terms you agree to',
                    icon: Icons.description_rounded,
                    iconColor: const Color(0xFF9C27B0),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserAgreementScreen()),
                    ),
                  ),
                  _SettingItem(
                    title: 'Terms of Service',
                    subtitle: 'Our service terms',
                    icon: Icons.gavel_rounded,
                    iconColor: const Color(0xFFFF5722),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
                    ),
                  ),
                  _SettingItem(
                    title: 'Disclaimer',
                    subtitle: 'Important information',
                    icon: Icons.warning_rounded,
                    iconColor: const Color(0xFFFF9800),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DisclaimerScreen()),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Support Section
              _buildSectionCard(
                context,
                title: 'Support',
                items: [
                  _SettingItem(
                    title: 'Feedback',
                    subtitle: 'Share your thoughts',
                    icon: Icons.feedback_rounded,
                    iconColor: const Color(0xFF00BCD4),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<_SettingItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: AppTextStyles.bodyText.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.ink,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.paperLight.withValues(alpha: 0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.cardBorder.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.olive.withValues(alpha: 0.03),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: List.generate(
              items.length,
              (index) => Column(
                children: [
                  _buildSettingItem(context, items[index]),
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.cardBorder.withValues(alpha: 0.3),
                      indent: 68,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(BuildContext context, _SettingItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.iconColor.withValues(alpha: 0.15),
                      item.iconColor.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: item.iconColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: item.iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  _SettingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}
