import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsUserAgreementScreen extends StatelessWidget {
  const SettingsUserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      appBar: AppBar(
        title: const Text(
          'User Agreement',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.aeroNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildAgreementCard(
            icon: Icons.gavel,
            title: 'Terms of Service',
            content:
                'By using Torami, you agree to these terms. This app is provided for educational and conceptual design purposes only. The simulations are based on simplified 2D potential flow theory and do not replace professional CFD software or wind tunnel testing.',
          ),
          const SizedBox(height: 16),
          _buildAgreementCard(
            icon: Icons.security,
            title: 'Data Privacy',
            content:
                'All image processing for Aero-Vision happens locally on your device using NACA airfoil generation algorithms. No images are sent to external servers. Your data never leaves your phone.',
          ),
          const SizedBox(height: 16),
          _buildAgreementCard(
            icon: Icons.save_alt,
            title: 'Local Storage',
            content:
                'All your simulated profiles and aerodynamic data are saved locally on your device in the "Aero Archive". If you delete the app or clear the cache, this data will be permanently lost.',
          ),
          const SizedBox(height: 40),
          Text(
            'Last Updated: April 12, 2026',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.aeroNavy.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.aeroNavy, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.aeroNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.aeroNavy.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
