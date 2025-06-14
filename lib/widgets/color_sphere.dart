import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/color_scheme.dart';

class ColorSphere extends StatelessWidget {
  final CustomColorScheme colorScheme;
  final double size;
  final bool animate;

  const ColorSphere({
    super.key,
    required this.colorScheme,
    this.size = 150,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    // 创建球体的渐变色
    final primaryColor = colorScheme.primaryColor;
    final complementaryColor = colorScheme.complementaryColor;

    // 构建球体
    Widget sphere = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            primaryColor,
            HSLColor.fromColor(primaryColor)
                .withLightness((colorScheme.lightness - 20).clamp(0, 100) / 100)
                .toColor(),
          ],
          center: const Alignment(0.3, -0.3), // 光源位置
          focal: const Alignment(0.2, -0.2),
          focalRadius: 0.2,
          radius: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: complementaryColor.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
    );

    // 添加高光效果
    final highlight = Positioned(
      top: size * 0.2,
      left: size * 0.2,
      child: Container(
        width: size * 0.3,
        height: size * 0.3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.6),
              Colors.white.withOpacity(0),
            ],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );

    // 添加小高光效果
    final smallHighlight = Positioned(
      top: size * 0.15,
      left: size * 0.6,
      child: Container(
        width: size * 0.1,
        height: size * 0.1,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0),
            ],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );

    // 组合球体和高光
    Widget result = Stack(children: [sphere, highlight, smallHighlight]);

    // 添加动画效果
    if (animate) {
      result = result
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            duration: 3.seconds,
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
            curve: Curves.easeInOut,
          )
          .then()
          .scale(
            duration: 2.seconds,
            begin: const Offset(1, 1),
            end: const Offset(0.95, 0.95),
            curve: Curves.easeInOut,
          );
    }

    return result;
  }
}
