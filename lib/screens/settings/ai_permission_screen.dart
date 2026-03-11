import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_panel.dart';

class AiPermissionScreen extends StatelessWidget {
  const AiPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Permissions & Transparency',
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
                  _buildQuestion(
                    '1. What AI service does this app use?',
                    'Strim utilizes DeepSeek (specifically the deepseek-chat model) as its core artificial intelligence provider. This service powers our "AI Planner" feature, generating astronomical observation recommendations and detailed shooting plans based on your input.',
                  ),
                  const SizedBox(height: 24),
                  _buildQuestion(
                    '2. Does this app share data with third-party AI services?',
                    'Yes, strictly limited data is shared. When you use the AI Planner feature, the text you enter (e.g., target names like "M42" or context like "Current Season") is transmitted securely to DeepSeek\'s API for processing. \n\nIMPORTANT: We do NOT share your photos, location data, device identifiers, or any personal identifiable information (PII) with the AI provider.',
                  ),
                  const SizedBox(height: 24),
                  _buildQuestion(
                    '3. Where can I confirm my consent before data sharing?',
                    'Your consent is confirmed explicitly through action. By navigating to the "AI Planner" tab and tapping "Analyze Sky" or submitting a search query, you acknowledge and agree to send that specific text prompt to DeepSeek.\n\nAdditionally, this screen (Settings > AI Permissions) serves as a permanent reference for our data practices. You can revoke consent at any time by simply ceasing to use the AI Planner feature.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            color: AppColors.andromedaCyan,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          answer,
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
