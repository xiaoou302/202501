import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/growth_track_model.dart';

class GrowthTimeline extends StatelessWidget {
  final List<GrowthTrack> tracks;

  const GrowthTimeline({Key? key, required this.tracks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(left: 24),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppConstants.softCoral.withOpacity(0.5),
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: tracks.map((track) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingXL),
            child: Stack(
              children: [
                // Dot
                Positioned(
                  left: -33,
                  top: 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: track.isArchived
                          ? AppConstants.mediumGray
                          : AppConstants.softCoral,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppConstants.deepPlum
                            : AppConstants.shellWhite,
                        width: 4,
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${track.date.month}/${track.date.day}/${track.date.year}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppConstants.mediumGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(track.title, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(
                        track.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (track.imageUrls != null &&
                          track.imageUrls!.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.spacingM),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                          child: Image.file(
                            File(track.imageUrls!.first),
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
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
