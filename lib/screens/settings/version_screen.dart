import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsVersionScreen extends StatelessWidget {
  const SettingsVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      appBar: AppBar(
        title: const Text(
          'Version Info',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.aeroNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          children: [
            Container(
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
                size: 72,
                color: AppTheme.laminarCyan,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Torami',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.aeroNavy,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.aeroNavy.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Version 1.0.0 (Build 2026.04.12)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.aeroNavy,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildChangelogCard(
              version: 'v1.0.0 - Genesis Release',
              date: 'April 12, 2026',
              isLatest: true,
              changes: [
                'Initial release of Torami',
                'Integrated Local NACA Airfoil Generator (Offline)',
                'Navier-Stokes Lite real-time simulator (Lift, Drag, Stall)',
                'Aero Archive with expandable telemetry cards',
                'Premium Cyberpunk/Glassmorphism UI overhaul',
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Made with ♥ by Torami Team',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangelogCard({
    required String version,
    required String date,
    required bool isLatest,
    required List<String> changes,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isLatest
            ? Border.all(
                color: AppTheme.laminarCyan.withValues(alpha: 0.5),
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isLatest
                ? AppTheme.laminarCyan.withValues(alpha: 0.1)
                : AppTheme.aeroNavy.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                version,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.aeroNavy,
                ),
              ),
              if (isLatest)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.laminarCyan.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LATEST',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.laminarCyan,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.aeroNavy.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...changes.map(
            (change) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6.0, right: 8.0),
                    child: Icon(
                      Icons.circle,
                      size: 6,
                      color: AppTheme.laminarCyan,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      change,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.aeroNavy.withValues(alpha: 0.8),
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
}
