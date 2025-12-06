import 'package:flutter/material.dart';

enum TileType { wan, tong, tiao }

class MahjongTile {
  final int id;
  final TileType type;
  final int number;
  bool isActive;
  bool isRevealed;
  bool isHinted;

  MahjongTile({
    required this.id,
    required this.type,
    required this.number,
    this.isActive = true,
    this.isRevealed = false,
    this.isHinted = false,
  });

  MahjongTile copyWith({
    int? id,
    TileType? type,
    int? number,
    bool? isActive,
    bool? isRevealed,
    bool? isHinted,
  }) {
    return MahjongTile(
      id: id ?? this.id,
      type: type ?? this.type,
      number: number ?? this.number,
      isActive: isActive ?? this.isActive,
      isRevealed: isRevealed ?? this.isRevealed,
      isHinted: isHinted ?? this.isHinted,
    );
  }

  Color get numberColor {
    switch (type) {
      case TileType.wan:
        return const Color(0xFFB7312C);
      case TileType.tiao:
        return const Color(0xFF0E6655);
      case TileType.tong:
        return const Color(0xFF1B4F72);
    }
  }
}
