import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/colors.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _titleSlideAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _hexagonAnimation;

  bool _showLoading = false;
  bool _loadingComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Title animations
    _titleSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Hexagon grid animation
    _hexagonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start animation sequence
    _controller.forward().then((_) {
      setState(() {
        _showLoading = true;
      });

      // Simulate loading time
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _loadingComplete = true;
        });

        // Navigate to onboarding screen
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const OnboardingScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOutCubic;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // Background hexagon grid
          AnimatedBuilder(
            animation: _hexagonAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _hexagonAnimation.value * 0.3,
                child: CustomPaint(
                  painter: HexagonGridPainter(
                    color: AppColors.primaryAccent.withOpacity(0.2),
                    progress: _hexagonAnimation.value,
                  ),
                  size: Size.infinite,
                ),
              );
            },
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Animated logo
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _logoRotateAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryAccent.withOpacity(
                                  _glowAnimation.value * 0.8,
                                ),
                                blurRadius: 30 * _glowAnimation.value,
                                spreadRadius: 5 * _glowAnimation.value,
                              ),
                              BoxShadow(
                                color: AppColors.secondaryAccent.withOpacity(
                                  _glowAnimation.value * 0.5,
                                ),
                                blurRadius: 20 * _glowAnimation.value,
                                spreadRadius: 2 * _glowAnimation.value,
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomPaint(
                              painter: HexagonLogoPainter(
                                primaryColor: AppColors.primaryAccent,
                                secondaryColor: AppColors.secondaryAccent,
                                progress: _glowAnimation.value,
                              ),
                              size: const Size(80, 80),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Animated title
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _titleSlideAnimation.value),
                      child: Opacity(
                        opacity: _titleFadeAnimation.value,
                        child: Column(
                          children: [
                            Text(
                              'ChroPlexiGnosis',
                              style: TextStyle(
                                fontFamily: 'System',
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryAccent,
                                shadows: [
                                  Shadow(
                                    color: AppColors.primaryAccent.withOpacity(
                                      0.7,
                                    ),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'A Cerebral Matching Game',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(),

                // Loading animation
                if (_showLoading)
                  AnimatedOpacity(
                    opacity: _loadingComplete ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: const CyberLoadingIndicator(),
                  ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom hexagon grid background painter
class HexagonGridPainter extends CustomPainter {
  final Color color;
  final double progress;

  HexagonGridPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const hexSize = 40.0;
    final rows = (size.height / (hexSize * 0.75)).ceil() + 1;
    final cols = (size.width / (hexSize * math.sqrt(3) / 2)).ceil() + 1;

    for (int r = -1; r < rows; r++) {
      for (int c = -1; c < cols; c++) {
        final isOffset = c % 2 == 0;
        final centerX = c * hexSize * math.sqrt(3) / 2;
        final centerY = r * hexSize * 1.5 + (isOffset ? hexSize * 0.75 : 0);

        // Calculate distance from center for reveal animation
        final centerDist = math.sqrt(
          math.pow((centerX - size.width / 2) / size.width, 2) +
              math.pow((centerY - size.height / 2) / size.height, 2),
        );

        // Skip drawing if not yet revealed by animation
        if (centerDist > progress * 1.5) continue;

        final opacity = math.max(0, 1 - centerDist);
        paint.color = color.withOpacity(opacity * 0.7);

        final path = Path();
        for (int i = 0; i < 6; i++) {
          final angle = (i * 60) * math.pi / 180;
          final x = centerX + hexSize * math.cos(angle);
          final y = centerY + hexSize * math.sin(angle);

          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HexagonGridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.progress != progress;
  }
}

// Custom hexagon logo painter
class HexagonLogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double progress;

  HexagonLogoPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw outer hexagon
    final outerPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final outerPath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        outerPath.moveTo(x, y);
      } else {
        outerPath.lineTo(x, y);
      }
    }
    outerPath.close();
    canvas.drawPath(outerPath, outerPaint);

    // Draw inner hexagon
    final innerPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final innerPath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * math.pi / 180;
      final x = center.dx + radius * 0.6 * math.cos(angle);
      final y = center.dy + radius * 0.6 * math.sin(angle);

      if (i == 0) {
        innerPath.moveTo(x, y);
      } else {
        innerPath.lineTo(x, y);
      }
    }
    innerPath.close();
    canvas.drawPath(innerPath, innerPaint);

    // Draw connecting lines
    final linePaint = Paint()
      ..color = primaryColor.withOpacity(0.7 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 3; i++) {
      final angle1 = (i * 120) * math.pi / 180;
      final angle2 = (i * 120 + 60) * math.pi / 180;

      final x1 = center.dx + radius * 0.6 * math.cos(angle1);
      final y1 = center.dy + radius * 0.6 * math.sin(angle1);
      final x2 = center.dx + radius * 0.6 * math.cos(angle2);
      final y2 = center.dy + radius * 0.6 * math.sin(angle2);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }

    // Draw center circle with pulsing effect
    final circlePaint = Paint()
      ..color = secondaryColor.withOpacity(
        0.5 + 0.5 * math.sin(progress * math.pi * 2),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.2, circlePaint);
  }

  @override
  bool shouldRepaint(covariant HexagonLogoPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.progress != progress;
  }
}

// Custom loading indicator
class CyberLoadingIndicator extends StatefulWidget {
  const CyberLoadingIndicator({Key? key}) : super(key: key);

  @override
  State<CyberLoadingIndicator> createState() => _CyberLoadingIndicatorState();
}

class _CyberLoadingIndicatorState extends State<CyberLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
    return Column(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: CyberLoadingPainter(
                progress: _controller.value,
                primaryColor: AppColors.primaryAccent,
                secondaryColor: AppColors.secondaryAccent,
              ),
              size: const Size(120, 10),
            );
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'INITIALIZING NEURAL NETWORK',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// Custom loading painter
class CyberLoadingPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  CyberLoadingPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background track
    final trackPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final trackPath = Path();
    trackPath.moveTo(0, size.height / 2);
    trackPath.lineTo(size.width, size.height / 2);
    canvas.drawPath(trackPath, trackPaint);

    // Draw progress segments
    final segmentWidth = size.width / 12;
    final activePaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final segmentProgress = (progress * 12 - i) % 12;
      if (segmentProgress >= 0 && segmentProgress <= 1) {
        final segmentOpacity = segmentProgress <= 0.5
            ? segmentProgress * 2
            : (1 - segmentProgress) * 2;

        final color = i % 2 == 0 ? primaryColor : secondaryColor;
        activePaint.color = color.withOpacity(segmentOpacity);

        final rect = Rect.fromLTWH(
          i * segmentWidth,
          0,
          segmentWidth,
          size.height,
        );
        canvas.drawRect(rect, activePaint);
      }
    }

    // Draw glowing dot at current position
    final dotPosition = (progress * size.width) % size.width;
    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(dotPosition, size.height / 2),
      size.height / 2,
      dotPaint,
    );

    // Draw glow effect
    final glowPaint = Paint()
      ..color = primaryColor.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(
      Offset(dotPosition, size.height / 2),
      size.height,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CyberLoadingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
