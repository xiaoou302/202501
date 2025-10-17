/// Model representing a mahjong tile in the game
class MahjongTile {
  /// Unique identifier for the tile
  final String id;

  /// Type of the tile (e.g., 'w1', 't2', 'fE')
  final String type;

  /// X position on the board
  final double x;

  /// Y position on the board
  final double y;

  /// Z-index (layer) on the board
  final int z;

  /// Whether the tile is selectable (not blocked by other tiles)
  final bool isSelectable;

  /// Constructor
  const MahjongTile({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    this.isSelectable = false,
  });

  /// Creates a copy of this tile with the given fields replaced with new values
  MahjongTile copyWith({
    String? id,
    String? type,
    double? x,
    double? y,
    int? z,
    bool? isSelectable,
  }) {
    return MahjongTile(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      isSelectable: isSelectable ?? this.isSelectable,
    );
  }

  /// Creates a MahjongTile from a map
  factory MahjongTile.fromMap(Map<String, dynamic> map) {
    return MahjongTile(
      id: map['id'] as String,
      type: map['type'] as String,
      x: map['x'] as double,
      y: map['y'] as double,
      z: map['z'] as int,
      isSelectable: map['isSelectable'] as bool? ?? false,
    );
  }

  /// Converts this MahjongTile to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'x': x,
      'y': y,
      'z': z,
      'isSelectable': isSelectable,
    };
  }

  @override
  String toString() {
    return 'MahjongTile(id: $id, type: $type, x: $x, y: $y, z: $z, isSelectable: $isSelectable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MahjongTile &&
        other.id == id &&
        other.type == type &&
        other.x == x &&
        other.y == y &&
        other.z == z &&
        other.isSelectable == isSelectable;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        x.hashCode ^
        y.hashCode ^
        z.hashCode ^
        isSelectable.hashCode;
  }
}
