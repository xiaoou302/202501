import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/app_colors.dart';
import '../widgets/glass_panel.dart';
import 'settings/app_info_screen.dart';
import 'settings/feedback_screen.dart';
import 'settings/contact_screen.dart';
import 'settings/about_screen.dart';
import 'settings/privacy_screen.dart';
import 'settings/agreement_screen.dart';
import 'settings/ai_permission_screen.dart';
import '../astriusAP/FinishBasicEqualizationGroup.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SETTINGS',
                style: TextStyle(
                  color: AppColors.orionPurple,
                  fontSize: 12,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'General & Legal',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.starlightWhite,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),

              // Store Section
              _buildSectionHeader('STORE'),
              GlassPanel(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      context,
                      icon: FontAwesomeIcons.store,
                      iconColor: AppColors.orionPurple,
                      title: 'Coin Store',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OptimizeSymmetricNodeHelper(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // App Info & Support Section
              _buildSectionHeader('INFORMATION & SUPPORT'),
              GlassPanel(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      context,
                      icon: FontAwesomeIcons.circleInfo,
                      iconColor: Colors.blue,
                      title: 'App Introduction',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AppInfoScreen(),
                        ),
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      context,
                      icon: FontAwesomeIcons.lightbulb,
                      iconColor: Colors.amber,
                      title: 'Provide Suggestions',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FeedbackScreen(),
                        ),
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      context,
                      icon: FontAwesomeIcons.envelope,
                      iconColor: Colors.green,
                      title: 'Contact Us',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactScreen(),
                        ),
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      context,
                      icon: FontAwesomeIcons.mobileScreen,
                      iconColor: Colors.purple,
                      title: 'About Strim',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Legal & Privacy Section
              _buildSectionHeader('LEGAL & PRIVACY'),
              GlassPanel(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      context,
                      icon: FontAwesomeIcons.shieldHalved,
                      iconColor: Colors.teal,
                      title: 'Privacy Policy',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyScreen(),
                        ),
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      context,
                      icon: FontAwesomeIcons.fileContract,
                      iconColor: Colors.orange,
                      title: 'User Agreement',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AgreementScreen(),
                        ),
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      context,
                      icon: FontAwesomeIcons.robot,
                      iconColor: AppColors.andromedaCyan,
                      title: 'AI Permissions',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AiPermissionScreen(),
                        ),
                      ),
                    ),
                  ],
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
      padding: const EdgeInsets.only(bottom: 16.0, left: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.meteoriteGrey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.starlightWhite,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.meteoriteGrey.withOpacity(0.5),
        size: 20,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.glassBorder.withOpacity(0.3),
      indent: 56,
    );
  }
}
