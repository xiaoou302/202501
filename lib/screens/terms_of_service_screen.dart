import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Screen for Terms of Service
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

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
                        'Terms of Service',
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
                          color: const Color(
                            0xFFD1813D,
                          ).withOpacity(0.1), // Custom orange
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.gavel,
                              color: const Color(0xFFD1813D),
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Please read these Terms of Service carefully before using our application. By accessing or using the app, you agree to be bound by these Terms.',
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

                      // Terms sections
                      _buildTermsSection(
                        title: '1. Acceptance of Terms',
                        content:
                            'By downloading, installing, or using Glyphion, you agree to be bound by these Terms of Service. If you do not agree to these Terms, you may not access or use the app.\n\n'
                            'We may update these Terms from time to time. Your continued use of the app after any changes indicates your acceptance of the updated Terms.',
                      ),

                      _buildTermsSection(
                        title: '2. License and Use Restrictions',
                        content:
                            'Subject to your compliance with these Terms, we grant you a limited, non-exclusive, non-transferable, revocable license to download, install, and use the app for your personal, non-commercial use.\n\n'
                            'You may not:\n'
                            '• Modify, adapt, or hack the app\n'
                            '• Reverse engineer or attempt to extract the source code\n'
                            '• Remove any copyright or proprietary notices\n'
                            '• Use the app for any illegal purpose\n'
                            '• Distribute or make the app available over a network\n'
                            '• Create derivative works based on the app\n'
                            '• Use the app in any way that could damage or impair the app or our services',
                      ),

                      _buildTermsSection(
                        title: '3. User Accounts',
                        content:
                            'You may need to create an account to use certain features of the app. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.\n\n'
                            'You agree to provide accurate and complete information when creating your account and to update your information to keep it accurate and current.\n\n'
                            'We reserve the right to suspend or terminate your account if you violate these Terms or if we determine, in our sole discretion, that your actions may cause legal liability for you, other users, or us.',
                      ),

                      _buildTermsSection(
                        title: '4. In-App Purchases',
                        content:
                            'The app may offer in-app purchases. These purchases are processed through your device\'s app store and are subject to the app store\'s terms and conditions.\n\n'
                            'All purchases are final and non-refundable, except as required by applicable law. We are not responsible for any issues related to in-app purchases, including but not limited to billing errors or unauthorized purchases.',
                      ),

                      _buildTermsSection(
                        title: '5. Intellectual Property',
                        content:
                            'All rights, title, and interest in and to the app, including all content, designs, text, graphics, images, information, software, and other materials, are owned by us or our licensors.\n\n'
                            'Nothing in these Terms grants you any right to use our intellectual property for any purpose without our prior written consent.',
                      ),

                      _buildTermsSection(
                        title: '6. User Content',
                        content:
                            'You may be able to submit content through the app, such as feedback, comments, or suggestions. By submitting content, you grant us a worldwide, non-exclusive, royalty-free, perpetual, irrevocable license to use, reproduce, modify, adapt, publish, translate, distribute, and display such content.\n\n'
                            'You represent and warrant that you have all rights necessary to grant us these rights and that your content does not violate any third-party rights or applicable laws.',
                      ),

                      _buildTermsSection(
                        title: '7. Disclaimer of Warranties',
                        content:
                            'THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, OR COURSE OF PERFORMANCE.\n\n'
                            'We do not warrant that the app will function uninterrupted or error-free, that defects will be corrected, or that the app is free of viruses or other harmful components.',
                      ),

                      _buildTermsSection(
                        title: '8. Limitation of Liability',
                        content:
                            'TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL WE BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING WITHOUT LIMITATION, LOSS OF PROFITS, DATA, USE, GOODWILL, OR OTHER INTANGIBLE LOSSES, RESULTING FROM YOUR ACCESS TO OR USE OF OR INABILITY TO ACCESS OR USE THE APP.\n\n'
                            'Our total liability to you for any claims arising from or related to these Terms or the app shall not exceed the amount you have paid us, if any, for use of the app during the twelve (12) months immediately preceding the event giving rise to the claim.',
                      ),

                      _buildTermsSection(
                        title: '9. Governing Law',
                        content:
                            'These Terms shall be governed by and construed in accordance with the laws of the United States, without regard to its conflict of law principles.\n\n'
                            'Any dispute arising from or relating to these Terms or the app shall be subject to the exclusive jurisdiction of the courts located within the United States.',
                      ),

                      _buildTermsSection(
                        title: '10. Contact Information',
                        content:
                            'If you have any questions about these Terms, please contact us:\n\n'
                            'By email: terms@glyphion.com\n\n'
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

  Widget _buildTermsSection({
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
