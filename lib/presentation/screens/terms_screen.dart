import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';

/// Terms of Service screen
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        backgroundColor: AppTheme.deepSpace,
        title: const Text(
          'Terms of Service',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.champagne),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last updated
            Animations.fadeSlideIn(child: _buildLastUpdatedSection()),
            const SizedBox(height: 32),

            // Introduction
            Animations.fadeSlideIn(
              delay: 100,
              child: _buildSection(
                'Introduction',
                'Welcome to Soli. By accessing or using our application, you agree to be bound by these Terms of Service. If you disagree with any part of the terms, you may not access the service.',
              ),
            ),
            const SizedBox(height: 24),

            // User accounts
            Animations.fadeSlideIn(
              delay: 150,
              child: _buildSection(
                'User Accounts',
                'When you create an account with us, you must provide accurate and complete information. You are responsible for safeguarding the password that you use to access the service and for any activities or actions under your password.\n\n'
                    'You agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.',
              ),
            ),
            const SizedBox(height: 24),

            // Content
            Animations.fadeSlideIn(
              delay: 200,
              child: _buildSection(
                'User Content',
                'Our service allows you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material. You are responsible for the content that you post to the service, including its legality, reliability, and appropriateness.\n\n'
                    'By posting content to the service, you grant us the right to use, modify, publicly perform, publicly display, reproduce, and distribute such content on and through the service.',
              ),
            ),
            const SizedBox(height: 24),

            // Intellectual property
            Animations.fadeSlideIn(
              delay: 250,
              child: _buildSection(
                'Intellectual Property',
                'The service and its original content, features, and functionality are and will remain the exclusive property of Soli and its licensors. The service is protected by copyright, trademark, and other laws of both the United States and foreign countries.\n\n'
                    'Our trademarks and trade dress may not be used in connection with any product or service without the prior written consent of Soli.',
              ),
            ),
            const SizedBox(height: 24),

            // Termination
            Animations.fadeSlideIn(
              delay: 300,
              child: _buildSection(
                'Termination',
                'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.\n\n'
                    'Upon termination, your right to use the service will immediately cease. If you wish to terminate your account, you may simply discontinue using the service or delete your account within the app settings.',
              ),
            ),
            const SizedBox(height: 24),

            // Limitation of liability
            Animations.fadeSlideIn(
              delay: 350,
              child: _buildSection(
                'Limitation of Liability',
                'In no event shall Soli, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from:\n\n'
                    '• Your access to or use of or inability to access or use the service;\n'
                    '• Any conduct or content of any third party on the service;\n'
                    '• Any content obtained from the service; and\n'
                    '• Unauthorized access, use or alteration of your transmissions or content.',
              ),
            ),
            const SizedBox(height: 24),

            // Governing law
            Animations.fadeSlideIn(
              delay: 400,
              child: _buildSection(
                'Governing Law',
                'These Terms shall be governed and construed in accordance with the laws of the United States, without regard to its conflict of law provisions.\n\n'
                    'Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect.',
              ),
            ),
            const SizedBox(height: 24),

            // Changes to terms
            Animations.fadeSlideIn(
              delay: 450,
              child: _buildSection(
                'Changes to Terms',
                'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days\' notice prior to any new terms taking effect.\n\n'
                    'By continuing to access or use our service after those revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, please stop using the service.',
              ),
            ),
            const SizedBox(height: 24),

            // Contact us
            Animations.fadeSlideIn(delay: 500, child: _buildContactSection()),
            const SizedBox(height: 32),

            // Accept terms button
            Animations.fadeSlideIn(
              delay: 550,
              child: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.champagne,
                    foregroundColor: AppTheme.deepSpace,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'I Accept',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Build last updated section
  Widget _buildLastUpdatedSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.silverstone,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.champagne.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.champagne.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppTheme.champagne,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms of Service',
                    style: TextStyle(
                      color: AppTheme.moonlight,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Last Updated: September 1, 2025',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Please read these Terms of Service carefully before using the Soli application. These terms govern your use of our application and services.',
            style: TextStyle(color: AppTheme.moonlight, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Build content section
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.champagne,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.silverstone,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            style: const TextStyle(
              color: AppTheme.moonlight,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // Build contact section
  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Us',
          style: TextStyle(
            color: AppTheme.champagne,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.silverstone,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'If you have any questions about these Terms, please contact us:',
                style: TextStyle(
                  color: AppTheme.moonlight,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                'Email',
                'legal@soliapp.com',
                Icons.email_outlined,
                Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                'Phone',
                '+1 (800) 123-4567',
                Icons.phone_outlined,
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                'Address',
                '123 App Street, San Francisco, CA 94103',
                Icons.location_on_outlined,
                Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build contact item
  Widget _buildContactItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.moonlight,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
