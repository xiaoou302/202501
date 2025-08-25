import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/glass_card.dart';

/// Privacy Protection Screen
/// Displays information about how player data is protected
class PrivacyProtectionScreen extends StatelessWidget {
  const PrivacyProtectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Adventurer Information Protection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Colors.purpleAccent,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ADVENTURER INFORMATION PROTECTION',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Privacy Policy & Data Security',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Introduction Section
            const Text(
              'INTRODUCTION',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Text(
                'ChroPlexiGnosis is committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Information Collection Section
            const Text(
              'INFORMATION COLLECTION',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacyItem(
                    title: 'Game Progress Data',
                    description:
                        'We collect information about your game progress, including levels completed, scores, and achievements.',
                    icon: Icons.games,
                    iconColor: Colors.blueAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildPrivacyItem(
                    title: 'Device Information',
                    description:
                        'We may collect device information such as device type, operating system version, and unique device identifiers to optimize game performance.',
                    icon: Icons.devices,
                    iconColor: Colors.tealAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildPrivacyItem(
                    title: 'Usage Data',
                    description:
                        'We collect data about how you interact with the game, including features used and time spent playing.',
                    icon: Icons.analytics,
                    iconColor: Colors.amberAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Data Usage Section
            const Text(
              'HOW WE USE YOUR INFORMATION',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacyItem(
                    title: 'Game Functionality',
                    description:
                        'We use your data to save your game progress and provide personalized gaming experiences.',
                    icon: Icons.save,
                    iconColor: Colors.greenAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildPrivacyItem(
                    title: 'Game Improvement',
                    description:
                        'We analyze usage patterns to improve game features, fix bugs, and enhance overall gameplay.',
                    icon: Icons.build,
                    iconColor: Colors.orangeAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildPrivacyItem(
                    title: 'Customer Support',
                    description:
                        'We may use your information to respond to your inquiries and provide technical support.',
                    icon: Icons.support_agent,
                    iconColor: Colors.purpleAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Data Security Section
            const Text(
              'DATA SECURITY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacyItem(
                    title: 'Storage Security',
                    description:
                        'Your data is stored securely using industry-standard encryption and security practices.',
                    icon: Icons.lock,
                    iconColor: Colors.redAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildPrivacyItem(
                    title: 'Access Controls',
                    description:
                        'We implement strict access controls to ensure only authorized personnel can access your information.',
                    icon: Icons.admin_panel_settings,
                    iconColor: Colors.blueAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildPrivacyItem(
                    title: 'Data Retention',
                    description:
                        'We retain your data only for as long as necessary to provide services and comply with legal obligations.',
                    icon: Icons.access_time,
                    iconColor: Colors.tealAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Your Rights Section
            const Text(
              'YOUR RIGHTS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacyItem(
                    title: 'Access',
                    description:
                        'You have the right to access the personal information we hold about you.',
                    icon: Icons.visibility,
                    iconColor: Colors.cyanAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildPrivacyItem(
                    title: 'Deletion',
                    description:
                        'You can request deletion of your personal data by contacting our support team.',
                    icon: Icons.delete,
                    iconColor: Colors.redAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildPrivacyItem(
                    title: 'Data Portability',
                    description:
                        'You can request a copy of your data in a structured, commonly used format.',
                    icon: Icons.import_export,
                    iconColor: Colors.amberAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Contact Information
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONTACT US',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'privacy@chroplexignosis.com',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: January 2023',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Helper method to build privacy items
  Widget _buildPrivacyItem({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
