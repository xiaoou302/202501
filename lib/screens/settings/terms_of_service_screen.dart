import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/neumorphic_card.dart';

/// Terms of Service Screen
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.gavel,
                      color: Colors.amber,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Updated: January 1, 2023',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Introduction
            const Text(
              'Introduction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Welcome to Hyquinoxa. These Terms of Service ("Terms") govern your use of the Hyquinoxa '
                  'mobile application ("App"), operated by Hyquinoxa Team ("we," "us," or "our"). '
                  'By accessing or using our App, you agree to be bound by these Terms. If you disagree '
                  'with any part of the terms, you do not have permission to access the App.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[300],
                    height: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Use of the App
            const Text(
              'Use of the App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermsSection(
                      '1. License',
                      'We grant you a limited, non-exclusive, non-transferable, revocable license to use the App '
                          'for your personal, non-commercial purposes, subject to these Terms.',
                    ),
                    const SizedBox(height: 16),
                    _buildTermsSection(
                      '2. User Restrictions',
                      'You agree not to:\n'
                          '• Modify, adapt, or hack the App\n'
                          '• Use the App for any illegal purpose\n'
                          '• Attempt to gain unauthorized access to any part of the App\n'
                          '• Use the App to distribute malware or harmful code\n'
                          '• Interfere with the proper working of the App',
                    ),
                    const SizedBox(height: 16),
                    _buildTermsSection(
                      '3. Age Restrictions',
                      'The App is intended for users of all ages. However, users under the age of 13 should '
                          'use the App with parental supervision.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Intellectual Property
            const Text(
              'Intellectual Property',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermsSection(
                      '1. Ownership',
                      'The App and its original content, features, and functionality are owned by Hyquinoxa Team '
                          'and are protected by international copyright, trademark, patent, trade secret, '
                          'and other intellectual property laws.',
                    ),
                    const SizedBox(height: 16),
                    _buildTermsSection(
                      '2. Feedback',
                      'Any feedback, comments, or suggestions you may provide regarding the App is entirely '
                          'voluntary, and we will be free to use such feedback, comments, or suggestions '
                          'without any obligation to you.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // User Content
            const Text(
              'User Content',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildTermsSection(
                  'User Generated Content',
                  'The App does not currently allow users to submit or post content visible to other users. '
                      'Any personal game data you generate is stored locally on your device or in your '
                      'personal account and is subject to our Privacy Policy.',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Termination
            const Text(
              'Termination',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildTermsSection(
                  'Account Termination',
                  'We may terminate or suspend your access to the App immediately, without prior notice or liability, '
                      'for any reason whatsoever, including without limitation if you breach the Terms.\n\n'
                      'Upon termination, your right to use the App will immediately cease. If you wish to terminate '
                      'your account, you may simply discontinue using the App.',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Limitation of Liability
            const Text(
              'Limitation of Liability',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildTermsSection(
                  'Disclaimer',
                  'The App is provided "as is" and "as available" without any warranties of any kind, either '
                      'express or implied, including but not limited to the implied warranties of merchantability, '
                      'fitness for a particular purpose, or non-infringement.\n\n'
                      'In no event shall Hyquinoxa Team be liable for any indirect, incidental, special, '
                      'consequential or punitive damages, including without limitation, loss of profits, data, '
                      'use, goodwill, or other intangible losses, resulting from your access to or use of or '
                      'inability to access or use the App.',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Governing Law
            const Text(
              'Governing Law',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildTermsSection(
                  'Applicable Law',
                  'These Terms shall be governed and construed in accordance with the laws applicable in your '
                      'jurisdiction, without regard to its conflict of law provisions.\n\n'
                      'Our failure to enforce any right or provision of these Terms will not be considered a waiver '
                      'of those rights. If any provision of these Terms is held to be invalid or unenforceable by '
                      'a court, the remaining provisions of these Terms will remain in effect.',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Changes to Terms
            const Text(
              'Changes to Terms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildTermsSection(
                  'Updates to Terms',
                  'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. '
                      'If a revision is material we will try to provide at least 30 days notice prior to any new '
                      'terms taking effect.\n\n'
                      'By continuing to access or use our App after those revisions become effective, you agree to '
                      'be bound by the revised terms. If you do not agree to the new terms, please stop using the App.',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Contact Us
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'If you have any questions about these Terms, please contact us at:',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'legal@hyquinoxa.com',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/customer_support');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Acceptance
            Center(
              child: Text(
                'By using the Hyquinoxa app, you acknowledge that you have read and\n'
                'understand these Terms of Service and agree to be bound by them.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build a terms section with title and content
  Widget _buildTermsSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 15, color: Colors.grey[300], height: 1.5),
        ),
      ],
    );
  }
}
