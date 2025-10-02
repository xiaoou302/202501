import 'package:flutter/material.dart';
import 'arrow_tile.dart';

/// Represents an obstacle tile that cannot be removed
class ObstacleTile extends ArrowTile {
  /// Type of obstacle
  final ObstacleType type;

  ObstacleTile({
    required int id,
    required this.type,
    required Color color,
    required int row,
    required int column,
  }) : super(
         id: id,
         direction: ArrowDirection.up, // Direction doesn't matter for obstacles
         color: color,
         row: row,
         column: column,
         isRemoved: false,
       );

  /// Create a copy of this obstacle with updated properties
  @override
  ObstacleTile copyWith({
    int? id,
    ArrowDirection? direction,
    Color? color,
    bool? isRemoved,
    int? row,
    int? column,
    ObstacleType? type,
  }) {
    return ObstacleTile(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }

  /// Check if this tile is an obstacle
  bool get isObstacle => true;
}

/// Types of obstacles
enum ObstacleType { stone, ice, metal }
