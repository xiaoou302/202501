import 'package:flutter/material.dart';
import '../utils/theme.dart';

class EulaScreen extends StatelessWidget {
  const EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      appBar: AppBar(
        title: const Text(
          'End User License Agreement',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSafetyCard(),
            const SizedBox(height: 24),
            _buildWarningCard(),
            const SizedBox(height: 32),
            const Text(
              'Local Processing & Privacy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppTheme.aeroNavy,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            _buildPrivacyCard(
              question: 'How does Aero-Vision process images?',
              answer:
                  'Aero-Vision uses local NACA airfoil generation algorithms. All processing happens entirely on your device. No images are sent to any external servers.',
              icon: Icons.devices,
            ),
            const SizedBox(height: 12),
            _buildPrivacyCard(
              question: 'Is any data shared with third parties?',
              answer:
                  'No. All airfoil generation and processing occurs locally on your device. Your images never leave your phone, ensuring complete privacy and data security.',
              icon: Icons.security,
            ),
            const SizedBox(height: 12),
            _buildPrivacyCard(
              question: 'Does Aero-Vision require internet access?',
              answer:
                  'No. Aero-Vision works completely offline. You can generate airfoil profiles anywhere without needing an internet connection.',
              icon: Icons.wifi_off,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'By using Torami, you agree to abide by these terms.',
                style: TextStyle(
                  color: AppTheme.aeroNavy.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.laminarCyan.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.laminarCyan.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.laminarCyan.withValues(alpha: 0.1),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.laminarCyan.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flight_takeoff,
                  color: AppTheme.laminarCyan,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Flight Safety & Compliance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.aeroNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Fly Safely, Fly Legally.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppTheme.aeroNavy,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Torami encourages the exploration of aerodynamics and the joy of RC modeling. However, it is your strict responsibility to fly your RC models within designated, legal flight zones as mandated by your local authorities.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.aeroNavy.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Never fly near airports, crowds, or sensitive areas. Always maintain visual line of sight and adhere to your local aviation authority regulations. Safety must always be your top priority.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.aeroNavy.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.stallRed.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.stallRed.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.stallRed.withValues(alpha: 0.1),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.stallRed.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.gavel,
                  color: AppTheme.stallRed,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Zero Tolerance Policy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.stallRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'We maintain a strict zero tolerance for users with objectionable content and abusive behavior.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppTheme.stallRed,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Any violation of this policy will result in immediate consequences, including but not limited to the deletion of your posts and the permanent banning of your account.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.aeroNavy.withValues(alpha: 0.9),
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard({
    required String question,
    required String answer,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.laminarCyan.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.laminarCyan, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.aeroNavy,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            answer,
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
