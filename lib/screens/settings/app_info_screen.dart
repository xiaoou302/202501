import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_panel.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Introduction',
          style: TextStyle(color: AppColors.starlightWhite, fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.starlightWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildFeatureCard(
              context,
              icon: FontAwesomeIcons.satelliteDish,
              iconColor: AppColors.orionPurple,
              title: 'AI Planner',
              description:
                  'Intelligent astrophotography planning powered by advanced AI. Get personalized target recommendations based on your location and season.',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              icon: FontAwesomeIcons.bookAtlas,
              iconColor: AppColors.andromedaCyan,
              title: 'Astro-Atlas',
              description:
                  'Comprehensive database of deep-sky objects including Messier, NGC, and IC catalogs with detailed specifications like magnitude, size, and distance.',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              icon: FontAwesomeIcons.crosshairs,
              iconColor: Colors.amber,
              title: 'FOV Simulator',
              description:
                  'Visualize your framing before shooting. Upload your own photos or use star charts to simulate different focal lengths and camera sensors.',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              icon: FontAwesomeIcons.bookOpen,
              iconColor: Colors.greenAccent,
              title: 'Astro-Log',
              description:
                  'Keep a detailed record of your observation sessions. Track seeing conditions, equipment used, Bortle scale, and personal notes.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return GlassPanel(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: iconColor.withOpacity(0.3)),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.starlightWhite,
                    height: 1.5,
                    fontSize: 13,
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
