import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:flutter/services.dart';

// Import screens for navigation
import 'help/faq_screen.dart';
import 'help/recent_updates_screen.dart';
import 'help/feedback_channel_screen.dart';
import 'help/privacy_center_screen.dart';
import 'help/version_history_screen.dart';
import 'help/about_team_screen.dart';
import 'help/beginners_guide_screen.dart';
import 'help/user_agreement_screen.dart';

/// Profile screen with help and information sections
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _appVersion = '1.0.0';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildHelpAndSupportCard(),
                      const SizedBox(height: 24),
                      _buildInformationCard(),
                      const SizedBox(height: 24),
                      _buildLegalCard(),
                      const SizedBox(height: 24),
                      _buildAppInfoCard(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader() {
    return const Row(
      children: [
        Text(
          'Help Center',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Build help and support card with FAQ and feedback options
  Widget _buildHelpAndSupportCard() {
    return _buildCard('Help & Support', [
      _buildListItem(
        'Frequently Asked Questions',
        'Find answers to common questions',
        Icons.help_outline,
        const Color(0xFF4CAF50), // Green
        () => _navigateToScreen(const FAQScreen()),
      ),
      _buildListItem(
        'Beginner\'s Guide',
        'Essential tips for new users',
        Icons.lightbulb_outline,
        const Color(0xFFFFB74D), // Amber
        () => _navigateToScreen(const BeginnersGuideScreen()),
      ),
      _buildListItem(
        'Feedback Channel',
        'Share your thoughts and suggestions',
        Icons.feedback_outlined,
        const Color(0xFF2196F3), // Blue
        () => _navigateToScreen(const FeedbackChannelScreen()),
      ),
    ]);
  }

  /// Build information card with updates and version history
  Widget _buildInformationCard() {
    return _buildCard('Information', [
      _buildListItem(
        'Recent Updates',
        'What\'s new in Virelia',
        Icons.new_releases_outlined,
        const Color(0xFFE91E63), // Pink
        () => _navigateToScreen(const RecentUpdatesScreen()),
      ),
      _buildListItem(
        'Version History',
        'See all previous versions and changes',
        Icons.history,
        const Color(0xFF9C27B0), // Purple
        () => _navigateToScreen(const VersionHistoryScreen()),
      ),
      _buildListItem(
        'About Our Team',
        'Meet the people behind Virelia',
        Icons.people_outline,
        const Color(0xFF03A9F4), // Light Blue
        () => _navigateToScreen(const AboutTeamScreen()),
      ),
    ]);
  }

  /// Build legal information card
  Widget _buildLegalCard() {
    return _buildCard('Legal', [
      _buildListItem(
        'Privacy Center',
        'How we protect your data',
        Icons.privacy_tip_outlined,
        const Color(0xFF3F51B5), // Indigo
        () => _navigateToScreen(const PrivacyCenterScreen()),
      ),
      _buildListItem(
        'User Agreement',
        'Terms and conditions of use',
        Icons.gavel_outlined,
        const Color(0xFF795548), // Brown
        () => _navigateToScreen(const UserAgreementScreen()),
      ),
    ]);
  }

  /// Build app info card with logo and version
  Widget _buildAppInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // App Logo
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.brandBlue, AppTheme.accentOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'K',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Virelia',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version $_appVersion',
            style: const TextStyle(color: AppTheme.secondaryText, fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2024 Virelia Team',
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Helper method to build a card with title and list items
  Widget _buildCard(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  /// Helper method to build a list item with icon and navigation
  Widget _buildListItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.secondaryText),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigate to a new screen
  void _navigateToScreen(Widget screen) {
    HapticFeedback.mediumImpact();
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
