import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'dart:math' as math;

/// Onboarding screen with game introduction
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _backgroundController;
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.menu_book_rounded,
      title: 'The Ancient Codex',
      subtitle: '古老的法典',
      description:
          'In a realm where memories fade like ink on weathered pages, you discover the Zenion Codex—an ancient tome holding the wisdom of forgotten ages.',
      gradient: [AppColors.magicBlue, AppColors.magicPurple],
      features: [
        'Discover a world of fading memories',
        'Uncover ancient secrets',
        'Become the keeper of lost knowledge',
      ],
    ),
    OnboardingPage(
      icon: Icons.timer_outlined,
      title: 'Race Against Time',
      subtitle: '与时间竞赛',
      description:
          'Words vanish as you read. The Codex is fading, and with it, the memories it holds. You must read swiftly before the knowledge disappears forever.',
      gradient: [AppColors.warningRed, AppColors.glowAmber],
      features: [
        'Read before text fades away',
        'Each chapter presents a unique challenge',
        'Master the art of speed reading',
      ],
    ),
    OnboardingPage(
      icon: Icons.category_outlined,
      title: 'Collect Keywords',
      subtitle: '收集关键词',
      description:
          'Hidden within the text are mystical keywords—fragments of power that unlock the Codex\'s deepest secrets. Click swiftly to capture them.',
      gradient: [AppColors.magicPurple, AppColors.magicGold],
      features: [
        'Find hidden keywords in the text',
        'Build your collection of power words',
        'Unlock special achievements',
      ],
    ),
    OnboardingPage(
      icon: Icons.auto_stories_outlined,
      title: 'Master the Codex',
      subtitle: '掌握法典',
      description:
          'Progress through chapters, improve your skills, and prove yourself worthy of the ancient wisdom. Are you ready to begin your journey?',
      gradient: [AppColors.arcaneGreen, AppColors.magicBlue],
      features: [
        'Track your progress and statistics',
        'Compete for the best times',
        'Unlock all chapters and secrets',
      ],
      isLast: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  void _skipToEnd() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.parchmentLight,
                      AppColors.parchmentMedium,
                      AppColors.parchmentDark,
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: MysticPatternPainter(_backgroundController.value),
                  size: Size.infinite,
                ),
              );
            },
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _skipToEnd,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.inkBrown,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index], index);
                    },
                  ),
                ),

                // Page indicators and button
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => _buildPageIndicator(index),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Next/Start button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pages[_currentPage].gradient[0],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: _pages[_currentPage]
                                .gradient[0]
                                .withOpacity(0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1
                                    ? 'Begin Journey'
                                    : 'Continue',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentPage == _pages.length - 1
                                    ? Icons.check_circle_outline
                                    : Icons.arrow_forward_rounded,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildPage(OnboardingPage page, int index) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Icon with gradient background
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: page.gradient,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: page.gradient[0].withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      page.icon,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Title
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: page.gradient,
                          ).createShader(bounds),
                          child: Text(
                            page.title,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          page.subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppColors.inkFaded,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Description card
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: page.gradient[0].withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: page.gradient[0].withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            page.description,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: AppColors.inkBrown,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          // Features list
                          ...page.features.map((feature) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: page.gradient,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.inkBrown,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: isActive
            ? LinearGradient(colors: _pages[_currentPage].gradient)
            : null,
        color: isActive ? null : AppColors.inkFaded.withOpacity(0.3),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: _pages[_currentPage].gradient[0].withOpacity(0.4),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Onboarding page data model
class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<Color> gradient;
  final List<String> features;
  final bool isLast;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.features,
    this.isLast = false,
  });
}

/// Custom painter for mystic background pattern
class MysticPatternPainter extends CustomPainter {
  final double progress;

  MysticPatternPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw mystical floating symbols/runes
    for (int i = 0; i < 15; i++) {
      final seed = i * 234.567;
      final x = (math.sin(seed) * 0.5 + 0.5) * size.width;
      final baseY = (math.cos(seed * 0.8) * 0.5 + 0.5) * size.height;
      
      // Animate position
      final yOffset = math.sin(progress * math.pi * 2 + seed) * 20;
      final y = baseY + yOffset;

      // Animate opacity
      final opacity = ((math.sin(progress * math.pi + seed * 0.3) * 0.5 + 0.5) * 0.15)
          .clamp(0.0, 0.15);

      // Rotation
      final rotation = progress * math.pi * 2 + seed;

      paint.color = AppColors.magicGold.withOpacity(opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // Draw simple rune-like shapes
      final runeType = i % 3;
      switch (runeType) {
        case 0:
          // Circle
          canvas.drawCircle(Offset.zero, 15, paint);
          canvas.drawCircle(Offset.zero, 10, paint);
          break;
        case 1:
          // Triangle
          final path = Path()
            ..moveTo(0, -15)
            ..lineTo(13, 15)
            ..lineTo(-13, 15)
            ..close();
          canvas.drawPath(path, paint);
          break;
        case 2:
          // Lines
          canvas.drawLine(const Offset(-15, 0), const Offset(15, 0), paint);
          canvas.drawLine(const Offset(0, -15), const Offset(0, 15), paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(MysticPatternPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

