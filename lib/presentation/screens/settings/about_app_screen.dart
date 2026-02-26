import 'package:flutter/material.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vellum,
      appBar: AppBar(
        title: Text("About Rue",
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.leather,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.brass, width: 6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.leather.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(FontAwesomeIcons.compassDrafting,
                      color: AppColors.brass, size: 60),
                ),
              ),
              const SizedBox(height: 32),
              Text("Rue",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.leather,
                      letterSpacing: 4,
                      fontSize: 32)),
              const SizedBox(height: 8),
              Text("Relic. Restore. Remember.",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.brass,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.2)),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.shale,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Version 1.0.0 (Beta)",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.soot, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 48),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Rue bridges the gap between the past and the present. Using advanced AI, we help you analyze, restore, and cherish your vintage artifacts. Join our community of preservationists and keep history alive.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.ink, height: 1.6, fontSize: 16),
                ),
              ),
              const SizedBox(height: 48),
              _buildInfoRow("Developer", "Rue Team"),
              const SizedBox(height: 12),
              _buildInfoRow("Contact", "hello@orivet.com"),
              const SizedBox(height: 48),
              Text("© 2026 Rue Inc. All rights reserved.",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.soot.withOpacity(0.5))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$label: ",
            style: const TextStyle(
                color: AppColors.soot, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: AppColors.leather)),
      ],
    );
  }
}
