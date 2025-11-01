import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _titleController;
  late AnimationController _glowController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleSlide;
  late Animation<double> _titleOpacity;
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

    // Title animation controller
    _titleController = AnimationController(
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
        curve: Curves.elasticOut,
      ),
    );

    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Title animations
    _titleSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: Curves.easeOutCubic,
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: Curves.easeIn,
      ),
    );

    // Glow pulse
    _glowPulse = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _titleController.forward();

    // Navigate to home after animations complete
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    _titleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      body: Stack(
        children: [
          // Animated particles background
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: AlchemicalParticlesPainter(
                  animation: _particleController.value,
                ),
                size: Size.infinite,
              );
            },
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
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Transform.rotate(
                        angle: _logoRotation.value,
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.alchemicalGold
                                      .withOpacity(0.6 * _glowPulse.value),
                                  blurRadius: 40 * _glowPulse.value,
                                  spreadRadius: 10 * _glowPulse.value,
                                ),
                                BoxShadow(
                                  color: AppColors.rubedoRed
                                      .withOpacity(0.3 * _glowPulse.value),
                                  blurRadius: 60 * _glowPulse.value,
                                  spreadRadius: 5 * _glowPulse.value,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer ring
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.alchemicalGold,
                                      width: 3,
                                    ),
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.alchemicalGold
                                            .withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                ),
                                // Inner symbol
                                Icon(
                                  Icons.auto_stories,
                                  size: 70,
                                  color: AppColors.alchemicalGold,
                                  shadows: [
                                    Shadow(
                                      color: AppColors.alchemicalGold
                                          .withOpacity(0.8),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                // Rotating decorative elements
                                Transform.rotate(
                                  angle: _particleController.value * 2 * math.pi,
                                  child: CustomPaint(
                                    size: const Size(140, 140),
                                    painter: AlchemicalSymbolPainter(),
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
                  animation: _titleController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _titleSlide.value),
                      child: Opacity(
                        opacity: _titleOpacity.value,
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  AppColors.alchemicalGold,
                                  AppColors.alabasterWhite,
                                  AppColors.alchemicalGold,
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'COGNIFEX',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.serifFont,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 8.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: AppColors.alchemicalGold
                                        .withOpacity(0.5),
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: AppColors.alchemicalGold
                                        .withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'The Alchemist\'s Paradox',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.serifFont,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.alabasterWhite,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 60),

                // Custom loading animation
                AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(200, 40),
                      painter: AlchemicalLoadingPainter(
                        animation: _particleController.value,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom text
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _titleController,
              builder: (context, child) {
                return Opacity(
                  opacity: _titleOpacity.value,
                  child: const Text(
                    'Preparing the Great Work...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.neutralSteel,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for floating alchemical particles
class AlchemicalParticlesPainter extends CustomPainter {
  final double animation;

  AlchemicalParticlesPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 30; i++) {
      final seed = i * 137.5; // Golden angle
      final x = (seed % size.width);
      final y = ((seed * 1.618) % size.height +
              animation * size.height * 0.3) %
          size.height;

      final opacity = (math.sin(animation * 2 * math.pi + i) + 1) / 2;
      final size_particle = 2.0 + math.sin(animation * 2 * math.pi + i) * 1.5;

      paint.color = AppColors.alchemicalGold.withOpacity(opacity * 0.3);
      canvas.drawCircle(Offset(x, y), size_particle, paint);
    }
  }

  @override
  bool shouldRepaint(AlchemicalParticlesPainter oldDelegate) => true;
}

// Custom painter for rotating alchemical symbols
class AlchemicalSymbolPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.alchemicalGold.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw decorative symbols at cardinal points
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(AlchemicalSymbolPainter oldDelegate) => false;
}

// Custom painter for alchemical loading animation
class AlchemicalLoadingPainter extends CustomPainter {
  final double animation;

  AlchemicalLoadingPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final spacing = 15.0;
    final count = 7;
    final startX = (size.width - (count - 1) * spacing) / 2;

    for (int i = 0; i < count; i++) {
      final progress = (animation + i / count) % 1.0;
      final x = startX + i * spacing;

      // Create wave effect
      final y = centerY + math.sin(progress * 2 * math.pi) * 12;
      final opacity = (math.sin(progress * 2 * math.pi) + 1) / 2;
      final size_dot = 4.0 + math.sin(progress * 2 * math.pi) * 2;

      // Gradient color effect
      final color = Color.lerp(
        AppColors.alchemicalGold,
        AppColors.rubedoRed,
        progress,
      )!;

      paint.color = color.withOpacity(0.5 + opacity * 0.5);
      canvas.drawCircle(Offset(x, y), size_dot, paint);

      // Add glow
      paint.color = color.withOpacity(0.2 * opacity);
      canvas.drawCircle(Offset(x, y), size_dot * 2, paint);
    }
  }

  @override
  bool shouldRepaint(AlchemicalLoadingPainter oldDelegate) => true;
}

