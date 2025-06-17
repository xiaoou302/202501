import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme.dart';

class WaveAnimation extends StatefulWidget {
  final double height;
  final double width;
  final Color color;
  final double speed;
  final double amplitude;

  const WaveAnimation({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    this.speed = 1.0,
    this.amplitude = 20.0,
  });

  @override
  State<WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (5000 ~/ widget.speed)),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _WavePainter(
            animation: _controller,
            color: widget.color,
            amplitude: widget.amplitude,
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final double amplitude;

  _WavePainter({
    required this.animation,
    required this.color,
    required this.amplitude,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from the left edge
    path.moveTo(0, size.height * 0.5);

    // Draw the wave
    for (double i = 0; i < size.width; i++) {
      // Calculate the wave's y position
      final y = sin((i / size.width * 2 * pi) + (animation.value * 2 * pi)) *
              amplitude +
          (size.height * 0.5);

      path.lineTo(i, y);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => true;
}
