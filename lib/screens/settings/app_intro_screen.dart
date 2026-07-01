import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AppIntroScreen extends StatelessWidget {
  const AppIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'App Introduction',
          style: TextStyle(
            color: AppColors.cocoaBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.cocoaBrown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.seafoam.withValues(alpha: 0.15),
                    AppColors.mistyFoam.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.seafoam.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.creamWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pets,
                      color: AppColors.seafoam,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Stray Rescue AI',
                    style: TextStyle(
                      color: AppColors.cocoaBrown,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'An AI-powered tool dedicated to helping kind-hearted individuals rescue, track, and care for stray animals with ease and love.',
                    style: TextStyle(
                      color: AppColors.chestnutGray,
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Core Features',
              style: TextStyle(
                color: AppColors.cocoaBrown,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureRow(
              Icons.document_scanner,
              AppColors.seafoam,
              'AI Scan & Analyze',
              'Upload a photo to instantly analyze the breed, age, and condition of a stray pet using advanced AI.',
            ),
            _buildFeatureRow(
              Icons.timeline,
              AppColors.peachFuzz,
              'Rescue Journey',
              'Continuously track their recovery progress, weight, and daily meals with beautiful charts and stacked logs.',
            ),
            _buildFeatureRow(
              Icons.sports_esports,
              AppColors.warmSun,
              'Play & Training',
              'Access a library of hardware-free interactive games and training guides to build trust and intimacy.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(
    IconData icon,
    Color color,
    String title,
    String desc,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warmGauze.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.chestnutGray.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.cocoaBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 14,
                    height: 1.5,
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
