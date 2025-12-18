import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';

class EULAScreen extends StatelessWidget {
  const EULAScreen({super.key});

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
          'End User License Agreement',
          style: AppTextStyles.poemTitle.copyWith(fontSize: 18),
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.ribbon.withValues(alpha: 0.15),
                    AppColors.ribbon.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.ribbon.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ribbon.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.ribbon,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'IMPORTANT NOTICE',
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.ribbon,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please read carefully before using Zina',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.ink,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Zero Tolerance Policy Section
            _buildSectionTitle('🚫 Zero Tolerance Policy', AppColors.ribbon),
            const SizedBox(height: 16),
            
            _buildPolicyCard(
              'Prohibited Content',
              [
                'Hate speech, harassment, or bullying',
                'Explicit sexual content or nudity',
                'Violence, gore, or graphic content',
                'Spam, scams, or fraudulent activities',
                'Copyright infringement or plagiarism',
                'Personal information disclosure',
                'Illegal activities or promotion thereof',
              ],
              Icons.block_rounded,
              AppColors.ribbon,
            ),
            
            const SizedBox(height: 20),
            
            _buildPolicyCard(
              'Consequences of Violations',
              [
                'First Offense: Content removal + warning',
                'Second Offense: 7-day account suspension',
                'Third Offense: 30-day account suspension',
                'Severe Violations: Permanent account ban',
                'All violations are logged and reviewed',
                'Appeals can be submitted within 14 days',
              ],
              Icons.gavel_rounded,
              const Color(0xFFFF5722),
            ),
            
            const SizedBox(height: 32),
            
            // User Responsibilities
            _buildSectionTitle('✅ Your Responsibilities', AppColors.olive),
            const SizedBox(height: 16),
            
            _buildResponsibilityCard(
              'Content Creation',
              'You are solely responsible for all content you create, share, or publish on Zina. Ensure your content is original, respectful, and complies with all applicable laws.',
              Icons.create_rounded,
            ),
            
            const SizedBox(height: 12),
            
            _buildResponsibilityCard(
              'Community Respect',
              'Treat all users with respect and kindness. Engage in constructive discussions and support fellow poets in their creative journey.',
              Icons.people_rounded,
            ),
            
            const SizedBox(height: 12),
            
            _buildResponsibilityCard(
              'Reporting Violations',
              'If you encounter inappropriate content or behavior, please report it immediately using the report feature. Help us maintain a safe community.',
              Icons.flag_rounded,
            ),
            
            const SizedBox(height: 32),
            
            // Terms and Conditions
            _buildSectionTitle('📋 Terms and Conditions', AppColors.ink),
            const SizedBox(height: 16),
            
            _buildTermItem(
              '1. Acceptance of Terms',
              'By using Zina, you agree to be bound by these terms and conditions. If you do not agree, please do not use the application.',
            ),
            
            _buildTermItem(
              '2. Account Security',
              'You are responsible for maintaining the confidentiality of your account credentials. Notify us immediately of any unauthorized access.',
            ),
            
            _buildTermItem(
              '3. Intellectual Property',
              'You retain ownership of your original content. By posting on Zina, you grant us a license to display and distribute your content within the platform.',
            ),
            
            _buildTermItem(
              '4. Content Moderation',
              'We reserve the right to review, moderate, or remove any content that violates our policies without prior notice.',
            ),
            
            _buildTermItem(
              '5. Service Availability',
              'We strive to provide uninterrupted service but do not guarantee 100% uptime. We are not liable for any service interruptions.',
            ),
            
            _buildTermItem(
              '6. Privacy and Data',
              'Your privacy is important to us. We collect and use data as described in our Privacy Policy. We do not sell your personal information.',
            ),
            
            _buildTermItem(
              '7. Modifications',
              'We may update these terms at any time. Continued use of Zina after changes constitutes acceptance of the new terms.',
            ),
            
            _buildTermItem(
              '8. Termination',
              'We reserve the right to terminate or suspend accounts that violate these terms or engage in harmful behavior.',
            ),
            
            const SizedBox(height: 32),
            
            // Contact Information
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.olive.withValues(alpha: 0.1),
                    AppColors.olive.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.olive.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_support_rounded,
                        color: AppColors.olive,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Need Help?',
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'If you have questions about these terms or need to report a violation, please contact us through the Feedback section in Settings.',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Last Updated
            Center(
              child: Text(
                'Last Updated: December 9, 2024',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color,
                color.withValues(alpha: 0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyles.poemTitle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyCard(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.paperLight.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.ink,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildResponsibilityCard(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.paperLight.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.olive.withValues(alpha: 0.15),
                  AppColors.olive.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.olive, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
    );
  }

  Widget _buildTermItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyText.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
