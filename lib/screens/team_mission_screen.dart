import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

class TeamMissionScreen extends StatelessWidget {
  const TeamMissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team & Mission'),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Our Mission',
              content: 'To help people find inner peace and balance through mindful journaling and breathing exercises.',
              icon: FontAwesomeIcons.heart,
              color: AppTheme.accentPink,
            ),
            SizedBox(height: 24),
            _buildSection(
              title: 'Our Vision',
              content: 'Creating a world where everyone can easily access tools for mental wellness and self-reflection.',
              icon: FontAwesomeIcons.eye,
              color: AppTheme.accentBlue,
            ),
            SizedBox(height: 24),
            Text(
              'Core Team',
              style: AppTheme.headingStyle,
            ),
            SizedBox(height: 16),
            _buildTeamMember(
              name: 'Sarah Chen',
              role: 'Founder & Design Lead',
              description: 'Passionate about creating intuitive and beautiful user experiences.',
              icon: FontAwesomeIcons.paintBrush,
              color: AppTheme.accentPurple,
            ),
            _buildTeamMember(
              name: 'Michael Zhang',
              role: 'Technical Lead',
              description: 'Expert in creating smooth and reliable mobile applications.',
              icon: FontAwesomeIcons.laptop,
              color: AppTheme.accentGreen,
            ),
            _buildTeamMember(
              name: 'Emma Wilson',
              role: 'Wellness Advisor',
              description: 'Certified mindfulness coach and mental health advocate.',
              icon: FontAwesomeIcons.brain,
              color: AppTheme.accentOrange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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

  Widget _buildTeamMember({
    required String name,
    required String role,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppTheme.darkGradient,
          borderRadius: AppTheme.borderRadius,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 14,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textColor.withOpacity(0.7),
                      height: 1.4,
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
} 