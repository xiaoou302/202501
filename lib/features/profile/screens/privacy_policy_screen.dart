import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../shared/widgets/app_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildLastUpdated(),
        const SizedBox(height: 24),
        _buildPolicySection(
          title: '1. Information Collection',
          content: 'We may collect the following types of information:\n\n'
              '1.1 Personal Information: Including your name, email address, phone number, date of birth, and other information you provide during registration and use.\n\n'
              '1.2 Usage Data: Including how you use our application, access times, viewed pages, application crash information, etc.\n\n'
              '1.3 Device Information: Including device type, operating system, unique device identifiers, IP address, etc.\n\n'
              '1.4 Location Information: With your authorization, we may collect your precise or approximate location information.',
        ),
        const SizedBox(height: 20),
        _buildPolicySection(
          title: '2. Information Usage',
          content: 'We use the collected information to:\n\n'
              '2.1 Provide, maintain, and improve our services.\n\n'
              '2.2 Process and complete your transactions.\n\n'
              '2.3 Send you technical notices, updates, security alerts, and support messages.\n\n'
              '2.4 Respond to your comments, questions, and requests.\n\n'
              '2.5 Develop new products and services.\n\n'
              '2.6 Monitor and analyze trends, usage, and activities.',
        ),
        const SizedBox(height: 20),
        _buildPolicySection(
          title: '3. Information Sharing',
          content:
              'We may share your information in the following situations:\n\n'
              '3.1 With your consent or at your direction.\n\n'
              '3.2 With third-party service providers who provide services.\n\n'
              '3.3 To comply with applicable laws, regulations, or legal processes.\n\n'
              '3.4 To protect our or others\' rights, property, or safety.\n\n'
              '3.5 With our subsidiaries and affiliates.\n\n'
              '3.6 In connection with a merger, sale, or asset transfer.',
        ),
        const SizedBox(height: 20),
        _buildPolicySection(
          title: '4. Data Security',
          content:
              'We take reasonable measures to protect your personal information from loss, theft, misuse, unauthorized access, disclosure, alteration, and destruction. However, no internet transmission or electronic storage method is 100% secure.',
        ),
        const SizedBox(height: 20),
        _buildPolicySection(
          title: '5. Data Retention',
          content:
              'We will retain your personal information for as long as necessary to fulfill the purposes described in this Privacy Policy, unless a longer retention period is required or permitted by law.',
        ),
        const SizedBox(height: 20),
        _buildPolicySection(
          title: '6. Your Rights',
          content: 'Under applicable law, you may have the right to:\n\n'
              '6.1 Access your personal information.\n\n'
              '6.2 Correct inaccurate personal information.\n\n'
              '6.3 Delete your personal information.\n\n'
              '6.4 Restrict or object to the processing of your personal information.\n\n'
              '6.5 Data portability.\n\n'
              '6.6 Withdraw consent.',
        ),
        const SizedBox(height: 20),
        _buildPolicySection(
          title: '7. Children\'s Privacy',
          content:
              'Our services are not directed to children under 13. If we learn we have collected personal information from a child under 13, we will take steps to delete that information.',
        ),
        const SizedBox(height: 20),
        _buildPolicySection(
          title: '8. Third-Party Links',
          content:
              'Our application may contain links to third-party websites or services that are not controlled by us. We are not responsible for the privacy practices of these third parties.',
        ),
        const SizedBox(height: 20),
        _buildPolicySection(
          title: '9. Privacy Policy Updates',
          content:
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the application.',
        ),
        const SizedBox(height: 20),
        _buildContactSection(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppTheme.accentPurple, AppTheme.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentPurple.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.security,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Protecting your privacy is our top priority',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.update,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Updated',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'October 15, 2023',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'This Privacy Policy describes how we collect, use, and share your personal information. We value your privacy and are committed to protecting your personal information. Please take the time to read carefully to understand our practices.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection({
    required String title,
    required String content,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.contact_support,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'If you have any questions or concerns about our Privacy Policy, please contact our privacy team:',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.email,
            title: 'Email',
            content: 'privacy@halyvernoxian.com',
          ),
          _buildContactItem(
            icon: Icons.location_on,
            title: 'Mailing Address',
            content:
                '88 Science Avenue, Zhangjiang Hi-Tech Park, Pudong, Shanghai, China',
          ),
          _buildContactItem(
            icon: Icons.phone,
            title: 'Phone',
            content: '400-123-4567',
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
