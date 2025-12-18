import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

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
          'User Agreement',
          style: AppTextStyles.poemTitle.copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using Zina, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these terms, please do not use our service.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '2. User Content',
              'You retain all rights to the content you create and share on Zina. By posting content, you grant us a non-exclusive license to display, distribute, and promote your work within the app.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '3. Acceptable Use',
              'You agree to use Zina only for lawful purposes. You must not use our service to post content that is offensive, harmful, or violates the rights of others.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '4. Privacy',
              'We respect your privacy and are committed to protecting your personal data. Please review our Privacy Policy to understand how we collect and use your information.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '5. Intellectual Property',
              'All content, features, and functionality of Zina are owned by us and are protected by international copyright, trademark, and other intellectual property laws.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '6. Termination',
              'We reserve the right to terminate or suspend your access to Zina at any time, without prior notice, for conduct that we believe violates this agreement or is harmful to other users.',
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              '7. Changes to Agreement',
              'We may modify this agreement at any time. We will notify you of any changes by posting the new agreement on this page. Your continued use of Zina after changes constitutes acceptance.',
            ),
            const SizedBox(height: 40),
            
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF9C27B0).withValues(alpha: 0.1),
            const Color(0xFF9C27B0).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description_rounded,
            color: const Color(0xFF9C27B0),
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Updated',
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

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paperLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.olive,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'For questions about this agreement, please contact us at legal@versia.app',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
