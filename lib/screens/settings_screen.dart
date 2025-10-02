import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Screen for app settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Color(0xFFEAE5E1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.textGraphite,
                    ),
                    const Expanded(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGraphite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the header
                  ],
                ),
              ),

              // Settings groups
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    // App information card
                    _buildSettingsCard(
                      context,
                      title: 'App Information',
                      items: [
                        SettingsItem(
                          icon: Icons.info_outline_rounded,
                          iconColor: AppColors.arrowBlue,
                          title: 'About Us',
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.aboutUs),
                        ),
                        SettingsItem(
                          icon: Icons.help_outline_rounded,
                          iconColor: AppColors.arrowGreen,
                          title: 'Help Center',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.helpCenter,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Support card
                    _buildSettingsCard(
                      context,
                      title: 'Support',
                      items: [
                        SettingsItem(
                          icon: Icons.feedback_outlined,
                          iconColor: AppColors.arrowPink,
                          title: 'Feedback',
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.feedback),
                        ),
                        SettingsItem(
                          icon: Icons.support_agent_rounded,
                          iconColor: AppColors.arrowTerracotta,
                          title: 'Contact Support',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.contactSupport,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Legal card
                    _buildSettingsCard(
                      context,
                      title: 'Legal',
                      items: [
                        SettingsItem(
                          icon: Icons.security_rounded,
                          iconColor: const Color(0xFF6A8CAA), // Custom blue
                          title: 'Privacy & Security',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.privacyPolicy,
                          ),
                        ),
                        SettingsItem(
                          icon: Icons.gavel_rounded,
                          iconColor: const Color(0xFFD1813D), // Custom orange
                          title: 'Terms of Service',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.termsOfService,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Version info
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: AppColors.disabledGray,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom padding for navigation bar
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required List<SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card title
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textGraphite,
            ),
          ),
        ),

        // Card with items
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(
              UIConstants.defaultBorderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(items.length * 2 - 1, (index) {
              // Return divider for odd indices
              if (index.isOdd) {
                return const Divider(height: 1, indent: 56);
              }

              // Return list item for even indices
              final itemIndex = index ~/ 2;
              return _buildSettingsListItem(context, items[itemIndex]);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsListItem(BuildContext context, SettingsItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              // Colorful icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.iconColor, size: 20),
              ),
              const SizedBox(width: 16),

              // Title
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGraphite,
                  ),
                ),
              ),

              // Arrow icon
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.disabledGray,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Model class for settings item
class SettingsItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });
}
