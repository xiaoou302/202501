import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About Game',
          style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.antiqueGold.withValues(alpha: 0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🀄', style: TextStyle(fontSize: 80)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PAIKO',
              style: TextStyle(
                color: AppColors.antiqueGold,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mahjong Memory Solitaire',
              style: TextStyle(
                color: AppColors.ivory.withValues(alpha: 0.7),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoSection(
              'About',
              'PAIKO is a unique memory-based Mahjong solitaire game. Match tiles by number while remembering their positions. Challenge yourself across 8 difficulty levels and unlock achievements!',
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              'Developer',
              'Created with passion for puzzle game enthusiasts.',
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              'Version',
              '1.9.1',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sandalwood.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.antiqueGold.withValues(alpha: 0.2)),
      ),
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
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
