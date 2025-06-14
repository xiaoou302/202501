import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _logoScaleController;
  late AnimationController _logoRotateController;
  late AnimationController _nameController;
  late AnimationController _loadingController;
  late AnimationController _particleController;
  late AnimationController _glowController;

  // Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _nameAnimation;
  late Animation<double> _loadingAnimation;

  // Particles
  final List<Particle> _particles = [];
  final int _particleCount = 20;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Initialize particles
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        position: Offset(
          _random.nextDouble() * 300 - 150,
          _random.nextDouble() * 300 - 150,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 2,
          (_random.nextDouble() - 0.5) * 2,
        ),
        radius: _random.nextDouble() * 4 + 1,
        color: _random.nextBool()
            ? AppColors.electricBlue
            : AppColors.hologramPurple,
        lifespan: _random.nextDouble() * 0.7 + 0.3,
      ));
    }

    // Logo scale animation
    _logoScaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_logoScaleController);

    // Logo rotation animation
    _logoRotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoRotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _logoRotateController,
      curve: Curves.easeInOutCubic,
    ));

    // Name animation
    _nameController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _nameAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _nameController,
      curve: Curves.easeOutCubic,
    ));

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_loadingController);

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Start animations sequentially
    _logoScaleController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _logoRotateController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _nameController.forward();
    });

    // Navigate to home screen after delay
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  void dispose() {
    _logoScaleController.dispose();
    _logoRotateController.dispose();
    _nameController.dispose();
    _loadingController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Particle effect
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    animation: _particleController.value,
                  ),
                  size: MediaQuery.of(context).size,
                );
              },
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoScaleController,
                      _logoRotateController,
                      _glowController,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotateAnimation.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.electricBlue.withOpacity(
                                    0.3 + 0.3 * _glowController.value,
                                  ),
                                  blurRadius: 20 + 10 * _glowController.value,
                                  spreadRadius: 5 + 3 * _glowController.value,
                                ),
                                BoxShadow(
                                  color: AppColors.hologramPurple.withOpacity(
                                    0.3 + 0.2 * _glowController.value,
                                  ),
                                  blurRadius: 25 + 15 * _glowController.value,
                                  spreadRadius: 2 + 2 * _glowController.value,
                                ),
                              ],
                            ),
                            child: Center(
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: const Icon(
                                  FontAwesomeIcons.rocket,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  // App name
                  AnimatedBuilder(
                    animation: _nameController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _nameAnimation.value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            20 * (1 - _nameAnimation.value),
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: const [
                                AppColors.electricBlue,
                                AppColors.hologramPurple,
                                Color(0xFFff4d94),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              'LUXANVORYX',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 60),

                  // Loading animation
                  AnimatedBuilder(
                    animation: _loadingAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: LoadingPainter(
                          animation: _loadingAnimation.value,
                        ),
                        size: const Size(120, 4),
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

// Particle class
class Particle {
  Offset position;
  Offset velocity;
  double radius;
  Color color;
  double lifespan;

  Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
    required this.lifespan,
  });
}

// Particle painter
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticlePainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      // Update position based on animation
      final currentPosition = center +
          Offset(
            particle.position.dx + particle.velocity.dx * animation * 100,
            particle.position.dy + particle.velocity.dy * animation * 100,
          );

      // Calculate opacity based on distance from center
      final distance = (currentPosition - center).distance;
      final maxDistance = 200.0;
      final opacity =
          (1.0 - (distance / maxDistance)).clamp(0.0, 1.0) * particle.lifespan;

      // Draw particle
      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        currentPosition,
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

// Loading painter
class LoadingPainter extends CustomPainter {
  final double animation;

  LoadingPainter({
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Background track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(4),
      ),
      trackPaint,
    );

    // Calculate the position of the glowing dot
    final dotPosition = width * animation;

    // Create gradient for the progress
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: const [
          AppColors.electricBlue,
          AppColors.hologramPurple,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    // Draw progress
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, dotPosition, height),
        const Radius.circular(4),
      ),
      progressPaint,
    );

    // Draw glow effect at the end of the progress
    final glowPaint = Paint()
      ..color = AppColors.electricBlue
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      Offset(dotPosition, height / 2),
      height * 1.5,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(LoadingPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
