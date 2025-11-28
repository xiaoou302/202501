import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSection(
                    '1. Acceptance of Terms',
                    'By accessing and using Mireya, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    '2. Use License',
                    'Permission is granted to temporarily download one copy of Mireya for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    '3. User Account',
                    'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    '4. Content',
                    'Users are solely responsible for the content they post. We reserve the right to remove any content that violates our community guidelines or terms of service.',
                  ),
                  const SizedBox(height: 16),
                  _buildZeroToleranceSection(),
                  const SizedBox(height: 16),
                  _buildSection(
                    '5. Privacy',
                    'Your use of Mireya is also governed by our Privacy Policy. Please review our Privacy Policy, which also governs the site and informs users of our data collection practices.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    '6. Modifications',
                    'We reserve the right to modify these terms at any time. We will notify users of any material changes via email or through the app.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    '7. Termination',
                    'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    '8. Contact',
                    'If you have any questions about these Terms, please contact us at legal@mireya.app',
                  ),
                  const SizedBox(height: 24),
                  _buildLastUpdated(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: AppConstants.ebony.withValues(alpha: 0.95),
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConstants.graphite.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppConstants.offWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'User Agreement',
        style: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.5),
            AppConstants.graphite.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.midGray.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppConstants.offWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: AppConstants.midGray.withValues(alpha: 0.9),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZeroToleranceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.theatreRed.withValues(alpha: 0.15),
            AppConstants.graphite.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.theatreRed.withValues(alpha: 0.3),
          width: 2,
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
                  color: AppConstants.theatreRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: AppConstants.theatreRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '4.1 Zero Tolerance Policy',
                  style: TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.theatreRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppConstants.theatreRed.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: AppConstants.theatreRed.withValues(alpha: 0.9),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'We maintain a strict zero-tolerance policy towards inappropriate content and abusive behavior.',
                    style: TextStyle(
                      color: AppConstants.theatreRed,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Prohibited Content & Behavior',
            style: TextStyle(
              color: AppConstants.offWhite.withValues(alpha: 0.95),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'The following content and behaviors are strictly prohibited and will result in immediate action:',
            style: TextStyle(
              color: AppConstants.midGray.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          _buildProhibitedItem(
            Icons.dangerous_rounded,
            'Violence & Threats',
            'Content depicting, promoting, or threatening violence, self-harm, or harm to others.',
          ),
          const SizedBox(height: 10),
          _buildProhibitedItem(
            Icons.block_rounded,
            'Adult & Sexual Content',
            'Pornography, sexually explicit material, or content of a sexual nature.',
          ),
          const SizedBox(height: 10),
          _buildProhibitedItem(
            Icons.person_off_rounded,
            'Harassment & Bullying',
            'Harassment, bullying, stalking, or intimidation of any user.',
          ),
          const SizedBox(height: 10),
          _buildProhibitedItem(
            Icons.report_rounded,
            'Hate Speech',
            'Content promoting hatred, discrimination, or violence based on race, ethnicity, religion, gender, sexual orientation, disability, or other protected characteristics.',
          ),
          const SizedBox(height: 10),
          _buildProhibitedItem(
            Icons.child_care_rounded,
            'Child Safety',
            'Any content that exploits, endangers, or sexualizes minors.',
          ),
          const SizedBox(height: 10),
          _buildProhibitedItem(
            Icons.gavel_rounded,
            'Illegal Activities',
            'Content promoting or facilitating illegal activities, including drug use, weapons sales, or other criminal behavior.',
          ),
          const SizedBox(height: 10),
          _buildProhibitedItem(
            Icons.copyright_rounded,
            'Copyright Infringement',
            'Unauthorized use of copyrighted material without proper permission or attribution.',
          ),
          const SizedBox(height: 10),
          _buildProhibitedItem(
            Icons.report_problem_rounded,
            'Spam & Scams',
            'Spam, phishing attempts, scams, or misleading information.',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.ebony.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_rounded,
                      color: AppConstants.energyYellow.withValues(alpha: 0.9),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Enforcement Actions',
                      style: TextStyle(
                        color: AppConstants.offWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• First Violation: Warning and content removal\n'
                  '• Second Violation: Temporary account suspension (7-30 days)\n'
                  '• Severe Violations: Immediate permanent account ban\n'
                  '• Criminal Activity: Report to law enforcement authorities',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We are committed to maintaining a safe, respectful, and positive environment for all dancers. If you encounter any prohibited content, please report it immediately using the in-app reporting feature.',
            style: TextStyle(
              color: AppConstants.midGray.withValues(alpha: 0.85),
              fontSize: 14,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProhibitedItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppConstants.theatreRed.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppConstants.theatreRed,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppConstants.offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: AppConstants.midGray.withValues(alpha: 0.85),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated() {
    return Center(
      child: Text(
        'Last Updated: November 28, 2024',
        style: TextStyle(
          color: AppConstants.midGray.withValues(alpha: 0.7),
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
