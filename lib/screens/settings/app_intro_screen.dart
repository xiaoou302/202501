import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsAppIntroScreen extends StatelessWidget {
  const SettingsAppIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      appBar: AppBar(
        title: const Text(
          'App Introduction',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.aeroNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.laminarCyan.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.air,
                  size: 80,
                  color: AppTheme.laminarCyan,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Torami: Pocket Wind Tunnel',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.aeroNavy,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Torami is a specialized tool designed for RC aircraft builders, hydrofoil designers, and aerodynamic geeks. We eliminate the tedious mesh generation and solving processes of traditional CAD/CFD software.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.aeroNavy.withValues(alpha: 0.8),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            _buildFeatureCard(
              icon: Icons.document_scanner,
              title: 'Aero-Vision',
              description:
                  'Instantly generate standard NACA airfoil profiles using local algorithms. No internet connection required.',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.storm,
              title: 'Navier-Stokes Lite',
              description:
                  'A real-time potential flow simulator. Adjust Angle of Attack (AoA) and Velocity to visualize streamlines and pressure fields.',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.warning_amber,
              title: 'Stall Telemetry',
              description:
                  'Push the limits of your design and receive instant haptic & visual warnings when boundary layer separation occurs.',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.polarIce,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.laminarCyan, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.aeroNavy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: AppTheme.aeroNavy.withValues(alpha: 0.7),
                    fontSize: 12,
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
