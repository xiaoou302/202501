import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import 'team_mission_screen.dart';
import 'feedback_screen.dart';
import 'quick_start_screen.dart';
import 'help_center_screen.dart';
import 'privacy_security_screen.dart';
import 'whats_new_screen.dart';
import 'terms_service_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: AppTheme.headingStyle),

            SizedBox(height: 32),
            _buildSettingCard(
              context,
              icon: FontAwesomeIcons.users,
              color: AppTheme.accentBlue,
              title: 'Team & Mission',
              subtitle: 'About our team and vision',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeamMissionScreen()),
              ),
            ),
            SizedBox(height: 16),
            _buildSettingCard(
              context,
              icon: FontAwesomeIcons.bullhorn,
              color: AppTheme.accentGreen,
              title: 'Submit Feedback',
              subtitle: 'Help us improve',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackScreen()),
              ),
            ),
            SizedBox(height: 16),
            _buildSettingCard(
              context,
              icon: FontAwesomeIcons.rocket,
              color: AppTheme.accentPurple,
              title: 'Quick Start Guide',
              subtitle: 'Learn the basics',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuickStartScreen()),
              ),
            ),
            SizedBox(height: 16),
            _buildSettingCard(
              context,
              icon: FontAwesomeIcons.questionCircle,
              color: AppTheme.accentPink,
              title: 'Help Center',
              subtitle: 'Get assistance',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpCenterScreen()),
              ),
            ),
            SizedBox(height: 16),
            _buildSettingCard(
              context,
              icon: FontAwesomeIcons.shieldAlt,
              color: AppTheme.accentYellow,
              title: 'Privacy & Security',
              subtitle: 'Manage your data protection',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacySecurityScreen(),
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildSettingCard(
              context,
              icon: FontAwesomeIcons.star,
              color: AppTheme.accentOrange,
              title: 'What\'s New',
              subtitle: 'Latest features and updates',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WhatsNewScreen()),
              ),
            ),
            SizedBox(height: 16),
            _buildSettingCard(
              context,
              icon: FontAwesomeIcons.fileContract,
              color: AppTheme.accentBlue,
              title: 'Terms of Service',
              subtitle: 'User agreement',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsServiceScreen()),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.borderRadius,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppTheme.darkGradient,
          borderRadius: AppTheme.borderRadius,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}
