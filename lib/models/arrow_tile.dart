import 'package:flutter/material.dart';

/// Enum representing the four possible arrow directions
enum ArrowDirection { up, down, left, right }

/// Model class for an arrow tile in the game grid
class ArrowTile {
  /// Unique identifier for the tile
  final int id;

  /// Direction the arrow is pointing
  final ArrowDirection direction;

  /// Color of the tile
  final Color color;

  /// Whether the tile has been removed from the grid
  bool isRemoved;

  /// Position in the grid (row, column)
  final int row;
  final int column;

  ArrowTile({
    required this.id,
    required this.direction,
    required this.color,
    required this.row,
    required this.column,
    this.isRemoved = false,
  });

  /// Get the direction as a string for icon selection
  String get directionString {
    switch (direction) {
      case ArrowDirection.up:
        return 'up';
      case ArrowDirection.down:
        return 'down';
      case ArrowDirection.left:
        return 'left';
      case ArrowDirection.right:
        return 'right';
    }
  }

  /// Check if this tile is an obstacle
  bool get isObstacle => false;

  /// Create a copy of this tile with updated properties
  ArrowTile copyWith({
    int? id,
    ArrowDirection? direction,
    Color? color,
    bool? isRemoved,
    int? row,
    int? column,
  }) {
    return ArrowTile(
      id: id ?? this.id,
      direction: direction ?? this.direction,
      color: color ?? this.color,
      isRemoved: isRemoved ?? this.isRemoved,
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }
}
