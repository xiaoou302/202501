import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_panel.dart';

class EulaScreen extends StatelessWidget {
  const EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'End User License Agreement',
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
                  _buildSectionHeader(
                    'ZERO TOLERANCE POLICY',
                    Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Strim maintains a strict ZERO TOLERANCE policy regarding objectionable content and abusive behavior.',
                    style: TextStyle(
                      color: AppColors.starlightWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBulletPoint(
                    'Objectionable Content',
                    'Users are prohibited from generating, uploading, or sharing content that is defamatory, discriminatory, offensive, or illegal.',
                  ),
                  _buildBulletPoint(
                    'Abusive Behavior',
                    'Harassment, bullying, or any form of abuse towards other users or the platform is strictly forbidden.',
                  ),
                  _buildBulletPoint(
                    'Consequences',
                    'Violations will result in immediate removal of content and permanent suspension of the user account. We actively monitor and act upon reports of violations within 24 hours.',
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    'AI TRANSPARENCY & PRIVACY',
                    AppColors.andromedaCyan,
                  ),
                  const SizedBox(height: 16),
                  _buildQnA(
                    '1. Which AI service does this app use?',
                    'Strim uses DeepSeek (specifically the deepseek-chat model) as its AI service provider for generating astronomical recommendations and shooting plans.',
                  ),
                  const SizedBox(height: 16),
                  _buildQnA(
                    '2. Does this app share data with third-party AI services?',
                    'Yes, limited data is shared. When you use the "AI Planner" feature, the text prompt you enter (e.g., target name) is sent to DeepSeek API. We do NOT share photos, personal identifiers, or location data.',
                  ),
                  const SizedBox(height: 16),
                  _buildQnA(
                    '3. Where is user consent confirmed?',
                    'Your consent is confirmed on the Splash Screen before entering the app by agreeing to this EULA. Additionally, using the "AI Planner" feature constitutes ongoing consent to process your specific text queries.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 6, color: AppColors.meteoriteGrey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(height: 1.5),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(
                      color: AppColors.starlightWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: content,
                    style: const TextStyle(
                      color: AppColors.meteoriteGrey,
                      fontSize: 14,
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

  Widget _buildQnA(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            color: AppColors.andromedaCyan,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          answer,
          style: const TextStyle(
            color: AppColors.starlightWhite,
            height: 1.5,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
