import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

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
          'Disclaimer',
          style: AppTextStyles.poemTitle.copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF9800).withValues(alpha: 0.15),
                    const Color(0xFFFF9800).withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: const Color(0xFFFF9800),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Please read this disclaimer carefully before using Zina',
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF9800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSection(
              'General Information',
              'The information provided by Zina is for general informational purposes only. All content on the app is provided in good faith, however we make no representation or warranty of any kind regarding the accuracy or completeness of any information.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              'AI-Generated Content',
              'Zina uses AI technology to assist with creative writing. AI-generated suggestions are provided as inspiration only and should not be considered as professional advice. Users are responsible for reviewing and editing all AI-assisted content.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              'User-Generated Content',
              'Content posted by users represents their own views and opinions. Zina does not endorse, support, or guarantee the accuracy of any user-generated content. We are not responsible for any content posted by users.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              'No Professional Advice',
              'The content on Zina is not intended to be a substitute for professional advice. Always seek the advice of qualified professionals with any questions you may have.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              'External Links',
              'Zina may contain links to external websites. We have no control over the content of those sites and assume no responsibility for them or for any loss or damage that may arise from your use of them.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              'Limitation of Liability',
              'In no event shall Zina or its suppliers be liable for any damages arising out of the use or inability to use the materials on Zina, even if we have been notified of the possibility of such damage.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              'Changes to Disclaimer',
              'We may update this disclaimer from time to time. We will notify you of any changes by posting the new disclaimer on this page.',
            ),
            const SizedBox(height: 40),
            
            // Contact Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.paperLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cardBorder.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Questions?',
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If you have any questions about this disclaimer, please contact us at legal@versia.app',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
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
