import 'package:flutter/material.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';

class AgreementScreen extends StatelessWidget {
  const AgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'User Agreement',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.padding_large),
        child: Container(
          padding: const EdgeInsets.all(AppValues.padding_large),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppValues.radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Zenith Sprint User Service Agreement',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppValues.margin),
              const Text(
                'Last updated: January 1, 2024',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.neutralDark,
                ),
              ),
              const SizedBox(height: AppValues.margin_large),
              _buildSection(
                '1. Acceptance of Agreement',
                'Welcome to Zenith Sprint. By using our application, you agree to be bound by all terms and conditions of this Service Agreement. Please read this agreement carefully.',
              ),
              _buildSection(
                '2. Description of Service',
                'Zenith Sprint is a mobile application focused on improving users\' mental arithmetic skills. We provide personalized training content, cognitive ability assessment, and progress tracking features.',
              ),
              _buildSection(
                '3. User Responsibilities',
                'You agree to:\n• Provide accurate and complete personal information\n• Not misuse our services\n• Not interfere with or disrupt the normal operation of the service\n• Comply with all applicable laws and regulations',
              ),
              _buildSection(
                '4. Intellectual Property',
                'This application and all its content (including but not limited to text, images, audio, video, software code) are protected by intellectual property laws. You may not copy, modify, distribute, or otherwise use this content without our express written permission.',
              ),
              _buildSection(
                '5. Privacy Protection',
                'We value your privacy. For details on how we collect, use, and protect your personal information, please refer to our Privacy Policy.',
              ),
              _buildSection(
                '6. Service Changes',
                'We reserve the right to modify, suspend, or terminate the service at any time. We will notify you of significant changes through in-app notifications or other reasonable means.',
              ),
              _buildSection(
                '7. Disclaimer',
                'This service is provided "as is". We do not guarantee the continuity, accuracy, or completeness of the service. To the maximum extent permitted by law, we are not liable for any direct, indirect, incidental, or consequential damages.',
              ),
              _buildSection(
                '8. Dispute Resolution',
                'Any dispute arising from this agreement shall first be resolved through friendly negotiation. If negotiation fails, the dispute shall be submitted to a court of competent jurisdiction in our locality.',
              ),
              _buildSection(
                '9. Contact Information',
                'If you have any questions about this agreement, please contact us at:\nEmail: legal@zenithsprint.com',
              ),
              const SizedBox(height: AppValues.margin_large),
              Container(
                padding: const EdgeInsets.all(AppValues.padding),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppValues.radius),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: const Text(
                  'By continuing to use Zenith Sprint, you acknowledge that you have read, understood, and agree to be bound by all terms of this User Agreement.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.margin_large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppValues.margin_small),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.neutralDark,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
