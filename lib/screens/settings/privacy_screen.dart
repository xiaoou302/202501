import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_panel.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
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
                    '1. Data Collection',
                    'We collect minimal data necessary for app functionality. This includes:\n• Device model (for FOV simulations)\n• Search queries (for AI recommendations)',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '2. AI Data Usage',
                    'Your text queries are sent to DeepSeek API for processing. We do not share personal identifiable information (PII) with third parties. All AI interactions are stateless and transient.',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '3. Local Storage',
                    'Your observation logs and photos are stored locally on your device. We do not upload your astrophotos to any cloud server unless you explicitly share them.',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '4. Third-Party Services',
                    'We may use third-party services for analytics and crash reporting to improve app stability. These services operate under their own privacy policies.',
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
