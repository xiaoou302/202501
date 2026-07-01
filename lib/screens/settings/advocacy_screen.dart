import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AdvocacyScreen extends StatelessWidget {
  const AdvocacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Care Advocacy',
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
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.peachFuzz.withValues(alpha: 0.2),
                    AppColors.morningPeach.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: AppColors.peachFuzz.withValues(alpha: 0.2),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.favorite, color: AppColors.peachFuzz, size: 64),
                  SizedBox(height: 24),
                  Text(
                    'Companionship & Protection',
                    style: TextStyle(
                      color: AppColors.cocoaBrown,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Every life deserves respect and tender care. Animals are not just pets; they are our best friends, our family, and our loyal companions.',
                    style: TextStyle(
                      color: AppColors.chestnutGray,
                      fontSize: 15,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildAdvocacyCard(
              icon: Icons.home_rounded,
              color: AppColors.seafoam,
              title: 'Adopt, Don\'t Shop',
              desc:
                  'Give a stray a warm home. Rescue changes two lives: theirs and yours.',
            ),
            const SizedBox(height: 16),
            _buildAdvocacyCard(
              icon: Icons.health_and_safety,
              color: AppColors.warmSun,
              title: 'Lifelong Commitment',
              desc:
                  'Owning a pet is a lifetime promise. Please do not abandon them when they get old or sick.',
            ),
            const SizedBox(height: 16),
            _buildAdvocacyCard(
              icon: Icons.volunteer_activism,
              color: AppColors.apricotPreserve,
              title: 'Patience & Love',
              desc:
                  'Rescued animals may have trauma. Give them time, space, and endless love to heal.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvocacyCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.warmGauze.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.chestnutGray.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.cocoaBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
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
