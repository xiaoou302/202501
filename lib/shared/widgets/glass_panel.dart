import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? borderColor;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.deepTeal.withOpacity(
            0.85,
          ), // Increased opacity slightly since blur is gone
          borderRadius: borderRadius ?? BorderRadius.circular(24),
          border: Border.all(
            color: borderColor ?? AppColors.borderSubtle,
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
