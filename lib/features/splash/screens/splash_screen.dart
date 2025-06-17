import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../routes.dart';
import '../widgets/animated_particle.dart';
import '../widgets/wave_animation.dart';
import '../widgets/animated_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _particleAnimation;

  final List<AnimatedParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Generate particles
    _generateParticles();

    // Initialize animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Logo animations
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    // Text animations
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    // Particle animation
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to main screen after splash
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    });
  }

  void _generateParticles() {
    for (int i = 0; i < 50; i++) {
      _particles.add(
        AnimatedParticle(
          initialPosition: Offset(
            _random.nextDouble() * 400 - 200,
            _random.nextDouble() * 400 - 200,
          ),
          finalPosition: Offset(
            _random.nextDouble() * 800 - 400,
            _random.nextDouble() * 800 - 400,
          ),
          color: Color.fromARGB(
            150 + _random.nextInt(105),
            AppTheme.accentPurple.red,
            AppTheme.accentPurple.green,
            AppTheme.accentPurple.blue,
          ),
          size: 2 + _random.nextDouble() * 4,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Stack(
        children: [
          // Animated background with floating hearts and stars
          const AnimatedBackground(
            itemCount: 20,
            icons: [Icons.favorite, Icons.star, Icons.favorite_border],
          ),

          // Background waves
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: WaveAnimation(
              height: screenSize.height * 0.4,
              width: screenSize.width,
              color: AppTheme.deepPurple.withOpacity(0.3),
              amplitude: 25,
              speed: 0.8,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: WaveAnimation(
              height: screenSize.height * 0.3,
              width: screenSize.width,
              color: AppTheme.accentPurple.withOpacity(0.2),
              amplitude: 20,
              speed: 1.2,
            ),
          ),

          // Main content
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  // Particles
                  ..._buildParticles(),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Transform.rotate(
                          angle: _logoRotationAnimation.value,
                          child: Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Opacity(
                              opacity: _logoOpacityAnimation.value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.accentPurple,
                                      AppTheme.deepPurple,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.accentPurple
                                          .withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.favorite,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // App name
                        Transform.translate(
                          offset: Offset(0, _textSlideAnimation.value),
                          child: Opacity(
                            opacity: _textOpacityAnimation.value,
                            child: Text(
                              'Halyvernoxian',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Tagline
                        Transform.translate(
                          offset: Offset(0, _textSlideAnimation.value),
                          child: Opacity(
                            opacity: _textOpacityAnimation.value,
                            child: Text(
                              'For Couples in Love',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Loading indicator
                        Opacity(
                          opacity: _textOpacityAnimation.value,
                          child: _buildLoadingIndicator(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildParticles() {
    return _particles.map((particle) {
      final progress = _particleAnimation.value;
      final currentPosition = Offset.lerp(
        particle.initialPosition,
        particle.finalPosition,
        progress,
      )!;

      final size = particle.size * progress;
      final opacity = progress < 0.1
          ? progress * 10
          : (progress > 0.8 ? (1.0 - progress) * 5 : 1.0);

      return Positioned(
        left: MediaQuery.of(context).size.width / 2 + currentPosition.dx,
        top: MediaQuery.of(context).size.height / 2 + currentPosition.dy,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: particle.color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLoadingIndicator() {
    final animationValue = _controller.value;

    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 4,
          child: Stack(
            children: [
              // Background
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Animated progress
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 120 * animationValue,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accentPurple,
                      AppTheme.lightPurple,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentPurple.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: -1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Loading text
        Text(
          'Loading...',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
