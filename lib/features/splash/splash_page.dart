import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../shared/widgets/glass_panel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _logoRotateAnimation;

  bool _isEulaAccepted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter() {
    if (_isEulaAccepted) {
      context.go('/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the EULA to continue.'),
          backgroundColor: AppColors.toxicityAlert,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.voidBlack,
                    AppColors.deepTeal.withValues(alpha: 0.6),
                    AppColors.voidBlack,
                  ],
                ),
              ),
            ),
          ),

          // Animated Bubbles (Simulated)
          ...List.generate(5, (index) => _buildBubble(index)),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Animated Logo
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _logoRotateAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.deepTeal.withValues(alpha: 0.5),
                            border: Border.all(
                              color: AppColors.floraNeon.withValues(alpha: 0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.floraNeon.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 50 * _scaleAnimation.value,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            FontAwesomeIcons.water,
                            size: 80,
                            color: AppColors.floraNeon,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Animated Text
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'Glim',
                        style: TextStyle(
                          color: AppColors.starlightWhite,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ecosystem Control',
                        style: TextStyle(
                          color: AppColors.starlightWhite.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // EULA Checkbox
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isEulaAccepted,
                              activeColor: AppColors.floraNeon,
                              checkColor: AppColors.voidBlack,
                              side: BorderSide(
                                color: AppColors.starlightWhite.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _isEulaAccepted = value ?? false;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () => context.push('/eula'),
                              child: RichText(
                                text: const TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    color: AppColors.mossMuted,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'EULA & Terms',
                                      style: TextStyle(
                                        color: AppColors.aquaCyan,
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
                        InkWell(
                          onTap: _onEnter,
                          borderRadius: BorderRadius.circular(30),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isEulaAccepted
                                    ? [
                                        AppColors.floraNeon,
                                        const Color(0xFF00BFA5),
                                      ]
                                    : [
                                        AppColors.trenchBlue,
                                        AppColors.deepTeal,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: _isEulaAccepted
                                  ? [
                                      BoxShadow(
                                        color: AppColors.floraNeon.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                'ENTER ABYSS',
                                style: TextStyle(
                                  color: _isEulaAccepted
                                      ? AppColors.voidBlack
                                      : AppColors.mossMuted,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(int index) {
    // Simple static bubbles for visual effect, could be animated further
    final size = 10.0 + (index * 5);
    final top = 100.0 + (index * 80);
    final left = 40.0 + (index * 60);

    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.aquaCyan.withValues(alpha: 0.1),
          boxShadow: [
            BoxShadow(
              color: AppColors.aquaCyan.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
