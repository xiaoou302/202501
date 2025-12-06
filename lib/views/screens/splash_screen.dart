import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _tileController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late Animation<double> _tileScale;
  late Animation<double> _tileRotation;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;

  @override
  void initState() {
    super.initState();

    // Tile animation controller
    _tileController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _tileScale = CurvedAnimation(
      parent: _tileController,
      curve: Curves.elasticOut,
    );

    _tileRotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _tileController,
        curve: const Interval(0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFade = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _textSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tileController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 2500));
    widget.onComplete();
  }

  @override
  void dispose() {
    _tileController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/17381765004589_.pic_hd.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Dark overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    AppColors.inkGreen.withValues(alpha: 0.7),
                    AppColors.inkGreen.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Animated particles background
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(_particleController.value),
                  size: Size.infinite,
                );
              },
            ),

            // Vignette effect
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Tile Logo
                  AnimatedBuilder(
                    animation: _tileController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _tileScale.value,
                        child: Transform.rotate(
                          angle: _tileRotation.value,
                          child: Container(
                            width: 140,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                // Outer glow
                                BoxShadow(
                                  color: AppColors.antiqueGold
                                      .withValues(alpha: 0.6 * _tileScale.value),
                                  blurRadius: 40,
                                  spreadRadius: 15,
                                ),
                                // Strong shadow
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: 0.5 * _tileScale.value),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFFFFDF7),
                                      AppColors.ivory,
                                      const Color(0xFFF5F0E3),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Subtle pattern overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.jadeGreen.withValues(alpha: 0.08),
                                            Colors.transparent,
                                            AppColors.antiqueGold.withValues(alpha: 0.05),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Light reflection
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      height: 60,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white.withValues(alpha: 0.4),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Mahjong emoji with shadow
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: const Text(
                                          '🀄',
                                          style: TextStyle(
                                            fontSize: 90,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Bottom edge shadow
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      height: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              AppColors.jadeGreen.withValues(alpha: 0.3),
                                            ],
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Animated Text
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textFade.value,
                        child: Transform.translate(
                          offset: Offset(0, _textSlide.value),
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    AppColors.antiqueGold,
                                    AppColors.ivory,
                                    AppColors.antiqueGold,
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  'PAIKO',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'MAHJONG MEMORY SOLITAIRE',
                                style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 3,
                                  color: AppColors.ivory.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // Custom loading indicator
                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: LoadingIndicatorPainter(_particleController.value),
                        size: const Size(60, 60),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Particle background painter
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw floating particles with varied movement
    for (int i = 0; i < 30; i++) {
      final offset = (animationValue + i * 0.03) % 1.0;
      final horizontalWave = math.sin(animationValue * 2 * math.pi + i) * 20;
      final x = ((i * 50) % size.width) + horizontalWave;
      final y = size.height * offset;
      final opacity = (1 - offset) * 0.4;
      final particleSize = 1.5 + (i % 4) * 0.5;

      // Alternate between gold and white particles
      final color = i % 3 == 0 
          ? AppColors.antiqueGold.withValues(alpha: opacity)
          : Colors.white.withValues(alpha: opacity * 0.6);
      
      paint.color = color;
      
      // Add glow effect for some particles
      if (i % 5 == 0) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(Offset(x, y), particleSize * 2, paint);
        paint.maskFilter = null;
      }
      
      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// Custom loading indicator painter
class LoadingIndicatorPainter extends CustomPainter {
  final double animationValue;

  LoadingIndicatorPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw three rotating tiles
    for (int i = 0; i < 3; i++) {
      final angle = (animationValue * 2 * math.pi) + (i * 2 * math.pi / 3);
      final radius = 20.0;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final tileSize = 8.0 + 3 * math.sin(animationValue * 2 * math.pi + i);
      
      paint.color = [
        AppColors.antiqueGold,
        AppColors.jadeGreen,
        AppColors.vermillion,
      ][i].withValues(alpha: 0.8);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y), width: tileSize, height: tileSize * 1.3),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(LoadingIndicatorPainter oldDelegate) => true;
}
