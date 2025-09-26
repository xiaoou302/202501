import 'package:flutter/material.dart';

/// 自定义页面过渡动画
class PageTransitions {
  // 淡入淡出过渡
  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: duration,
    );
  }

  // 滑动过渡
  static PageRouteBuilder<T> slideTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    SlideDirection direction = SlideDirection.right,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;

        switch (direction) {
          case SlideDirection.right:
            begin = const Offset(1.0, 0.0);
            break;
          case SlideDirection.left:
            begin = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.up:
            begin = const Offset(0.0, 1.0);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, -1.0);
            break;
        }

        const Offset end = Offset.zero;
        const Curve curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: duration,
    );
  }

  // 缩放过渡
  static PageRouteBuilder<T> scaleTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Alignment alignment = Alignment.center,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          alignment: alignment,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // 组合过渡（缩放+淡入）
  static PageRouteBuilder<T> scaleAndFadeTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }
}

/// 滑动方向枚举
enum SlideDirection { right, left, up, down }
