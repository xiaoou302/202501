import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
                  _buildWarningCard(),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Zero Tolerance Policy',
                    'Mireya maintains a strict zero-tolerance policy towards inappropriate content and abusive behavior. We are committed to providing a safe, respectful, and positive environment for all dancers.',
                    Icons.shield_rounded,
                    const Color(0xFFE74C3C),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Prohibited Content',
                    'The following content is strictly prohibited:\n\n'
                    '• Harassment, bullying, or threatening behavior\n'
                    '• Hate speech or discriminatory content\n'
                    '• Sexually explicit or inappropriate material\n'
                    '• Violence or graphic content\n'
                    '• Spam, scams, or misleading information\n'
                    '• Copyright infringement\n'
                    '• Personal information sharing without consent',
                    Icons.block_rounded,
                    const Color(0xFFFF6B6B),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Consequences of Violations',
                    'Users who violate our terms will face immediate consequences:\n\n'
                    '• First offense: Warning and content removal\n'
                    '• Second offense: Temporary account suspension\n'
                    '• Severe violations: Permanent account ban\n'
                    '• Legal action may be taken for serious violations',
                    Icons.gavel_rounded,
                    const Color(0xFFE67E22),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Reporting Violations',
                    'If you encounter inappropriate content or abusive behavior:\n\n'
                    '• Use the report button on any content\n'
                    '• Provide detailed information about the violation\n'
                    '• Our moderation team reviews all reports within 24 hours\n'
                    '• Your report remains confidential',
                    Icons.flag_rounded,
                    const Color(0xFF3498DB),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Community Standards',
                    'We expect all users to:\n\n'
                    '• Treat others with respect and kindness\n'
                    '• Share constructive and helpful content\n'
                    '• Respect intellectual property rights\n'
                    '• Maintain a positive and supportive atmosphere\n'
                    '• Follow all applicable laws and regulations',
                    Icons.people_rounded,
                    const Color(0xFF50C878),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Account Responsibility',
                    'You are responsible for:\n\n'
                    '• All activity on your account\n'
                    '• Keeping your password secure\n'
                    '• Content you post or share\n'
                    '• Interactions with other users\n'
                    '• Compliance with these terms',
                    Icons.person_rounded,
                    const Color(0xFF9B59B6),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Contact & Support',
                    'For questions or concerns about these terms:\n\n'
                    '• Email: support@mireya.app\n'
                    '• Report violations through the app\n'
                    '• Contact our moderation team directly\n\n'
                    'We are committed to maintaining a safe community for all dancers.',
                    Icons.email_rounded,
                    const Color(0xFF4A90E2),
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
        'Terms of Service',
        style: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE74C3C).withValues(alpha: 0.2),
            const Color(0xFFE74C3C).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE74C3C).withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE74C3C).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.warning_rounded,
              color: Color(0xFFE74C3C),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zero Tolerance',
                  style: TextStyle(
                    color: Color(0xFFE74C3C),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'We do not tolerate abuse or inappropriate content',
                  style: TextStyle(
                    color: AppConstants.midGray,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, Color iconColor) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
