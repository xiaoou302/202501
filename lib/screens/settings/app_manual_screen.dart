import 'package:flutter/material.dart';
import '../../theme/color_palette.dart';
import '../../theme/app_theme.dart';

class AppManualScreen extends StatelessWidget {
  const AppManualScreen({super.key});

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
          "USER MANUAL",
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              "QUICK START GUIDE",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: ColorPalette.obsidian,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Master your brewing journey with Selah.",
              style: AppTheme.monoStyle.copyWith(
                color: ColorPalette.matteSteel,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 40),
            _buildChapter(
              context,
              number: "01",
              title: "Digital Pantry",
              content:
                  "Start by adding your coffee beans to the Archive. You can scan the bag for auto-detection or manually input details like Origin, Roast Level, and Process.",
              icon: Icons.inventory_2_outlined,
            ),
            _buildDivider(),
            _buildChapter(
              context,
              number: "02",
              title: "AI Vision",
              content:
                  "Tap the camera icon to use AI Vision. It analyzes packaging to extract flavor notes and roast details instantly, saving you typing time.",
              icon: Icons.camera_alt_outlined,
            ),
            _buildDivider(),
            _buildChapter(
              context,
              number: "03",
              title: "Sensory Compass",
              content:
                  "Record your tasting experiences in the Sensory tab. Describe flavors in natural language, and our AI will generate a professional 6-axis flavor radar chart.",
              icon: Icons.explore_outlined,
            ),
            _buildDivider(),
            _buildChapter(
              context,
              number: "04",
              title: "Smart Suggestions",
              content:
                  "Based on your flavor preferences and history, Selah recommends new beans or brewing adjustments to explore.",
              icon: Icons.lightbulb_outline,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildChapter(
    BuildContext context, {
    required String number,
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ColorPalette.obsidian,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "CHAPTER $number",
                  style: AppTheme.monoStyle.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(icon, color: ColorPalette.rustedCopper, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorPalette.obsidian,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: ColorPalette.matteSteel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Container(
          width: 2,
          height: 40,
          color: ColorPalette.concreteDark,
        ),
      ),
    );
  }
}
