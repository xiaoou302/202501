import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inkGreen,
      appBar: AppBar(
        backgroundColor: AppColors.sandalwood,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.antiqueGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Disclaimer',
          style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.vermillion.withValues(alpha: 0.3),
                    AppColors.vermillion.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.vermillion.withValues(alpha: 0.5), width: 2),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.vermillion,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'IMPORTANT NOTICE',
                      style: TextStyle(
                        color: AppColors.vermillion,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              'Entertainment Only',
              'PAIKO is a puzzle game that uses Mahjong tiles purely as visual elements for entertainment purposes. This game has NO connection to gambling, betting, or any form of real-money wagering.',
              Icons.games,
              AppColors.jadeGreen,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Zero Tolerance Policy',
              'We maintain a strict zero-tolerance policy against any form of gambling, illegal activities, or misuse of this game. PAIKO is designed solely as a memory and puzzle challenge.',
              Icons.block,
              AppColors.vermillion,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'No Real Money Involved',
              'This game does NOT involve:\n• Real money transactions\n• Gambling or betting\n• Cash prizes or rewards\n• Any form of monetary exchange',
              Icons.money_off,
              Color(0xFFD84315),
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Cultural Respect',
              'Mahjong tiles are used respectfully as a cultural element to create an engaging puzzle experience. We honor the traditional game while creating a completely different gameplay mechanic.',
              Icons.favorite,
              Color(0xFF9C27B0),
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Age Appropriate',
              'PAIKO is suitable for all ages. It is a family-friendly puzzle game focused on memory skills, pattern recognition, and strategic thinking.',
              Icons.family_restroom,
              AppColors.jadeBlue,
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              'Responsible Gaming',
              'We encourage healthy gaming habits. Take breaks, play responsibly, and remember that this is purely for entertainment and mental exercise.',
              Icons.psychology,
              AppColors.antiqueGold,
            ),
            
            const SizedBox(height: 32),
            
            // Footer Statement
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.sandalwood.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.antiqueGold.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.verified_user,
                    color: AppColors.jadeGreen,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'COMMITMENT TO INTEGRITY',
                    style: TextStyle(
                      color: AppColors.antiqueGold,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We are committed to providing a safe, legal, and enjoyable gaming experience. Any attempt to misuse this game for illegal purposes will not be tolerated.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.ivory.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.5,
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

  Widget _buildSection(String title, String content, IconData icon, Color iconColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sandalwood.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.antiqueGold.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.antiqueGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    color: AppColors.ivory.withValues(alpha: 0.9),
                    fontSize: 13,
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
