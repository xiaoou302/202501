import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/color_palette.dart';
import '../../theme/app_theme.dart';

class AiSettingsScreen extends StatelessWidget {
  const AiSettingsScreen({super.key});

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
          "AI PERMISSIONS",
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Info Card
            Container(
              padding: const EdgeInsets.all(24),
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
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: ColorPalette.obsidian,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.wandMagicSparkles,
                      color: ColorPalette.cremaGold,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "AI Service Transparency",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.obsidian,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Selah uses advanced AI models to provide you with detailed coffee analysis and insights.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorPalette.matteSteel,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionHeader("AI SERVICES USED"),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              icon: FontAwesomeIcons.image,
              title: "Image Analysis",
              provider: "Doubao (by ByteDance)",
              description:
                  "Used in Bean Archive to analyze packaging photos and extract details like origin, process, and roast level.",
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              icon: FontAwesomeIcons.chartPie,
              title: "Sensory Analysis",
              provider: "DeepSeek",
              description:
                  "Used in Flavor Compass to analyze your tasting notes and generate flavor radar charts.",
            ),

            const SizedBox(height: 32),

            _buildSectionHeader("DATA PRIVACY & SHARING"),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorPalette.obsidian,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.shieldHalved,
                        color: ColorPalette.extractionGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "DATA SHARING POLICY",
                        style: AppTheme.monoStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Does this application share user data with third-party AI services?",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPalette.extractionGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorPalette.extractionGreen.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      "NO",
                      style: AppTheme.monoStyle.copyWith(
                        color: ColorPalette.extractionGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your data is processed solely to provide the requested analysis and is not shared with third parties for any other purpose. We do not sell or distribute your personal data.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.monoStyle.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: ColorPalette.matteSteel,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String provider,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ColorPalette.concrete,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: ColorPalette.obsidian),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorPalette.obsidian,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Provider: $provider",
                  style: AppTheme.monoStyle.copyWith(
                    fontSize: 11,
                    color: ColorPalette.rustedCopper,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: ColorPalette.matteSteel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
