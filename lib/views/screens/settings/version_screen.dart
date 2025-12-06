import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

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
          'Version Info',
          style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.antiqueGold.withValues(alpha: 0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🀄', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PAIKO',
              style: TextStyle(
                color: AppColors.antiqueGold,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.jadeGreen.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.jadeGreen),
              ),
              child: const Text(
                'Version 1.9.1',
                style: TextStyle(
                  color: AppColors.jadeGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildVersionSection(
              'LATEST UPDATE',
              'v1.9.1 - Real Data Integration',
              [
                'Connected achievements to actual game data',
                'Integrated statistics with player progress',
                'Enhanced data persistence',
                'Bug fixes and performance improvements',
              ],
            ),
            const SizedBox(height: 20),
            _buildVersionSection(
              'PREVIOUS UPDATES',
              'v1.9.0 - Achievements & Stats',
              [
                'Added comprehensive achievement system',
                'Introduced detailed statistics tracking',
                'New player progression features',
              ],
            ),
            const SizedBox(height: 20),
            _buildVersionSection(
              '',
              'v1.8.0 - Premium UI Design',
              [
                'Complete visual overhaul',
                'Enhanced color palette',
                'Improved animations and transitions',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionSection(String label, String version, List<String> features) {
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
          if (label.isNotEmpty) ...[
            Text(
              label,
              style: TextStyle(
                color: AppColors.antiqueGold.withValues(alpha: 0.8),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            version,
            style: const TextStyle(
              color: AppColors.ivory,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        color: AppColors.antiqueGold,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: AppColors.ivory.withValues(alpha: 0.9),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
