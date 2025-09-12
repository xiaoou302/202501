import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Terms of service screen
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgDeepSpaceGray,
              AppColors.bgDeepSpaceGray.withBlue(70),
            ],
            stops: const [0.2, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Introduction
                      _buildSection(
                        'Terms of Service',
                        'Last updated: September 2025',
                        icon: Icons.description_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Acceptance of Terms',
                        'By downloading, installing, or using Blokko, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app.',
                        icon: Icons.check_circle_outline,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'License',
                        'Blokko grants you a limited, non-exclusive, non-transferable, revocable license to use the app for your personal, non-commercial purposes.',
                        icon: Icons.verified_user_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'User Conduct',
                        'You agree not to:\n\n'
                            '• Modify, adapt, or hack the app\n'
                            '• Use the app for any illegal purpose\n'
                            '• Attempt to decompile or reverse engineer the app\n'
                            '• Use the app in any way that could damage or impair its functionality',
                        icon: Icons.people_outline,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Intellectual Property',
                        'All rights, title, and interest in and to the app, including all content, designs, text, graphics, images, and code, are owned by Blokko or its licensors.',
                        icon: Icons.copyright_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Disclaimer of Warranties',
                        'The app is provided "as is" without warranties of any kind, either express or implied. We do not warrant that the app will be error-free or uninterrupted.',
                        icon: Icons.warning_amber_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Limitation of Liability',
                        'In no event shall Blokko be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or relating to your use of the app.',
                        icon: Icons.shield_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Changes to Terms',
                        'We reserve the right to modify these Terms at any time. We will notify users of any changes by posting the updated Terms on this page.',
                        icon: Icons.update_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Contact',
                        'If you have any questions about these Terms, please contact us through the Feedback option in the app settings.',
                        icon: Icons.contact_mail_outlined,
                      ),

                      const SizedBox(height: 40),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textMoonWhite,
                  size: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.description_outlined,
                    color: AppColors.accentMintGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Terms of Service',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Placeholder for layout balance
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with icon
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentMintGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.accentMintGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.accentMintGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Content
          Text(
            content,
            style: TextStyle(
              color: AppColors.textMoonWhite.withOpacity(0.9),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
