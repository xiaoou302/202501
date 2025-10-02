import 'package:flutter/material.dart';
import '../services/achievement_service.dart';
import '../utils/constants.dart';
import 'dart:math' as math;

/// Widget for displaying an achievement card
class AchievementCard extends StatelessWidget {
  /// Achievement data
  final Achievement achievement;

  /// Progress value (0.0 to 1.0)
  final double progress;

  /// Whether the achievement is unlocked
  final bool isUnlocked;

  const AchievementCard({
    Key? key,
    required this.achievement,
    required this.progress,
    required this.isUnlocked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // Will add detail view later
            splashColor: achievement.iconColor.withOpacity(0.1),
            highlightColor: achievement.iconColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon with background
                  _buildAchievementIcon(),

                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              achievement.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textGraphite,
                              ),
                            ),
                            if (isUnlocked)
                              Icon(
                                Icons.check_circle,
                                size: 18,
                                color: achievement.iconColor,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement.isSecret && !isUnlocked
                              ? 'Secret achievement'
                              : achievement.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.disabledGray,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Progress indicator
                        _buildProgressIndicator(),

                        // Progress text
                        const SizedBox(height: 4),
                        _buildProgressText(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the achievement icon with background
  Widget _buildAchievementIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked
            ? achievement.iconColor.withOpacity(0.15)
            : Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: isUnlocked
              ? achievement.iconColor.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: isUnlocked
          ? Icon(achievement.icon, size: 28, color: achievement.iconColor)
          : Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  achievement.isSecret ? Icons.help_outline : achievement.icon,
                  size: 28,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: Colors.grey.withOpacity(0.7),
                ),
              ],
            ),
    );
  }

  /// Builds the progress indicator
  Widget _buildProgressIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background track
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.withOpacity(0.2),
          ),
        ),

        // Progress fill
        Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    isUnlocked ? Colors.amber : achievement.iconColor,
                    isUnlocked
                        ? Colors.amber.shade300
                        : achievement.iconColor.withOpacity(0.7),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isUnlocked ? Colors.amber : achievement.iconColor)
                        .withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Shine effect
        if (progress > 0.05)
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: math.min(progress, 0.95),
              child: Container(
                height: 3,
                margin: const EdgeInsets.only(top: -3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the progress text
  Widget _buildProgressText() {
    final progressPercent = (progress * 100).toInt();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isUnlocked ? 'Completed!' : '$progressPercent% complete',
          style: TextStyle(
            fontSize: 11,
            fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal,
            color: isUnlocked ? achievement.iconColor : AppColors.disabledGray,
          ),
        ),
        if (!isUnlocked && progress > 0)
          Text(
            '${progressPercent}/100',
            style: const TextStyle(fontSize: 11, color: AppColors.disabledGray),
          ),
      ],
    );
  }
}
