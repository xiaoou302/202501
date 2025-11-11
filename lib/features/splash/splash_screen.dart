import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import '../../core/constants/app_constants.dart';
import '../../navigation/main_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  final Function(bool)? onThemeToggle;

  const SplashScreen({Key? key, this.onThemeToggle}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _contentController;
  late AnimationController _pawController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<double> _pawAnimation;

  bool _agreedToEULA = false;
  bool _isEntering = false;

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
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Content animation controller
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Paw animation controller (continuous)
    _pawController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text animations
    _textSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Content fade animation
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    // Paw animation
    _pawAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pawController, curve: Curves.easeInOut));

    // Start animations in sequence
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _contentController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _contentController.dispose();
    _pawController.dispose();
    super.dispose();
  }

  Future<void> _launchEULA() async {
    final uri = Uri.parse(
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _enterApp() {
    if (!_agreedToEULA) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the EULA to continue'),
          backgroundColor: AppConstants.softCoral,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isEntering = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MainScreen(onThemeToggle: widget.onThemeToggle),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppConstants.deepPlum,
                    AppConstants.darkGray,
                    AppConstants.deepPlum,
                  ]
                : [
                    AppConstants.shellWhite,
                    AppConstants.softCoral.withOpacity(0.1),
                    AppConstants.shellWhite,
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background paw prints
              ..._buildBackgroundPaws(size),

              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingXL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with animation
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Transform.rotate(
                              angle: _logoRotateAnimation.value,
                              child: Opacity(
                                opacity: _logoOpacityAnimation.value,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppConstants.softCoral,
                                        AppConstants.softCoral.withOpacity(0.7),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppConstants.softCoral
                                            .withOpacity(0.4),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.pets,
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.spacingXL),

                      // App name with animation
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _textSlideAnimation.value),
                            child: Opacity(
                              opacity: _textOpacityAnimation.value,
                              child: Column(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        colors: [
                                          AppConstants.softCoral,
                                          AppConstants.softCoral.withOpacity(
                                            0.8,
                                          ),
                                        ],
                                      ).createShader(bounds);
                                    },
                                    child: const Text(
                                      'Leno',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                        inherit: false,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppConstants.spacingS),
                                  Text(
                                    'Your Pet Care Companion',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: AppConstants.mediumGray,
                                      letterSpacing: 1,
                                      inherit: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.spacingXL * 2),

                      // EULA agreement section
                      AnimatedBuilder(
                        animation: _contentController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _contentFadeAnimation.value,
                            child: Column(
                              children: [
                                // EULA checkbox and text
                                Container(
                                  padding: const EdgeInsets.all(
                                    AppConstants.spacingM,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppConstants.darkGray.withOpacity(0.5)
                                        : AppConstants.panelWhite.withOpacity(
                                            0.8,
                                          ),
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.radiusL,
                                    ),
                                    border: Border.all(
                                      color: _agreedToEULA
                                          ? AppConstants.softCoral
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Custom checkbox
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _agreedToEULA = !_agreedToEULA;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: _agreedToEULA
                                                ? AppConstants.softCoral
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: _agreedToEULA
                                                  ? AppConstants.softCoral
                                                  : AppConstants.mediumGray,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
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
                                      ),
                                      const SizedBox(
                                        width: AppConstants.spacingM,
                                      ),
                                      // EULA text
                                      Flexible(
                                        child: RichText(
                                          text: TextSpan(
                                            style:
                                                theme.textTheme.bodyMedium
                                                    ?.copyWith(
                                                      inherit: false,
                                                    ) ??
                                                TextStyle(
                                                  fontSize: 14,
                                                  color: isDark
                                                      ? AppConstants.softWhite
                                                      : AppConstants
                                                            .darkGraphite,
                                                  inherit: false,
                                                ),
                                            children: [
                                              TextSpan(text: 'I agree to the '),
                                              TextSpan(
                                                text: 'EULA',
                                                style: TextStyle(
                                                  color: AppConstants.softCoral,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  inherit: false,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = _launchEULA,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppConstants.spacingXL),

                                // Enter button
                                SizedBox(
                                  width: 200,
                                  height: 56,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _isEntering ? null : _enterApp,
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.radiusFull,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppConstants.softCoral,
                                          borderRadius: BorderRadius.circular(
                                            AppConstants.radiusFull,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppConstants.softCoral
                                                  .withOpacity(0.5),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: _isEntering
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      'Enter',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundPaws(Size size) {
    return List.generate(8, (index) {
      final random = math.Random(index);
      final left = random.nextDouble() * 0.8;
      final top = random.nextDouble() * 0.8;
      final delay = index * 0.2;

      return Positioned(
        left: size.width * left,
        top: size.height * top,
        child: AnimatedBuilder(
          animation: _pawController,
          builder: (context, child) {
            final animationValue = (_pawAnimation.value + delay) % 1.0;
            final opacity = (math.sin(animationValue * 2 * math.pi) + 1) / 2;
            final scale = 0.8 + (opacity * 0.4);

            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity * 0.15,
                child: Icon(
                  Icons.pets,
                  size: 40 + (index % 3) * 20,
                  color: AppConstants.softCoral,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
