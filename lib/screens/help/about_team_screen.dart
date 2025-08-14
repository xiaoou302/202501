import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// About Team screen showing team members and information
class AboutTeamScreen extends StatelessWidget {
  const AboutTeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: const Text(
          'About Our Team',
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
              _buildTeamHeader(),
              const SizedBox(height: 24),
              _buildTeamStory(),
              const SizedBox(height: 24),
              _buildTeamMembers(),
              const SizedBox(height: 24),
              _buildJoinTeam(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build team header with logo
  Widget _buildTeamHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.brandBlue, AppTheme.accentOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'K',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'The Virelia Team',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Passionate about making travel planning easier',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Build team story section
  Widget _buildTeamStory() {
    return Card(
      color: AppTheme.surfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF03A9F4).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.history_edu,
                    color: Color(0xFF03A9F4),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Our Story',
                  style: TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Virelia was born from a shared frustration with travel planning. Our team of passionate travelers and technologists came together with a simple mission: to make travel preparation stress-free and enjoyable.',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'After forgetting essential items on our own trips one too many times, we decided to build a solution that combines AI technology with practical travel knowledge to create the ultimate packing assistant.',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Today, our diverse team works remotely across the globe, bringing perspectives from different cultures and travel experiences to make Virelia the best travel companion for adventurers everywhere.',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build team members section
  Widget _buildTeamMembers() {
    // List of team members
    final List<Map<String, dynamic>> teamMembers = [
      {
        'name': 'Alex Chen',
        'role': 'Founder & CEO',
        'bio':
            'Passionate traveler who\'s visited over 30 countries. Previously worked at leading tech companies before founding Virelia.',
        'color': const Color(0xFF4CAF50), // Green
        'initial': 'A',
      },
      {
        'name': 'Maya Rodriguez',
        'role': 'Lead Designer',
        'bio':
            'Award-winning UX/UI designer with a focus on creating intuitive and beautiful user experiences.',
        'color': const Color(0xFFE91E63), // Pink
        'initial': 'M',
      },
      {
        'name': 'Raj Patel',
        'role': 'Lead Developer',
        'bio':
            'Full-stack developer with expertise in mobile applications and AI integration.',
        'color': const Color(0xFF2196F3), // Blue
        'initial': 'R',
      },
      {
        'name': 'Sarah Kim',
        'role': 'AI Specialist',
        'bio':
            'PhD in Machine Learning with a focus on natural language processing and recommendation systems.',
        'color': const Color(0xFF9C27B0), // Purple
        'initial': 'S',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Meet the Team',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...teamMembers.map(
          (member) => _buildTeamMember(
            member['name'],
            member['role'],
            member['bio'],
            member['color'],
            member['initial'],
          ),
        ),
      ],
    );
  }

  /// Build a single team member card
  Widget _buildTeamMember(
    String name,
    String role,
    String bio,
    Color color,
    String initial,
  ) {
    return Card(
      color: AppTheme.surfaceBackground,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bio,
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

  /// Build join team section
  Widget _buildJoinTeam() {
    return Card(
      color: AppTheme.surfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Join Our Team',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We\'re always looking for passionate individuals to join our mission of making travel planning easier and more enjoyable.',
              style: TextStyle(color: AppTheme.primaryText, fontSize: 14),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
