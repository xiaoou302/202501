import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          "Privacy Policy",
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
            title: "Introduction",
            content:
                "At Luxanvoryx, we respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.\n\nPlease read this Privacy Policy carefully. If you do not agree with the terms of this Privacy Policy, please do not access the application.",
          ),
          _buildSection(
            title: "Information We Collect",
            content:
                "We collect several types of information for various purposes to provide and improve our service to you:\n\n1. Personal Data: While using our application, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. This may include, but is not limited to:\n• Email address\n• First name and last name\n• Usage data\n\n2. Usage Data: We may also collect information that your device sends whenever you access our application, such as:\n• The type of device you use\n• Your device's unique ID\n• Your device's operating system\n• The time and date of your use\n• Other diagnostic data",
          ),
          _buildSection(
            title: "How We Use Your Information",
            content:
                "We use the collected data for various purposes:\n\n• To provide and maintain our service\n• To notify you about changes to our service\n• To allow you to participate in interactive features of our application\n• To provide customer support\n• To gather analysis or valuable information so that we can improve our service\n• To monitor the usage of our service\n• To detect, prevent and address technical issues",
          ),
          _buildSection(
            title: "Data Storage",
            content:
                "Your personal data is primarily stored locally on your device. The Caffeine Tracker, Coupon Manager, and Color Generator features store data on your device to provide you with a personalized experience.\n\nWe do not transfer your personal data to external servers unless explicitly stated and with your consent.",
          ),
          _buildSection(
            title: "Data Security",
            content:
                "The security of your data is important to us, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your personal data, we cannot guarantee its absolute security.",
          ),
          _buildSection(
            title: "Third-Party Services",
            content:
                "Our application may contain links to other sites that are not operated by us. If you click on a third-party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site you visit.\n\nWe have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.",
          ),
          _buildSection(
            title: "Children's Privacy",
            content:
                "Our application does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you are aware that your child has provided us with personal data, please contact us so that we can take necessary actions.",
          ),
          _buildSection(
            title: "Changes to This Privacy Policy",
            content:
                "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the 'Last Updated' date.\n\nYou are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.",
          ),
          _buildSection(
            title: "Your Data Rights",
            content:
                "Depending on your location, you may have certain rights regarding your personal data, including:\n\n• The right to access the personal data we hold about you\n• The right to request correction of your personal data\n• The right to request deletion of your personal data\n• The right to restrict processing of your personal data\n• The right to data portability\n\nTo exercise any of these rights, please contact us using the information provided below.",
          ),
          _buildSection(
            title: "Contact Us",
            content:
                "If you have any questions about this Privacy Policy, please contact us:\n\n• By email: privacy@luxanvoryx.com\n• By visiting this page on our website: www.luxanvoryx.com/privacy\n• By mail: 123 App Street, Tech City, CA 94043, United States",
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
