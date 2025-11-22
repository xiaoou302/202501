import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 大自然主题装饰组件
/// 可以在界面各处添加动物、植物等装饰元素
class NatureDecoration extends StatelessWidget {
  final NatureDecorationType type;
  final double size;
  final Color? color;

  const NatureDecoration({
    Key? key,
    required this.type,
    this.size = 24,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      _getIcon(),
      size: size,
      color: color ?? _getDefaultColor(),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case NatureDecorationType.leaf:
        return FontAwesomeIcons.leaf;
      case NatureDecorationType.tree:
        return FontAwesomeIcons.tree;
      case NatureDecorationType.seedling:
        return FontAwesomeIcons.seedling;
      case NatureDecorationType.mountain:
        return FontAwesomeIcons.mountain;
      case NatureDecorationType.sun:
        return FontAwesomeIcons.sun;
      case NatureDecorationType.moon:
        return FontAwesomeIcons.moon;
      case NatureDecorationType.star:
        return FontAwesomeIcons.star;
      case NatureDecorationType.water:
        return FontAwesomeIcons.water;
      case NatureDecorationType.fire:
        return FontAwesomeIcons.fire;
      case NatureDecorationType.wind:
        return FontAwesomeIcons.wind;
    }
  }

  Color _getDefaultColor() {
    switch (type) {
      case NatureDecorationType.leaf:
      case NatureDecorationType.tree:
      case NatureDecorationType.seedling:
        return const Color(0xFF2ECC71);
      case NatureDecorationType.mountain:
        return const Color(0xFF95A5A6);
      case NatureDecorationType.sun:
        return const Color(0xFFF1C40F);
      case NatureDecorationType.moon:
        return const Color(0xFFDFE6E9);
      case NatureDecorationType.star:
        return const Color(0xFFF1C40F);
      case NatureDecorationType.water:
        return const Color(0xFF3498DB);
      case NatureDecorationType.fire:
        return const Color(0xFFE74C3C);
      case NatureDecorationType.wind:
        return const Color(0xFF00CEC9);
    }
  }
}

enum NatureDecorationType {
  leaf,
  tree,
  seedling,
  mountain,
  sun,
  moon,
  star,
  water,
  fire,
  wind,
}

/// 浮动动画装饰组件
class FloatingNatureIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final Duration duration;

  const FloatingNatureIcon({
    Key? key,
    required this.icon,
    required this.color,
    this.size = 16,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<FloatingNatureIcon> createState() => _FloatingNatureIconState();
}

class _FloatingNatureIconState extends State<FloatingNatureIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: FaIcon(
            widget.icon,
            size: widget.size,
            color: widget.color,
          ),
        );
      },
    );
  }
}

/// 旋转的叶子装饰
class RotatingLeaf extends StatefulWidget {
  final Color color;
  final double size;

  const RotatingLeaf({
    Key? key,
    this.color = const Color(0xFF2ECC71),
    this.size = 20,
  }) : super(key: key);

  @override
  State<RotatingLeaf> createState() => _RotatingLeafState();
}

class _RotatingLeafState extends State<RotatingLeaf>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: FaIcon(
            FontAwesomeIcons.leaf,
            size: widget.size,
            color: widget.color.withOpacity(0.6),
          ),
        );
      },
    );
  }
}

/// 脉冲发光效果的图标
class PulsingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const PulsingIcon({
    Key? key,
    required this.icon,
    required this.color,
    this.size = 24,
  }) : super(key: key);

  @override
  State<PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        return Transform.scale(
          scale: _animation.value,
          child: FaIcon(
            widget.icon,
            size: widget.size,
            color: widget.color.withOpacity(0.8),
          ),
        );
      },
    );
  }
}

