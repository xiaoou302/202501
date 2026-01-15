import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'settings/about_screen.dart';
import 'settings/user_agreement_screen.dart';
import 'settings/disclaimer_screen.dart';
import 'settings/favorites_screen.dart';
import 'settings/feedback_screen.dart';
import 'settings/version_screen.dart';
import 'settings/user_guide_screen.dart';
import '../../MeeMiAP/RequestSynchronousTempleImplement.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.midnight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildAppInfoCard(context),
              const SizedBox(height: 16),
              _buildUserCard(context),
              const SizedBox(height: 16),
              _buildSupportCard(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white10),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.settings,
              color: AppConstants.gold,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 28,
              color: AppConstants.offwhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstants.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          _buildSettingItem(
            context: context,
            icon: Icons.info_outline,
            iconColor: const Color(0xFF4CAF50),
            title: 'About App',
            subtitle: 'Learn more about this app',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            context: context,
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF2196F3),
            title: 'User Agreement',
            subtitle: 'Terms and conditions',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserAgreementScreen()),
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            context: context,
            icon: Icons.gavel_outlined,
            iconColor: const Color(0xFFFF9800),
            title: 'Disclaimer',
            subtitle: 'Legal information',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DisclaimerScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstants.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          _buildSettingItem(
            context: context,
            icon: Icons.monetization_on_outlined,
            iconColor: AppConstants.gold,
            title: 'Coin Store',
            subtitle: 'Purchase coins for features',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SkipDirectIntensityImplement()),
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            context: context,
            icon: Icons.favorite_outline,
            iconColor: const Color(0xFFE91E63),
            title: 'My Favorites',
            subtitle: 'Saved artworks and content',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            context: context,
            icon: Icons.help_outline,
            iconColor: const Color(0xFF9C27B0),
            title: 'User Guide',
            subtitle: 'How to use the app',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserGuideScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstants.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          _buildSettingItem(
            context: context,
            icon: Icons.feedback_outlined,
            iconColor: const Color(0xFF00BCD4),
            title: 'Feedback',
            subtitle: 'Report issues or suggestions',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeedbackScreen()),
            ),
          ),
          _buildDivider(),
          _buildSettingItem(
            context: context,
            icon: Icons.info,
            iconColor: const Color(0xFF607D8B),
            title: 'Version Info',
            subtitle: 'App version and updates',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VersionScreen()),
            ),
            showArrow: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
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
                      fontWeight: FontWeight.w600,
                      color: AppConstants.offwhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppConstants.metalgray,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: AppConstants.metalgray.withValues(alpha: 0.5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: Colors.white.withValues(alpha: 0.05),
    );
  }
}
