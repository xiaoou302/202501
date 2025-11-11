import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class DataProtectionScreen extends StatelessWidget {
  const DataProtectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppConstants.deepPlum : AppConstants.shellWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Data Protection'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppConstants.darkGray
                      : AppConstants.panelWhite,
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      size: 64,
                      color: const Color(0xFF2196F3),
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      'Your Data is Safe',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'We take your privacy seriously and protect your data with industry-standard security measures.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingL),

              _buildSection(
                context: context,
                isDark: isDark,
                icon: Icons.lock,
                iconColor: const Color(0xFF4CAF50),
                title: 'Data Encryption',
                content:
                    'All your personal data and pet information are encrypted using AES-256 encryption, ensuring that your information remains secure both in transit and at rest.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildSection(
                context: context,
                isDark: isDark,
                icon: Icons.phone_android,
                iconColor: const Color(0xFFFF9800),
                title: 'Local Storage',
                content:
                    'Your pet data is stored locally on your device. We do not upload your personal information to external servers without your explicit consent.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildSection(
                context: context,
                isDark: isDark,
                icon: Icons.visibility_off,
                iconColor: const Color(0xFF9C27B0),
                title: 'No Third-Party Sharing',
                content:
                    'We never sell, rent, or share your personal information with third parties for marketing purposes. Your data belongs to you.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildSection(
                context: context,
                isDark: isDark,
                icon: Icons.delete_outline,
                iconColor: const Color(0xFFE91E63),
                title: 'Data Control',
                content:
                    'You have full control over your data. You can export, delete, or modify your information at any time through the app settings.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildSection(
                context: context,
                isDark: isDark,
                icon: Icons.update,
                iconColor: const Color(0xFF00BCD4),
                title: 'Regular Updates',
                content:
                    'We continuously update our security protocols to protect against emerging threats and ensure your data remains safe.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildSection(
                context: context,
                isDark: isDark,
                icon: Icons.verified_user,
                iconColor: const Color(0xFFFF5722),
                title: 'GDPR Compliant',
                content:
                    'Our data protection practices comply with GDPR and other international privacy regulations, giving you peace of mind.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Icon(icon, color: iconColor, size: AppConstants.iconL),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppConstants.mediumGray,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
