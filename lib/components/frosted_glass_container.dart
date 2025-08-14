import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

/// 磨砂玻璃容器组件，用于创建毛玻璃效果
class FrostedGlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double blurAmount;
  final BoxBorder? border;

  const FrostedGlassContainer({
    Key? key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor,
    this.blurAmount = 10.0,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          decoration: BoxDecoration(
            color:
                backgroundColor ?? AppTheme.surfaceBackground.withOpacity(0.7),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// 磨砂玻璃卡片组件，用于创建带阴影的毛玻璃效果卡片
class FrostedGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final double blurAmount;
  final double elevation;

  const FrostedGlassCard({
    Key? key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
    this.backgroundColor,
    this.blurAmount = 10.0,
    this.elevation = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: FrostedGlassContainer(
        borderRadius: borderRadius,
        padding: padding,
        backgroundColor: backgroundColor,
        blurAmount: blurAmount,
        child: child,
      ),
    );
  }
}
