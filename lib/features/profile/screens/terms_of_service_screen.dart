import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../shared/widgets/app_card.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
        _buildTermsSection(
          title: '1. Acceptance of Terms',
          content:
              'Welcome to the Halyvernoxian application (hereinafter referred to as "App"). By downloading, installing, accessing, or using this App, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not download, install, access, or use this App.',
        ),
        const SizedBox(height: 20),
        _buildTermsSection(
          title: '2. Service Description',
          content:
              'Halyvernoxian is a multi-functional app designed for couples, providing features such as love records, travel planning, image generation, and more. We reserve the right to modify, suspend, or terminate part or all of the services at any time without prior notice.',
        ),
        const SizedBox(height: 20),
        _buildTermsSection(
          title: '3. User Accounts',
          content:
              '3.1 You need to create an account to use certain features of this App.\n\n'
              '3.2 You are responsible for maintaining the security of your account, including protecting passwords and limiting access to your device.\n\n'
              '3.3 You agree to provide accurate and complete registration information and to update it promptly when it changes.',
        ),
        const SizedBox(height: 20),
        _buildTermsSection(
          title: '4. User Content',
          content:
              '4.1 You retain all rights to the content you create, upload, or share in the App ("User Content").\n\n'
              '4.2 By submitting User Content, you grant us a worldwide, non-exclusive, royalty-free license to use, copy, modify, and distribute your User Content to provide and improve our services.\n\n'
              '4.3 You promise not to upload illegal, infringing, or inappropriate content.',
        ),
        const SizedBox(height: 20),
        _buildTermsSection(
          title: '5. Privacy Policy',
          content:
              'We value your privacy. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.',
        ),
        const SizedBox(height: 20),
        _buildTermsSection(
          title: '6. Intellectual Property',
          content:
              '6.1 This App and its content (including but not limited to text, graphics, logos, icons, images, audio clips, downloads, data, and software) are protected by copyright, trademark, and other intellectual property laws.\n\n'
              '6.2 You may not copy, modify, distribute, sell, or rent any part of the App without our express written permission.',
        ),
        const SizedBox(height: 20),
        _buildTermsSection(
          title: '7. Disclaimer',
          content:
              '7.1 This App is provided on an "as is" and "as available" basis, without warranties of any kind.\n\n'
              '7.2 We do not guarantee that the App will be error-free or uninterrupted, nor do we guarantee that any defects will be corrected.\n\n'
              '7.3 Your use of this App is at your own risk.',
        ),
        const SizedBox(height: 20),
        _buildTermsSection(
          title: '8. Limitation of Liability',
          content:
              'To the maximum extent permitted by law, we are not liable for any direct, indirect, incidental, special, punitive, or consequential damages resulting from the use or inability to use this App.',
        ),
        const SizedBox(height: 20),
        _buildTermsSection(
          title: '9. Modification of Terms',
          content:
              'We may modify these terms from time to time. Modified terms will be posted in the App and will be effective immediately upon posting. Continued use of this App will be deemed acceptance of the modified terms.',
        ),
        const SizedBox(height: 20),
        _buildTermsSection(
          title: '10. Governing Law',
          content:
              'These terms are governed by the laws of the People\'s Republic of China, and any disputes shall be submitted to the courts with jurisdiction.',
        ),
        const SizedBox(height: 20),
        _buildContactInfo(),
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
              Icons.gavel,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Terms of Service',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please read the following terms carefully',
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
            'These Terms of Service constitute a legally binding agreement between you and Halyvernoxian. Using our App indicates your acceptance of these terms. Please read them carefully before using the App.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection({
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

  Widget _buildContactInfo() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.contact_support,
                  color: Colors.green,
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
            'If you have any questions or suggestions about these Terms of Service, please contact us:',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.email,
            text: 'legal@halyvernoxian.com',
          ),
          _buildContactItem(
            icon: Icons.phone,
            text: '400-123-4567',
          ),
          _buildContactItem(
            icon: Icons.location_on,
            text:
                '88 Science Avenue, Zhangjiang Hi-Tech Park, Pudong, Shanghai, China',
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
