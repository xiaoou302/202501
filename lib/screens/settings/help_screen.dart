import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsHelpScreen extends StatelessWidget {
  const SettingsHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
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
          _buildHeader(),
          const SizedBox(height: 32),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppTheme.aeroNavy,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildFaqAccordion(
            icon: Icons.document_scanner,
            iconColor: AppTheme.laminarCyan,
            question: 'How to scan an airfoil?',
            answer:
                'Use the "Scan" tab. Select an image from your gallery or take a photo. The app will generate a standard NACA airfoil profile locally on your device.',
          ),
          const SizedBox(height: 12),
          _buildFaqAccordion(
            icon: Icons.gradient,
            iconColor: AppTheme.turbulenceMagenta,
            question: 'What does the Magenta color mean?',
            answer:
                'In the Wind Tunnel, the magenta color represents areas of high velocity and low pressure (based on Bernoulli\'s principle). This low pressure on the upper surface is the primary source of your lift!',
          ),
          const SizedBox(height: 12),
          _buildFaqAccordion(
            icon: Icons.warning_amber_rounded,
            iconColor: AppTheme.stallRed,
            question: 'Why did the flow separate?',
            answer:
                'If you push the Angle of Attack (AoA) too high, the fluid can no longer follow the adverse pressure gradient on the upper surface. The boundary layer separates, causing a "Stall". This drastically drops lift and increases drag.',
          ),
          const SizedBox(height: 12),
          _buildFaqAccordion(
            icon: Icons.water_drop,
            iconColor: Colors.blueAccent,
            question: 'How to change fluid density?',
            answer:
                'In the Wind Tunnel, tap the "AIR / WATER" toggle in the top-left corner to switch the physical environment instantly. Water is much denser than air, so the generated Lift (L) will be significantly higher at the same velocity.',
          ),
          const SizedBox(height: 12),
          _buildFaqAccordion(
            icon: Icons.save,
            iconColor: Colors.green,
            question: 'Where are my saved profiles?',
            answer:
                'When you tap "Save to Archive" in the Wind Tunnel, your profile and current aerodynamic parameters are saved locally. You can view, expand, and delete them in the "Library" tab.',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.aeroNavy, AppTheme.aeroNavy.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent,
              size: 40,
              color: AppTheme.laminarCyan,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How can we help?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find answers to common questions about Torami below.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqAccordion({
    required IconData icon,
    required Color iconColor,
    required String question,
    required String answer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.aeroNavy.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppTheme.aeroNavy,
          collapsedIconColor: AppTheme.aeroNavy.withValues(alpha: 0.5),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppTheme.aeroNavy,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 72, right: 24, bottom: 20),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.aeroNavy.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
