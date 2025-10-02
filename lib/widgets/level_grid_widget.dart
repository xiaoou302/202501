import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../utils/constants.dart';
import '../utils/level_cache.dart';

/// Widget for displaying a grid of levels
class LevelGridWidget extends StatelessWidget {
  /// List of levels to display (deprecated, use levelMetadata instead)
  final List<GameLevel>? levels;

  /// List of level metadata to display (lightweight)
  final List<GameLevelMetadata>? levelMetadata;

  /// List of completed level IDs
  final List<int> completedLevelIds;

  /// Callback when a level is tapped
  final Function(int) onLevelTap;

  const LevelGridWidget({
    Key? key,
    this.levels,
    this.levelMetadata,
    required this.completedLevelIds,
    required this.onLevelTap,
  }) : assert(
         levels != null || levelMetadata != null,
         'Either levels or levelMetadata must be provided',
       ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use either levels or levelMetadata
    final itemCount = levelMetadata?.length ?? levels?.length ?? 0;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (levelMetadata != null) {
          // Use lightweight metadata
          final metadata = levelMetadata![index];
          final isCompleted = completedLevelIds.contains(metadata.id);
          final isLocked = metadata.isLocked;

          return _buildLevelTileFromMetadata(metadata, isCompleted, isLocked);
        } else {
          // Fallback to full levels
          final level = levels![index];
          final isCompleted = completedLevelIds.contains(level.id);
          final isLocked = level.isLocked;

          return _buildLevelTile(level, isCompleted, isLocked);
        }
      },
    );
  }

  /// Build a level tile
  Widget _buildLevelTile(GameLevel level, bool isCompleted, bool isLocked) {
    return GestureDetector(
      onTap: isLocked ? null : () => onLevelTap(level.id),
      child: Container(
        decoration: BoxDecoration(
          color: _getLevelColor(level, isCompleted, isLocked),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '${level.id}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
            if (isCompleted)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.green, size: 16),
                ),
              ),
            if (isLocked)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.lock, color: Colors.white, size: 32),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build a level tile from metadata (lightweight) with enhanced UI
  Widget _buildLevelTileFromMetadata(
    GameLevelMetadata metadata,
    bool isCompleted,
    bool isLocked,
  ) {
    // Use a hero animation tag for smooth transitions
    final heroTag = 'level_${metadata.id}';

    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked ? null : () => onLevelTap(metadata.id),
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.3),
          child: Container(
            decoration: BoxDecoration(
              color: _getLevelColorFromMetadata(
                metadata,
                isCompleted,
                isLocked,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getLevelColorFromMetadata(
                    metadata,
                    isCompleted,
                    isLocked,
                  ).withOpacity(0.9),
                  _getLevelColorFromMetadata(metadata, isCompleted, isLocked),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background pattern for visual interest
                if (!isLocked)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _createGridPatternPainter(
                        color: Colors.white.withOpacity(0.05),
                        lineCount: 3,
                      ),
                    ),
                  ),
                // Level number
                Center(
                  child: Text(
                    '${metadata.id}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 3,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                // Completion indicator
                if (isCompleted)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                  ),
                // Lock overlay
                if (isLocked)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 32,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
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

  // Using a function to create a CustomPainter for grid pattern
  CustomPainter _createGridPatternPainter({
    required Color color,
    int lineCount = 3,
  }) {
    return _GridPatternPainter(color: color, lineCount: lineCount);
  }

  /// Get the color for a level tile
  Color _getLevelColor(GameLevel level, bool isCompleted, bool isLocked) {
    if (isLocked) {
      return Colors.grey;
    } else if (isCompleted) {
      return AppColors.arrowGreen.withOpacity(0.8);
    } else {
      // Return a color based on the level pack
      switch (level.levelPack) {
        case 'Tranquil Beginnings':
          return AppColors.arrowBlue;
        case 'Colorful Maze':
          return AppColors.arrowTerracotta;
        case 'Core Challenge':
          return AppColors.arrowPink;
        default:
          return AppColors.arrowGreen;
      }
    }
  }

  /// Get the color for a level tile from metadata
  Color _getLevelColorFromMetadata(
    GameLevelMetadata metadata,
    bool isCompleted,
    bool isLocked,
  ) {
    if (isLocked) {
      return Colors.grey;
    } else if (isCompleted) {
      return AppColors.arrowGreen.withOpacity(0.8);
    } else {
      // Return a color based on the level pack
      switch (metadata.levelPack) {
        case 'Tranquil Beginnings':
          return AppColors.arrowBlue;
        case 'Colorful Maze':
          return AppColors.arrowTerracotta;
        case 'Core Challenge':
          return AppColors.arrowPink;
        default:
          return AppColors.arrowGreen;
      }
    }
  }
}

/// Custom painter for grid pattern background
class _GridPatternPainter extends CustomPainter {
  final Color color;
  final int lineCount;

  _GridPatternPainter({required this.color, this.lineCount = 3});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw horizontal lines
    final spacing = size.height / (lineCount + 1);
    for (int i = 1; i <= lineCount; i++) {
      final y = spacing * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    final spacingV = size.width / (lineCount + 1);
    for (int i = 1; i <= lineCount; i++) {
      final x = spacingV * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
