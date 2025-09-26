import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';

/// Privacy & Security information screen
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        backgroundColor: AppTheme.deepSpace,
        title: const Text(
          'Privacy & Security',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.champagne),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction section
            Animations.fadeSlideIn(child: _buildIntroductionSection()),
            const SizedBox(height: 32),

            // Privacy information
            Animations.fadeSlideIn(
              delay: 100,
              child: _buildSectionHeader('Privacy Information'),
            ),
            const SizedBox(height: 16),

            Animations.fadeSlideIn(
              delay: 150,
              child: _buildInfoSection(
                'Data Collection',
                'We collect certain information to provide and improve our services. This includes information you provide to us, information we collect when you use our services, and information from third-party sources.',
                Icons.analytics_outlined,
                Colors.purple,
              ),
            ),

            Animations.fadeSlideIn(
              delay: 200,
              child: _buildInfoSection(
                'Location Services',
                'Our app may request access to your location to provide location-based services. You can always disable location services through your device settings if you prefer not to share this information.',
                Icons.location_on_outlined,
                Colors.blue,
              ),
            ),

            Animations.fadeSlideIn(
              delay: 250,
              child: _buildInfoSection(
                'Push Notifications',
                'We may send notifications to keep you updated about our services. You can manage notification preferences through your device settings at any time.',
                Icons.notifications_outlined,
                Colors.orange,
              ),
            ),

            const SizedBox(height: 32),

            // Security information
            Animations.fadeSlideIn(
              delay: 300,
              child: _buildSectionHeader('Security Information'),
            ),
            const SizedBox(height: 16),

            Animations.fadeSlideIn(
              delay: 350,
              child: _buildInfoSection(
                'Account Security',
                'We implement various security measures to protect your personal information. We recommend using strong, unique passwords and enabling additional security features when available.',
                Icons.security_outlined,
                Colors.green,
              ),
            ),

            Animations.fadeSlideIn(
              delay: 400,
              child: _buildInfoSection(
                'Authentication Methods',
                'Our app supports multiple authentication methods, including password-based login, biometric authentication, and two-factor authentication for enhanced security.',
                Icons.fingerprint,
                Colors.teal,
              ),
            ),

            Animations.fadeSlideIn(
              delay: 450,
              child: _buildInfoSection(
                'Data Encryption',
                'We use industry-standard encryption to protect your data during transmission and storage. This helps ensure that your sensitive information remains secure.',
                Icons.lock_outline,
                Colors.amber,
              ),
            ),

            const SizedBox(height: 32),

            // Data usage
            Animations.fadeSlideIn(
              delay: 500,
              child: _buildSectionHeader('Data Usage & Retention'),
            ),
            const SizedBox(height: 16),

            Animations.fadeSlideIn(
              delay: 550,
              child: _buildInfoSection(
                'How We Use Your Data',
                'We use collected information to provide, maintain, and improve our services, develop new features, and protect our users. We may also use data to communicate with you about updates, offers, and promotions.',
                Icons.data_usage_outlined,
                Colors.indigo,
              ),
            ),

            Animations.fadeSlideIn(
              delay: 600,
              child: _buildInfoSection(
                'Data Retention',
                'We retain your information for as long as necessary to provide our services and fulfill the purposes outlined in our Privacy Policy. If you wish to delete your account or request data deletion, please contact our support team.',
                Icons.access_time,
                Colors.deepOrange,
              ),
            ),

            const SizedBox(height: 32),

            // Privacy policy
            Animations.fadeSlideIn(
              delay: 650,
              child: _buildPrivacyPolicySection(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Build introduction section
  Widget _buildIntroductionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.silverstone,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.champagne.withOpacity(0.3),
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
                  color: AppTheme.champagne.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppTheme.champagne,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Privacy Matters',
                      style: TextStyle(
                        color: AppTheme.moonlight,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'We are committed to protecting your privacy and security',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'This page provides information about how we handle your data and the security measures we implement to protect your information. For more detailed information, please refer to our complete Privacy Policy.',
            style: TextStyle(color: AppTheme.moonlight, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Build information section
  Widget _buildInfoSection(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.silverstone,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.moonlight,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Build section header
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.moonlight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Build privacy policy section
  Widget _buildPrivacyPolicySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.silverstone,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.champagne.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy Policy',
            style: TextStyle(
              color: AppTheme.champagne,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our privacy policy explains how we collect, use, and protect your personal information when you use our services. The policy covers our data collection practices, how we use your information, your rights regarding your data, and how we secure your information.',
            style: TextStyle(color: AppTheme.moonlight, fontSize: 14),
          ),
          const SizedBox(height: 12),
          const Text(
            'For questions about our privacy practices or to request access to your personal information, please contact our privacy team at privacy@soliapp.com.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Last updated: Sep 1, 2025',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
