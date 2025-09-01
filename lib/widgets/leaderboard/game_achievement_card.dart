import 'package:flutter/material.dart';
import '../common/neumorphic_card.dart';

/// A card to display game achievements and progress
class GameAchievementCard extends StatelessWidget {
  /// The title of the game
  final String gameTitle;

  /// The game icon
  final IconData gameIcon;

  /// The primary color for this game
  final Color gameColor;

  /// The number of achievements completed
  final int achievementsCompleted;

  /// The total number of achievements
  final int totalAchievements;

  /// The best score achieved
  final int bestScore;

  /// The number of levels completed
  final int levelsCompleted;

  /// The total number of levels
  final int totalLevels;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  const GameAchievementCard({
    Key? key,
    required this.gameTitle,
    required this.gameIcon,
    required this.gameColor,
    required this.achievementsCompleted,
    required this.totalAchievements,
    required this.bestScore,
    required this.levelsCompleted,
    required this.totalLevels,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate completion percentage
    final achievementPercent = (achievementsCompleted / totalAchievements * 100)
        .round();
    final levelPercent = (levelsCompleted / totalLevels * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: NeumorphicCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game title and icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: gameColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(gameIcon, color: gameColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  gameTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: gameColor,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey[600]),
              ],
            ),
            const SizedBox(height: 16),

            // Best score
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Best Score:',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(width: 4),
                Text(
                  bestScore.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Achievements progress
            _buildProgressSection(
              'Achievements',
              '$achievementsCompleted/$totalAchievements',
              achievementPercent,
              Colors.purple,
            ),
            const SizedBox(height: 12),

            // Levels progress
            _buildProgressSection(
              'Levels',
              '$levelsCompleted/$totalLevels',
              levelPercent,
              gameColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    String label,
    String value,
    int percent,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            // Background
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Progress
            FractionallySizedBox(
              widthFactor: percent / 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
