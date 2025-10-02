import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Splash screen displayed when the app starts
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Logo animation controllers
  late AnimationController _logoScaleController;
  late Animation<double> _logoScaleAnimation;

  // Text animation controllers
  late AnimationController _textController;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;

  // Arrow animations
  late AnimationController _arrowController;
  late List<Animation<double>> _arrowAnimations;

  // Loading animation controller
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  // Background animation
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Logo scale animation
    _logoScaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOutQuart)),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40.0,
      ),
    ]).animate(_logoScaleController);

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );

    // Arrow animations
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _arrowAnimations = List.generate(4, (index) {
      final start = index * 0.1;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _arrowController,
          curve: Interval(start, start + 0.6, curve: Curves.easeOutQuint),
        ),
      );
    });

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_loadingController);

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    // Start animations in sequence
    _logoScaleController.forward();

    Future.delayed(const Duration(milliseconds: 600), () {
      _textController.forward();
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      _arrowController.forward();
    });

    // Navigate to home screen after delay
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _logoScaleController.dispose();
    _textController.dispose();
    _arrowController.dispose();
    _loadingController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.background,
                  Color.lerp(
                    AppColors.background,
                    const Color(0xFFE8E1D9),
                    _backgroundAnimation.value,
                  )!,
                ],
                stops: [0.3, 1.0],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Animated arrows in background
              ..._buildBackgroundArrows(),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App logo
                    ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: _buildAppLogo(),
                    ),

                    const SizedBox(height: 24),

                    // App name
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _textSlideAnimation.value),
                          child: Opacity(
                            opacity: _textOpacityAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: const Text(
                        'Glyphion',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGraphite,
                        ),
                      ),
                    ),

                    // Tagline
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _textSlideAnimation.value * 1.2),
                          child: Opacity(
                            opacity: _textOpacityAnimation.value * 0.9,
                            child: child,
                          ),
                        );
                      },
                      child: const Text(
                        'Arrow Fly Out',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.disabledGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading indicator
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Center(child: _buildLoadingIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.arrowBlue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background gradient
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.white.withOpacity(0.8)],
                ),
              ),
            ),
          ),

          // Logo content
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Arrows
                ..._buildLogoArrows(),

                // Center circle
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.accentCoral.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCoral.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLogoArrows() {
    final arrowColors = [
      AppColors.arrowBlue,
      AppColors.arrowTerracotta,
      AppColors.arrowGreen,
      AppColors.arrowPink,
    ];

    return List.generate(4, (index) {
      final angle = index * (math.pi / 2);
      final color = arrowColors[index];

      return AnimatedBuilder(
        animation: _arrowAnimations[index],
        builder: (context, child) {
          return Transform.rotate(
            angle: angle,
            child: Transform.translate(
              offset: Offset(0, -20 * _arrowAnimations[index].value),
              child: Opacity(
                opacity: _arrowAnimations[index].value,
                child: _buildArrow(color),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildArrow(Color color) {
    return Icon(Icons.arrow_upward_rounded, color: color, size: 28);
  }

  List<Widget> _buildBackgroundArrows() {
    final random = math.Random(42); // Fixed seed for consistent positioning
    final arrowColors = [
      AppColors.arrowBlue.withOpacity(0.2),
      AppColors.arrowTerracotta.withOpacity(0.2),
      AppColors.arrowGreen.withOpacity(0.2),
      AppColors.arrowPink.withOpacity(0.2),
    ];

    return List.generate(20, (index) {
      final size = random.nextDouble() * 20 + 10;
      final x = random.nextDouble() * MediaQuery.of(context).size.width;
      final y = random.nextDouble() * MediaQuery.of(context).size.height;
      final color = arrowColors[random.nextInt(arrowColors.length)];
      final angle = random.nextDouble() * math.pi * 2;
      final delay = random.nextDouble() * 0.8;

      return Positioned(
        left: x,
        top: y,
        child: AnimatedBuilder(
          animation: _arrowController,
          builder: (context, child) {
            final progress =
                (_arrowController.value - delay).clamp(0.0, 1.0) / 1.0;
            return Transform.rotate(
              angle: angle,
              child: Opacity(
                opacity: progress * 0.6,
                child: Transform.scale(
                  scale: progress,
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: color,
                    size: size,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Container(
          width: 160,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              // Animated gradient
              Positioned(
                left: -80 + (_loadingAnimation.value * 240),
                child: Container(
                  width: 80,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentCoral.withOpacity(0),
                        AppColors.accentCoral,
                        AppColors.accentCoral.withOpacity(0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Progress indicator
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor:
                      _loadingAnimation.value.clamp(0.0, 0.8) +
                      (math.sin(_loadingController.value * math.pi * 2) * 0.03),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.accentCoral.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
