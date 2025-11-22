import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({Key? key}) : super(key: key);

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Create 30 particles with different types
    for (int i = 0; i < 30; i++) {
      _particles.add(Particle.random());
    }

    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: NatureParticlePainter(
              particles: _particles,
              animationValue: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

enum ParticleType { circle, leaf, star, hexagon }

class Particle {
  final Offset position;
  final double size;
  final double speed;
  final double opacity;
  final ParticleType type;
  final double rotation;
  final Color color;

  const Particle({
    required this.position,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.type,
    required this.rotation,
    required this.color,
  });

  factory Particle.random() {
    final random = Random();
    final types = ParticleType.values;

    // Nature-themed colors
    final colors = [
      const Color(0xFF2ECC71), // Green
      const Color(0xFF27AE60), // Dark Green
      const Color(0xFF00CEC9), // Turquoise
      const Color(0xFF3498DB), // Blue
      const Color(0xFFF1C40F), // Yellow
    ];

    return Particle(
      position: Offset(random.nextDouble(), random.nextDouble()),
      size: random.nextDouble() * 6 + 3,
      speed: random.nextDouble() * 0.3 + 0.2,
      opacity: random.nextDouble() * 0.3 + 0.1,
      type: types[random.nextInt(types.length)],
      rotation: random.nextDouble() * 2 * pi,
      color: colors[random.nextInt(colors.length)],
    );
  }
}

class NatureParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  NatureParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      final x = particle.position.dx * size.width;
      final y =
          (particle.position.dy + animationValue * particle.speed) %
          1.0 *
          size.height;

      // Calculate rotation with time
      final currentRotation = particle.rotation + (animationValue * pi * 0.5);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(currentRotation);

      switch (particle.type) {
        case ParticleType.circle:
          canvas.drawCircle(Offset.zero, particle.size, paint);
          break;
        case ParticleType.leaf:
          _drawLeaf(canvas, particle.size, paint);
          break;
        case ParticleType.star:
          _drawStar(canvas, particle.size, paint);
          break;
        case ParticleType.hexagon:
          _drawHexagon(canvas, particle.size, paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawLeaf(Canvas canvas, double size, Paint paint) {
    final path = Path();
    path.moveTo(0, -size);
    path.quadraticBezierTo(size * 0.5, -size * 0.5, size * 0.3, 0);
    path.quadraticBezierTo(size * 0.5, size * 0.5, 0, size);
    path.quadraticBezierTo(-size * 0.5, size * 0.5, -size * 0.3, 0);
    path.quadraticBezierTo(-size * 0.5, -size * 0.5, 0, -size);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final double angle = (2 * pi) / 5;
    for (int i = 0; i < 5; i++) {
      final double x = size * cos(i * angle - pi / 2);
      final double y = size * sin(i * angle - pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      final double innerX = size * 0.4 * cos(i * angle + angle / 2 - pi / 2);
      final double innerY = size * 0.4 * sin(i * angle + angle / 2 - pi / 2);
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHexagon(Canvas canvas, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final double angle = (pi / 3) * i;
      final double x = size * cos(angle);
      final double y = size * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NatureParticlePainter oldDelegate) => true;
}
