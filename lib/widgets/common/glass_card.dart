import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';

/// 玻璃态卡片组件
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color borderColor;
  final bool isGlowing;
  final Color glowColor;
  final VoidCallback? onTap;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius,
    this.borderColor = Colors.transparent,
    this.isGlowing = false,
    this.glowColor = AppColors.primaryAccent,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppStyles.radiusMedium),
          border: Border.all(color: borderColor.withOpacity(0.2), width: 1),
          boxShadow: isGlowing
              ? [
                  BoxShadow(
                    color: glowColor.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: glowColor.withOpacity(0.6),
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppStyles.radiusMedium),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withOpacity(0.5),
                borderRadius:
                    borderRadius ??
                    BorderRadius.circular(AppStyles.radiusMedium),
              ),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
