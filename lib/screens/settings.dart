import 'package:flutter/material.dart';
import '../core/app_fonts.dart';
import '../core/constants.dart';

import 'settings/game_intro_screen.dart';
import 'settings/user_agreement_screen.dart';
import 'settings/disclaimer_screen.dart';
import 'settings/terms_screen.dart';
import 'settings/feedback_screen.dart';
import 'settings/version_info_screen.dart';
import 'settings/gameplay_guide_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.8,
              colors: [
                Color(0xFF1a2332),
                Color(0xFF0f1419),
                Colors.black,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
               // const SizedBox(height: 48),
                _buildHeader(context),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildSectionTitle('About'),
                      const SizedBox(height: 12),
                      _buildInfoCard(context),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Legal'),
                      const SizedBox(height: 12),
                      _buildLegalCard(context),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Support'),
                      const SizedBox(height: 12),
                      _buildSupportCard(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.01),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Icon(Icons.chevron_left, size: 14, color: Colors.white),
            ),
          ),
          Text(
            'SETTINGS',
            style: AppFonts.orbitron(
              fontSize: 14,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: AppFonts.orbitron(
        fontSize: 11,
        color: Colors.grey.shade500,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFF3B82F6),
            title: 'Game Introduction',
            subtitle: 'Learn about Solvion',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GameIntroScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.school_rounded,
            iconColor: const Color(0xFF8B5CF6),
            title: 'Gameplay Guide',
            subtitle: 'How to play',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GameplayGuideScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.info_rounded,
            iconColor: const Color(0xFF10B981),
            title: 'Version Info',
            subtitle: 'v${AppConstants.appVersion}',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VersionInfoScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.description_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: 'User Agreement',
            subtitle: 'Terms of use',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserAgreementScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.shield_rounded,
            iconColor: const Color(0xFFEF4444),
            title: 'Disclaimer',
            subtitle: 'No gambling involved',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DisclaimerScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.gavel_rounded,
            iconColor: const Color(0xFF6366F1),
            title: 'Terms of Service',
            subtitle: 'Legal terms',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TermsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: _buildMenuItem(
        context,
        icon: Icons.feedback_rounded,
        iconColor: const Color(0xFF14B8A6),
        title: 'Feedback',
        subtitle: 'Report issues or suggestions',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FeedbackScreen()),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 76),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withValues(alpha: 0.05),
      ),
    );
  }
}
