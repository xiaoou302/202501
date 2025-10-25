import 'package:flutter/material.dart';
import '../../core/models/chapter_model.dart';
import '../../core/models/user_stats_model.dart';
import '../theme/app_colors.dart';

/// Chapter card widget for displaying chapter information
class ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final ChapterProgress? progress;
  final VoidCallback? onTap;

  const ChapterCard({
    super.key,
    required this.chapter,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = !chapter.isUnlocked;
    final opacity = isLocked ? 0.6 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Card(
        child: InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: isLocked
                                      ? AppColors.textDark.withOpacity(0.6)
                                      : AppColors.textDark,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chapter.subtitle,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: isLocked
                                      ? AppColors.textDark.withOpacity(0.5)
                                      : AppColors.textDark.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                    _buildStarRating(progress?.starRating ?? 0, isLocked),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Story Progress: ${progress != null ? progress!.calculateProgress(chapter.keywords.length).toStringAsFixed(0) : "0"}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isLocked
                        ? AppColors.textMuted.withOpacity(0.6)
                        : AppColors.textMuted.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLocked ? null : onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLocked ? Colors.grey[300] : null,
                      foregroundColor: isLocked ? Colors.grey[500] : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isLocked ? Icons.lock : Icons.play_arrow,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(isLocked ? 'Locked' : 'Enter Memory'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(int rating, bool isLocked) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isFilled = index < rating;
        return Icon(
          isFilled ? Icons.star : Icons.star_border,
          color: isLocked
              ? AppColors.textMuted.withOpacity(0.3)
              : (isFilled
                    ? AppColors.accentOrange
                    : AppColors.textMuted.withOpacity(0.3)),
          size: 20,
        );
      }),
    );
  }
}
