import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_feedback.dart';

/// 发光效果按钮组件
class GlowButton extends StatefulWidget {
  /// 按钮文本
  final String text;

  /// 按钮点击回调
  final VoidCallback onPressed;

  /// 按钮宽度
  final double? width;

  /// 按钮高度
  final double height;

  /// 按钮颜色
  final Color color;

  /// 文本颜色
  final Color textColor;

  /// 按钮图标
  final IconData? icon;

  /// 是否禁用
  final bool disabled;

  /// 是否是小型按钮
  final bool small;

  const GlowButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 56,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.icon,
    this.disabled = false,
    this.small = false,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final HapticFeedbackManager _hapticFeedback = HapticFeedbackManager();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (!widget.disabled) {
            _animationController.forward();
            _hapticFeedback.lightImpact();
          }
        },
        onTapUp: (_) {
          if (!widget.disabled) {
            _animationController.reverse();
            widget.onPressed();
          }
        },
        onTapCancel: () {
          if (!widget.disabled) {
            _animationController.reverse();
          }
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.disabled
                ? widget.color.withOpacity(0.5)
                : widget.color,
            borderRadius: BorderRadius.circular(widget.small ? 20 : 30),
            boxShadow: widget.disabled
                ? []
                : [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: widget.textColor,
                    size: widget.small ? 16 : 20,
                  ),
                  SizedBox(width: widget.small ? 6 : 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.small ? 14 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
