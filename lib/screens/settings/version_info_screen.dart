import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/glass_card.dart';

/// Version Info Screen
/// Displays information about the game version and update history
class VersionInfoScreen extends StatelessWidget {
  const VersionInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Version Info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.info,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CHROPLEXIGNOSIS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Released: January 15, 2023',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Current Version Section
            const Text(
              'CURRENT VERSION',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem(
                    title: 'Build Number',
                    value: '1.0.0 (100)',
                    icon: Icons.build,
                    iconColor: Colors.orangeAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildInfoItem(
                    title: 'Platform',
                    value: 'iOS & Android',
                    icon: Icons.devices,
                    iconColor: Colors.greenAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildInfoItem(
                    title: 'Size',
                    value: '45.7 MB',
                    icon: Icons.sd_storage,
                    iconColor: Colors.purpleAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildInfoItem(
                    title: 'Last Updated',
                    value: 'January 15, 2023',
                    icon: Icons.update,
                    iconColor: Colors.blueAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Version History Section
            const Text(
              'VERSION HISTORY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            _buildVersionCard(
              version: '1.0.0',
              date: 'January 15, 2023',
              changes: [
                'Initial release of ChroPlexiGnosis',
                'Six campaign levels with unique objectives',
                'Multiple unit types: standard, locked, changing, and polluted',
                'Perfect match and transmute mechanics',
                'Achievement system with 7 unique achievements',
                'Player statistics tracking',
              ],
              isLatest: true,
            ),
            const SizedBox(height: 16),
            _buildVersionCard(
              version: '0.9.5 (Beta)',
              date: 'December 10, 2022',
              changes: [
                'Final beta release before public launch',
                'Added level 6 with dual objectives',
                'Implemented achievement system',
                'Fixed various bugs and performance issues',
                'Improved UI responsiveness',
                'Added tutorial for each level',
              ],
            ),
            const SizedBox(height: 16),
            _buildVersionCard(
              version: '0.9.0 (Beta)',
              date: 'November 15, 2022',
              changes: [
                'Added levels 4 and 5 with special mechanics',
                'Implemented changing units and polluted tiles',
                'Added transmute ability for special interactions',
                'Improved game board generation algorithm',
                'Enhanced visual effects for matches',
              ],
            ),
            const SizedBox(height: 16),
            _buildVersionCard(
              version: '0.8.0 (Alpha)',
              date: 'October 1, 2022',
              changes: [
                'First alpha release with core gameplay',
                'Implemented basic match-3 mechanics',
                'Added first three levels',
                'Basic UI and navigation',
                'Local storage for game progress',
              ],
            ),

            const SizedBox(height: 32),

            // Technical Info Section
            const Text(
              'TECHNICAL INFORMATION',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem(
                    title: 'Framework',
                    value: 'Flutter',
                    icon: Icons.flutter_dash,
                    iconColor: Colors.lightBlueAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildInfoItem(
                    title: 'Minimum OS',
                    value: 'iOS 11.0 / Android 5.0',
                    icon: Icons.phone_android,
                    iconColor: Colors.tealAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildInfoItem(
                    title: 'Permissions',
                    value: 'Storage (for saving game progress)',
                    icon: Icons.folder,
                    iconColor: Colors.amberAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Credits Section
            const Text(
              'CREDITS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DEVELOPMENT TEAM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Game Design: ChroPlexiGnosis Team\nProgramming: Flutter Development Team\nArt & UI: Creative Design Studio\nMusic & Sound: Audio Synthesis Labs',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SPECIAL THANKS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To all our beta testers who provided valuable feedback and helped shape the game into what it is today.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '© 2023 ChroPlexiGnosis Team. All Rights Reserved.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Helper method to build info items
  Widget _buildInfoItem({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build version cards
  Widget _buildVersionCard({
    required String version,
    required String date,
    required List<String> changes,
    bool isLatest = false,
  }) {
    return GlassCard(
      isGlowing: isLatest,
      glowColor: isLatest ? AppColors.primaryAccent : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      version,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isLatest)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryAccent,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'CURRENT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'CHANGES:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryAccent,
            ),
          ),
          const SizedBox(height: 8),
          ...changes.map(
            (change) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      change,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withOpacity(0.9),
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
