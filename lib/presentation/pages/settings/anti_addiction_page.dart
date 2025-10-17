import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Anti-addiction reminder page
class AntiAddictionPage extends StatelessWidget {
  /// Constructor
  const AntiAddictionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Anti-Addiction Reminder',
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
            image: AssetImage('assets/5.jpg'),
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
                      _buildInfoCard(
                        title: 'Healthy Gaming',
                        icon: Icons.favorite,
                        iconColor: Colors.red,
                        content:
                            'While ${AppConstants.appName} is designed to be an enjoyable and relaxing experience, we encourage all players to maintain a healthy balance between gaming and other activities in their daily lives.',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Play Time Limits',
                        icon: Icons.timer,
                        iconColor: AppColors.beeswaxAmber,
                        content:
                            'We recommend playing ${AppConstants.appName} for no more than 2 hours per day. Taking regular breaks (5-10 minutes every hour) can help reduce eye strain and maintain mental freshness.',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Warning Signs',
                        icon: Icons.warning,
                        iconColor: Colors.orange,
                        content:
                            '• Losing track of time while playing\n• Neglecting responsibilities or daily activities\n• Feeling irritable when unable to play\n• Difficulty stopping gameplay\n• Disrupted sleep patterns\n\nIf you experience these symptoms, consider reducing your play time.',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Balance Tips',
                        icon: Icons.balance,
                        iconColor: AppColors.carvedJadeGreen,
                        content:
                            '• Set a timer to remind yourself when to take breaks\n• Establish specific times for gaming in your schedule\n• Maintain regular physical activity\n• Ensure gaming doesn\'t interfere with sleep\n• Prioritize real-life social interactions',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Resources for Help',
                        icon: Icons.help_outline,
                        iconColor: AppColors.mahjongBlue,
                        content:
                            'If you feel that gaming is negatively impacting your life or becoming addictive, consider reaching out to professional resources:\n\n• National helplines for gaming addiction\n• Local mental health services\n• Online support communities\n• Professional counseling services',
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

  Widget _buildInfoCard({
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18, // 减小字体大小
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3, // 减小字母间距
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 3,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
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
