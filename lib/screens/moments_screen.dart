import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'settings/app_intro_screen.dart';
import 'settings/help_screen.dart';
import 'settings/version_screen.dart';
import 'settings/contact_us_screen.dart';
import 'settings/user_agreement_screen.dart';
import 'settings/advocacy_screen.dart';

class MomentsScreen extends StatelessWidget {
  const MomentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings & Info',
          style: TextStyle(
            color: AppColors.cocoaBrown,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.mistyFoam.withValues(alpha: 0.4),
              AppColors.pageBackground,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.25],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              _buildSectionHeader('About App'),
              _buildSettingsGroup([
                _SettingsItem(
                  icon: Icons.info_outline,
                  color: AppColors.seafoam,
                  title: 'App Introduction',
                  subtitle: 'What is Stray Rescue AI?',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AppIntroScreen()),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.new_releases_outlined,
                  color: AppColors.warmSun,
                  title: 'Version Info',
                  subtitle: 'Current version and features',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VersionScreen()),
                  ),
                ),
              ]),
              const SizedBox(height: 32),
              _buildSectionHeader('Support & Legal'),
              _buildSettingsGroup([
                _SettingsItem(
                  icon: Icons.help_outline,
                  color: AppColors.peachFuzz,
                  title: 'Help & Support',
                  subtitle: 'FAQ and usage guides',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpScreen()),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.mail_outline,
                  color: AppColors.mintGrass,
                  title: 'Contact Us',
                  subtitle: 'Send us your feedback',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                  ),
                ),
                _SettingsItem(
                  icon: Icons.description_outlined,
                  color: AppColors.chestnutGray,
                  title: 'User Agreement',
                  subtitle: 'Terms of service & privacy',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserAgreementScreen(),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 32),
              _buildSectionHeader('Our Mission'),
              _buildSettingsGroup([
                _SettingsItem(
                  icon: Icons.favorite_outline,
                  color: AppColors.apricotPreserve,
                  title: 'Care Advocacy',
                  subtitle: 'Companionship & Protection',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdvocacyScreen()),
                  ),
                ),
              ]),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Made with ♥ for strays',
                  style: TextStyle(
                    color: AppColors.chestnutGray.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.seafoam,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.cocoaBrown,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.warmGauze.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.chestnutGray.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(28) : Radius.zero,
                  bottom: isLast ? const Radius.circular(28) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(item.icon, color: item.color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: AppColors.cocoaBrown,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (item.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle!,
                                style: const TextStyle(
                                  color: AppColors.chestnutGray,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.chestnutGray.withValues(alpha: 0.5),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 76,
                  endIndent: 20,
                  color: AppColors.warmGauze.withValues(alpha: 0.5),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  _SettingsItem({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}
