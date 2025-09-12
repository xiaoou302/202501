import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Privacy policy screen
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgDeepSpaceGray,
              AppColors.bgDeepSpaceGray.withBlue(70),
            ],
            stops: const [0.2, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Introduction
                      _buildSection(
                        'Privacy Policy',
                        'Last updated: September 2025',
                        icon: Icons.privacy_tip_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Information We Collect',
                        'Blokko is designed to respect your privacy. We collect minimal data necessary for the game to function properly:\n\n'
                            '• Game progress and statistics\n'
                            '• Device information for optimization\n'
                            '• Optional feedback you provide',
                        icon: Icons.folder_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'How We Use Your Information',
                        'We use the collected information to:\n\n'
                            '• Save your game progress\n'
                            '• Improve game performance\n'
                            '• Fix bugs and address issues\n'
                            '• Enhance user experience',
                        icon: Icons.settings_applications_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Data Storage',
                        'All game data is stored locally on your device. We do not upload your personal data or game statistics to any external servers.',
                        icon: Icons.storage_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Third-Party Services',
                        'Blokko does not integrate with any third-party services that would collect your data.',
                        icon: Icons.handshake_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Your Rights',
                        'You have the right to:\n\n'
                            '• Access your data (stored locally on your device)\n'
                            '• Delete your data by uninstalling the app or using the reset option in settings\n'
                            '• Play without providing any personal information',
                        icon: Icons.gavel_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Changes to This Policy',
                        'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                        icon: Icons.update_outlined,
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        'Contact Us',
                        'If you have any questions about this Privacy Policy, please contact us through the Feedback option in the app settings.',
                        icon: Icons.contact_mail_outlined,
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textMoonWhite,
                  size: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: AppColors.accentMintGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Privacy & Security',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Placeholder for layout balance
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with icon
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentMintGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.accentMintGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.accentMintGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Content
          Text(
            content,
            style: TextStyle(
              color: AppColors.textMoonWhite.withOpacity(0.9),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
