import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;

  final List<ParticleModel> _particles = List.generate(
    20,
    (index) => ParticleModel.random(),
  );

  @override
  void initState() {
    super.initState();

    // Logo animations
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 40,
      ),
    ]).animate(_logoController);

    _logoRotateAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.3)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 40,
      ),
    ]).animate(_logoController);

    // Text animations
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Particle animations
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Start animations sequence
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    // Navigate to main screen after animations
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainScreen(),
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
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // Animated particles
          ...List.generate(_particles.length, (index) {
            return AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final particle = _particles[index];
                final progress = _particleController.value;
                final offset = particle.getOffset(progress);
                final opacity = particle.getOpacity(progress);

                return Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: particle.size,
                      height: particle.size,
                      decoration: BoxDecoration(
                        color: particle.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: particle.color.withOpacity(0.3),
                            blurRadius: particle.size * 2,
                            spreadRadius: particle.size / 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Logo and text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _logoRotateAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.accentPurple,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentPurple.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Background geometric pattern
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: LogoBackgroundPainter(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              // Main logo composition
                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer ring
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.8),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    // Inner geometric shape
                                    Transform.rotate(
                                      angle: -0.4,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(25),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Center dot
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppColors.accentPurple,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    // Animated particles
                                    ...List.generate(4, (index) {
                                      final angle = (index * 1.57);
                                      return Transform.rotate(
                                        angle: angle,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: 6,
                                            height: 6,
                                            margin: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                // Animated text
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textSlideAnimation.value),
                      child: Opacity(
                        opacity: _textFadeAnimation.value,
                        child: const Column(
                          children: [
                            Text(
                              'Ventrixalor',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Unleash Your Creativity',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
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
    );
  }
}

class ParticleModel {
  final Offset startPosition;
  final Offset endPosition;
  final Color color;
  final double size;

  ParticleModel({
    required this.startPosition,
    required this.endPosition,
    required this.color,
    required this.size,
  });

  factory ParticleModel.random() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final screenWidth = 400.0; // Approximate screen width
    final screenHeight = 800.0; // Approximate screen height

    final colors = [
      AppColors.accentPurple,
      AppColors.accentBlue,
      AppColors.accentGreen,
      Colors.white,
    ];

    return ParticleModel(
      startPosition: Offset(
        (random % screenWidth).toDouble(),
        (random % screenHeight).toDouble(),
      ),
      endPosition: Offset(
        ((random * 7) % screenWidth).toDouble(),
        ((random * 11) % screenHeight).toDouble(),
      ),
      color: colors[(random % colors.length)],
      size: 2 + (random % 4),
    );
  }

  Offset getOffset(double progress) {
    return Offset.lerp(startPosition, endPosition, progress) ?? Offset.zero;
  }

  double getOpacity(double progress) {
    if (progress < 0.3) {
      return progress / 0.3;
    } else if (progress > 0.7) {
      return (1 - progress) / 0.3;
    }
    return 1.0;
  }
}

class LogoBackgroundPainter extends CustomPainter {
  final Color color;

  LogoBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final spacing = size.width / 8;

    // Draw diagonal lines
    for (var i = 0; i < 16; i++) {
      final x = i * spacing;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint,
      );
    }

    // Draw curved path in corners
    final path = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.1,
        size.height * 0.1,
        size.width * 0.2,
        0,
      );

    final pathReversed = Path()
      ..moveTo(size.width, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.9,
        size.width * 0.8,
        size.height,
      );

    canvas.drawPath(path, paint);
    canvas.drawPath(pathReversed, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
