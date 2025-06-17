import 'package:flutter/material.dart';

class AnimatedParticle {
  final Offset initialPosition;
  final Offset finalPosition;
  final Color color;
  final double size;

  AnimatedParticle({
    required this.initialPosition,
    required this.finalPosition,
    required this.color,
    required this.size,
  });
}
