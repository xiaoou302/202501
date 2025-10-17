import 'mahjong_tile_model.dart';

/// Model representing the history of a move for undo functionality
class MoveHistory {
  /// The tile that was moved
  final MahjongTile tile;

  /// Where the tile was moved from ('board' or 'hand')
  final String from;

  /// Constructor
  const MoveHistory({required this.tile, required this.from});

  /// Creates a copy of this move history with the given fields replaced with new values
  MoveHistory copyWith({MahjongTile? tile, String? from}) {
    return MoveHistory(tile: tile ?? this.tile, from: from ?? this.from);
  }

  /// Creates a MoveHistory from a map
  factory MoveHistory.fromMap(Map<String, dynamic> map) {
    return MoveHistory(
      tile: MahjongTile.fromMap(map['tile'] as Map<String, dynamic>),
      from: map['from'] as String,
    );
  }

  /// Converts this MoveHistory to a map
  Map<String, dynamic> toMap() {
    return {'tile': tile.toMap(), 'from': from};
  }

  @override
  String toString() => 'MoveHistory(tile: $tile, from: $from)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoveHistory && other.tile == tile && other.from == from;
  }

  @override
  int get hashCode => tile.hashCode ^ from.hashCode;
}
