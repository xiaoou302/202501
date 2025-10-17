import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Player rights page
class PlayerRightsPage extends StatelessWidget {
  /// Constructor
  const PlayerRightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Player Rights',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/8.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Use constraints to adapt to different screen sizes
              final double contentWidth = constraints.maxWidth > 700
                  ? 700
                  : constraints.maxWidth;
              final double horizontalPadding =
                  (constraints.maxWidth - contentWidth) / 2;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding > 0 ? horizontalPadding : 16.0,
                  vertical: 16.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRightsSection(
                        title: 'Privacy Rights',
                        icon: Icons.privacy_tip,
                        iconColor: Colors.blue,
                        content:
                            'We respect your privacy and are committed to protecting your personal information. '
                            'This game does not collect any personal data beyond what is strictly necessary for its operation. '
                            'You have the right to know what data is collected and request its deletion at any time.',
                      ),
                      const SizedBox(height: 16),
                      _buildRightsSection(
                        title: 'Fair Play',
                        icon: Icons.balance,
                        iconColor: AppColors.carvedJadeGreen,
                        content:
                            'Every level in ${AppConstants.appName} is designed to be completable. '
                            'The game employs algorithms to ensure that each board layout has at least one solution. '
                            'We are committed to providing a fair and enjoyable gaming experience without hidden obstacles.',
                      ),
                      const SizedBox(height: 16),
                      _buildRightsSection(
                        title: 'Content Accessibility',
                        icon: Icons.accessibility_new,
                        iconColor: AppColors.beeswaxAmber,
                        content:
                            'We strive to make ${AppConstants.appName} accessible to all players. '
                            'The game features clear visual cues, adjustable difficulty levels, and intuitive controls. '
                            'If you have suggestions for improving accessibility, please contact us.',
                      ),
                      const SizedBox(height: 16),
                      _buildRightsSection(
                        title: 'Customer Support',
                        icon: Icons.support_agent,
                        iconColor: AppColors.mahjongBlue,
                        content:
                            'You have the right to receive prompt and helpful customer support. '
                            'If you encounter any issues or have questions about ${AppConstants.appName}, '
                            'our support team is available to assist you through the Contact Us section.',
                      ),
                      const SizedBox(height: 16),
                      _buildRightsSection(
                        title: 'Game Improvement',
                        icon: Icons.trending_up,
                        iconColor: AppColors.mahjongRed,
                        content:
                            'Your feedback is valuable to us. As a player, you have the right to contribute to the improvement of ${AppConstants.appName}. '
                            'We welcome your suggestions and will consider them for future updates. '
                            'Together, we can make this game even better.',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRightsSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
