import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terms of Service',
          style: AppTextStyles.poemTitle.copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF5722).withValues(alpha: 0.1),
                    const Color(0xFFFF5722).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF5722).withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.gavel_rounded,
                    color: const Color(0xFFFF5722),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Effective Date',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'December 9, 2024',
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSection(
              '1. Service Description',
              'Zina provides a platform for poetry creation, discovery, and sharing. Our service includes AI-assisted writing tools, a community of poets, and features for organizing and collecting poetic works.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '2. Account Registration',
              'To access certain features, you may need to create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '3. User Conduct',
              'You agree not to use Zina to: post offensive or harmful content, infringe on intellectual property rights, harass other users, distribute spam or malware, or engage in any illegal activities.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '4. Content Ownership',
              'You retain ownership of all content you create. By posting on Zina, you grant us a worldwide, non-exclusive license to use, display, and distribute your content within our service.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '5. AI Services',
              'Our AI features are provided "as is" without warranties. AI-generated content is for inspiration only. You are responsible for reviewing and editing all AI-assisted work before publication.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '6. Privacy and Data',
              'We collect and process data as described in our Privacy Policy. By using Zina, you consent to such processing and warrant that all data provided is accurate.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '7. Termination',
              'We may terminate or suspend access to our service immediately, without prior notice, for any breach of these Terms. Upon termination, your right to use the service will cease immediately.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '8. Limitation of Liability',
              'Zina shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '9. Changes to Terms',
              'We reserve the right to modify these terms at any time. We will notify users of any material changes. Continued use of Zina after changes constitutes acceptance of new terms.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '10. Contact Information',
              'For questions about these Terms of Service, please contact us at legal@versia.app or through our feedback form in the app.',
            ),
            const SizedBox(height: 40),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.paperLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cardBorder.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                'By using Zina, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
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
          style: AppTextStyles.poemTitle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: AppTextStyles.bodyText.copyWith(
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
