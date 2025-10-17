import 'dart:ui';
import 'package:flutter/material.dart';
import 'settings/game_introduction_page.dart';
import 'settings/version_info_page.dart';
import 'settings/player_rights_page.dart';
import 'settings/anti_addiction_page.dart';
import 'settings/bug_report_page.dart';
import 'settings/contact_us_page.dart';

/// Settings page with various options
class SettingsPage extends StatelessWidget {
  /// Constructor
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeaderSection(),
                  const SizedBox(height: 24),
                  _buildSettingsCategory(
                    context,
                    title: 'Game Information',
                    items: [
                      SettingsItem(
                        icon: Icons.info_outline,
                        iconColor: Colors.blue,
                        title: 'Game Introduction',
                        onTap: () => _navigateToPage(
                          context,
                          const GameIntroductionPage(),
                        ),
                      ),
                      SettingsItem(
                        icon: Icons.new_releases,
                        iconColor: Colors.purple,
                        title: 'Version Information',
                        onTap: () =>
                            _navigateToPage(context, const VersionInfoPage()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCategory(
                    context,
                    title: 'Player Support',
                    items: [
                      SettingsItem(
                        icon: Icons.verified_user,
                        iconColor: Colors.green,
                        title: 'Player Rights',
                        onTap: () =>
                            _navigateToPage(context, const PlayerRightsPage()),
                      ),
                      SettingsItem(
                        icon: Icons.timer,
                        iconColor: Colors.orange,
                        title: 'Anti-Addiction Reminder',
                        onTap: () =>
                            _navigateToPage(context, const AntiAddictionPage()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCategory(
                    context,
                    title: 'Contact & Support',
                    items: [
                      SettingsItem(
                        icon: Icons.bug_report,
                        iconColor: Colors.red,
                        title: 'Report Bug',
                        onTap: () =>
                            _navigateToPage(context, const BugReportPage()),
                      ),
                      SettingsItem(
                        icon: Icons.contact_support,
                        iconColor: Colors.teal,
                        title: 'Contact Us',
                        onTap: () =>
                            _navigateToPage(context, const ContactUsPage()),
                      ),
                    ],
                  ),
                  // Add padding at the bottom to prevent white space
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCategory(
    BuildContext context, {
    required String title,
    required List<SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
              shadows: const [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2.0,
                  color: Color.fromARGB(150, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: items.map((item) {
                  final isLast = items.indexOf(item) == items.length - 1;
                  return Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.iconColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.icon, color: item.iconColor),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.white70,
                        ),
                        onTap: item.onTap,
                      ),
                      if (!isLast)
                        Divider(
                          color: Colors.white.withOpacity(0.2),
                          height: 1,
                          indent: 70,
                          endIndent: 20,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildHeaderSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Customize your experience and learn more about Jongara. Explore game information, player support options, and ways to connect with us.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 3,
                      offset: const Offset(1, 1),
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
}

/// Settings item model
class SettingsItem {
  /// Icon data
  final IconData icon;

  /// Icon color
  final Color iconColor;

  /// Title text
  final String title;

  /// Tap callback
  final VoidCallback onTap;

  /// Constructor
  const SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });
}
