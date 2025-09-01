import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// 节奏游戏方块组件
class RhythmTile extends StatefulWidget {
  /// 是否激活（被点击）
  final bool isActive;
  
  const RhythmTile({
    super.key,
    this.isActive = false,
  });

  @override
  State<RhythmTile> createState() => _RhythmTileState();
}

class _RhythmTileState extends State<RhythmTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    if (widget.isActive) {
      _animationController.value = 1.0;
    }
  }
  
  @override
  void didUpdateWidget(RhythmTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
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
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: widget.isActive ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
          border: Border(
            top: BorderSide(
              color: AppColors.primary.withOpacity(0.5),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
