import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../data/local/local_storage.dart';
import '../widgets/particle_background.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _leafController;
  late AnimationController _glowController;
  late AnimationController _textController;
  late AnimationController _loadingController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _leafFloat;
  late Animation<double> _glowPulse;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // Floating leaves animation
    _leafController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _leafFloat = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _leafController, curve: Curves.easeInOut),
    );

    // Glow pulse animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _glowPulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  void _startAnimationSequence() async {
    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Start text animation
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Navigate after loading
    await Future.delayed(const Duration(milliseconds: 2500));
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Check if user has seen onboarding
    final hasSeenOnboarding = LocalStorage.hasSeenOnboarding();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              hasSeenOnboarding ? const HomeScreen() : const OnboardingScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _leafController.dispose();
    _glowController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          // Animated gradient overlay
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5 * _glowPulse.value,
                    colors: [
                      const Color(
                        0xFF2ECC71,
                      ).withOpacity(0.1 * _glowPulse.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  _buildAnimatedLogo(),
                  const SizedBox(height: 40),
                  _buildAnimatedTitle(),
                  const SizedBox(height: 12),
                  _buildSubtitle(),
                  const Spacer(flex: 2),
                  _buildLoadingIndicator(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Transform.rotate(
            angle: _logoRotation.value * pi,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      width: 160 + (20 * _glowPulse.value),
                      height: 160 + (20 * _glowPulse.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF2ECC71,
                            ).withOpacity(0.4 * _glowPulse.value),
                            blurRadius: 40 * _glowPulse.value,
                            spreadRadius: 10 * _glowPulse.value,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Main logo container
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2ECC71),
                        Color(0xFF27AE60),
                        Color(0xFF16A085),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated pattern background
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _NaturePatternPainter(
                            animation: _leafController.value,
                          ),
                        ),
                      ),
                      // Main leaf icon
                      const FaIcon(
                        FontAwesomeIcons.spa,
                        size: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                // Floating leaves around logo
                ..._buildFloatingLeaves(),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildFloatingLeaves() {
    return List.generate(6, (index) {
      final angle = (2 * pi * index) / 6;
      final distance = 100.0;

      return AnimatedBuilder(
        animation: _leafController,
        builder: (context, child) {
          final offsetAngle = angle + (_leafController.value * 0.3);
          final x = cos(offsetAngle) * distance;
          final y = sin(offsetAngle) * distance + _leafFloat.value;

          return Transform.translate(
            offset: Offset(x, y),
            child: Opacity(
              opacity:
                  0.6 + (0.4 * sin(_leafController.value * 2 * pi + index)),
              child: Transform.rotate(
                angle: _leafController.value * 2 * pi,
                child: FaIcon(
                  _getLeafIcon(index),
                  size: 16 + (4 * sin(_leafController.value * 2 * pi + index)),
                  color: _getLeafColor(index),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  IconData _getLeafIcon(int index) {
    final icons = [
      FontAwesomeIcons.leaf,
      FontAwesomeIcons.seedling,
      FontAwesomeIcons.tree,
      FontAwesomeIcons.clover,
      FontAwesomeIcons.leaf,
      FontAwesomeIcons.seedling,
    ];
    return icons[index % icons.length];
  }

  Color _getLeafColor(int index) {
    final colors = [
      const Color(0xFF2ECC71),
      const Color(0xFF27AE60),
      const Color(0xFF16A085),
      const Color(0xFF1ABC9C),
      const Color(0xFF2ECC71),
      const Color(0xFF00CEC9),
    ];
    return colors[index % colors.length];
  }

  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFade,
          child: SlideTransition(
            position: _textSlide,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFF2ECC71),
                    Color(0xFF00CEC9),
                    Color(0xFF3498DB),
                  ],
                ).createShader(bounds);
              },
              child: Text(
                'MEMBLY',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 56,
                  color: Colors.white,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: const Color(0xFF2ECC71).withOpacity(0.5),
                      blurRadius: 30,
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

  Widget _buildSubtitle() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFade,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.paw,
                size: 12,
                color: Color(0xFF2ECC71),
              ),
              const SizedBox(width: 10),
              Text(
                'Nature Memory Journey',
                style: AppTextStyles.body.copyWith(
                  fontSize: 15,
                  color: const Color(0xFF2ECC71),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(width: 10),
              const FaIcon(
                FontAwesomeIcons.paw,
                size: 12,
                color: Color(0xFF2ECC71),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        return Column(
          children: [
            Text(
              'Loading...',
              style: AppTextStyles.label.copyWith(
                fontSize: 12,
                color: AppColors.mica.withOpacity(0.6),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final delay = index * 0.2;
                  final animValue = (_loadingController.value + delay) % 1.0;
                  final scale = sin(animValue * pi);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Transform.scale(
                      scale: 0.5 + (scale * 0.5),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF2ECC71).withOpacity(scale),
                              const Color(0xFF00CEC9).withOpacity(scale),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2ECC71,
                              ).withOpacity(scale * 0.5),
                              blurRadius: 8 * scale,
                              spreadRadius: 2 * scale,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NaturePatternPainter extends CustomPainter {
  final double animation;

  _NaturePatternPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw animated leaf veins
    for (int i = 0; i < 8; i++) {
      final angle = (2 * pi * i) / 8 + (animation * pi * 0.1);
      final startX = centerX;
      final startY = centerY;
      final endX = centerX + cos(angle) * 45;
      final endY = centerY + sin(angle) * 45;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      // Draw branches
      for (int j = 1; j <= 3; j++) {
        final branchRatio = j / 4;
        final branchX = startX + (endX - startX) * branchRatio;
        final branchY = startY + (endY - startY) * branchRatio;
        final branchLen = 12 * (1 - branchRatio);

        // Left branch
        final leftEndX = branchX + cos(angle - pi / 3) * branchLen;
        final leftEndY = branchY + sin(angle - pi / 3) * branchLen;
        canvas.drawLine(
          Offset(branchX, branchY),
          Offset(leftEndX, leftEndY),
          paint..strokeWidth = 1,
        );

        // Right branch
        final rightEndX = branchX + cos(angle + pi / 3) * branchLen;
        final rightEndY = branchY + sin(angle + pi / 3) * branchLen;
        canvas.drawLine(
          Offset(branchX, branchY),
          Offset(rightEndX, rightEndY),
          paint..strokeWidth = 1,
        );
      }
    }

    // Draw center circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      10,
      paint
        ..style = PaintingStyle.fill
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_NaturePatternPainter oldDelegate) =>
      animation != oldDelegate.animation;
}
