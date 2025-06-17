import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme.dart';

class AnimatedBackground extends StatefulWidget {
  final int itemCount;
  final List<IconData> icons;

  const AnimatedBackground({
    super.key,
    this.itemCount = 15,
    this.icons = const [Icons.favorite, Icons.star, Icons.favorite_border],
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  final List<_FloatingItem> _items = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  void _initializeItems() {
    for (int i = 0; i < widget.itemCount; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 3000 + _random.nextInt(5000)),
      );

      final iconData = widget.icons[_random.nextInt(widget.icons.length)];
      final size = 8.0 + _random.nextDouble() * 16.0;
      final color = _getRandomColor();

      _items.add(_FloatingItem(
        controller: controller,
        position: Offset(
          _random.nextDouble(),
          _random.nextDouble(),
        ),
        size: size,
        icon: iconData,
        color: color,
        speed: 0.5 + _random.nextDouble() * 0.5,
      ));

      controller.repeat(reverse: true);
    }
  }

  Color _getRandomColor() {
    final colors = [
      AppTheme.accentPurple,
      AppTheme.lightPurple,
      Colors.pink.shade300,
      Colors.blue.shade300,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    for (var item in _items) {
      item.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: _items.map((item) {
            return AnimatedBuilder(
              animation: item.controller,
              builder: (context, child) {
                final x = constraints.maxWidth * item.position.dx;
                final y = constraints.maxHeight * item.position.dy;

                // Calculate floating movement
                final offset =
                    sin(item.controller.value * pi * 2) * 15.0 * item.speed;

                // Calculate opacity
                final opacity =
                    0.3 + (sin(item.controller.value * pi * 2) + 1) / 2 * 0.4;

                return Positioned(
                  left: x,
                  top: y + offset,
                  child: Opacity(
                    opacity: opacity,
                    child: Icon(
                      item.icon,
                      size: item.size,
                      color: item.color,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class _FloatingItem {
  final AnimationController controller;
  final Offset position;
  final double size;
  final IconData icon;
  final Color color;
  final double speed;

  _FloatingItem({
    required this.controller,
    required this.position,
    required this.size,
    required this.icon,
    required this.color,
    required this.speed,
  });
}
