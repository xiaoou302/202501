import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../about/about_us_page.dart';
import '../feedback/feedback_page.dart';
import '../tutorial/tutorial_page.dart';
import '../privacy/privacy_policy_page.dart';
import '../changelog/changelog_page.dart';
import '../terms/terms_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
                title: 'Information Center',
                showBackButton: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppStyles.paddingMedium),
                  child: Column(
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildCard(
                        title: 'About & Support',
                        items: [
                          MenuItem(
                            icon: Icons.info_outline,
                            iconColor: AppColors.accentPurple,
                            title: 'About Us',
                            subtitle: 'Learn about our mission and team',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutUsPage(),
                              ),
                            ),
                          ),
                          MenuItem(
                            icon: Icons.lightbulb_outline,
                            iconColor: AppColors.accentBlue,
                            title: 'Help Us Improve',
                            subtitle: 'Share your feedback and suggestions',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FeedbackPage(),
                              ),
                            ),
                          ),
                          MenuItem(
                            icon: Icons.school_outlined,
                            iconColor: AppColors.accentGreen,
                            title: 'Getting Started',
                            subtitle: 'Learn how to use the app',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TutorialPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildCard(
                        title: 'Legal & Privacy',
                        items: [
                          MenuItem(
                            icon: Icons.shield_outlined,
                            iconColor: AppColors.warning,
                            title: 'Privacy Policy',
                            subtitle: 'How we protect your data',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicyPage(),
                              ),
                            ),
                          ),
                          MenuItem(
                            icon: Icons.gavel_outlined,
                            iconColor: AppColors.error,
                            title: 'Terms of Service',
                            subtitle: 'Rules and guidelines',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TermsPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildCard(
                        title: 'Updates & Version',
                        items: [
                          MenuItem(
                            icon: Icons.update,
                            iconColor: AppColors.info,
                            title: 'What\'s New',
                            subtitle: 'See latest changes and updates',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChangelogPage(),
                              ),
                            ),
                          ),
                          MenuItem(
                            icon: Icons.info_outline,
                            iconColor: AppColors.accentPurple,
                            title: 'Version',
                            subtitle: 'v1.2.0 (Build 203)',
                            onTap: null,
                          ),
                        ],
                      ),
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
                  Icons.info_outline,
                  color: AppColors.accentPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppStyles.paddingMedium),
              const Expanded(
                child: Text(
                  'Welcome to Ventrixalor',
                  style: AppStyles.heading3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'Find help, learn about the app, and stay up to date with the latest changes.',
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required List<MenuItem> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.heading3,
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          ...items.map((item) => _buildMenuItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppStyles.paddingMedium,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppStyles.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppStyles.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: AppStyles.bodyTextSmall.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            if (item.onTap != null)
              const Icon(
                Icons.chevron_right,
                color: Colors.white38,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}
