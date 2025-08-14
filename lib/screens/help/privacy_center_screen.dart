import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Privacy Center screen showing privacy policy and data practices
class PrivacyCenterScreen extends StatelessWidget {
  const PrivacyCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: const Text(
          'Privacy Center',
          style: TextStyle(color: AppTheme.primaryText),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPrivacyHeader(),
              const SizedBox(height: 24),
              _buildPrivacySection(
                'Data Collection',
                'We collect minimal data to provide you with the best experience. All your travel plans and personal information are stored locally on your device.',
                Icons.storage_outlined,
                const Color(0xFF3F51B5),
              ),
              const SizedBox(height: 16),
              _buildPrivacySection(
                'AI Processing',
                'When you use our AI features, your queries are processed securely. We don\'t store your conversations or use them for training our models.',
                Icons.psychology_outlined,
                const Color(0xFF9C27B0),
              ),
              const SizedBox(height: 16),
              _buildPrivacySection(
                'Third-Party Services',
                'We may use third-party services for weather data and other information. These services receive only the minimum necessary data to provide their functionality.',
                Icons.public_outlined,
                const Color(0xFF009688),
              ),
              const SizedBox(height: 16),
              _buildPrivacySection(
                'Your Rights',
                'You have full control over your data. You can delete all your data at any time from the settings menu.',
                Icons.gavel_outlined,
                const Color(0xFF795548),
              ),
              const SizedBox(height: 24),
              _buildFullPrivacyPolicy(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build privacy header with icon
  Widget _buildPrivacyHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF3F51B5).withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Color(0xFF3F51B5),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Privacy Matters',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'We\'re committed to protecting your privacy and being transparent about our data practices.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a privacy section with icon
  Widget _buildPrivacySection(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: AppTheme.surfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 14,
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

  /// Build full privacy policy button
  Widget _buildFullPrivacyPolicy(BuildContext context) {
    return Card(
      color: AppTheme.surfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showFullPrivacyPolicy(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Read Full Privacy Policy',
                  style: TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.brandBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: AppTheme.brandBlue,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show full privacy policy in a dialog
  void _showFullPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBackground,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Last Updated: June 1, 2024',
                style: TextStyle(color: AppTheme.secondaryText, fontSize: 12),
              ),
              SizedBox(height: 16),
              Text(
                'This Privacy Policy describes how Virelia ("we", "our", or "us") collects, uses, and discloses your information when you use our mobile application (the "App").',
                style: TextStyle(color: AppTheme.primaryText),
              ),
              SizedBox(height: 16),
              Text(
                '1. INFORMATION WE COLLECT',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We collect information that you provide directly to us, such as when you create an account, create travel plans, or contact us for support. This may include your name, email address, and travel preferences.',
                style: TextStyle(color: AppTheme.primaryText),
              ),
              SizedBox(height: 16),
              Text(
                '2. HOW WE USE YOUR INFORMATION',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We use the information we collect to provide, maintain, and improve our services, to develop new features, and to protect our users.',
                style: TextStyle(color: AppTheme.primaryText),
              ),
              SizedBox(height: 16),
              Text(
                '3. DATA STORAGE',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your travel plans and personal information are stored locally on your device. We do not collect or store this information on our servers.',
                style: TextStyle(color: AppTheme.primaryText),
              ),
              SizedBox(height: 16),
              Text(
                '4. CHANGES TO THIS POLICY',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                style: TextStyle(color: AppTheme.primaryText),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
