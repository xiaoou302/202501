import 'package:flutter/material.dart';
import '../../theme/color_palette.dart';
import '../../theme/app_theme.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.concrete,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: ColorPalette.obsidian,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "PRIVACY & SECURITY",
          style: AppTheme.monoStyle.copyWith(
            color: ColorPalette.obsidian,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              "YOUR DATA,\nPROTECTED.",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: ColorPalette.obsidian,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
                fontSize: 32,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 40),
            _buildPolicyCard(
              context,
              icon: Icons.data_usage,
              title: "Data Collection",
              content:
                  "We collect minimal data necessary to provide the service. This includes images you upload for analysis and your tasting notes. We do not track your location or usage outside the app.",
            ),
            const SizedBox(height: 20),
            _buildPolicyCard(
              context,
              icon: Icons.lock_outline,
              title: "Secure Storage",
              content:
                  "Your data is stored securely on your device using sandboxed storage. Cloud backups are encrypted with AES-256 standard.",
            ),
            const SizedBox(height: 20),
            _buildPolicyCard(
              context,
              icon: Icons.smart_toy_outlined,
              title: "AI Processing",
              content:
                  "Images uploaded for AI analysis are processed transiently. They are processed in memory and are not stored permanently on our AI servers.",
            ),
            const SizedBox(height: 20),
            _buildPolicyCard(
              context,
              icon: Icons.shield_outlined,
              title: "User Rights",
              content:
                  "You have the right to request a full export or deletion of your data at any time via the 'Contact Us' page.",
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "Last Updated: October 2024",
                style: AppTheme.monoStyle.copyWith(
                  fontSize: 10,
                  color: ColorPalette.matteSteel.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ColorPalette.rustedCopper, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.obsidian,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: ColorPalette.matteSteel,
            ),
          ),
        ],
      ),
    );
  }
}
