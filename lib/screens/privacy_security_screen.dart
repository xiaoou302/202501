import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy & Security'),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Privacy Matters',
              style: AppTheme.headingStyle,
            ),
            SizedBox(height: 8),
            Text(
              'We take your privacy and data security seriously.',
              style: TextStyle(
                color: AppTheme.textColor.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            _buildSection(
              title: 'Data Storage',
              icon: FontAwesomeIcons.database,
              color: AppTheme.accentBlue,
              content: [
                'All your journal entries are stored locally on your device',
                'We don\'t upload or store your data on any servers',
                'Your data remains private and under your control',
                'Regular backups are recommended',
              ],
            ),
            _buildSection(
              title: 'Sharing Controls',
              icon: FontAwesomeIcons.share,
              color: AppTheme.accentGreen,
              content: [
                'Share entries only when you choose to',
                'QR codes are generated locally',
                'Control what information to include in shared content',
                'Shared content is temporary and not stored online',
              ],
            ),
            _buildSection(
              title: 'App Permissions',
              icon: FontAwesomeIcons.lock,
              color: AppTheme.accentPurple,
              content: [
                'Camera: For QR code scanning',
                'Storage: For saving QR codes',
                'No location tracking',
                'No contact access',
              ],
            ),
            _buildSection(
              title: 'Your Rights',
              icon: FontAwesomeIcons.userShield,
              color: AppTheme.accentPink,
              content: [
                'Access your data anytime',
                'Export your data (coming soon)',
                'Delete your data permanently',
                'Control app permissions',
              ],
            ),
            SizedBox(height: 32),
            _buildActionCard(
              context,
              title: 'Clear All Data',
              subtitle: 'Permanently delete all journal entries and settings',
              icon: FontAwesomeIcons.trash,
              color: AppTheme.accentRed,
              onTap: () => _showClearDataDialog(context),
            ),
            SizedBox(height: 16),
         
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> content,
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
          ...content.map((item) => _buildContentItem(item, color)).toList(),
        ],
      ),
    );
  }

  Widget _buildContentItem(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppTheme.textColor.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.borderRadius,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppTheme.darkGradient,
          borderRadius: AppTheme.borderRadius,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: color.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showClearDataDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
        title: Text(
          'Clear All Data',
          style: TextStyle(color: AppTheme.textColor),
        ),
        content: Text(
          'This action cannot be undone. All your journal entries and settings will be permanently deleted.',
          style: TextStyle(color: AppTheme.textColor.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textColor),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement clear data functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All data cleared'),
                  backgroundColor: AppTheme.accentRed,
                ),
              );
            },
            child: Text(
              'Clear Data',
              style: TextStyle(color: AppTheme.accentRed),
            ),
          ),
        ],
      ),
    );
  }
} 