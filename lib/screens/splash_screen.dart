import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';
import 'eula_screen.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _formController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isAgreed = false;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();

    // 1. Logo Animation (Scale + Rotate)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // 2. Text Reveal Animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // 3. Form Slide Up Animation
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeIn));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _formController, curve: Curves.easeOutQuart),
        );

    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        _showForm = true;
      });
      _formController.forward();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _formController.dispose();
    super.dispose();
  }

  void _handleEnter() {
    if (!_isAgreed) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.concrete,
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ColorPalette.rustedCopper.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: ColorPalette.obsidian.withOpacity(0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulse Effect Ring
                              if (_logoController.isCompleted)
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 1.0, end: 1.2),
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.easeInOut,
                                  builder: (context, value, child) {
                                    return Container(
                                      width: 120 * value,
                                      height: 120 * value,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: ColorPalette.rustedCopper
                                              .withOpacity(
                                                1.0 - (value - 1.0) * 5,
                                              ),
                                          width: 1,
                                        ),
                                      ),
                                    );
                                  },
                                  onEnd:
                                      () {}, // Repeat logic could be added here
                                ),
                              Icon(
                                FontAwesomeIcons.mugHot,
                                size: 50,
                                color: ColorPalette.obsidian,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Animated Text "Selah"
                _buildAnimatedText(),

                const SizedBox(height: 8),

                // Subtitle
                FadeTransition(
                  opacity: _textController,
                  child: Text(
                    "PRECISION BREWING",
                    style: AppTheme.monoStyle.copyWith(
                      fontSize: 12,
                      letterSpacing: 4.0,
                      color: ColorPalette.matteSteel,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Form Section
          if (_showForm)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(32, 40, 32, 60),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Agreement Checkbox
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: _isAgreed,
                                activeColor: ColorPalette.obsidian,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                side: BorderSide(
                                  color: ColorPalette.matteSteel.withOpacity(
                                    0.5,
                                  ),
                                  width: 1.5,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _isAgreed = value ?? false;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const EulaScreen(),
                                    ),
                                  );
                                },
                                child: RichText(
                                  text: TextSpan(
                                    style: AppTheme.monoStyle.copyWith(
                                      fontSize: 13,
                                      color: ColorPalette.obsidian,
                                    ),
                                    children: [
                                      const TextSpan(text: "I agree to the "),
                                      TextSpan(
                                        text: "EULA",
                                        style: TextStyle(
                                          color: ColorPalette.rustedCopper,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: " and Terms of Service",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Enter Button
                        GestureDetector(
                          onTap: _handleEnter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: _isAgreed
                                  ? ColorPalette.obsidian
                                  : ColorPalette.concreteDark,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: _isAgreed
                                  ? [
                                      BoxShadow(
                                        color: ColorPalette.obsidian
                                            .withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ENTER LABORATORY",
                                  style: AppTheme.monoStyle.copyWith(
                                    color: _isAgreed
                                        ? Colors.white
                                        : ColorPalette.matteSteel,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                if (_isAgreed) ...[
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedText() {
    const text = "Selah";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(text.length, (index) {
        return AnimatedBuilder(
          animation: _textController,
          builder: (context, child) {
            final double start = index * 0.1;
            final double end = start + 0.4;
            final double value = _textController.value;

            // Opacity & Offset for each letter
            double opacity = 0.0;
            double offsetY = 20.0;

            if (value >= start) {
              final double localProgress = ((value - start) / 0.4).clamp(
                0.0,
                1.0,
              );
              opacity = localProgress;
              offsetY =
                  20.0 * (1 - Curves.easeOutBack.transform(localProgress));
            }

            return Transform.translate(
              offset: Offset(0, offsetY),
              child: Opacity(
                opacity: opacity,
                child: Text(
                  text[index],
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: ColorPalette.obsidian,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
