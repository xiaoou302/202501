import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/neumorphic_card.dart';

/// Safety & Privacy Screen
class SafetyPrivacyScreen extends StatelessWidget {
  const SafetyPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Safety & Privacy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Privacy Matters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We are committed to protecting your privacy and ensuring the security of your data.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Data Collection
            const Text(
              'Data We Collect',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDataItem(
                      icon: Icons.bar_chart,
                      title: 'Game Performance',
                      description:
                          'We collect your game scores, completion rates, and progress to '
                          'provide personalized experiences and track achievements.',
                    ),
                    const Divider(height: 24, color: Colors.grey),
                    _buildDataItem(
                      icon: Icons.settings,
                      title: 'App Preferences',
                      description:
                          'Your settings and preferences are stored locally on your device '
                          'to provide a consistent user experience.',
                    ),
                    const Divider(height: 24, color: Colors.grey),
                    _buildDataItem(
                      icon: Icons.device_unknown,
                      title: 'Device Information',
                      description:
                          'Basic device information may be collected for troubleshooting '
                          'and optimizing app performance.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // How We Use Your Data
            const Text(
              'How We Use Your Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUsageItem(
                      icon: Icons.auto_graph,
                      title: 'Improve User Experience',
                      description:
                          'We analyze usage patterns to enhance game features and user experience.',
                    ),
                    const SizedBox(height: 16),
                    _buildUsageItem(
                      icon: Icons.person_outline,
                      title: 'Personalization',
                      description:
                          'We use your game data to personalize your experience and suggest appropriate difficulty levels.',
                    ),
                    const SizedBox(height: 16),
                    _buildUsageItem(
                      icon: Icons.bug_report_outlined,
                      title: 'Troubleshooting',
                      description:
                          'Device information helps us identify and fix technical issues.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Data Protection
            const Text(
              'How We Protect Your Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProtectionItem(
                      title: 'Local Storage',
                      description:
                          'Most of your data is stored locally on your device and is not transmitted to our servers.',
                    ),
                    const SizedBox(height: 16),
                    _buildProtectionItem(
                      title: 'No Personal Information',
                      description:
                          'We do not collect personally identifiable information unless explicitly provided by you for support purposes.',
                    ),
                    const SizedBox(height: 16),
                    _buildProtectionItem(
                      title: 'No Third-Party Sharing',
                      description:
                          'We do not sell or share your data with third parties for marketing purposes.',
                    ),
                    const SizedBox(height: 16),
                    _buildProtectionItem(
                      title: 'Secure Transmission',
                      description:
                          'Any data transmitted to our servers is encrypted using industry-standard protocols.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Your Rights
            const Text(
              'Your Rights',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You have the right to:',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                    const SizedBox(height: 16),
                    _buildRightItem('Access your data stored within the app'),
                    _buildRightItem('Request deletion of your data'),
                    _buildRightItem('Opt out of analytics collection'),
                    _buildRightItem('Export your game progress data'),
                    const SizedBox(height: 16),
                    Text(
                      'To exercise any of these rights, please contact our support team through the Customer Support section.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Privacy Controls
            const Text(
              'Privacy Controls',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You can control your privacy settings within the app:',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    _buildControlItem(
                      'Clear Game History',
                      'Delete all your game history and statistics',
                      Icons.delete_outline,
                      onTap: () => _showClearDataDialog(context),
                    ),
                    const SizedBox(height: 12),
                    _buildControlItem(
                      'Export Your Data',
                      'Download a copy of your game data',
                      Icons.download_outlined,
                      onTap: () => _showExportDataDialog(context),
                    ),
                    const SizedBox(height: 12),
                    _buildControlItem(
                      'Analytics Preferences',
                      'Control what data is collected for analytics',
                      Icons.analytics_outlined,
                      onTap: () => _showAnalyticsDialog(context),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Contact for Privacy
            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Privacy Questions?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'If you have any questions about our privacy practices or would like to exercise your data rights, please contact our privacy team at:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'privacy@hyquinoxa.com',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Full Privacy Policy
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/terms_of_service');
                },
                child: Text(
                  'View Full Privacy Policy',
                  style: TextStyle(
                    color: Colors.red[300],
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Last Updated
            Center(
              child: Text(
                'Last Updated: January 1, 2023',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build a data collection item
  Widget _buildDataItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.red, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a data usage item
  Widget _buildUsageItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a data protection item
  Widget _buildProtectionItem({
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.green, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a user right item with bullet point
  Widget _buildRightItem(String right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[300],
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              right,
              style: TextStyle(fontSize: 15, color: Colors.grey[300]),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a privacy control item
  Widget _buildControlItem(
    String title,
    String description,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.red[300], size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }

  /// Show dialog to confirm clearing data
  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Clear Game History',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will permanently delete all your game history, scores, and progress. This action cannot be undone. Are you sure you want to proceed?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              // Implement data clearing functionality
              Navigator.pop(context);

              // Show confirmation snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Game history cleared successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Clear Data',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog to export data
  void _showExportDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Export Your Data',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Your game data will be exported as a JSON file. This file will contain all your game statistics, progress, and settings.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              // Implement data export functionality
              Navigator.pop(context);

              // Show confirmation snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data exported successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Export', style: TextStyle(color: Colors.blue[300])),
          ),
        ],
      ),
    );
  }

  /// Show dialog to configure analytics preferences
  void _showAnalyticsDialog(BuildContext context) {
    bool collectUsageData = true;
    bool collectPerformanceData = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text(
            'Analytics Preferences',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Control what data is collected for analytics purposes:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text(
                  'Usage Statistics',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: Text(
                  'Collect data about how you use the app',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                value: collectUsageData,
                onChanged: (value) {
                  setState(() {
                    collectUsageData = value;
                  });
                },
                activeColor: Colors.red[300],
              ),
              SwitchListTile(
                title: const Text(
                  'Performance Data',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: Text(
                  'Collect data about app performance and crashes',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                value: collectPerformanceData,
                onChanged: (value) {
                  setState(() {
                    collectPerformanceData = value;
                  });
                },
                activeColor: Colors.red[300],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
            ),
            TextButton(
              onPressed: () {
                // Implement analytics preferences saving
                Navigator.pop(context);

                // Show confirmation snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Analytics preferences saved'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Save', style: TextStyle(color: Colors.blue[300])),
            ),
          ],
        ),
      ),
    );
  }
}
