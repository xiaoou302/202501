import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// User Agreement screen showing terms and conditions
class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: const Text(
          'User Agreement',
          style: TextStyle(color: AppTheme.primaryText),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAgreementHeader(),
              const SizedBox(height: 24),
              _buildAgreementContent(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build agreement header with icon
  Widget _buildAgreementHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF795548).withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.gavel_outlined,
              color: Color(0xFF795548),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Terms of Service',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Last Updated: June 1, 2024',
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Build agreement content with sections
  Widget _buildAgreementContent() {
    return Card(
      color: AppTheme.surfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. ACCEPTANCE OF TERMS',
              'By accessing or using the Virelia mobile application ("App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, please do not use the App.',
            ),
            _buildSection(
              '2. CHANGES TO TERMS',
              'We reserve the right to modify these Terms at any time. We will provide notice of any material changes through the App or by other means. Your continued use of the App after such modifications constitutes your acceptance of the modified Terms.',
            ),
            _buildSection(
              '3. PRIVACY POLICY',
              'Your use of the App is also governed by our Privacy Policy, which is incorporated by reference into these Terms. Please review our Privacy Policy to understand our practices regarding your personal information.',
            ),
            _buildSection(
              '4. USER ACCOUNTS',
              'You may be required to create an account to use certain features of the App. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
            ),
            _buildSection(
              '5. USER CONTENT',
              'You retain ownership of any content you submit to the App. By submitting content, you grant us a non-exclusive, royalty-free license to use, modify, and display that content in connection with the App.',
            ),
            _buildSection(
              '6. PROHIBITED CONDUCT',
              'You agree not to:\n'
                  '• Use the App for any illegal purpose\n'
                  '• Violate any applicable laws or regulations\n'
                  '• Impersonate any person or entity\n'
                  '• Interfere with the operation of the App\n'
                  '• Attempt to gain unauthorized access to the App or its systems',
            ),
            _buildSection(
              '7. INTELLECTUAL PROPERTY',
              'The App and its original content, features, and functionality are owned by Virelia and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
            ),
            _buildSection(
              '8. TERMINATION',
              'We may terminate or suspend your access to the App immediately, without prior notice or liability, for any reason, including if you breach these Terms.',
            ),
            _buildSection(
              '9. DISCLAIMER OF WARRANTIES',
              'THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.',
            ),
            _buildSection(
              '10. LIMITATION OF LIABILITY',
              'IN NO EVENT SHALL Virelia BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING WITHOUT LIMITATION, LOSS OF PROFITS, DATA, USE, GOODWILL, OR OTHER INTANGIBLE LOSSES, RESULTING FROM YOUR ACCESS TO OR USE OF OR INABILITY TO ACCESS OR USE THE APP.',
            ),
            _buildSection(
              '11. GOVERNING LAW',
              'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which Virelia operates, without regard to its conflict of law provisions.',
            ),
            _buildSection(
              '12. CONTACT US',
              'If you have any questions about these Terms, please contact us at support@Virelia-app.com.',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Build a section of the agreement
  Widget _buildSection(String title, String content, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.primaryText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
