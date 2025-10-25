import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Health Reminders screen - Gaming wellness tips
class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.parchmentGradient,
          ),
          image: DecorationImage(
            image: NetworkImage(
              'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAFElEQVQI12P4//8/AwMDAwMDAwMAFwMBAweciQsAAAAASUVORK5CYII=',
            ),
            repeat: ImageRepeat.repeat,
            opacity: 0.03,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildIntro(),
                      const SizedBox(height: 20),
                      _buildTipCard(
                        icon: Icons.visibility_rounded,
                        title: 'Eye Care',
                        tips: [
                          'Follow the 20-20-20 rule: Every 20 minutes, look at something 20 feet away for 20 seconds',
                          'Adjust screen brightness to match your surroundings',
                          'Use proper lighting to reduce eye strain',
                          'Blink frequently to keep eyes moist',
                        ],
                        color: AppColors.magicBlue,
                      ),
                      const SizedBox(height: 16),
                      _buildTipCard(
                        icon: Icons.accessibility_new_rounded,
                        title: 'Posture & Movement',
                        tips: [
                          'Sit with your back straight and shoulders relaxed',
                          'Keep your device at arm\'s length',
                          'Take a 5-minute break every hour to stretch',
                          'Avoid playing in one position for too long',
                        ],
                        color: AppColors.arcaneGreen,
                      ),
                      const SizedBox(height: 16),
                      _buildTipCard(
                        icon: Icons.schedule_rounded,
                        title: 'Time Management',
                        tips: [
                          'Set time limits for gaming sessions',
                          'Take regular breaks between chapters',
                          'Avoid gaming before bedtime',
                          'Balance gaming with other activities',
                        ],
                        color: AppColors.glowAmber,
                      ),
                      const SizedBox(height: 16),
                      _buildTipCard(
                        icon: Icons.psychology_rounded,
                        title: 'Mental Wellness',
                        tips: [
                          'Play at your own pace - don\'t rush',
                          'Take breaks if you feel frustrated',
                          'Remember it\'s just a game - have fun!',
                          'Stay hydrated during play sessions',
                        ],
                        color: AppColors.magicPurple,
                      ),
                      const SizedBox(height: 24),
                      _buildWarningCard(),
                      const SizedBox(height: 24),
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
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentDark.withOpacity(0.3),
            AppColors.parchmentMedium.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.inkBlack.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              iconSize: 20,
              onPressed: () => Navigator.pop(context),
              color: AppColors.inkBrown,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Reminders',
                  style: TextStyle(
                    color: AppColors.inkBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Play Safely',
                  style: TextStyle(
                    color: AppColors.inkFaded,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.health_and_safety_rounded,
            color: AppColors.dangerRed,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.dangerRed.withOpacity(0.1),
            AppColors.glowAmber.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dangerRed.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.favorite_rounded, color: AppColors.dangerRed, size: 40),
          const SizedBox(height: 14),
          Text(
            'Your Health Matters',
            style: TextStyle(
              color: AppColors.inkBlack,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Gaming should be enjoyable and safe. Follow these wellness tips to maintain a healthy gaming experience.',
            style: TextStyle(
              color: AppColors.inkBrown,
              fontSize: 14,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required List<String> tips,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentLight,
            AppColors.parchmentMedium.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.inkBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        color: AppColors.inkBrown,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warningRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warningRed.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warningRed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Important Notice',
                  style: TextStyle(
                    color: AppColors.warningRed,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Prolonged gaming may cause:\n\n• Eye strain and discomfort\n• Repetitive strain injury\n• Sleep disturbance\n• Reduced physical activity\n\nIf you experience any discomfort, stop playing and consult a healthcare professional.',
            style: TextStyle(
              color: AppColors.inkBrown,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
