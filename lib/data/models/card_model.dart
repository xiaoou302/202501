import 'package:flutter/material.dart';

class CardModel {
  final int id;
  final IconData icon;
  final Color color;
  bool isFlipped;
  bool isMatched;

  CardModel({
    required this.id,
    required this.icon,
    required this.color,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardModel copyWith({bool? isFlipped, bool? isMatched}) {
    return CardModel(
      id: id,
      icon: icon,
      color: color,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
