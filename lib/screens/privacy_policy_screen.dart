import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Screen for Privacy Policy
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Color(0xFFEAE5E1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.textGraphite,
                    ),
                    const Expanded(
                      child: Text(
                        'Privacy & Security',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGraphite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the header
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Introduction
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.arrowBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: AppColors.arrowBlue,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Your privacy is important to us. This policy explains how we collect, use, and protect your information.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textGraphite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Last updated
                      const Text(
                        'Last Updated: September 15, 2025',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.disabledGray,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Privacy policy sections
                      _buildPolicySection(
                        title: 'Information We Collect',
                        content:
                            'We collect information to provide better services to our users. The types of information we collect include:\n\n'
                            '• Account Information: When you create an account, we collect your name, email address, and password.\n\n'
                            '• Game Data: We collect data about your game progress, achievements, and in-game actions to provide game functionality.\n\n'
                            '• Device Information: We collect device-specific information such as your hardware model, operating system version, and unique device identifiers.\n\n'
                            '• Log Information: When you use our services, we automatically collect certain information in server logs, including your IP address and device event information.',
                      ),

                      _buildPolicySection(
                        title: 'How We Use Your Information',
                        content:
                            'We use the information we collect to:\n\n'
                            '• Provide, maintain, and improve our services\n'
                            '• Develop new features and services\n'
                            '• Protect our users and the public\n'
                            '• Personalize your experience\n'
                            '• Communicate with you about our services\n\n'
                            'We do not share your personal information with third parties except as described in this policy.',
                      ),

                      _buildPolicySection(
                        title: 'Data Security',
                        content:
                            'We implement appropriate security measures to protect your information from unauthorized access, alteration, disclosure, or destruction. These measures include internal reviews of our data collection, storage, and processing practices and security measures, as well as physical security measures to guard against unauthorized access to systems where we store personal data.\n\n'
                            'However, no method of transmission over the Internet or method of electronic storage is 100% secure. Therefore, while we strive to use commercially acceptable means to protect your personal information, we cannot guarantee its absolute security.',
                      ),

                      _buildPolicySection(
                        title: 'Your Privacy Controls',
                        content:
                            'You have the following rights regarding your personal information:\n\n'
                            '• Access: You can request access to your personal information we hold.\n\n'
                            '• Correction: You can request that we correct inaccurate or incomplete information.\n\n'
                            '• Deletion: You can request that we delete your personal information.\n\n'
                            '• Restriction: You can request that we restrict the processing of your information.\n\n'
                            '• Objection: You can object to our processing of your information.\n\n'
                            'To exercise these rights, please contact us through our support channels.',
                      ),

                      _buildPolicySection(
                        title: 'Children\'s Privacy',
                        content:
                            'Our services are not directed to children under the age of 13, and we do not knowingly collect personal information from children under 13. If we learn that we have collected personal information of a child under 13, we will take steps to delete such information from our files as soon as possible.',
                      ),

                      _buildPolicySection(
                        title: 'Changes to This Policy',
                        content:
                            'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date at the top of this policy.\n\n'
                            'You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
                      ),

                      _buildPolicySection(
                        title: 'Contact Us',
                        content:
                            'If you have any questions about this Privacy Policy, please contact us:\n\n'
                            'By email: privacy@glyphion.com\n\n'
                            'By visiting our support page: www.glyphion.com/support',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection({
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textGraphite,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textGraphite,
          ),
        ),
        if (!isLast) const SizedBox(height: 24),
      ],
    );
  }
}
