import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/tile_model.dart';
import '../../core/constants.dart';
import 'tile_content.dart';

class MahjongTileWidget extends StatefulWidget {
  final MahjongTile tile;
  final VoidCallback onTap;
  final int gridColumns;

  const MahjongTileWidget({
    super.key,
    required this.tile,
    required this.onTap,
    this.gridColumns = 5,
  });

  @override
  State<MahjongTileWidget> createState() => _MahjongTileWidgetState();
}

class _MahjongTileWidgetState extends State<MahjongTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Set initial animation state based on isRevealed
    if (widget.tile.isRevealed) {
      _controller.value = 1.0; // Show front
    } else {
      _controller.value = 0.0; // Show back
    }
  }

  @override
  void didUpdateWidget(MahjongTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tile.isRevealed != oldWidget.tile.isRevealed) {
      if (widget.tile.isRevealed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 根据列数动态计算内边距
  double _getContentPadding() {
    switch (widget.gridColumns) {
      case 4:
        return 6.0;
      case 5:
        return 5.0;
      case 6:
        return 4.0;
      case 7:
        return 3.5;
      case 8:
        return 3.0;
      default:
        return 5.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.tile.isActive ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value;
          final isFront = angle > math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: _buildFront(),
                  )
                : _buildBack(),
          );
        },
      ),
    );
  }

  Widget _buildBack() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.jadeGreen,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: widget.tile.isHinted
                ? AppColors.fluoroGreen
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: widget.tile.isHinted
              ? [
                  BoxShadow(
                    color: AppColors.fluoroGreen.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Diagonal stripe pattern using CustomPaint
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CustomPaint(
                  painter: DiagonalStripePainter(),
                ),
              ),
            ),
            // Center decorative frame
            Center(
              child: Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFront() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Stack(
        children: [
          // Main tile body
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF9F3E3), Color(0xFFF2EBD9)],
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
                // Inner highlight
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                  spreadRadius: -2,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Number indicator
                Positioned(
                  top: 2,
                  left: 4,
                  child: Text(
                    widget.tile.number.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: widget.tile.numberColor.withOpacity(0.6),
                    ),
                  ),
                ),
                // Tile content - centered with FittedBox to prevent overflow
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(_getContentPadding()),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: 100,
                        height: 140,
                        child: Center(
                          child: TileContent(
                            type: widget.tile.type,
                            number: widget.tile.number,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom shadow (3D effect)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF0b4f42).withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for diagonal stripes on tile back
class DiagonalStripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw diagonal lines at 45 degrees
    for (double i = -size.height; i < size.width + size.height; i += 8) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
