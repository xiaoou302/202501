import 'package:flutter/material.dart';
import '../../../../app/theme/color_palette.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF059669).withValues(alpha: 0.15),
                    const Color(0xFF059669).withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF059669).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.policy_outlined,
                      color: Color(0xFF059669),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terms of Service',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Effective: December 2024',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grayDark,
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
              'Capu provides a platform for fashion inspiration, style discovery, and outfit organization. Our service includes AI-powered recommendations, content curation, and social features.',
            ),
            _buildSection(
              '2. Eligibility',
              'You must be at least 13 years old to use Capu. By using our service, you represent that you meet this age requirement and have the legal capacity to enter into this agreement.',
            ),
            _buildSection(
              '3. Service Availability',
              'We strive to provide continuous service availability but do not guarantee uninterrupted access. We may modify, suspend, or discontinue any aspect of the service at any time.',
            ),
            _buildSection(
              '4. User Responsibilities',
              'You agree to:\n• Provide accurate information\n• Maintain account security\n• Respect other users\n• Follow community guidelines\n• Not misuse the service',
            ),
            _buildSection(
              '5. Intellectual Property',
              'All content, features, and functionality of Capu are owned by us and protected by international copyright, trademark, and other intellectual property laws.',
            ),
            _buildSection(
              '6. Third-Party Services',
              'Our service may contain links to third-party websites or services. We are not responsible for the content or practices of these third parties.',
            ),
            _buildSection(
              '7. Limitation of Liability',
              'Capu is provided "as is" without warranties of any kind. We shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the service.',
            ),
            _buildSection(
              '8. Indemnification',
              'You agree to indemnify and hold Capu harmless from any claims, damages, or expenses arising from your use of the service or violation of these terms.',
            ),
            _buildSection(
              '9. Governing Law',
              'These terms shall be governed by and construed in accordance with applicable laws, without regard to conflict of law principles.',
            ),
            _buildSection(
              '10. Contact Information',
              'For questions about these Terms of Service, contact us at legal@zylo.app',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
