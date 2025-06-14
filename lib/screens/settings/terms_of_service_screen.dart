import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                _buildHeader(context),
                const SizedBox(height: 24),

                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build header with back button
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        const Text(
          "Terms of Service",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Build content
  Widget _buildContent() {
    return Container(
      decoration: UIHelper.glassDecoration(
        radius: 20,
        opacity: 0.1,
        borderColor: AppColors.hologramPurple.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _buildLastUpdated(),
          const SizedBox(height: 24),
          _buildSection(
            title: "1. Acceptance of Terms",
            content:
                "By accessing or using the Luxanvoryx application ('the App'), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.\n\nThese Terms of Service apply to all visitors, users, and others who access or use the App. By accessing or using the App, you agree to be bound by these Terms of Service.",
          ),
          _buildSection(
            title: "2. Description of Services",
            content:
                "Luxanvoryx provides a multi-functional application that includes caffeine tracking, coupon management, and color generation tools. These services are provided 'as is' and are subject to change or termination at any time without notice.",
          ),
          _buildSection(
            title: "3. User Accounts",
            content:
                "When you create an account with us, you must provide information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account.\n\nYou are responsible for safeguarding the password that you use to access the App and for any activities or actions under your password.\n\nYou agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.",
          ),
          _buildSection(
            title: "4. Intellectual Property",
            content:
                "The App and its original content, features, and functionality are and will remain the exclusive property of Luxanvoryx and its licensors. The App is protected by copyright, trademark, and other laws of both the United States and foreign countries.\n\nOur trademarks and trade dress may not be used in connection with any product or service without the prior written consent of Luxanvoryx.",
          ),
          _buildSection(
            title: "5. User Content",
            content:
                "Our App may allow you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material. You are responsible for the content that you post to the App, including its legality, reliability, and appropriateness.\n\nBy posting content to the App, you grant us the right to use, modify, publicly perform, publicly display, reproduce, and distribute such content on and through the App. You retain any and all of your rights to any content you submit, post or display on or through the App and you are responsible for protecting those rights.",
          ),
          _buildSection(
            title: "6. Prohibited Uses",
            content:
                "You may use the App only for lawful purposes and in accordance with these Terms of Service. You agree not to use the App:\n\n• In any way that violates any applicable national or international law or regulation\n• To exploit, harm, or attempt to exploit or harm minors in any way\n• To transmit, or procure the sending of, any advertising or promotional material, including any 'junk mail', 'chain letter', 'spam', or any other similar solicitation\n• To impersonate or attempt to impersonate the Company, a Company employee, another user, or any other person or entity\n• In any way that infringes upon the rights of others, or in any way is illegal, threatening, fraudulent, or harmful",
          ),
          _buildSection(
            title: "7. Limitation of Liability",
            content:
                "In no event shall Luxanvoryx, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from:\n\n• Your access to or use of or inability to access or use the App\n• Any conduct or content of any third party on the App\n• Any content obtained from the App\n• Unauthorized access, use or alteration of your transmissions or content\n\nwhether based on warranty, contract, tort (including negligence) or any other legal theory, whether or not we have been informed of the possibility of such damage.",
          ),
          _buildSection(
            title: "8. Disclaimer",
            content:
                "Your use of the App is at your sole risk. The App is provided on an 'AS IS' and 'AS AVAILABLE' basis. The App is provided without warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, non-infringement or course of performance.\n\nLuxanvoryx, its subsidiaries, affiliates, and its licensors do not warrant that:\n\n• The App will function uninterrupted, secure or available at any particular time or location\n• Any errors or defects will be corrected\n• The App is free of viruses or other harmful components\n• The results of using the App will meet your requirements",
          ),
          _buildSection(
            title: "9. Governing Law",
            content:
                "These Terms shall be governed and construed in accordance with the laws of the United States, without regard to its conflict of law provisions.\n\nOur failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect.",
          ),
          _buildSection(
            title: "10. Changes to Terms",
            content:
                "We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will try to provide at least 30 days' notice prior to any new terms taking effect.\n\nBy continuing to access or use our App after those revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, please stop using the App.",
          ),
          _buildSection(
            title: "11. Contact Us",
            content:
                "If you have any questions about these Terms, please contact us at support@luxanvoryx.com.",
          ),
        ],
      ),
    );
  }

  // Build last updated text
  Widget _buildLastUpdated() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.deepSpace.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 18,
            color: AppColors.electricBlue,
          ),
          const SizedBox(width: 12),
          Text(
            "Last Updated: January 1, 2023",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  // Build section
  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.electricBlue,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
