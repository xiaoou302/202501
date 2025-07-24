import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

class WhatsNewScreen extends StatelessWidget {
  const WhatsNewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What\'s New'),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Updates',
              style: AppTheme.headingStyle,
            ),
            SizedBox(height: 8),
            Text(
              'Check out our newest features and improvements.',
              style: TextStyle(
                color: AppTheme.textColor.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            _buildUpdateSection(
              version: '2.1.0',
              date: 'March 2024',
              features: [
                UpdateFeature(
                  title: 'Enhanced Journal Experience',
                  description: 'New color themes and improved writing experience.',
                  icon: FontAwesomeIcons.palette,
                  color: AppTheme.accentBlue,
                ),
                UpdateFeature(
                  title: 'Advanced Breathing Exercises',
                  description: 'Added new breathing patterns and animations.',
                  icon: FontAwesomeIcons.wind,
                  color: AppTheme.accentGreen,
                ),
                UpdateFeature(
                  title: 'Improved Sharing',
                  description: 'Better QR code generation and sharing options.',
                  icon: FontAwesomeIcons.share,
                  color: AppTheme.accentPurple,
                ),
              ],
            ),
            _buildUpdateSection(
              version: '2.0.0',
              date: 'February 2024',
              features: [
                UpdateFeature(
                  title: 'Complete UI Redesign',
                  description: 'Fresh new look with improved navigation.',
                  icon: FontAwesomeIcons.paintBrush,
                  color: AppTheme.accentPink,
                ),
                UpdateFeature(
                  title: 'Dark Mode Support',
                  description: 'Comfortable viewing in any lighting condition.',
                  icon: FontAwesomeIcons.moon,
                  color: AppTheme.accentYellow,
                ),
              ],
            ),
            _buildUpdateSection(
              version: '1.9.0',
              date: 'January 2024',
              features: [
                UpdateFeature(
                  title: 'Performance Improvements',
                  description: 'Faster app loading and smoother animations.',
                  icon: FontAwesomeIcons.bolt,
                  color: AppTheme.accentOrange,
                ),
                UpdateFeature(
                  title: 'Bug Fixes',
                  description: 'Various stability improvements and bug fixes.',
                  icon: FontAwesomeIcons.wrench,
                  color: AppTheme.accentBlue,
                ),
              ],
            ),
            SizedBox(height: 32),
            _buildComingSoonSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateSection({
    required String version,
    required String date,
    required List<UpdateFeature> features,
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  version,
                  style: TextStyle(
                    color: AppTheme.accentGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                date,
                style: TextStyle(
                  color: AppTheme.textColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...features.map((feature) => _buildFeatureItem(feature)).toList(),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(UpdateFeature feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(feature.icon, color: feature.color, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  feature.description,
                  style: TextStyle(
                    color: AppTheme.textColor.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonSection() {
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
                FontAwesomeIcons.rocket,
                color: AppTheme.accentPink,
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Coming Soon',
                style: AppTheme.subheadingStyle,
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildComingSoonItem(
            'Data Export',
            'Export your journal entries in various formats.',
            AppTheme.accentBlue,
          ),
          _buildComingSoonItem(
            'Custom Themes',
            'Create and save your own color themes.',
            AppTheme.accentPurple,
          ),
          _buildComingSoonItem(
            'Statistics Dashboard',
            'Visualize your journaling and breathing patterns.',
            AppTheme.accentGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonItem(String title, String description, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: AppTheme.textColor.withOpacity(0.8),
                    fontSize: 14,
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

class UpdateFeature {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  UpdateFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
} 