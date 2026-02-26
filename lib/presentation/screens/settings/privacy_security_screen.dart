import 'package:flutter/material.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vellum,
      appBar: AppBar(
        title: Text("Privacy & Security",
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
            const Text(
              "Your privacy is our priority.",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.leather),
            ),
            const SizedBox(height: 8),
            const Text(
              "We are committed to protecting your personal information and your digital restoration history.",
              style: TextStyle(color: AppColors.soot, fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildSection(
              "Data Protection",
              "We use industry-standard encryption to protect your data during transmission and storage. Your uploaded artifact photos are processed securely.",
              FontAwesomeIcons.lock,
            ),
            _buildSection(
              "Information Collection",
              "We collect only essential data: images you upload for analysis, app usage statistics to improve performance, and optional profile information.",
              FontAwesomeIcons.fileLines,
            ),
            _buildSection(
              "Third-Party Sharing",
              "We do not sell your personal data. We do NOT share your photos or data with third parties for training or marketing purposes. Processing is ephemeral and solely for providing the restoration service.",
              FontAwesomeIcons.shareNodes,
            ),
            _buildSection(
              "User Rights",
              "You retain full ownership of your photos. You can request to export or permanently delete your account and data at any time via settings.",
              FontAwesomeIcons.userShield,
            ),
            _buildSection(
              "Cookie Policy",
              "We use cookies and similar technologies to remember your preferences and understand how you use our app.",
              FontAwesomeIcons.cookieBite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.leather.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.leather, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink)),
                const SizedBox(height: 8),
                Text(content,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.soot.withOpacity(0.9),
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
