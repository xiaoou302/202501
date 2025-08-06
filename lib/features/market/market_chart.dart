import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Interactive chart for price trends
class MarketChart extends StatelessWidget {
  final List<double> data;
  final String trend;
  final double height;

  const MarketChart({
    Key? key,
    required this.data,
    required this.trend,
    this.height = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = trend == 'up' ? AppColors.fieryRed : AppColors.coolBlue;

    return Container(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: ChartPainter(data: data, color: color),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  ChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.5), color.withOpacity(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Find min and max values for scaling
    final double minValue = data.reduce((a, b) => a < b ? a : b);
    final double maxValue = data.reduce((a, b) => a > b ? a : b);
    final double range = maxValue - minValue;

    // Create path for the line
    final path = Path();
    final fillPath = Path();

    // Calculate point spacing
    final double xStep = size.width / (data.length - 1);

    // Start paths
    path.moveTo(0, _getY(data[0], minValue, range, size.height));
    fillPath.moveTo(0, _getY(data[0], minValue, range, size.height));

    // Add points to the paths
    for (int i = 1; i < data.length; i++) {
      final double x = i * xStep;
      final double y = _getY(data[i], minValue, range, size.height);

      // For a smoother curve, use quadratic bezier
      if (i < data.length - 1) {
        final double nextX = (i + 1) * xStep;
        final double nextY = _getY(data[i + 1], minValue, range, size.height);

        final double controlX = x + (nextX - x) / 2;

        path.quadraticBezierTo(controlX, y, nextX, nextY);
        fillPath.quadraticBezierTo(controlX, y, nextX, nextY);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Complete the fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Draw the fill and the line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  double _getY(double value, double min, double range, double height) {
    // Normalize and invert (0 at top, 1 at bottom)
    final double normalizedValue = range != 0 ? (value - min) / range : 0.5;
    return height - (normalizedValue * height);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
