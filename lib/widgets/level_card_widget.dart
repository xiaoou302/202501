import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Widget for displaying a level pack card
class LevelCardWidget extends StatelessWidget {
  /// Level pack name
  final String packName;

  /// Level pack description
  final String description;

  /// Background color
  final Color backgroundColor;

  /// Number of completed levels
  final int completedLevels;

  /// Total number of levels
  final int totalLevels;

  /// Whether the pack is locked
  final bool isLocked;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  const LevelCardWidget({
    Key? key,
    required this.packName,
    required this.description,
    required this.backgroundColor,
    required this.completedLevels,
    required this.totalLevels,
    this.isLocked = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: UIConstants.defaultShadowBlur,
              offset: const Offset(0, UIConstants.defaultShadowOffset),
            ),
          ],
        ),
        child: Opacity(
          opacity: isLocked ? 0.6 : 1.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      packName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              isLocked
                  ? const Icon(Icons.lock, color: Colors.white70, size: 24)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$completedLevels / $totalLevels',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Completed',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
