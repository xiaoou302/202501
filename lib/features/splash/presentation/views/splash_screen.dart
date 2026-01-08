import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../app/theme/color_palette.dart';
import 'eula_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _pulseAnimation;
  
  bool _agreedToEULA = false;

  @override
  void initState() {
    super.initState();
    
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    
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
    
    // Text animations
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );
    
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start animations
    _logoController.forward().then((_) {
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.accent.withValues(alpha: 0.05),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated particles background
              AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ParticlePainter(_particleController.value),
                    size: Size.infinite,
                  );
                },
              ),
              
              // Main content
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated logo
                          AnimatedBuilder(
                            animation: _logoController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _logoOpacity.value,
                                child: Transform.scale(
                                  scale: _logoScale.value,
                                  child: Transform.rotate(
                                    angle: _logoRotation.value * math.pi,
                                    child: AnimatedBuilder(
                                      animation: _pulseAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _pulseAnimation.value,
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  AppColors.accent,
                                                  AppColors.accent.withValues(alpha: 0.7),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.accent.withValues(alpha: 0.4),
                                                  blurRadius: 30,
                                                  spreadRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.auto_awesome,
                                              size: 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Animated app name
                          SlideTransition(
                            position: _textSlide,
                            child: FadeTransition(
                              opacity: _textOpacity,
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    AppColors.accent,
                                    AppColors.accent.withValues(alpha: 0.8),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  'Capu',
                                  style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          FadeTransition(
                            opacity: _textOpacity,
                            child: Text(
                              'Your Style, Your Story',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // EULA agreement section
                  FadeTransition(
                    opacity: _textOpacity,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Agreement checkbox
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreedToEULA = !_agreedToEULA;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _agreedToEULA
                                      ? AppColors.accent
                                      : AppColors.gray.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _agreedToEULA
                                          ? AppColors.accent
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _agreedToEULA
                                            ? AppColors.accent
                                            : AppColors.gray,
                                        width: 2,
                                      ),
                                    ),
                                    child: _agreedToEULA
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const EULAScreen(),
                                          ),
                                        );
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.text,
                                          ),
                                          children: [
                                            const TextSpan(text: 'I agree to the '),
                                            TextSpan(
                                              text: 'EULA',
                                              style: TextStyle(
                                                color: AppColors.accent,
                                                fontWeight: FontWeight.w700,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Enter button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _agreedToEULA
                                  ? () {
                                      Navigator.pushReplacementNamed(context, '/main');
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _agreedToEULA
                                    ? AppColors.accent
                                    : AppColors.gray.withValues(alpha: 0.3),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                    AppColors.gray.withValues(alpha: 0.3),
                                disabledForegroundColor:
                                    AppColors.grayDark.withValues(alpha: 0.5),
                                elevation: _agreedToEULA ? 8 : 0,
                                shadowColor: _agreedToEULA
                                    ? AppColors.accent.withValues(alpha: 0.5)
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'Enter Capu',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for animated particles
class ParticlePainter extends CustomPainter {
  final double animationValue;
  
  ParticlePainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Draw multiple particles
    for (int i = 0; i < 20; i++) {
      final progress = (animationValue + i * 0.05) % 1.0;
      final x = size.width * (0.1 + (i % 5) * 0.2);
      final y = size.height * progress;
      final opacity = (1 - progress) * 0.3;
      
      paint.color = AppColors.accent.withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(x, y),
        2 + (i % 3),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}
