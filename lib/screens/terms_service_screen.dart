import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

class TermsServiceScreen extends StatelessWidget {
  const TermsServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service'),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: AppTheme.headingStyle,
            ),
            SizedBox(height: 8),
            Text(
              'Last updated: March 2024',
              style: TextStyle(
                color: AppTheme.textColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            _buildSection(
              title: 'Acceptance of Terms',
              icon: FontAwesomeIcons.fileContract,
              color: AppTheme.accentBlue,
              content: 'By accessing or using Azenquoria, you agree to be bound by these Terms of Service. '
                  'If you disagree with any part of the terms, you may not access the application.',
            ),
            _buildSection(
              title: 'User Responsibilities',
              icon: FontAwesomeIcons.userShield,
              color: AppTheme.accentGreen,
              content: 'You are responsible for maintaining the confidentiality of your data and for all activities '
                  'that occur within the application. You agree not to use the service for any unlawful purposes.',
            ),
            _buildSection(
              title: 'Privacy Policy',
              icon: FontAwesomeIcons.lock,
              color: AppTheme.accentPurple,
              content: 'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect '
                  'your personal information. By using Azenquoria, you agree to our Privacy Policy.',
            ),
            _buildSection(
              title: 'Content Guidelines',
              icon: FontAwesomeIcons.fileAlt,
              color: AppTheme.accentPink,
              content: 'You agree not to create or share content that:\n\n'
                  '• Is illegal or promotes illegal activities\n'
                  '• Infringes on others\' intellectual property rights\n'
                  '• Contains malicious code or harmful content\n'
                  '• Violates others\' privacy or rights',
            ),
            _buildSection(
              title: 'Service Modifications',
              icon: FontAwesomeIcons.tools,
              color: AppTheme.accentYellow,
              content: 'We reserve the right to modify or discontinue the service at any time. We will notify users '
                  'of any material changes to these terms or the service.',
            ),
            _buildSection(
              title: 'Limitation of Liability',
              icon: FontAwesomeIcons.shieldAlt,
              color: AppTheme.accentOrange,
              content: 'Azenquoria is provided "as is" without warranties of any kind. We are not liable for any '
                  'damages arising from your use of the service.',
            ),
            SizedBox(height: 32),
            _buildContactSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.darkGradient,
        borderRadius: AppTheme.borderRadius,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: AppTheme.subheadingStyle,
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              color: AppTheme.textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.darkGradient,
        borderRadius: AppTheme.borderRadius,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.envelope,
                color: AppTheme.accentBlue,
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Contact Us',
                style: AppTheme.subheadingStyle,
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'If you have any questions about these Terms of Service, please contact us:',
            style: TextStyle(
              color: AppTheme.textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Email address copied to clipboard'),
                  backgroundColor: AppTheme.accentBlue,
                ),
              );
            },
            borderRadius: AppTheme.borderRadius,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withOpacity(0.1),
                borderRadius: AppTheme.borderRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.envelope,
                    color: AppTheme.accentBlue,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'support@azenquoria.com',
                    style: TextStyle(
                      color: AppTheme.accentBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 