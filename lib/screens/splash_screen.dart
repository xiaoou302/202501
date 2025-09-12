import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/constants.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Logo animation controllers
  late AnimationController _logoScaleController;
  late AnimationController _logoRotationController;
  late AnimationController _logoColorController;

  // Text animation controllers
  late AnimationController _textSlideController;
  late AnimationController _textGlowController;

  // Loading animation controllers
  late AnimationController _loadingController;
  late AnimationController _blockAnimationController;

  // Logo animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<Color?> _logoColorAnimation;

  // Text animations
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textGlowAnimation;

  // Loading animations

  // Block positions for the loading animation
  final List<Offset> _blockPositions = [];
  final List<Color> _blockColors = [];
  final int _numBlocks = 5;

  @override
  void initState() {
    super.initState();

    // Initialize block positions and colors
    _initializeBlocks();

    // Logo scale animation
    _logoScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_logoScaleController);

    // Logo rotation animation
    _logoRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoRotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: math.pi * 1.5)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: math.pi * 1.5, end: math.pi * 2)
            .chain(CurveTween(curve: Curves.decelerate)),
        weight: 40,
      ),
    ]).animate(_logoRotationController);

    // Logo color animation
    _logoColorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoColorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(
          begin: AppColors.accentMintGreen.withOpacity(0.5),
          end: AppColors.accentMintGreen,
        ),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: AppColors.accentMintGreen,
          end: Colors.white,
        ),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: Colors.white,
          end: AppColors.accentMintGreen,
        ),
        weight: 30,
      ),
    ]).animate(_logoColorController);

    // Text slide animation
    _textSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textSlideController,
      curve: Curves.elasticOut,
    ));

    // Text glow animation
    _textGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _textGlowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 10)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 10, end: 2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
    ]).animate(_textGlowController);

    // Loading animation
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Block animation controller for the loading effect
    _blockAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Start animations sequentially
    _logoRotationController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      _logoScaleController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      _logoColorController.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _textSlideController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _textGlowController.forward();
    });

    // Navigate to onboarding screen after splash delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeAnimation = animation.drive(tween);

            return FadeTransition(opacity: fadeAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  void _initializeBlocks() {
    // Define block colors
    _blockColors.addAll([
      AppColors.blockCoralPink,
      AppColors.blockSunnyYellow,
      AppColors.blockSkyBlue,
      AppColors.blockGrapePurple,
      AppColors.blockJadeGreen,
    ]);

    // Initialize block positions in a circular pattern
    for (int i = 0; i < _numBlocks; i++) {
      double angle = (i / _numBlocks) * 2 * math.pi;
      double radius = 30;
      double x = radius * math.cos(angle);
      double y = radius * math.sin(angle);
      _blockPositions.add(Offset(x, y));
    }
  }

  @override
  void dispose() {
    _logoScaleController.dispose();
    _logoRotationController.dispose();
    _logoColorController.dispose();
    _textSlideController.dispose();
    _textGlowController.dispose();
    _loadingController.dispose();
    _blockAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeepSpaceGray,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgDeepSpaceGray,
              AppColors.bgDeepSpaceGray.withBlue(70),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: Listenable.merge([
                  _logoScaleController,
                  _logoRotationController,
                  _logoColorController,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _logoRotationAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _logoColorAnimation.value,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: (_logoColorAnimation.value ??
                                      AppColors.accentMintGreen)
                                  .withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.grid_view_rounded,
                          color: AppColors.bgDeepSpaceGray,
                          size: 60,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Animated Text
              SlideTransition(
                position: _textSlideAnimation,
                child: AnimatedBuilder(
                  animation: _textGlowController,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentMintGreen.withOpacity(0.3),
                            blurRadius: _textGlowAnimation.value,
                            spreadRadius: _textGlowAnimation.value / 5,
                          ),
                        ],
                      ),
                      child: const Text(
                        'BLOKKO',
                        style: TextStyle(
                          color: AppColors.textMoonWhite,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              SlideTransition(
                position: _textSlideAnimation,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'PATTERN MATCH & CLEAR',
                    style: TextStyle(
                      color: AppColors.textMoonWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Custom Loading Animation
              SizedBox(
                height: 60,
                width: 60,
                child: AnimatedBuilder(
                  animation: _blockAnimationController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: List.generate(_numBlocks, (index) {
                        // Calculate dynamic position with animation
                        final progress = (_blockAnimationController.value +
                                index / _numBlocks) %
                            1.0;

                        // Create a wave-like motion
                        final waveOffset = math.sin(progress * math.pi * 2) * 8;

                        // Scale effect
                        final scale = 0.6 + math.sin(progress * math.pi) * 0.4;

                        return Positioned(
                          left: 30 +
                              _blockPositions[index].dx *
                                  math.cos(progress * math.pi * 2),
                          top: 30 +
                              _blockPositions[index].dy *
                                  math.sin(progress * math.pi * 2) +
                              waveOffset,
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color:
                                    _blockColors[index % _blockColors.length],
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: _blockColors[
                                            index % _blockColors.length]
                                        .withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                ],
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
      ),
    );
  }
}
