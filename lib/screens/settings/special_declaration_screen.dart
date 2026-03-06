import 'package:flutter/material.dart';
import '../../theme/color_palette.dart';
import '../../theme/app_theme.dart';

class SpecialDeclarationScreen extends StatelessWidget {
  const SpecialDeclarationScreen({super.key});

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
          "DECLARATION",
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ColorPalette.charcoal,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: ColorPalette.cremaGold,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "IMPORTANT NOTICE",
                    style: AppTheme.monoStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Selah provides AI-driven analysis for informational and entertainment purposes only.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildDisclaimerItem(
              title: "AI Accuracy",
              content:
                  "The AI analysis provided by Selah is for reference only. While we strive for high accuracy, results may vary based on image quality, lighting, and packaging design. We do not guarantee 100% accuracy in flavor detection.",
            ),
            _buildDisclaimerItem(
              title: "Health Advice",
              content:
                  "Selah does not provide medical or health advice. Caffeine consumption affects individuals differently. Please monitor your intake according to your personal health conditions and consult a doctor if necessary.",
            ),
            _buildDisclaimerItem(
              title: "Third-Party Services",
              content:
                  "This app may contain links to third-party websites or services that are not owned or controlled by Selah. We assume no responsibility for the content, privacy policies, or practices of any third-party websites.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimerItem({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorPalette.obsidian,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: ColorPalette.matteSteel,
            ),
          ),
          const SizedBox(height: 24),
          Divider(height: 1, color: ColorPalette.concreteDark),
        ],
      ),
    );
  }
}
