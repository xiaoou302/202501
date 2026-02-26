import 'package:flutter/material.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vellum,
      appBar: AppBar(
        title: Text("User Agreement",
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
            const Text("Last Updated: October 2026",
                style: TextStyle(
                    color: AppColors.soot, fontStyle: FontStyle.italic)),
            const SizedBox(height: 24),
            _buildSection(
              "1. Acceptance of Terms",
              "By accessing or using the Rue application, you agree to be bound by these Terms of Service and all applicable laws and regulations.",
            ),
            _buildSection(
              "2. Service Description",
              "Rue provides AI-powered restoration suggestions and visualizations for vintage artifacts. These are for informational and entertainment purposes only.",
            ),
            _buildSection(
              "3. User Conduct",
              "You agree not to use the service for any illegal purpose. You must not transmit any worms, viruses, or destructive code. Respect the community and other users.",
            ),
            _buildSection(
              "4. Intellectual Property",
              "The content, features, and functionality of the App (excluding user-generated content) are owned by Rue and protected by copyright and trademark laws.",
            ),
            _buildSection(
              "5. Disclaimer of Warranties",
              "The service is provided 'as is'. We do not guarantee that the AI results will be perfectly accurate or that restoration guides will result in a specific outcome.",
            ),
            _buildSection(
              "6. Limitation of Liability",
              "Rue shall not be liable for any indirect, incidental, special, consequential or punitive damages, or any loss of profits or revenues.",
            ),
            _buildSection(
              "7. Governing Law",
              "These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which Rue operates.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.shale.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.leather.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.leather)),
          const SizedBox(height: 8),
          Text(content,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.ink, height: 1.5)),
        ],
      ),
    );
  }
}
