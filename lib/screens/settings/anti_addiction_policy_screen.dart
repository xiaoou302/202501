import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/neumorphic_card.dart';

/// Anti-addiction Policy Screen
class AntiAddictionPolicyScreen extends StatelessWidget {
  const AntiAddictionPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Anti-addiction Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer, color: Colors.orange, size: 48),
              ),
            ),
            const SizedBox(height: 24),

            // Introduction
            const Text(
              'Healthy Gaming Habits',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'At Hyquinoxa, we believe in promoting healthy gaming habits. '
              'While our brain training games are designed to be beneficial, '
              'we encourage responsible usage and balance in your daily activities.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[300],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Our Policy
            const Text(
              'Our Anti-addiction Policy',
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
                    _buildPolicyItem(
                      icon: Icons.timer_outlined,
                      title: 'Play Time Reminders',
                      description:
                          'The app will display friendly reminders after extended play sessions '
                          'to encourage taking breaks.',
                    ),
                    const Divider(height: 24, color: Colors.grey),
                    _buildPolicyItem(
                      icon: Icons.nightlight_outlined,
                      title: 'Night Mode Recommendations',
                      description:
                          'During late hours, the app will suggest enabling dark mode '
                          'to reduce eye strain and improve sleep quality.',
                    ),
                    const Divider(height: 24, color: Colors.grey),
                    _buildPolicyItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'Daily Time Limits',
                      description:
                          'You can set optional daily time limits for gameplay in the settings.',
                    ),
                    const Divider(height: 24, color: Colors.grey),
                    _buildPolicyItem(
                      icon: Icons.insights_outlined,
                      title: 'Usage Statistics',
                      description:
                          'View your gameplay patterns to help maintain a healthy balance.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Recommendations
            const Text(
              'Healthy Gaming Recommendations',
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
                    _buildRecommendationItem(
                      number: '1',
                      title: 'Take regular breaks',
                      description:
                          'Follow the 20-20-20 rule: Every 20 minutes, look at something '
                          '20 feet away for 20 seconds.',
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendationItem(
                      number: '2',
                      title: 'Maintain physical activity',
                      description:
                          'Balance screen time with physical activities to maintain overall health.',
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendationItem(
                      number: '3',
                      title: 'Set time boundaries',
                      description:
                          'Establish specific times for gaming and stick to your schedule.',
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendationItem(
                      number: '4',
                      title: 'Prioritize sleep',
                      description:
                          'Avoid playing games right before bedtime to ensure quality sleep.',
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendationItem(
                      number: '5',
                      title: 'Stay hydrated',
                      description:
                          'Remember to drink water regularly during extended gaming sessions.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // For Parents
            const Text(
              'For Parents',
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
                      'Hyquinoxa is designed to be a beneficial brain training tool, but we '
                      'encourage parents to monitor their children\'s usage. Consider the following:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildParentTip(
                      'Set clear time limits for daily app usage',
                    ),
                    _buildParentTip(
                      'Encourage a balance between screen time and other activities',
                    ),
                    _buildParentTip(
                      'Use the app together to make it a shared learning experience',
                    ),
                    _buildParentTip(
                      'Discuss the benefits of brain training and the importance of moderation',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Commitment
            NeumorphicCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Our Commitment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We are committed to promoting healthy gaming habits and continuously '
                      'improving our anti-addiction features. If you have suggestions or '
                      'feedback, please contact our support team.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build a policy item with icon and description
  Widget _buildPolicyItem({
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
            color: Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.orange, size: 24),
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

  /// Build a numbered recommendation item
  Widget _buildRecommendationItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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

  /// Build a parent tip item with bullet point
  Widget _buildParentTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(fontSize: 15, color: Colors.grey[300]),
            ),
          ),
        ],
      ),
    );
  }
}
