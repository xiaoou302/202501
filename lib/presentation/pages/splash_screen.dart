import 'dart:async';
import 'dart:math' as math;
import 'dart:math' show Random;
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'game_introduction_screen.dart';

/// Splash screen with animated logo and app name
class SplashScreen extends StatefulWidget {
  /// Constructor
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoScaleController;
  late AnimationController _logoRotationController;
  late AnimationController _textSlideController;
  late AnimationController _particleController;
  late AnimationController _shimmerController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textSlideAnimation;

  final List<ParticleModel> particles = [];
  final int numberOfParticles = 20;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    // Initialize particles
    for (int i = 0; i < numberOfParticles; i++) {
      particles.add(ParticleModel(random));
    }

    // Logo scale animation
    _logoScaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = CurvedAnimation(
      parent: _logoScaleController,
      curve: Curves.elasticOut,
    );

    // Logo rotation animation
    _logoRotationController = AnimationController(
      duration: const Duration(milliseconds: 30000),
      vsync: this,
    );

    // Text slide animation
    _textSlideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textSlideAnimation = CurvedAnimation(
      parent: _textSlideController,
      curve: Curves.easeOutCubic,
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    // Start animations with slight delays
    _logoScaleController.forward();

    Timer(const Duration(milliseconds: 300), () {
      _textSlideController.forward();
    });

    Timer(const Duration(milliseconds: 500), () {
      _logoRotationController.repeat();
    });

    // Navigate to introduction screen after delay
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const GameIntroductionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoScaleController.dispose();
    _logoRotationController.dispose();
    _textSlideController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0),
                Colors.black.withOpacity(0),
              ],
            ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated particles
                AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ParticlePainter(
                        particles: particles,
                        animation: _particleController.value,
                      ),
                      size: Size(MediaQuery.of(context).size.width, 400),
                    );
                  },
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: RotationTransition(
                        turns: _logoRotationController,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.carvedJadeGreen.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.carvedJadeGreen.withOpacity(
                                  0.5,
                                ),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Inner rotating circle
                              RotationTransition(
                                turns: AlwaysStoppedAnimation(
                                  -_logoRotationController.value,
                                ),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.8),
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                              // App icon
                              const Icon(
                                Icons.spa,
                                color: Colors.white,
                                size: 60,
                              ),

                              // Shimmer effect
                              AnimatedBuilder(
                                animation: _shimmerController,
                                builder: (context, child) {
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0),
                                          Colors.white.withOpacity(0.2),
                                          Colors.white.withOpacity(0),
                                        ],
                                        stops: [
                                          0.0,
                                          _shimmerController.value,
                                          1.0,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Animated App Name
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_textSlideAnimation),
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.8),
                                  Colors.white,
                                ],
                                stops: [0.0, _shimmerController.value, 1.0],
                                begin: const Alignment(-1.0, -0.5),
                                end: const Alignment(1.0, 0.5),
                              ).createShader(bounds);
                            },
                            child: Text(
                              AppConstants.appName,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 5.0,
                                    color: Color.fromARGB(180, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Animated Subtitle
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(_textSlideAnimation),
                      child: Text(
                        AppConstants.appSubtitle,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.2,
                          shadows: const [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2.0,
                              color: Color.fromARGB(150, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Loading animation
                    _buildLoadingAnimation(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return SizedBox(
          width: 60,
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 6,
                height: math.max(
                  6.0,
                  6 +
                      12 *
                          math.sin(
                            (_particleController.value * 2 * math.pi) +
                                (index * 0.5),
                          ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.carvedJadeGreen.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Model for animated particles
class ParticleModel {
  late double x;
  late double y;
  late double size;
  late Color color;
  late double speed;

  ParticleModel(Random random) {
    x = random.nextDouble();
    y = random.nextDouble();
    size = 2 + random.nextDouble() * 4;

    // Randomize color between jade green and amber
    final colorRandom = random.nextDouble();
    if (colorRandom > 0.7) {
      color = AppColors.beeswaxAmber.withOpacity(0.6);
    } else {
      color = AppColors.carvedJadeGreen.withOpacity(0.6);
    }

    speed = 0.2 + random.nextDouble() * 0.2;
  }

  void update(double animation) {
    y = (y + speed * 0.02) % 1.0;
  }
}

/// Custom painter for particle effect
class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;
  final double animation;

  ParticlePainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update(animation);

      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      final position = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );

      canvas.drawCircle(position, particle.size, paint);

      // Add glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(position, particle.size * 1.5, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
