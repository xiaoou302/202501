import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';

class SimpleRadarChart extends StatelessWidget {
  final Map<String, double> data; // Labels and values (0-10)
  final double size;

  const SimpleRadarChart({super.key, required this.data, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _RadarPainter(data)),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Map<String, double> data;

  _RadarPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY) * 0.8;
    final center = Offset(centerX, centerY);

    final Paint gridPaint = Paint()
      ..color = ColorPalette.concreteDark.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Gradient Fill for a premium look
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    final Gradient gradient = RadialGradient(
      colors: [
        ColorPalette.rustedCopper.withOpacity(0.4),
        ColorPalette.rustedCopper.withOpacity(0.05),
      ],
      stops: const [0.0, 1.0],
    );

    final Paint fillPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = ColorPalette.rustedCopper
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;

    final int sides = data.length;
    final double angleStep = (2 * pi) / sides;

    // Draw Grid (5 levels for more detail)
    for (int i = 1; i <= 5; i++) {
      final double r = radius * (i / 5);
      final Path path = Path();
      for (int j = 0; j < sides; j++) {
        final double angle = j * angleStep - (pi / 2);
        final double x = centerX + r * cos(angle);
        final double y = centerY + r * sin(angle);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw Axes and Labels
    final List<String> keys = data.keys.toList();
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < sides; i++) {
      final double angle = i * angleStep - (pi / 2);
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);

      // Draw Labels
      textPainter.text = TextSpan(
        text: keys[i].toUpperCase(),
        style: AppTheme.monoStyle.copyWith(
          fontSize: 8,
          color: ColorPalette.matteSteel,
        ),
      );
      textPainter.layout();

      // Position label slightly outside
      final double labelR = radius + 15;
      final double labelX =
          centerX + labelR * cos(angle) - (textPainter.width / 2);
      final double labelY =
          centerY + labelR * sin(angle) - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(labelX, labelY));
    }

    // Draw Data Shape
    final Path dataPath = Path();
    int i = 0;
    for (final entry in data.entries) {
      final double value = entry.value;
      final double normalized = value / 10.0; // Assume max 10
      final double r = radius * normalized;
      final double angle = i * angleStep - (pi / 2);
      final double x = centerX + r * cos(angle);
      final double y = centerY + r * sin(angle);
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
      i++;
    }
    dataPath.close();
    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
