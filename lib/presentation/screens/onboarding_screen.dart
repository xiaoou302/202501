import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/local/local_storage.dart';
import '../widgets/particle_background.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late List<AnimationController> _fadeControllers;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: FontAwesomeIcons.seedling,
      title: 'Welcome to Membly',
      description:
          'Embark on a magical memory journey through nature! Connect with adorable animals and discover the beauty of the natural world.',
      color: const Color(0xFF2ECC71),
      secondaryColor: const Color(0xFF27AE60),
      features: [
        'Beautiful nature theme',
        '12 progressive levels',
        'Charming animal icons',
      ],
    ),
    OnboardingPage(
      icon: FontAwesomeIcons.gamepad,
      title: 'Simple & Fun Gameplay',
      description:
          'Flip cards to reveal hidden animals and nature elements. Match pairs before time runs out to complete each level!',
      color: const Color(0xFF3498DB),
      secondaryColor: const Color(0xFF2980B9),
      features: ['Easy to learn', 'Tap to flip cards', 'Find matching pairs'],
    ),
    OnboardingPage(
      icon: FontAwesomeIcons.fire,
      title: 'Build Your Combo',
      description:
          'Match cards consecutively without mistakes to build powerful combos! The higher your streak, the more points you earn.',
      color: const Color(0xFFE67E22),
      secondaryColor: const Color(0xFFD35400),
      features: ['Combo multipliers', 'Bonus scoring', 'Perfect match rewards'],
    ),
    OnboardingPage(
      icon: FontAwesomeIcons.trophy,
      title: 'Earn Stars & Achievements',
      description:
          'Complete levels with time to spare and earn up to 3 stars! Unlock special achievements as you master the game.',
      color: const Color(0xFFF1C40F),
      secondaryColor: const Color(0xFFF39C12),
      features: [
        'Star rating system',
        'Track your records',
        'Special achievements',
      ],
    ),
    OnboardingPage(
      icon: FontAwesomeIcons.heart,
      title: 'Ready to Begin?',
      description:
          'Your nature adventure awaits! Test your memory, relax with beautiful visuals, and have fun matching cute animals.',
      color: const Color(0xFF9B59B6),
      secondaryColor: const Color(0xFF8E44AD),
      features: [
        'No ads, completely free',
        'Play offline anytime',
        '100% privacy protected',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeControllers = List.generate(
      _pages.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    _fadeControllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticUtils.selectionClick();
    _fadeControllers[page].forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() async {
    await LocalStorage.setHasSeenOnboarding(true);
    HapticUtils.mediumImpact();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
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
                _buildBottomSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _pages[_currentPage].color,
                      _pages[_currentPage].secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _pages[_currentPage].color.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.spa,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'MEMBLY',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 20,
                  color: _pages[_currentPage].color,
                ),
              ),
            ],
          ),
          // Skip button
          if (_currentPage < _pages.length - 1)
            GestureDetector(
              onTap: _skipOnboarding,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.slate.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.mica.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Skip',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    color: AppColors.mica.withOpacity(0.8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, int index) {
    return FadeTransition(
      opacity: _fadeControllers[index],
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAnimatedIcon(page),
            const SizedBox(height: 32),
            _buildTitle(page),
            const SizedBox(height: 16),
            _buildDescription(page),
            const SizedBox(height: 24),
            _buildFeatures(page),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(OnboardingPage page) {
    return TweenAnimationBuilder(
      key: ValueKey(_currentPage),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.rotate(
            angle: (1 - value) * 0.5,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [page.color, page.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: page.color.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative circles
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DecorativeCirclesPainter(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  // Main icon
                  FaIcon(page.icon, size: 50, color: Colors.white),
                  // Floating particles
                  ..._buildFloatingParticles(page.color),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildFloatingParticles(Color color) {
    return List.generate(4, (index) {
      final angle = (2 * pi * index) / 4;
      final distance = 70.0;

      return TweenAnimationBuilder(
        key: ValueKey('particle_$_currentPage\_$index'),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 1000 + (index * 200)),
        curve: Curves.easeOut,
        builder: (context, double value, child) {
          final x = cos(angle) * distance * value;
          final y = sin(angle) * distance * value;

          return Transform.translate(
            offset: Offset(x, y),
            child: Opacity(
              opacity: 1.0 - value,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildTitle(OnboardingPage page) {
    return Text(
      page.title,
      style: AppTextStyles.h1.copyWith(
        fontSize: 28,
        color: page.color,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(OnboardingPage page) {
    return Text(
      page.description,
      style: AppTextStyles.body.copyWith(
        fontSize: 14,
        height: 1.5,
        color: AppColors.mica.withOpacity(0.85),
      ),
      textAlign: TextAlign.center,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFeatures(OnboardingPage page) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            page.color.withOpacity(0.1),
            page.secondaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: page.color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: page.features
            .asMap()
            .entries
            .map(
              (entry) => _buildFeatureItem(entry.value, page.color, entry.key),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFeatureItem(String text, Color color, int index) {
    return TweenAnimationBuilder(
      key: ValueKey('feature_$_currentPage\_$index'),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mica.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          _buildPageIndicator(),
          const SizedBox(height: 24),
          _buildNavigationButton(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      _pages[_currentPage].color,
                      _pages[_currentPage].secondaryColor,
                    ],
                  )
                : null,
            color: isActive ? null : AppColors.slate.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _pages[_currentPage].color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButton() {
    final isLastPage = _currentPage == _pages.length - 1;
    final page = _pages[_currentPage];

    return GestureDetector(
      onTap: _nextPage,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [page.color, page.secondaryColor]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: page.color.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? 'Start Adventure' : 'Continue',
              style: AppTextStyles.h3.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            FaIcon(
              isLastPage ? FontAwesomeIcons.play : FontAwesomeIcons.arrowRight,
              size: 18,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color secondaryColor;
  final List<String> features;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.secondaryColor,
    required this.features,
  });
}

class _DecorativeCirclesPainter extends CustomPainter {
  final Color color;

  _DecorativeCirclesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        (size.width / 2) * (i / 4),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DecorativeCirclesPainter oldDelegate) => false;
}
