import 'package:flutter/material.dart';
import '../../../../app/theme/color_palette.dart';

class EULAScreen extends StatelessWidget {
  const EULAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('End User License Agreement'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withValues(alpha: 0.15),
                    AppColors.accent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.gavel,
                      color: AppColors.accent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EULA Agreement',
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
            
            // Zero Tolerance Policy - Highlighted
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.error.withValues(alpha: 0.15),
                    AppColors.error.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: AppColors.error,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'ZERO TOLERANCE POLICY',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.error,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Capu has ZERO TOLERANCE for inappropriate content and abusive behavior',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We are committed to creating a safe, friendly, and positive community environment for all users. Any violation of our community guidelines will be taken seriously.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildWarningItem(
                    '🚫 Prohibited Content',
                    'Pornography, violence, hate speech, harassment, bullying, misinformation, copyright infringement',
                  ),
                  const SizedBox(height: 12),
                  _buildWarningItem(
                    '⚠️ Consequences of Violations',
                    '• First violation: Content removal + Warning\n• Second violation: Account suspended for 7 days\n• Third violation: Permanent account ban',
                  ),
                  const SizedBox(height: 12),
                  _buildWarningItem(
                    '🔒 Severe Violations',
                    'Activities involving illegal conduct, serious harassment, or threats to safety will result in immediate permanent ban and may be reported to law enforcement',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            _buildSection(
              '1. License Grant',
              'Capu grants you a limited, non-exclusive, non-transferable license to use this application on your personal device. This license does not include any rights to resell or commercially use the application.',
            ),
            
            _buildSection(
              '2. Usage Restrictions',
              'You agree not to:\n• Modify, decompile, or reverse engineer the application\n• Remove any copyright or proprietary notices\n• Use the application for any illegal purposes\n• Interfere with or disrupt the normal operation of the application\n• Use automated tools to access the application\n• Impersonate others or misrepresent your identity',
            ),
            
            _buildSection(
              '3. User Content',
              'You are responsible for all content you upload to Capu. You warrant that you have the necessary rights and licenses. By uploading content, you grant Capu a worldwide, royalty-free license to use, display, and distribute your content.',
            ),
            
            _buildSection(
              '4. Privacy Protection',
              'We value your privacy. We collect and use your personal information solely to provide and improve our services. For details, please refer to our Privacy Policy. We do not sell your personal information to third parties.',
            ),
            
            _buildSection(
              '5. Intellectual Property',
              'Capu and all its content, features, and functionality are our proprietary property, protected by international copyright, trademark, and other intellectual property laws. You may not use our trademarks or branding without explicit authorization.',
            ),
            
            _buildSection(
              '6. Disclaimer',
              'Capu is provided "as is" without any express or implied warranties. We do not guarantee that the application will be error-free, secure, or always available. You use this application at your own risk.',
            ),
            
            _buildSection(
              '7. Limitation of Liability',
              'To the maximum extent permitted by law, Capu shall not be liable for any indirect, incidental, special, or consequential damages, including but not limited to loss of profits, data loss, or business interruption.',
            ),
            
            _buildSection(
              '8. Account Termination',
              'We reserve the right to suspend or terminate your account at any time, especially if you violate this agreement. Upon account termination, your right to use the application will immediately cease.',
            ),
            
            _buildSection(
              '9. Agreement Changes',
              'We may update this EULA from time to time. Significant changes will be notified through in-app notifications or email. Continued use of the application indicates your acceptance of the revised terms.',
            ),
            
            _buildSection(
              '10. Governing Law',
              'This agreement shall be governed by and construed in accordance with the laws of the relevant jurisdiction, without regard to conflict of law principles. Any disputes should be resolved through friendly negotiation, or submitted to arbitration or litigation if negotiation fails.',
            ),
            
            _buildSection(
              '11. Contact Us',
              'If you have any questions about this EULA or need to report violations, please contact us:\n\n📧 Email: legal@zylo.app\n📧 Report: report@zylo.app\n🌐 Website: www.zylo.app/support',
            ),
            
            const SizedBox(height: 32),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'By using Capu, you acknowledge that you have read, understood, and agree to comply with all terms of this agreement',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
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

  Widget _buildWarningItem(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
