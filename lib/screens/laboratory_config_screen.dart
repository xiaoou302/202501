import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';
import 'settings/app_manual_screen.dart';
import 'settings/feedback_screen.dart';
import 'settings/contact_us_screen.dart';
import 'settings/about_app_screen.dart';
import 'settings/privacy_security_screen.dart';
import 'settings/user_agreement_screen.dart';
import 'settings/special_declaration_screen.dart';
import 'settings/ai_settings_screen.dart';
import '../baristalAP/GetHyperbolicSpriteAdapter.dart';

class LaboratoryConfigScreen extends StatelessWidget {
  const LaboratoryConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.concrete,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                "Settings",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: ColorPalette.obsidian,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                  fontSize: 36,
                ),
              ),
              const SizedBox(height: 32),

              // Group 0: Store (New Entry)
              _buildSectionHeader("PREMIUM"),
              _buildCardGroup([
                _buildSettingsItem(
                  context,
                  icon: FontAwesomeIcons.diamond,
                  iconColor: Color(0xFF0A84FF),
                  label: "Store",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InitializeAutoConfigurationHelper(),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              // Group 1: Support & Feedback
              _buildSectionHeader("SUPPORT & FEEDBACK"),
              _buildCardGroup([
                _buildSettingsItem(
                  context,
                  icon: FontAwesomeIcons.bookOpen,
                  iconColor: Colors.blueAccent,
                  label: "User Manual",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AppManualScreen()),
                  ),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: FontAwesomeIcons.solidCommentDots,
                  iconColor: Colors.orangeAccent,
                  label: "Feedback & Suggestions",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                  ),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: FontAwesomeIcons.solidEnvelope,
                  iconColor: Colors.green,
                  label: "Contact Us",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              // Group 2: Information
              _buildSectionHeader("INFORMATION"),
              _buildCardGroup([
                _buildSettingsItem(
                  context,
                  icon: FontAwesomeIcons.circleInfo,
                  iconColor: Colors.purpleAccent,
                  label: "About App",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutAppScreen()),
                  ),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: FontAwesomeIcons.wandMagicSparkles,
                  iconColor: ColorPalette.cremaGold,
                  label: "AI Permissions",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiSettingsScreen()),
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              // Group 3: Legal
              _buildSectionHeader("LEGAL"),
              _buildCardGroup([
                _buildSettingsItem(
                  context,
                  icon: FontAwesomeIcons.shieldHalved,
                  iconColor: Colors.redAccent,
                  label: "Privacy & Security",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacySecurityScreen(),
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: FontAwesomeIcons.fileContract,
                  iconColor: Colors.indigoAccent,
                  label: "User Agreement",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserAgreementScreen(),
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: FontAwesomeIcons.bullhorn,
                  iconColor: Colors.amber,
                  label: "Special Declaration",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SpecialDeclarationScreen(),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: AppTheme.monoStyle.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: ColorPalette.matteSteel,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 56);
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          20,
        ), // This might clip if not careful, but inside column usually OK or just remove radius for inner items
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColorPalette.obsidian,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFFD1D5DB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
