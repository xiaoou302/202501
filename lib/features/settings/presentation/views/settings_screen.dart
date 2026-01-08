import 'package:flutter/material.dart';
import '../../../../app/theme/color_palette.dart';
import 'about_screen.dart';
import 'user_agreement_screen.dart';
import 'data_security_screen.dart';
import 'terms_of_service_screen.dart';
import 'feedback_screen.dart';
import 'version_info_screen.dart';
import 'disclaimer_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildInfoCard(context),
                  const SizedBox(height: 16),
                  _buildLegalCard(context),
                  const SizedBox(height: 16),
                  _buildSupportCard(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                AppColors.accent,
                AppColors.accent.withValues(alpha: 0.7),
              ],
            ).createShader(bounds),
            child: const Text(
              'SETTINGS',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'App Information & Support',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return _buildCard(
      title: 'App Information',
      icon: Icons.info_outline_rounded,
      iconColor: const Color(0xFF3B82F6),
      items: [
        _SettingItem(
          icon: Icons.article_outlined,
          iconColor: const Color(0xFF3B82F6),
          title: 'About Capu',
          subtitle: 'Learn more about our app',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutScreen()),
          ),
        ),
        _SettingItem(
          icon: Icons.new_releases_outlined,
          iconColor: const Color(0xFF8B5CF6),
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
      title: 'Legal & Privacy',
      icon: Icons.gavel_outlined,
      iconColor: const Color(0xFF10B981),
      items: [
        _SettingItem(
          icon: Icons.description_outlined,
          iconColor: const Color(0xFF10B981),
          title: 'User Agreement',
          subtitle: 'Terms you agreed to',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserAgreementScreen()),
          ),
        ),
        _SettingItem(
          icon: Icons.policy_outlined,
          iconColor: const Color(0xFF059669),
          title: 'Terms of Service',
          subtitle: 'Service usage terms',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
          ),
        ),
        _SettingItem(
          icon: Icons.security_outlined,
          iconColor: const Color(0xFF0891B2),
          title: 'Data Security',
          subtitle: 'How we protect your data',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DataSecurityScreen()),
          ),
        ),
        _SettingItem(
          icon: Icons.warning_amber_outlined,
          iconColor: const Color(0xFFF59E0B),
          title: 'Disclaimer',
          subtitle: 'Important notices',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DisclaimerScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return _buildCard(
      title: 'Support',
      icon: Icons.support_agent_outlined,
      iconColor: const Color(0xFFEC4899),
      items: [
        _SettingItem(
          icon: Icons.feedback_outlined,
          iconColor: const Color(0xFFEC4899),
          title: 'Feedback',
          subtitle: 'Share your thoughts',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<_SettingItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surface.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gray.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Column(
              children: [
                if (index > 0)
                  Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                    color: AppColors.gray.withValues(alpha: 0.1),
                  ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.icon,
                      size: 22,
                      color: item.iconColor,
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  subtitle: item.subtitle != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            item.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : null,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.grayDark.withValues(alpha: 0.5),
                  ),
                  onTap: item.onTap,
                ),
              ],
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  _SettingItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
  });
}
