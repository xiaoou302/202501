import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/timeline_story_model.dart';
import 'package:intl/intl.dart';

class TimelineItem extends StatelessWidget {
  final TimelineStory story;
  final bool isLast;

  const TimelineItem({Key? key, required this.story, this.isLast = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppConstants.softCoral,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppConstants.darkGray
                      : AppConstants.panelWhite,
                  width: 3,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 100,
                color: isDark
                    ? AppConstants.mediumGray.withOpacity(0.3)
                    : AppConstants.mediumGray.withOpacity(0.2),
              ),
          ],
        ),
        const SizedBox(width: AppConstants.spacingM),

        // Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: AppConstants.spacingL),
            padding: const EdgeInsets.all(AppConstants.spacingM),
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
                // Date
                Text(
                  DateFormat('MMM dd, yyyy').format(story.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppConstants.softCoral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingS),

                // Title
                Text(
                  story.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingS),

                // Content
                Text(
                  story.content,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),

                // Image if available
                if (story.imageUrl != null) ...[
                  const SizedBox(height: AppConstants.spacingM),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    child: Image.asset(
                      story.imageUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: AppConstants.mediumGray.withOpacity(0.2),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppConstants.mediumGray,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
