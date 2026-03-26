import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../shared/widgets/glass_panel.dart';
import '../../abyssosAP/TrainPivotalDeliveryDelegate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.deepTeal.withValues(alpha: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aquaCyan.withValues(alpha: 0.1),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.deepTeal,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.starlightWhite.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.gear,
                          color: AppColors.starlightWhite,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          color: AppColors.starlightWhite,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Group 0: Store
                  _buildSectionTitle('STORE'),
                  const SizedBox(height: 12),
                  GlassPanel(
                    borderRadius: BorderRadius.circular(20),
                    padding: EdgeInsets.zero,
                    borderColor: AppColors.floraNeon.withValues(alpha: 0.15),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          context,
                          icon: FontAwesomeIcons.store,
                          iconColor: AppColors.floraNeon,
                          title: 'Store',
                          subtitle: 'Get more Coins',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RestartConsultativeExponentBase(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Group 1: Support & Feedback
                  _buildSectionTitle('SUPPORT & FEEDBACK'),
                  const SizedBox(height: 12),
                  GlassPanel(
                    borderRadius: BorderRadius.circular(20),
                    padding: EdgeInsets.zero,
                    borderColor: AppColors.aquaCyan.withValues(alpha: 0.15),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          context,
                          icon: FontAwesomeIcons.bookOpen,
                          iconColor: AppColors.aquaCyan,
                          title: 'App Manual',
                          subtitle: 'Guides & Tutorials',
                          onTap: () => context.push('/settings/manual'),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          context,
                          icon: FontAwesomeIcons.commentDots,
                          iconColor: AppColors.floraNeon,
                          title: 'Feedback',
                          subtitle: 'Share your thoughts',
                          onTap: () => context.push('/settings/feedback'),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          context,
                          icon: FontAwesomeIcons.envelope,
                          iconColor: AppColors.starlightWhite,
                          title: 'Contact Us',
                          subtitle: 'Get support',
                          onTap: () => context.push('/settings/contact'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Group 2: About
                  _buildSectionTitle('ABOUT'),
                  const SizedBox(height: 12),
                  GlassPanel(
                    borderRadius: BorderRadius.circular(20),
                    padding: EdgeInsets.zero,
                    borderColor: AppColors.alienPurple.withValues(alpha: 0.15),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          context,
                          icon: FontAwesomeIcons.circleInfo,
                          iconColor: AppColors.alienPurple,
                          title: 'About App',
                          subtitle: 'Version 1.0.0',
                          onTap: () => context.push('/settings/about'),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          context,
                          icon: FontAwesomeIcons.triangleExclamation,
                          iconColor: AppColors.algaeWarning,
                          title: 'Special Statement',
                          subtitle: 'Disclaimers',
                          onTap: () => context.push('/settings/statement'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Group 3: Legal & Privacy
                  _buildSectionTitle('LEGAL & PRIVACY'),
                  const SizedBox(height: 12),
                  GlassPanel(
                    borderRadius: BorderRadius.circular(20),
                    padding: EdgeInsets.zero,
                    borderColor: AppColors.toxicityAlert.withValues(
                      alpha: 0.15,
                    ),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          context,
                          icon: FontAwesomeIcons.shieldHalved,
                          iconColor: AppColors.mossMuted,
                          title: 'Privacy & Security',
                          onTap: () => context.push('/settings/privacy'),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          context,
                          icon: FontAwesomeIcons.fileContract,
                          iconColor: AppColors.mossMuted,
                          title: 'User Agreement',
                          onTap: () => context.push('/settings/agreement'),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          context,
                          icon: FontAwesomeIcons.robot,
                          iconColor: AppColors.alienPurple,
                          title: 'AI Permissions',
                          subtitle: 'Data usage details',
                          onTap: () => context.push('/settings/ai-permissions'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.mossMuted.withValues(alpha: 0.8),
          fontSize: 11,
          fontWeight: FontWeight.w800,
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
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.starlightWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.starlightWhite.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.starlightWhite.withValues(alpha: 0.2),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.starlightWhite.withValues(alpha: 0.05),
      indent: 68,
    );
  }
}
