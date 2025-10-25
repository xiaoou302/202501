import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'dart:math' as math;

/// Splash screen with creative animations
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _glowController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Particle animation controller (continuous)
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Glow pulse controller (continuous)
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Logo animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Text animations
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Glow pulse
    _glowPulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start animations
    _logoController.forward();
    _textController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkBackground,
              AppColors.inkBlack,
              AppColors.shadowBrown,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ParticlePainter(_particleController.value),
                  );
                },
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo with glow
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoController,
                      _glowController,
                    ]),
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Transform.rotate(
                            angle: _logoRotation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.magicGold.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.magicGold.withOpacity(
                                      0.5 * _glowPulse.value,
                                    ),
                                    blurRadius: 40 * _glowPulse.value,
                                    spreadRadius: 10 * _glowPulse.value,
                                  ),
                                  BoxShadow(
                                    color: AppColors.magicBlue.withOpacity(
                                      0.3 * _glowPulse.value,
                                    ),
                                    blurRadius: 60 * _glowPulse.value,
                                    spreadRadius: 5 * _glowPulse.value,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Inner glow circle
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.magicBlue,
                                          AppColors.magicPurple,
                                          AppColors.magicGold,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.magicBlue
                                              .withOpacity(0.5),
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Book icon
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        Colors.white,
                                        AppColors.parchmentLight,
                                      ],
                                    ).createShader(bounds),
                                    child: const Icon(
                                      Icons.auto_stories_rounded,
                                      size: 56,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _textSlide.value),
                          child: Column(
                            children: [
                              // Main title with shimmer effect
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.magicGold,
                                      Colors.white,
                                      AppColors.magicBlue,
                                      AppColors.magicGold,
                                    ],
                                    stops: [
                                      0.0,
                                      _textController.value * 0.5,
                                      _textController.value,
                                      1.0,
                                    ],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'Zenion',
                                  style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: AppColors.magicGold.withOpacity(
                                          0.5,
                                        ),
                                        blurRadius: 20,
                                      ),
                                      Shadow(
                                        color: AppColors.magicBlue.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 40,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Subtitle
                              Text(
                                'The Fading Codex',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 3,
                                  color: AppColors.parchmentMedium.withOpacity(
                                    0.9,
                                  ),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 80),

                  // Creative loading animation - floating runes
                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      return SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final delay = index * 0.2;
                            final progress =
                                (_particleController.value + delay) % 1.0;
                            final opacity = (math.sin(
                              progress * math.pi,
                            )).clamp(0.2, 1.0);
                            final translateY =
                                math.sin(progress * math.pi * 2) * 10;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Transform.translate(
                                offset: Offset(0, translateY),
                                child: Opacity(
                                  opacity: opacity,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          AppColors.magicGold,
                                          AppColors.magicBlue.withOpacity(0.5),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.magicGold
                                              .withOpacity(0.6),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Loading text
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacity.value,
                        child: Text(
                          'Awakening ancient memories...',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.parchmentMedium.withOpacity(0.6),
                            letterSpacing: 1,
                          ),
                        ),
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

/// Custom painter for floating particles
class ParticlePainter extends CustomPainter {
  final double progress;

  ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw multiple floating particles
    for (int i = 0; i < 20; i++) {
      final seed = i * 123.456;
      final x = (math.sin(seed) * 0.5 + 0.5) * size.width;
      final baseY = (math.cos(seed * 0.7) * 0.5 + 0.5) * size.height;

      // Animate y position
      final yOffset = math.sin(progress * math.pi * 2 + seed) * 30;
      final y = baseY + yOffset;

      // Animate opacity
      final opacity =
          ((math.sin(progress * math.pi * 2 + seed * 0.5) * 0.5 + 0.5) * 0.3)
              .clamp(0.0, 0.3);

      // Random particle size
      final particleSize = 2.0 + (math.sin(seed * 2) * 0.5 + 0.5) * 2;

      // Color variation
      final colorIndex = i % 3;
      Color color;
      switch (colorIndex) {
        case 0:
          color = AppColors.magicGold;
          break;
        case 1:
          color = AppColors.magicBlue;
          break;
        default:
          color = AppColors.magicPurple;
      }

      paint.color = color.withOpacity(opacity);

      // Draw particle with glow
      canvas.drawCircle(Offset(x, y), particleSize, paint);

      // Draw glow
      paint.color = color.withOpacity(opacity * 0.3);
      canvas.drawCircle(Offset(x, y), particleSize * 2, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
