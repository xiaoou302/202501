import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsDisclaimerScreen extends StatelessWidget {
  const SettingsDisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      appBar: AppBar(
        title: const Text(
          'Disclaimer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.aeroNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.stallRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.stallRed.withValues(alpha: 0.2),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: AppTheme.stallRed,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'CRITICAL NOTICE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.stallRed,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildDisclaimerCard(
              title: 'Educational Purposes Only',
              content:
                  'Torami provides simulated aerodynamic data based on simplified 2D potential flow theory and Kutta-Joukowski approximations. It is designed for conceptual understanding, education, and hobbyist exploration.',
              icon: Icons.school,
            ),
            const SizedBox(height: 16),
            _buildDisclaimerCard(
              title: 'Not for Real-world Aviation',
              content:
                  'The data provided (including Lift, Drag coefficients, L/D ratios, and stall predictions) MUST NOT be used for real-world aviation safety, structural integrity validation, or life-critical engineering designs.',
              icon: Icons.flight_takeoff,
              isCritical: true,
            ),
            const SizedBox(height: 16),
            _buildDisclaimerCard(
              title: 'Limitation of Liability',
              content:
                  'The creators and developers of Torami assume no liability for any damages, injuries, or losses resulting from the use of this software for manufacturing physical models, RC planes, hydrofoils, or any other objects.',
              icon: Icons.gavel,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard({
    required String title,
    required String content,
    required IconData icon,
    bool isCritical = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCritical
              ? AppTheme.stallRed.withValues(alpha: 0.5)
              : AppTheme.aeroNavy.withValues(alpha: 0.05),
          width: isCritical ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCritical
                ? AppTheme.stallRed.withValues(alpha: 0.1)
                : AppTheme.aeroNavy.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isCritical ? AppTheme.stallRed : AppTheme.aeroNavy,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCritical ? AppTheme.stallRed : AppTheme.aeroNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.aeroNavy.withValues(alpha: 0.8),
              height: 1.6,
              fontWeight: isCritical ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
