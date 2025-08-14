import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Pulse glow animation component
class PulseGlowAnimation extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final Duration duration;

  const PulseGlowAnimation({
    Key? key,
    required this.child,
    this.glowColor = const Color(0xFFFF9500),
    this.duration = const Duration(milliseconds: 2500),
  }) : super(key: key);

  @override
  State<PulseGlowAnimation> createState() => _PulseGlowAnimationState();
}

class _PulseGlowAnimationState extends State<PulseGlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.5),
                blurRadius: _animation.value,
                spreadRadius: _animation.value / 2,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Liquid flow animation component
class LiquidFlowAnimation extends StatefulWidget {
  final Color color;
  final double strokeWidth;
  final Duration duration;
  final double width;
  final double height;

  const LiquidFlowAnimation({
    Key? key,
    required this.color,
    this.strokeWidth = 3.0,
    this.duration = const Duration(seconds: 5),
    this.width = 100,
    this.height = 50,
  }) : super(key: key);

  @override
  State<LiquidFlowAnimation> createState() => _LiquidFlowAnimationState();
}

class _LiquidFlowAnimationState extends State<LiquidFlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
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
          painter: _LiquidPainter(
            animation: _controller,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final double strokeWidth;

  _LiquidPainter({
    required this.animation,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height;
    final waveHeight = height * 0.2;
    final waveWidth = width * 0.5;
    final offset = animation.value * width;

    path.moveTo(0, height / 2);

    for (double i = 0; i <= width; i += 1) {
      final x = i;
      final sinValue = math.sin((i - offset) / waveWidth * 2 * math.pi);
      final y = height / 2 + sinValue * waveHeight;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LiquidPainter oldDelegate) => true;
}
