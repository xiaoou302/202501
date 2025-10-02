import 'package:flutter/material.dart';
import '../services/achievement_service.dart';
import '../utils/constants.dart';
import 'dart:math' as math;

/// Widget for displaying an achievement unlock notification
class AchievementUnlockNotification extends StatefulWidget {
  /// Achievement that was unlocked
  final Achievement achievement;

  /// Optional callback when notification is dismissed
  final VoidCallback? onDismiss;

  const AchievementUnlockNotification({
    Key? key,
    required this.achievement,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<AchievementUnlockNotification> createState() =>
      _AchievementUnlockNotificationState();
}

class _AchievementUnlockNotificationState
    extends State<AchievementUnlockNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _shineController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Slide in animation
    _slideController = AnimationController(
      vsync: this,
      duration: AnimationDurations.medium,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Shine effect animation
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Scale pulse animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Start animations
    _slideController.forward();
    _shineController.repeat();
    _scaleController.forward();

    // Auto dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _shineController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _slideController.reverse().then((_) {
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: GestureDetector(
          onTap: _dismiss,
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: widget.achievement.iconColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Achievement icon with animation
                _buildAnimatedIcon(),

                const SizedBox(width: 16.0),

                // Achievement details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Achievement Unlocked!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentCoral,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        widget.achievement.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGraphite,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        widget.achievement.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.disabledGray,
                        ),
                      ),
                    ],
                  ),
                ),

                // Close button
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 16.0,
                    color: AppColors.disabledGray,
                  ),
                  onPressed: _dismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _scaleController,
      builder: (context, child) {
        final pulseValue =
            1.0 + 0.1 * math.sin(_scaleController.value * math.pi * 2);

        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.achievement.iconColor.withOpacity(0.1),
            border: Border.all(
              color: widget.achievement.iconColor.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse effect
              Transform.scale(
                scale: pulseValue,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.achievement.iconColor.withOpacity(0.05),
                  ),
                ),
              ),

              // Icon
              Icon(
                widget.achievement.icon,
                size: 26,
                color: widget.achievement.iconColor,
              ),

              // Shine effect
              AnimatedBuilder(
                animation: _shineController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _shineController.value * 2 * math.pi,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
