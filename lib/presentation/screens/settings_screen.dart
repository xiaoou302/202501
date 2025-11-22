import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/haptic_utils.dart';
import '../widgets/particle_background.dart';
import 'settings/about_game_screen.dart';
import 'settings/game_security_screen.dart';
import 'settings/how_to_play_screen.dart';
import 'settings/version_info_screen.dart';
import 'settings/player_agreement_screen.dart';
import 'settings/game_benefits_screen.dart';
import 'settings/bug_report_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _navigateToScreen(BuildContext context, Widget screen) {
    HapticUtils.lightImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(child: _buildSettingsList(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.midnight, AppColors.midnight.withOpacity(0)],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticUtils.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF9B59B6).withOpacity(0.3),
                    AppColors.slate,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF9B59B6).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF9B59B6),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.gears,
                      size: 12,
                      color: Color(0xFF9B59B6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CONFIGURATION',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFF9B59B6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Settings & Info',
                  style: AppTextStyles.h2.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
          const FaIcon(
            FontAwesomeIcons.circleInfo,
            size: 24,
            color: Color(0xFF3498DB),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        const SizedBox(height: 8),
        _buildInfoCard(context),
        const SizedBox(height: 16),
        _buildGeneralCard(context),
        const SizedBox(height: 16),
        _buildSupportCard(context),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3498DB).withOpacity(0.15),
            AppColors.slate.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3498DB).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3498DB).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3498DB).withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const FaIcon(
                  FontAwesomeIcons.circleInfo,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Information',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  color: const Color(0xFF3498DB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.bookOpen,
            title: 'About Game',
            subtitle: 'Learn about Membly',
            color: const Color(0xFF2ECC71),
            onTap: () => _navigateToScreen(context, const AboutGameScreen()),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.gamepad,
            title: 'How to Play',
            subtitle: 'Game rules and tips',
            color: const Color(0xFFF1C40F),
            onTap: () => _navigateToScreen(context, const HowToPlayScreen()),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.code,
            title: 'Version Info',
            subtitle: 'v2.1.0 - Latest updates',
            color: const Color(0xFF9B59B6),
            onTap: () => _navigateToScreen(context, const VersionInfoScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2ECC71).withOpacity(0.15),
            AppColors.slate.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF2ECC71).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2ECC71).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2ECC71).withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const FaIcon(
                  FontAwesomeIcons.shield,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Privacy & Security',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  color: const Color(0xFF2ECC71),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.userShield,
            title: 'Game Security',
            subtitle: 'Privacy and data protection',
            color: const Color(0xFF16A085),
            onTap: () => _navigateToScreen(context, const GameSecurityScreen()),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.fileContract,
            title: 'Player Agreement',
            subtitle: 'Terms and conditions',
            color: const Color(0xFF3498DB),
            onTap: () =>
                _navigateToScreen(context, const PlayerAgreementScreen()),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.gift,
            title: 'Game Benefits',
            subtitle: 'Rewards and features',
            color: const Color(0xFFE67E22),
            onTap: () => _navigateToScreen(context, const GameBenefitsScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE67E22).withOpacity(0.15),
            AppColors.slate.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE67E22).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE67E22).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE67E22), Color(0xFFD35400)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE67E22).withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const FaIcon(
                  FontAwesomeIcons.headset,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Support',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  color: const Color(0xFFE67E22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.bug,
            title: 'Bug Report',
            subtitle: 'Report issues and feedback',
            color: const Color(0xFFE74C3C),
            onTap: () => _navigateToScreen(context, const BugReportScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.midnight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(child: FaIcon(icon, color: Colors.white, size: 20)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mica,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.mica.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: color.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
