import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_panel.dart';

class AgreementScreen extends StatelessWidget {
  const AgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Agreement',
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
            GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    '1. Acceptance of Terms',
                    'By accessing or using Strim ("the App"), you agree to be bound by these Terms of Service and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing this site.',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '2. Use License',
                    'Permission is granted to temporarily download one copy of the App for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '3. AI Usage & Disclaimer',
                    'You acknowledge that AI-generated content (including shooting plans and recommendations) is for informational purposes only. Strim is not responsible for any inaccuracies in astronomical data provided by AI services. Users should verify critical data with official astronomical sources.',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '4. User Content',
                    'You retain ownership of any photos or logs you create within the App. By using the App, you grant us a license to process this content locally on your device for the purpose of providing App functionality.',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '5. Limitations',
                    'In no event shall Strim or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit) arising out of the use or inability to use the App.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Last Updated: March 2026',
              style: TextStyle(color: AppColors.meteoriteGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.andromedaCyan,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: AppColors.starlightWhite,
            height: 1.6,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
