import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class EmptyFollowingState extends StatelessWidget {
  final VoidCallback? onExplorePressed;

  const EmptyFollowingState({Key? key, this.onExplorePressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppConstants.softCoral.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 60,
                color: AppConstants.softCoral,
              ),
            ),

            const SizedBox(height: AppConstants.spacingL),

            // Title
            Text(
              'No Following Yet',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacingM),

            // Description
            Text(
              'Start building your pet community by following other pet lovers!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppConstants.mediumGray,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Tips Container
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              decoration: BoxDecoration(
                color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppConstants.softCoral,
                        size: 24,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Text(
                        'How to Follow',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingM),

                  // Step 1
                  _buildStep(
                    context,
                    '1',
                    'Browse Posts',
                    'Explore the "All" tab to discover amazing pet content',
                  ),

                  const SizedBox(height: AppConstants.spacingM),

                  // Step 2
                  _buildStep(
                    context,
                    '2',
                    'Visit Profiles',
                    'Tap on any post to view the user\'s profile and their pet stories',
                  ),

                  const SizedBox(height: AppConstants.spacingM),

                  // Step 3
                  _buildStep(
                    context,
                    '3',
                    'Follow Friends',
                    'Click the "Follow" button to add them to your Following list',
                  ),

                  const SizedBox(height: AppConstants.spacingM),

                  // Step 4
                  _buildStep(
                    context,
                    '4',
                    'Stay Connected',
                    'Return here to see posts only from people you follow',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // CTA Button
            ElevatedButton.icon(
              onPressed:
                  onExplorePressed ??
                  () {
                    // Default behavior if no callback provided
                  },
              icon: const Icon(Icons.explore, size: 20),
              label: const Text(
                'Explore Posts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.softCoral,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    String number,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number Circle
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppConstants.softCoral,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spacingM),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppConstants.mediumGray,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
