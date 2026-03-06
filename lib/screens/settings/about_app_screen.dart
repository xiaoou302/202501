import 'package:flutter/material.dart';
import '../../theme/color_palette.dart';
import '../../theme/app_theme.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

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
          "ABOUT",
          style: AppTheme.monoStyle.copyWith(
            color: ColorPalette.obsidian,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPalette.rustedCopper.withOpacity(0.05),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Card
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: ColorPalette.obsidian,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: ColorPalette.obsidian.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.coffee,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Selah",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: ColorPalette.obsidian,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPalette.concreteDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "v1.0.4 (Build 892)",
                      style: AppTheme.monoStyle.copyWith(
                        fontSize: 12,
                        color: ColorPalette.matteSteel,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    "Designed for Coffee Perfectionists.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.obsidian,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Selah combines the art of brewing with the precision of AI. From bean archiving to sensory analysis, every feature is crafted to elevate your daily coffee ritual.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: ColorPalette.matteSteel,
                    ),
                  ),
                  const SizedBox(height: 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(Icons.language),
                      const SizedBox(width: 24),
                      _buildSocialIcon(Icons.code),
                      const SizedBox(width: 24),
                      _buildSocialIcon(Icons.coffee_maker),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "© 2024 Selah Lab. \nAll rights reserved.",
                    textAlign: TextAlign.center,
                    style: AppTheme.monoStyle.copyWith(
                      fontSize: 10,
                      color: ColorPalette.matteSteel.withOpacity(0.5),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(icon, color: ColorPalette.obsidian, size: 20),
    );
  }
}
