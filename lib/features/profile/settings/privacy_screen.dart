import 'package:flutter/material.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
          'Privacy Policy',
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
                'Zenith Sprint Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppValues.margin),
              const Text(
                'Effective Date: January 1, 2024',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.neutralDark,
                ),
              ),
              const SizedBox(height: AppValues.margin_large),
              _buildSection(
                '1. Information Collection',
                'We collect the following types of information:\n\n• Account Information: username, email address\n• Training Data: question records, accuracy, reaction time\n• Device Information: device model, operating system version\n• Usage Data: app usage duration, feature usage frequency',
              ),
              _buildSection(
                '2. Information Use',
                'We use the collected information to:\n\n• Provide a personalized training experience\n• Generate cognitive ability analysis reports\n• Improve app features and user experience\n• Send important service notifications',
              ),
              _buildSection(
                '3. Information Sharing',
                'We promise not to sell, rent, or otherwise disclose your personal information to third parties, unless:\n\n• We obtain your explicit consent\n• Required by law\n• To protect our legal rights\n• To protect user safety in an emergency',
              ),
              _buildSection(
                '4. Data Security',
                'We use industry-standard security measures to protect your information:\n\n• Data encryption in transit and at rest\n• Regular security audits and vulnerability scanning\n• Strict access control and permission management\n• Employee privacy training and confidentiality agreements',
              ),
              _buildSection(
                '5. Data Retention',
                'We only retain your personal information for as long as necessary:\n\n• Account Information: for the duration of the account\n• Training Data: for analysis and service improvement\n• Log Data: typically retained for 90 days\n• You can request deletion of your personal data at any time',
              ),
              _buildSection(
                '6. Your Rights',
                'You have the following rights regarding your personal information:\n\n• Right to Access: view the information we hold about you\n• Right to Rectification: request correction of inaccurate information\n• Right to Erasure: request deletion of your personal information\n• Right to Restriction of Processing: restrict how we process your information',
              ),
              _buildSection(
                '7. Cookies and Tracking Technologies',
                'We use cookies and similar technologies to:\n\n• Remember your preferences\n• Analyze app usage\n• Provide personalized content\n• You can manage cookies through your device settings',
              ),
              _buildSection(
                '8. Children\'s Privacy',
                'Our service is not directed to children under 13. We do not knowingly collect personal information from children. If we discover that we have collected information from a child, we will delete it immediately.',
              ),
              _buildSection(
                '9. Policy Updates',
                'We may update this Privacy Policy from time to time. Significant changes will be notified to you via in-app notification or email. Continued use of the service constitutes acceptance of the updated policy.',
              ),
              _buildSection(
                '10. Contact Us',
                'If you have any privacy-related questions, please contact us:\n\nEmail: privacy@zenithsprint.com\nAddress: [Company Address]',
              ),
              const SizedBox(height: AppValues.margin_large),
              Container(
                padding: const EdgeInsets.all(AppValues.padding),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppValues.radius),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: AppColors.accent,
                      size: AppValues.icon_medium,
                    ),
                    const SizedBox(width: AppValues.margin),
                    const Expanded(
                      child: Text(
                        'We are committed to protecting your privacy and data security. If you have any questions, please feel free to contact us.',
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
