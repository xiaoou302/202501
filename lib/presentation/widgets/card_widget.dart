import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/card_model.dart';

class CardWidget extends StatefulWidget {
  final CardModel card;
  final VoidCallback onTap;
  final bool isLocked;
  final bool shouldShake;

  const CardWidget({
    Key? key,
    required this.card,
    required this.onTap,
    this.isLocked = false,
    this.shouldShake = false,
  }) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Flip animation controller with smooth easing curve
    _flipController = AnimationController(
      duration: AppDurations.cardFlip,
      vsync: this,
    );

    // Create smooth flip animation from 0 to π (180 degrees)
    _flipAnimation = Tween<double>(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut, // Smooth ease in/out for natural rotation
      ),
    );

    // Shake animation controller
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -5.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 5.0, end: -5.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 5.0, end: -3.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -3.0, end: 3.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 3.0, end: -1.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -1.0, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );

    // Initialize flip state based on card's current state
    if (widget.card.isFlipped) {
      _flipController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Detect flip state change and trigger animation
    if (widget.card.isFlipped != oldWidget.card.isFlipped) {
      if (widget.card.isFlipped) {
        // Flip to front (show icon)
        _flipController.forward();
      } else {
        // Flip to back (hide icon)
        _flipController.reverse();
      }
    }

    // Handle shake animation trigger
    if (widget.shouldShake && !oldWidget.shouldShake) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLocked ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipAnimation, _shakeAnimation]),
        builder: (context, child) {
          // Get current rotation angle (0 to π radians = 0 to 180 degrees)
          final angle = _flipAnimation.value;
          final shakeOffset = _shakeAnimation.value;

          return Transform(
            // Apply shake effect separately
            transform: Matrix4.identity()..translate(shakeOffset, 0.0, 0.0),
            alignment: Alignment.center,
            child: _build3DFlipCard(angle, angle > pi / 2),
          );
        },
      ),
    );
  }

  Widget _build3DFlipCard(double angle, bool showFront) {
    // Create 3D perspective transform for rotation effect
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective depth (lower = more dramatic)
      ..rotateY(angle); // Rotate around Y-axis

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: angle <= pi / 2
          ? _buildCardBack() // Show back when angle is 0 to 90 degrees
          : Transform(
              // Mirror the front side so it's not reversed
              transform: Matrix4.identity()..rotateY(pi),
              alignment: Alignment.center,
              child: _buildCardFront(),
            ),
    );
  }

  Widget _buildCardBack() {
    return AspectRatio(
      aspectRatio: 0.75, // 3:4 ratio for card
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.slate, AppColors.slate.withOpacity(0.85)],
          ),
          borderRadius: AppRadius.card,
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.electric.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative pattern
            Positioned.fill(
              child: CustomPaint(painter: _CardBackPatternPainter()),
            ),
            // Center fingerprint icon
            Center(
              child: FaIcon(
                FontAwesomeIcons.fingerprint,
                color: Colors.white.withOpacity(0.15),
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    final isMatched = widget.card.isMatched;
    final borderColor = isMatched ? AppColors.mint : AppColors.electric;
    final glowColor = isMatched ? AppColors.mint : AppColors.electric;

    return AspectRatio(
      aspectRatio: 0.75, // 3:4 ratio for card
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.midnight, AppColors.midnight.withOpacity(0.9)],
          ),
          borderRadius: AppRadius.card,
          border: Border.all(color: borderColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.5),
              blurRadius: isMatched ? 24 : 18,
              spreadRadius: isMatched ? 4 : 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.card.color.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderColor.withOpacity(0.05),
                ),
              ),
            ),
            // Nature decoration
            Positioned(
              top: 8,
              left: 8,
              child: FaIcon(
                FontAwesomeIcons.leaf,
                size: 10,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: FaIcon(
                FontAwesomeIcons.seedling,
                size: 10,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // Main icon with animation and background
            Center(
              child: AnimatedScale(
                scale: isMatched ? 1.25 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow background for icon
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.card.color.withOpacity(0.25),
                            widget.card.color.withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // The icon itself with enhanced size
                    FaIcon(
                      widget.card.icon,
                      color: widget.card.color,
                      size: 48,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for card back pattern
class _CardBackPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw circuit-like pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(Offset(centerX, centerY), 20.0 * i, paint);
    }

    // Draw connecting lines
    final lineCount = 8;
    for (int i = 0; i < lineCount; i++) {
      final angle = (2 * pi * i) / lineCount;
      final startX = centerX + cos(angle) * 20;
      final startY = centerY + sin(angle) * 20;
      final endX = centerX + cos(angle) * 60;
      final endY = centerY + sin(angle) * 60;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
