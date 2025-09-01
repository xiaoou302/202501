import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../onboarding/onboarding_screen.dart';

/// Splash screen with animated game-themed elements
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Main logo animations
  late AnimationController _logoAnimController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  // Particle animations
  late AnimationController _particleAnimController;

  // Background pulse animation
  late AnimationController _pulseAnimController;
  late Animation<double> _pulseAnimation;

  // Game icon animations
  late AnimationController _iconsAnimController;
  late Animation<double> _iconsAnimation;

  // Game icons with their colors
  final List<Map<String, dynamic>> _gameIcons = [
    {'icon': Icons.grid_view_rounded, 'color': Colors.blue},
    {'icon': Icons.music_note_rounded, 'color': Colors.purple},
    {'icon': Icons.format_list_numbered_rounded, 'color': Colors.green},
    {'icon': Icons.psychology, 'color': Colors.orange},
    {'icon': Icons.auto_awesome, 'color': Colors.amber},
    {'icon': Icons.lightbulb, 'color': Colors.pink},
  ];

  // Random generator for particle effects
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimController, curve: Curves.elasticOut),
    );

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Particle animation controller
    _particleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // Pulse animation controller
    _pulseAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Pulse animation
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseAnimController, curve: Curves.easeInOut),
    );

    // Game icons animation controller
    _iconsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Game icons animation
    _iconsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconsAnimController, curve: Curves.easeOutBack),
    );

    // Start animations with slight delays
    _logoAnimController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _iconsAnimController.forward();
    });

    // Navigate to onboarding screen after animation completes
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoAnimController.dispose();
    _particleAnimController.dispose();
    _pulseAnimController.dispose();
    _iconsAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background pulse effect
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Center(
                child: Container(
                  width: screenSize.width * 1.5 * _pulseAnimation.value,
                  height: screenSize.width * 1.5 * _pulseAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.3),
                        AppColors.primary.withOpacity(0.0),
                      ],
                      stops: const [0.2, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // Floating particles
          AnimatedBuilder(
            animation: _particleAnimController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlesPainter(
                  animation: _particleAnimController,
                  random: _random,
                ),
                size: Size(screenSize.width, screenSize.height),
              );
            },
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                AnimatedBuilder(
                  animation: _logoAnimController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(90),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.auto_awesome,
                        size: 90,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // App name
                AnimatedBuilder(
                  animation: _logoAnimController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white, AppColors.primary, Colors.white],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds),
                    child: const Text(
                      'Hyquinoxa',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: AppColors.primary,
                            blurRadius: 15,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // App subtitle
                AnimatedBuilder(
                  animation: _logoAnimController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: child,
                    );
                  },
                  child: Text(
                    'Train Your Brain, Expand Your Game',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Game icons
                SizedBox(
                  height: 60,
                  child: AnimatedBuilder(
                    animation: _iconsAnimation,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_gameIcons.length, (index) {
                          // Calculate delay based on index
                          final delay = index / _gameIcons.length;
                          // Fix: Ensure the end value doesn't exceed 1.0
                          final endValue = math.min(delay + 0.4, 1.0);
                          final delayedAnimation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _iconsAnimController,
                                  curve: Interval(
                                    delay,
                                    endValue,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              );

                          return Opacity(
                            opacity: delayedAnimation.value,
                            child: Transform.scale(
                              scale: delayedAnimation.value,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _gameIcons[index]['color'].withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _gameIcons[index]['icon'],
                                  color: _gameIcons[index]['color'],
                                  size: 24,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for particle effects
class ParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  final math.Random random;
  final int particleCount = 30;

  ParticlesPainter({required this.animation, required this.random})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particleCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 1.0 + random.nextDouble() * 3.0;

      // Create a pulsating effect based on animation and particle index
      final pulseOffset = (i / particleCount) * math.pi * 2;
      final pulseValue =
          0.5 + 0.5 * math.sin(animation.value * math.pi * 2 + pulseOffset);

      // Choose a color based on particle index
      final colorIndex = i % 5;
      Color color;
      switch (colorIndex) {
        case 0:
          color = Colors.blue;
        case 1:
          color = Colors.purple;
        case 2:
          color = Colors.green;
        case 3:
          color = Colors.orange;
        case 4:
          color = AppColors.primary;
        default:
          color = Colors.white;
      }

      // Draw the particle
      final paint = Paint()
        ..color = color.withOpacity(0.6 * pulseValue)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), radius * pulseValue, paint);

      // Draw a glow effect
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3 * pulseValue)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

      canvas.drawCircle(Offset(x, y), radius * 2 * pulseValue, glowPaint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}
