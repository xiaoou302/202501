import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'settings/about_app_screen.dart';
import 'settings/app_security_screen.dart';
import 'settings/app_guide_screen.dart';
import 'settings/version_info_screen.dart';
import 'settings/user_agreement_screen.dart';
import 'settings/app_disclaimer_screen.dart';
import 'settings/feedback_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildAppInfoCard(context),
                  const SizedBox(height: 16),
                  _buildLegalCard(context),
                  const SizedBox(height: 16),
                  _buildSupportCard(context),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.graphite.withValues(alpha: 0.3),
              AppConstants.ebony,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppConstants.theatreRed, AppConstants.balletPink],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.theatreRed.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: AppConstants.offWhite,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'App information & support',
                        style: TextStyle(
                          color: AppConstants.midGray,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context) {
    return _buildCard(
      title: 'App Information',
      items: [
        _SettingsItem(
          icon: Icons.info_rounded,
          iconColor: const Color(0xFF4A90E2),
          title: 'About App',
          subtitle: 'Learn more about Mireya',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutAppScreen()),
          ),
        ),
        _SettingsItem(
          icon: Icons.security_rounded,
          iconColor: const Color(0xFF50C878),
          title: 'App Security',
          subtitle: 'Privacy & data protection',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppSecurityScreen()),
          ),
        ),
        _SettingsItem(
          icon: Icons.menu_book_rounded,
          iconColor: const Color(0xFFFF6B6B),
          title: 'App Guide',
          subtitle: 'How to use Mireya',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppGuideScreen()),
          ),
        ),
        _SettingsItem(
          icon: Icons.system_update_rounded,
          iconColor: const Color(0xFFFFB347),
          title: 'Version Info',
          subtitle: 'Current version & updates',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VersionInfoScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildLegalCard(BuildContext context) {
    return _buildCard(
      title: 'Legal',
      items: [
        _SettingsItem(
          icon: Icons.description_rounded,
          iconColor: const Color(0xFF9B59B6),
          title: 'User Agreement',
          subtitle: 'Terms of service',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserAgreementScreen()),
          ),
        ),
        _SettingsItem(
          icon: Icons.gavel_rounded,
          iconColor: const Color(0xFFE74C3C),
          title: 'App Disclaimer',
          subtitle: 'Legal notices',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppDisclaimerScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return _buildCard(
      title: 'Support',
      items: [
        _SettingsItem(
          icon: Icons.feedback_rounded,
          iconColor: const Color(0xFF3498DB),
          title: 'Feedback',
          subtitle: 'Send us your thoughts',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required List<_SettingsItem> items}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.5),
            AppConstants.graphite.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.midGray.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                color: AppConstants.offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Divider(
                    color: AppConstants.midGray.withValues(alpha: 0.1),
                    height: 1,
                    indent: 72,
                  ),
                _buildSettingsItem(item),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(_SettingsItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
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
                    style: const TextStyle(
                      color: AppConstants.offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: AppConstants.midGray.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppConstants.midGray.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
