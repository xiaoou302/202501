import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:orivet/presentation/screens/home_screen.dart';
import 'package:orivet/presentation/screens/eula_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _gearController;
  late AnimationController _textController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isEulaAccepted = false;

  @override
  void initState() {
    super.initState();

    // Gear Rotation Animation
    _gearController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Text Reveal Animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    // Start text animation after a slight delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _gearController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _enterApp() {
    if (_isEulaAccepted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vellum,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Noise/Texture Overlay
          Opacity(
            opacity: 0.05,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://www.transparenttextures.com/patterns/cream-paper.png'),
                  repeat: ImageRepeat.repeat,
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating Gear Background
                    AnimatedBuilder(
                      animation: _gearController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _gearController.value * 2 * math.pi,
                          child: child,
                        );
                      },
                      child: Icon(
                        FontAwesomeIcons.gear,
                        size: 180,
                        color: AppColors.brass.withOpacity(0.2),
                      ),
                    ),
                    // Inner Static/Scaling Icon
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.vellum,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.leather.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          FontAwesomeIcons.compassDrafting,
                          size: 60,
                          color: AppColors.leather,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Animated Text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        "Rue",
                        style: GoogleFonts.cinzel(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.leather,
                          letterSpacing: 8.0,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 2,
                        color: AppColors.brass,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "RELIC • RESTORE • REMEMBER",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: AppColors.bronze,
                          letterSpacing: 4.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Area: EULA & Enter Button
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // EULA Checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isEulaAccepted,
                        activeColor: AppColors.leather,
                        checkColor: AppColors.vellum,
                        side: const BorderSide(color: AppColors.leather),
                        onChanged: (value) {
                          setState(() {
                            _isEulaAccepted = value ?? false;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EulaScreen()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.lato(
                              color: AppColors.soot,
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(text: "I agree to the "),
                              TextSpan(
                                text: "End User License Agreement",
                                style: GoogleFonts.lato(
                                  color: AppColors.leather,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Enter Button
                  GestureDetector(
                    onTap: _isEulaAccepted ? _enterApp : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: _isEulaAccepted
                            ? AppColors.leatherGradient
                            : LinearGradient(
                                colors: [
                                  AppColors.soot.withOpacity(0.3),
                                  AppColors.soot.withOpacity(0.3)
                                ],
                              ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: _isEulaAccepted
                            ? [
                                BoxShadow(
                                  color: AppColors.leather.withOpacity(0.3),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                )
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          "ENTER WORKSHOP",
                          style: GoogleFonts.cinzel(
                            color: _isEulaAccepted
                                ? AppColors.vellum
                                : AppColors.vellum.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
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
    );
  }
}
