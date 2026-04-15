import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'settings/app_intro_screen.dart';
import 'settings/user_agreement_screen.dart';
import 'settings/help_screen.dart';
import 'settings/contact_screen.dart';
import 'settings/feedback_screen.dart';
import 'settings/version_screen.dart';
import 'settings/disclaimer_screen.dart';
import 'CoinStoreScreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(child: CustomPaint(painter: SettingsGridPainter())),

          // Header
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: RichText(
              text: const TextSpan(
                text: 'Aero',
                style: TextStyle(
                  color: AppTheme.aeroNavy,
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                ),
                children: [
                  TextSpan(
                    text: 'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.aeroNavy,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content List
          Positioned(
            top: 120,
            bottom: 0,
            left: 0,
            right: 0,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                // Group 0: Store
                _buildCardGroup([
                  _buildListItem(
                    context,
                    icon: Icons.storefront_outlined,
                    iconColor: Colors.amber,
                    title: 'Coin Store',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CoinStoreScreen(),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                // Group 1: About & Info
                _buildCardGroup([
                  _buildListItem(
                    context,
                    icon: Icons.info_outline,
                    iconColor: Colors.blue,
                    title: 'App Introduction',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsAppIntroScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListItem(
                    context,
                    icon: Icons.article_outlined,
                    iconColor: Colors.deepPurple,
                    title: 'User Agreement',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsUserAgreementScreen(),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                // Group 2: Support
                _buildCardGroup([
                  _buildListItem(
                    context,
                    icon: Icons.help_outline,
                    iconColor: Colors.green,
                    title: 'Help & Support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsHelpScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListItem(
                    context,
                    icon: Icons.mail_outline,
                    iconColor: Colors.orange,
                    title: 'Contact Us',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsContactScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListItem(
                    context,
                    icon: Icons.feedback_outlined,
                    iconColor: AppTheme.turbulenceMagenta,
                    title: 'Feedback & Suggestions',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsFeedbackScreen(),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                // Group 3: System
                _buildCardGroup([
                  _buildListItem(
                    context,
                    icon: Icons.new_releases_outlined,
                    iconColor: AppTheme.laminarCyan,
                    title: 'Version Info',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsVersionScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListItem(
                    context,
                    icon: Icons.warning_amber_rounded,
                    iconColor: AppTheme.stallRed,
                    title: 'Disclaimer',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsDisclaimerScreen(),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.polarIce,
      indent: 64,
      endIndent: 20,
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        24,
      ), // Rough estimate for top/bottom items
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.aeroNavy,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class SettingsGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.aeroNavy.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
