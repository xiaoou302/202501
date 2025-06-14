import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RadialProgress extends StatefulWidget {
  final double percentage; // 0-100
  final double size;
  final Widget child;
  final List<Color> progressColors;
  final Color backgroundColor;
  final Duration animationDuration;

  const RadialProgress({
    super.key,
    required this.percentage,
    this.size = 220,
    required this.child,
    this.progressColors = const [
      AppColors.electricBlue,
      AppColors.hologramPurple,
      Color(0xFFff4d94),
    ],
    this.backgroundColor = AppColors.deepSpace,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<RadialProgress> createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _percentageAnimation;
  double _oldPercentage = 0;

  @override
  void initState() {
    super.initState();
    _oldPercentage = 0;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _percentageAnimation = Tween<double>(
      begin: _oldPercentage,
      end: widget.percentage,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(RadialProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _oldPercentage = oldWidget.percentage;
      _percentageAnimation = Tween<double>(
        begin: _oldPercentage,
        end: widget.percentage,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _percentageAnimation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RadialProgressPainter(
              percentage: _percentageAnimation.value,
              progressColors: widget.progressColors,
              backgroundColor: widget.backgroundColor,
            ),
            child: Center(child: widget.child),
          ),
        );
      },
    );
  }
}

class _RadialProgressPainter extends CustomPainter {
  final double percentage;
  final List<Color> progressColors;
  final Color backgroundColor;

  _RadialProgressPainter({
    required this.percentage,
    required this.progressColors,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // 绘制背景圆
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // 添加外圈光晕效果
    final outerGlowPaint = Paint()
      ..color = progressColors.first.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawCircle(center, radius - 5, outerGlowPaint);

    // 绘制进度条
    if (percentage > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);

      // 创建渐变色
      final gradient = SweepGradient(
        colors: progressColors,
        stops: const [0.3, 0.7, 1.0],
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        transform: GradientRotation(-pi / 2),
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round;

      // 计算进度角度
      final sweepAngle = 2 * pi * (percentage / 100);

      // 绘制进度弧
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 10),
        -pi / 2, // 从顶部开始
        sweepAngle,
        false,
        progressPaint,
      );

      // 添加发光效果
      final glowPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 10),
        -pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );

      // 绘制进度点
      if (percentage < 100) {
        final pointAngle = -pi / 2 + sweepAngle;
        final pointX = center.dx + (radius - 10) * cos(pointAngle);
        final pointY = center.dy + (radius - 10) * sin(pointAngle);

        final pointPaint = Paint()
          ..color = progressColors[progressColors.length - 1]
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(pointX, pointY), 6, pointPaint);

        // 点的光晕
        final pointGlowPaint = Paint()
          ..color = progressColors[progressColors.length - 1].withOpacity(0.5)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

        canvas.drawCircle(Offset(pointX, pointY), 8, pointGlowPaint);
      }
    }

    // 绘制内圆（中心区域）
    final innerCirclePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius - 20, innerCirclePaint);

    // 添加内圆边框
    final innerBorderPaint = Paint()
      ..color = AppColors.hologramPurple.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, radius - 20, innerBorderPaint);

    // 添加内圈发光效果
    final innerGlowPaint = Paint()
      ..color = AppColors.hologramPurple.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center, radius - 25, innerGlowPaint);
  }

  @override
  bool shouldRepaint(covariant _RadialProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.progressColors != progressColors ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
