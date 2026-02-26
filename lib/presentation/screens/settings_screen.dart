import 'package:flutter/material.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:orivet/presentation/screens/settings/app_manual_screen.dart';
import 'package:orivet/presentation/screens/settings/feedback_screen.dart';
import 'package:orivet/presentation/screens/settings/contact_us_screen.dart';
import 'package:orivet/presentation/screens/settings/about_app_screen.dart';
import 'package:orivet/presentation/screens/settings/privacy_security_screen.dart';
import 'package:orivet/presentation/screens/eula_screen.dart';
import 'package:orivet/presentation/screens/settings/special_instructions_screen.dart';
import 'package:orivet/OrivetAP/OffsetKeyBottomHelper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SETTINGS",
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.leather,
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 24),

          // Store Card
          _buildSettingsCard(
            context,
            "Store",
            [
              _buildSettingsItem(
                context,
                icon: FontAwesomeIcons.store,
                color: AppColors.brass,
                title: "Premium Store",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ContinueEasyChapterHandler())),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Help & Support Card
          _buildSettingsCard(
            context,
            "Help & Support",
            [
              _buildSettingsItem(
                context,
                icon: FontAwesomeIcons.bookOpen,
                color: Colors.blue,
                title: "App Manual",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AppManualScreen())),
              ),
              _buildSettingsItem(
                context,
                icon: FontAwesomeIcons.message,
                color: Colors.green,
                title: "Feedback",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FeedbackScreen())),
              ),
              _buildSettingsItem(
                context,
                icon: FontAwesomeIcons.headset,
                color: Colors.orange,
                title: "Contact Us",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ContactUsScreen())),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // About & Legal Card
          _buildSettingsCard(
            context,
            "About & Legal",
            [
              _buildSettingsItem(
                context,
                icon: FontAwesomeIcons.circleInfo,
                color: Colors.purple,
                title: "About App",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AboutAppScreen())),
              ),
              _buildSettingsItem(
                context,
                icon: FontAwesomeIcons.shieldHalved,
                color: Colors.red,
                title: "Privacy & Security",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PrivacySecurityScreen())),
              ),
              _buildSettingsItem(
                context,
                icon: FontAwesomeIcons.fileContract,
                color: Colors.teal,
                title: "User Agreement",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EulaScreen())),
              ),
              _buildSettingsItem(
                context,
                icon: FontAwesomeIcons.circleExclamation,
                color: Colors.amber,
                title: "Special Instructions",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SpecialInstructionsScreen())),
              ),
            ],
          ),

          const SizedBox(height: 48),
          Center(
            child: Text(
              "Rue v1.0.0",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.soot.withOpacity(0.5),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.soot,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.leather.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 56,
                      endIndent: 16,
                      color: AppColors.leather.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(icon, color: color, size: 16),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
            ),
            Icon(
              FontAwesomeIcons.chevronRight,
              size: 14,
              color: AppColors.soot.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
