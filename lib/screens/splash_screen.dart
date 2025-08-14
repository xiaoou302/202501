import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

/// Splash screen with animated logo and name
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _logoScaleController;
  late AnimationController _logoRotationController;
  late AnimationController _nameController;
  late AnimationController _loadingController;
  late AnimationController _backgroundController;

  // Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _nameOpacityAnimation;
  late Animation<double> _nameSlideAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  // Loading animation values
  final List<Color> _loadingColors = [
    AppTheme.brandBlue,
    AppTheme.accentOrange,
    AppTheme.successGreen,
  ];
  final List<Offset> _loadingPositions = [];
  final int _particleCount = 5;
  final double _particleSize = 8.0;

  @override
  void initState() {
    super.initState();

    // Initialize loading particle positions
    for (int i = 0; i < _particleCount; i++) {
      _loadingPositions.add(Offset.zero);
    }

    // Logo scale animation
    _logoScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 40,
      ),
    ]).animate(_logoScaleController);

    // Logo rotation animation
    _logoRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoRotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.1,
          end: 0.1,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.1,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_logoRotationController);

    // Name animation
    _nameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _nameOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _nameController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _nameSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _nameController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Loading animation
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(() {
        // Update particle positions
        setState(() {
          for (int i = 0; i < _particleCount; i++) {
            final angle = 2 * math.pi * (i / _particleCount) +
                (_loadingController.value * 2 * math.pi);
            final radius =
                20 + (10 * math.sin(_loadingController.value * 4 * math.pi));
            _loadingPositions[i] = Offset(
              radius * math.cos(angle),
              radius * math.sin(angle),
            );
          }
        });
      });

    // Background animation
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _backgroundColorAnimation = ColorTween(
      begin: AppTheme.primaryBackground.withOpacity(0.7),
      end: AppTheme.primaryBackground,
    ).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeIn),
    );

    // Start animations
    _startAnimations();

    // Navigate to main screen after delay
    Future.delayed(const Duration(seconds: 5), () {
      // Use a callback function to navigate to the main screen
      // This callback will be provided by the parent widget (main.dart)
      Navigator.of(context).pushReplacementNamed('/main');
    });
  }

  @override
  void dispose() {
    _logoScaleController.dispose();
    _logoRotationController.dispose();
    _nameController.dispose();
    _loadingController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  /// Start all animations in sequence
  void _startAnimations() async {
    // Start background animation immediately
    _backgroundController.forward();

    // Start logo animation with a small delay to ensure visibility
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoScaleController.forward();

    // Start logo floating animation
    _logoRotationController.repeat(reverse: true);

    // Start name animation after logo appears
    await _nameController.forward();

    // Start loading animation
    _loadingController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundColorAnimation.value ?? AppTheme.primaryBackground,
                  AppTheme.primaryBackground.withBlue(
                    (AppTheme.primaryBackground.blue + 10).clamp(0, 255),
                  ),
                ],
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: Listenable.merge([
                  _logoScaleAnimation,
                  _logoRotationAnimation,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _logoRotationAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.brandBlue, AppTheme.accentOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.brandBlue.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: AppTheme.accentOrange.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'K',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Animated App Name
              AnimatedBuilder(
                animation: _nameController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _nameOpacityAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _nameSlideAnimation.value),
                      child: child,
                    ),
                  );
                },
                child: const Text(
                  'Virelia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Animated Loading Indicator
              SizedBox(
                height: 50,
                width: 50,
                child: AnimatedBuilder(
                  animation: _loadingController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _ParticlesPainter(
                        positions: _loadingPositions,
                        colors: _loadingColors,
                        particleSize: _particleSize,
                        progress: _loadingController.value,
                      ),
                      size: const Size(50, 50),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the loading animation particles
class _ParticlesPainter extends CustomPainter {
  final List<Offset> positions;
  final List<Color> colors;
  final double particleSize;
  final double progress;

  _ParticlesPainter({
    required this.positions,
    required this.colors,
    required this.particleSize,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw particles
    for (int i = 0; i < positions.length; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round;

      // Calculate size variation based on progress
      final sizeVariation =
          particleSize * (0.8 + 0.4 * math.sin(progress * 2 * math.pi + i));

      // Draw at position relative to center
      canvas.drawCircle(center + positions[i], sizeVariation, paint);

      // Draw trail
      final trailPaint = Paint()
        ..color = colors[i % colors.length].withOpacity(0.3)
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round;

      final trailOffset = Offset(
            math.cos(
              2 * math.pi * (i / positions.length) +
                  progress * 2 * math.pi -
                  0.2,
            ),
            math.sin(
              2 * math.pi * (i / positions.length) +
                  progress * 2 * math.pi -
                  0.2,
            ),
          ) *
          15;

      canvas.drawCircle(center + trailOffset, sizeVariation * 0.6, trailPaint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) => true;
}
