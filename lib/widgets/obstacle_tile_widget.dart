import 'package:flutter/material.dart';
import '../models/obstacle_tile.dart';
import '../utils/constants.dart';

/// Widget for displaying an obstacle tile
class ObstacleTileWidget extends StatelessWidget {
  /// The obstacle tile to display
  final ObstacleTile tile;

  const ObstacleTileWidget({Key? key, required this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getBaseColor(),
        borderRadius: BorderRadius.circular(UIConstants.tileBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: _buildObstacleIcon()),
    );
  }

  /// Get the base color for the obstacle
  Color _getBaseColor() {
    switch (tile.type) {
      case ObstacleType.stone:
        return const Color(0xFF8A8A8A); // Gray stone color
      case ObstacleType.ice:
        return const Color(0xFFADE0FF); // Light blue ice color
      case ObstacleType.metal:
        return const Color(0xFFB8B8B8); // Silver metal color
    }
  }

  /// Build the icon for the obstacle
  Widget _buildObstacleIcon() {
    IconData iconData;
    Color iconColor;

    switch (tile.type) {
      case ObstacleType.stone:
        iconData = Icons.circle;
        iconColor = const Color(0xFF5A5A5A);
        break;
      case ObstacleType.ice:
        iconData = Icons.ac_unit;
        iconColor = Colors.white;
        break;
      case ObstacleType.metal:
        iconData = Icons.shield;
        iconColor = const Color(0xFF707070);
        break;
    }

    return Icon(iconData, color: iconColor, size: 32);
  }
}
