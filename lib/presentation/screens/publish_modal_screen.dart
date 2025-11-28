import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class PublishModalScreen extends StatelessWidget {
  const PublishModalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPublishOption(
                    context,
                    icon: Icons.camera_alt,
                    iconColor: AppConstants.balletPink,
                    title: 'Publish Pose',
                    subtitle: 'Share a public photo to "Pose Flow"',
                    onTap: () {
                      Navigator.pop(context);
                      // Handle publish pose
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPublishOption(
                    context,
                    icon: Icons.edit,
                    iconColor: AppConstants.energyYellow,
                    title: 'Share Insight',
                    subtitle: 'Write a public article to "Insights"',
                    onTap: () {
                      Navigator.pop(context);
                      // Handle share insight
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppConstants.graphite,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppConstants.offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppConstants.midGray,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
