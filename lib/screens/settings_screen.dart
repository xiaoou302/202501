import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'settings/about_us_screen.dart';
import 'settings/help_center_screen.dart';
import 'settings/terms_of_service_screen.dart';
import 'settings/privacy_policy_screen.dart';
import 'settings/contact_us_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Information Card
            _buildSettingsCard(
              context,
              title: "Information",
              items: [
                SettingsItem(
                  icon: FontAwesomeIcons.circleInfo,
                  iconColor: const Color(0xFF4FC3F7),
                  title: "About Us",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsScreen()),
                  ),
                ),
                SettingsItem(
                  icon: FontAwesomeIcons.headset,
                  iconColor: const Color(0xFF66BB6A),
                  title: "Help Center",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpCenterScreen()),
                  ),
                ),
                SettingsItem(
                  icon: FontAwesomeIcons.envelope,
                  iconColor: const Color(0xFFFFB74D),
                  title: "Contact Us",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Legal Card
            _buildSettingsCard(
              context,
              title: "Legal",
              items: [
                SettingsItem(
                  icon: FontAwesomeIcons.fileContract,
                  iconColor: const Color(0xFFBA68C8),
                  title: "Terms of Service",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsOfServiceScreen()),
                  ),
                ),
                SettingsItem(
                  icon: FontAwesomeIcons.shieldHalved,
                  iconColor: const Color(0xFF4DB6AC),
                  title: "Privacy Policy",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // App Info Card
            _buildSettingsCard(
              context,
              title: "App",
              items: [
                SettingsItem(
                  icon: FontAwesomeIcons.code,
                  iconColor: const Color(0xFFEF5350),
                  title: "Current Version",
                  subtitle: "1.0.0",
                  onTap: () {},
                  showArrow: false,
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Build header
  Widget _buildHeader() {
    return const Row(
      children: [
        Text(
          "Settings",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Build settings card
  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required List<SettingsItem> items,
  }) {
    return Container(
      decoration: UIHelper.glassDecoration(
        radius: 20,
        opacity: 0.1,
        borderColor: AppColors.hologramPurple.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.hologramPurple,
              ),
            ),
          ),

          // Settings items
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Column(
              children: [
                if (index > 0)
                  Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                    color: AppColors.hologramPurple.withOpacity(0.1),
                  ),
                _buildSettingsItem(context, item),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  // Build settings item
  Widget _buildSettingsItem(BuildContext context, SettingsItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Icon with gradient background
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    item.iconColor.withOpacity(0.7),
                    item.iconColor.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: item.iconColor.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: FaIcon(
                  item.icon,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Arrow icon
            if (item.showArrow)
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textColor,
              ),
          ],
        ),
      ),
    );
  }
}

// Settings item model
class SettingsItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showArrow;

  SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.showArrow = true,
  });
}
