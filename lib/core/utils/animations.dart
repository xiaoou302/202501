import 'package:flutter/material.dart';

/// 自定义动画组件
class Animations {
  // 淡入动画组件
  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeIn,
    double begin = 0.0,
    double end = 1.0,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(opacity: value, child: child);
      },
      child: delay > 0
          ? FutureBuilder(
              future: Future.delayed(Duration(milliseconds: delay)),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? child
                    : const SizedBox.shrink();
              },
            )
          : child,
    );
  }

  // 滑动动画组件
  static Widget slideIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOut,
    Offset begin = const Offset(0.0, 0.2),
    Offset end = Offset.zero,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (BuildContext context, Offset value, Widget? child) {
        return Transform.translate(
          offset: value * 100, // 乘以系数使位移更明显
          child: child,
        );
      },
      child: delay > 0
          ? FutureBuilder(
              future: Future.delayed(Duration(milliseconds: delay)),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? child
                    : const SizedBox.shrink();
              },
            )
          : child,
    );
  }

  // 缩放动画组件
  static Widget scaleIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.elasticOut,
    double begin = 0.8,
    double end = 1.0,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(scale: value, child: child);
      },
      child: delay > 0
          ? FutureBuilder(
              future: Future.delayed(Duration(milliseconds: delay)),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? child
                    : const SizedBox.shrink();
              },
            )
          : child,
    );
  }

  // 组合动画：淡入+滑动
  static Widget fadeSlideIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOut,
    Offset slideBegin = const Offset(0.0, 0.2),
    double fadeBegin = 0.0,
    int delay = 0,
  }) {
    return fadeIn(
      begin: fadeBegin,
      duration: duration,
      curve: curve,
      delay: delay,
      child: slideIn(
        begin: slideBegin,
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }

  // 脉冲动画
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    double minScale = 0.97,
    double maxScale = 1.03,
  }) {
    return _PulseAnimation(
      duration: duration,
      minScale: minScale,
      maxScale: maxScale,
      child: child,
    );
  }
}

// 脉冲动画组件
class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const _PulseAnimation({
    required this.child,
    required this.duration,
    required this.minScale,
    required this.maxScale,
  });

  @override
  _PulseAnimationState createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: widget.maxScale),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.maxScale, end: widget.minScale),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.minScale, end: 1.0),
        weight: 1,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: child);
      },
      child: widget.child,
    );
  }
}
