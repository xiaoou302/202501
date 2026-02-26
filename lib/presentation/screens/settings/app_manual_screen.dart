import 'package:flutter/material.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppManualScreen extends StatelessWidget {
  const AppManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vellum,
      appBar: AppBar(
        title: Text("App Manual",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 20)),
        backgroundColor: AppColors.vellum,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(FontAwesomeIcons.arrowLeft, color: AppColors.leather),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              "1. Gallery Archive",
              "Explore a curated collection of restored artifacts. Tap on any item to view its detailed history, material specifications, and restoration journey.",
              FontAwesomeIcons.buildingColumns,
            ),
            _buildSection(
              context,
              "2. Relic Re-envision",
              "Upload photos of your vintage items. Our AI analyzes the material and condition to generate a visualized restoration preview. Use the slider to compare the current state with the potential restored look.",
              FontAwesomeIcons.wandMagicSparkles,
            ),
            _buildSection(
              context,
              "3. Artisan's Guide",
              "Receive step-by-step restoration instructions tailored to your specific artifact. The guide includes material identification, required tools, and safety warnings.",
              FontAwesomeIcons.scroll,
            ),
            _buildSection(
              context,
              "4. Workshop & Achievements",
              "Track your restoration projects in the Workshop. Complete guides to earn badges and climb the ranks from Apprentice to Master Restorer.",
              FontAwesomeIcons.screwdriverWrench,
            ),
            _buildSection(
              context,
              "5. Data & Privacy",
              "Your uploaded images are processed securely. You can manage your restoration history in the settings or directly within the feature screens.",
              FontAwesomeIcons.shieldHalved,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.shale.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.leather.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.leather.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.vellum,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.brass.withOpacity(0.5)),
            ),
            child: Icon(icon, color: AppColors.leather, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.leather,
                        letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Text(content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.ink.withOpacity(0.8), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
