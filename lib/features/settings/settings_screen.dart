import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'screens/feedback_screen.dart';
import 'screens/data_protection_screen.dart';
import 'screens/guide_screen.dart';
import 'screens/version_history_screen.dart';
import 'screens/vision_screen.dart';
import 'screens/commitment_screen.dart';
import 'screens/echo_screen.dart';

class SettingsScreen extends StatelessWidget {
  final Function(bool)? onThemeToggle;

  const SettingsScreen({Key? key, this.onThemeToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Settings', style: theme.textTheme.displayMedium),
              const SizedBox(height: AppConstants.spacingL),

              // User Experience Card
              _buildCard(
                context: context,
                isDark: isDark,
                title: 'User Experience',
                items: [
                  _MenuItem(
                    icon: Icons.feedback,
                    iconColor: const Color(0xFF4CAF50),
                    title: 'Experience Feedback',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.explore,
                    iconColor: const Color(0xFFFF9800),
                    title: 'Explore Guide',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GuideScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingM),

              // Privacy & Security Card
              _buildCard(
                context: context,
                isDark: isDark,
                title: 'Privacy & Security',
                items: [
                  _MenuItem(
                    icon: Icons.security,
                    iconColor: const Color(0xFF2196F3),
                    title: 'Data Protection',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DataProtectionScreen(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.verified_user,
                    iconColor: const Color(0xFF9C27B0),
                    title: 'Commitment & Terms',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CommitmentScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingM),

              // About App Card
              _buildCard(
                context: context,
                isDark: isDark,
                title: 'About Leno',
                items: [
                  _MenuItem(
                    icon: Icons.history,
                    iconColor: const Color(0xFFE91E63),
                    title: 'Version Story',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VersionHistoryScreen(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.favorite,
                    iconColor: const Color(0xFFFF5722),
                    title: 'Vision & Mission',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VisionScreen()),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.forum,
                    iconColor: const Color(0xFF00BCD4),
                    title: 'Listening Echo',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EchoScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required List<_MenuItem> items,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppConstants.mediumGray,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Column(
              children: [
                _buildMenuItem(context, item),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingM,
                    ),
                    child: Divider(
                      height: 1,
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusL),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingM,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: AppConstants.iconM,
              ),
            ),
            const SizedBox(width: AppConstants.spacingM),
            Expanded(
              child: Text(item.title, style: theme.textTheme.titleLarge),
            ),
            Icon(
              Icons.chevron_right,
              color: AppConstants.mediumGray,
              size: AppConstants.iconM,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });
}
