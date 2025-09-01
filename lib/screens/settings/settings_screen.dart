import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/neumorphic_card.dart';
import 'game_introduction_screen.dart';
import 'anti_addiction_policy_screen.dart';
import 'help_center_screen.dart';
import 'customer_support_screen.dart';
import 'safety_privacy_screen.dart';
import 'terms_of_service_screen.dart';

/// Settings screen with various options and information
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Information Card
            NeumorphicCard(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  _buildListItem(
                    context,
                    icon: Icons.sports_esports,
                    iconColor: Colors.purple,
                    title: 'Game Introduction',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GameIntroductionScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  _buildListItem(
                    context,
                    icon: Icons.timer,
                    iconColor: Colors.orange,
                    title: 'Anti-addiction Policy',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AntiAddictionPolicyScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Support Card
            NeumorphicCard(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  _buildListItem(
                    context,
                    icon: Icons.help_center,
                    iconColor: Colors.blue,
                    title: 'Help Center',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HelpCenterScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  _buildListItem(
                    context,
                    icon: Icons.support_agent,
                    iconColor: Colors.green,
                    title: 'Customer Support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerSupportScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Legal Card
            NeumorphicCard(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  _buildListItem(
                    context,
                    icon: Icons.security,
                    iconColor: Colors.red,
                    title: 'Safety & Privacy',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SafetyPrivacyScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  _buildListItem(
                    context,
                    icon: Icons.gavel,
                    iconColor: Colors.amber,
                    title: 'Terms of Service',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsOfServiceScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // App Info
            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Version',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      '1.0.0',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Copyright
            Center(
              child: Text(
                '© 2023 Hyquinoxa',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a list item with icon and title
  Widget _buildListItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon with colorful background
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),

            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),

            // Arrow icon
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 22),
          ],
        ),
      ),
    );
  }
}
