import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oravie/core/constants/app_colors.dart';
import 'package:oravie/presentation/screens/settings/app_intro_screen.dart';
import 'package:oravie/presentation/screens/settings/contact_us_screen.dart';
import 'package:oravie/presentation/screens/settings/feedback_screen.dart';
import 'package:oravie/presentation/screens/settings/liability_disclaimer_screen.dart';
import 'package:oravie/presentation/screens/settings/privacy_security_screen.dart';
import 'package:oravie/presentation/screens/settings/user_agreement_screen.dart';
import 'package:oravie/presentation/screens/settings/user_guide_screen.dart';
import 'package:oravie/OravieAP/StopDirectlyIndexList.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.snowWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.snowWhite,
            elevation: 0,
            pinned: true,
            expandedHeight: 120.0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.charcoal,
                  size: 18,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: const Text(
                'Settings',
                style: TextStyle(
                  color: AppColors.charcoal,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Playfair Display',
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.slateGreen.withValues(alpha: 0.05),
                      AppColors.snowWhite,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildSection(
                    title: 'General',
                    items: [
                      _SettingsItem(
                        icon: FontAwesomeIcons.store,
                        iconColor: const Color(0xFFE91E63),
                        title: 'Store',
                        subtitle: 'Purchase premium packages',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CompareGranularProgressBarOwner(),
                          ),
                        ),
                      ),
                      _SettingsItem(
                        icon: FontAwesomeIcons.circleInfo,
                        iconColor: const Color(0xFF6C63FF),
                        title: 'App Introduction',
                        subtitle: 'Learn more about Strida',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppIntroScreen(),
                          ),
                        ),
                      ),
                      _SettingsItem(
                        icon: FontAwesomeIcons.bookOpen,
                        iconColor: const Color(0xFFFF6584),
                        title: 'User Guide',
                        subtitle: 'How to use the app',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserGuideScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Support & Feedback',
                    items: [
                      _SettingsItem(
                        icon: FontAwesomeIcons.headset,
                        iconColor: const Color(0xFF00BFA5),
                        title: 'Contact Us',
                        subtitle: 'Get in touch with support',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactUsScreen(),
                          ),
                        ),
                      ),
                      _SettingsItem(
                        icon: FontAwesomeIcons.message,
                        iconColor: const Color(0xFFFFA000),
                        title: 'Feedback',
                        subtitle: 'Share your thoughts',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Legal',
                    items: [
                      _SettingsItem(
                        icon: FontAwesomeIcons.fileContract,
                        iconColor: const Color(0xFF455A64),
                        title: 'User Agreement',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserAgreementScreen(),
                          ),
                        ),
                      ),
                      _SettingsItem(
                        icon: FontAwesomeIcons.shieldHalved,
                        iconColor: const Color(0xFFD32F2F),
                        title: 'Liability Disclaimer',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LiabilityDisclaimerScreen(),
                          ),
                        ),
                      ),
                      _SettingsItem(
                        icon: FontAwesomeIcons.lock,
                        iconColor: const Color(0xFF388E3C),
                        title: 'Privacy & Security',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacySecurityScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 16),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoal.withValues(alpha: 0.5),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
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
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: item.onTap,
                      borderRadius: BorderRadius.vertical(
                        top: index == 0
                            ? const Radius.circular(24)
                            : Radius.zero,
                        bottom: isLast
                            ? const Radius.circular(24)
                            : Radius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: item.iconColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  item.icon,
                                  color: item.iconColor,
                                  size: 18,
                                ),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.charcoal,
                                    ),
                                  ),
                                  if (item.subtitle != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      item.subtitle!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 80,
                      endIndent: 24,
                      color: Colors.grey[100],
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}
