import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// 新拟态风格卡片组件
class NeumorphicCard extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 卡片高度
  final double? height;

  /// 卡片宽度
  final double? width;

  /// 卡片边距
  final EdgeInsetsGeometry? margin;

  /// 卡片内边距
  final EdgeInsetsGeometry padding;

  /// 卡片圆角
  final double borderRadius;

  /// 是否使用凹陷效果
  final bool isInset;

  /// 是否添加发光效果
  final bool glow;

  /// 卡片背景色
  final Color? backgroundColor;

  /// 卡片边框
  final Border? border;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.isInset = false,
    this.glow = false,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        backgroundColor ??
        (isInset ? AppColors.cardBackground : const Color(0xFF2A2A2A));

    final List<BoxShadow> shadows = isInset
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(5, 5),
              blurRadius: 10,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.grey.shade800.withOpacity(0.5),
              offset: const Offset(-5, -5),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              offset: const Offset(8, 8),
              blurRadius: 16,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.grey.shade800.withOpacity(0.5),
              offset: const Offset(-8, -8),
              blurRadius: 16,
              spreadRadius: -2,
            ),
          ];

    // 添加发光效果
    if (glow) {
      shadows.add(
        BoxShadow(
          color: AppColors.primary.withOpacity(0.4),
          blurRadius: 15,
          spreadRadius: 2,
        ),
      );
    }

    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
        border: border,
        gradient: isInset
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey.shade800, const Color(0xFF2A2A2A)],
              ),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
