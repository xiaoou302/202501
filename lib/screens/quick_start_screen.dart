import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

class QuickStartScreen extends StatelessWidget {
  const QuickStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Start Guide'),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Azenquoria',
              style: AppTheme.headingStyle,
            ),
            SizedBox(height: 8),
            Text(
              'Let\'s get you started with the basics.',
              style: TextStyle(
                color: AppTheme.textColor.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            _buildFeatureSection(
              title: 'Journal',
              description: 'Record your thoughts and feelings with our intuitive journaling feature.',
              steps: [
                'Tap the Journal tab',
                'Press the + button to create a new entry',
                'Choose a color theme for your mood',
                'Write your thoughts',
                'Save or share your entry',
              ],
              icon: FontAwesomeIcons.book,
              color: AppTheme.accentBlue,
            ),
            _buildFeatureSection(
              title: 'Breathing Exercises',
              description: 'Practice mindful breathing with guided exercises.',
              steps: [
                'Go to the Breathe tab',
                'Choose a breathing mode',
                'Follow the on-screen instructions',
                'Complete the session',
                'View your practice statistics',
              ],
              icon: FontAwesomeIcons.wind,
              color: AppTheme.accentGreen,
            ),
            _buildFeatureSection(
              title: 'Share',
              description: 'Share your journal entries with others through QR codes.',
              steps: [
                'Select a journal entry',
                'Tap the Share button',
                'Generate a QR code',
                'Let others scan your code',
                'Download or share the QR code',
              ],
              icon: FontAwesomeIcons.share,
              color: AppTheme.accentPurple,
            ),
            SizedBox(height: 32),
            Container(
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
                        FontAwesomeIcons.lightbulb,
                        color: AppTheme.accentYellow,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Pro Tips',
                        style: AppTheme.subheadingStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildProTip(
                    'Regular journaling helps build a mindfulness habit.',
                    AppTheme.accentPink,
                  ),
                  _buildProTip(
                    'Try different breathing exercises for different needs.',
                    AppTheme.accentBlue,
                  ),
                  _buildProTip(
                    'Share your journey to inspire others.',
                    AppTheme.accentGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection({
    required String title,
    required String description,
    required List<String> steps,
    required IconData icon,
    required Color color,
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
          SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: AppTheme.textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: AppTheme.textColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProTip(String tip, Color color) {
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
              tip,
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
} 