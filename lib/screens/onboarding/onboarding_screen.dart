import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/colors.dart';
import '../../widgets/common/cyber_button.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPage = false;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to ChroPlexiGnosis',
      subtitle: 'A Cerebral Matching Experience',
      description:
          'Embark on a journey through time and space as you match patterns and solve puzzles in this unique blend of strategy and reflexes.',
      imagePath: 'assets/onboarding/concept.png',
      backgroundColor: AppColors.primaryDark,
      iconData: Icons.psychology,
      iconColor: AppColors.primaryAccent,
    ),
    OnboardingPage(
      title: 'Master the Basics',
      subtitle: 'Color and Shape Matching',
      description:
          'Match three or more units of the same color or shape. Create perfect matches by combining both color and shape for special abilities.',
      imagePath: 'assets/onboarding/gameplay.png',
      backgroundColor: AppColors.primaryDark.withBlue(50),
      iconData: Icons.grid_view,
      iconColor: AppColors.primaryAccent,
    ),
    OnboardingPage(
      title: 'Advanced Mechanics',
      subtitle: 'Transmute and Transform',
      description:
          'Use transmute abilities from perfect matches to change unit properties. Unlock special interactions with changing units and polluted tiles.',
      imagePath: 'assets/onboarding/mechanics.png',
      backgroundColor: AppColors.primaryDark.withGreen(50),
      iconData: Icons.auto_awesome,
      iconColor: AppColors.secondaryAccent,
    ),
    OnboardingPage(
      title: 'Strategic Tips',
      subtitle: 'Plan Your Moves',
      description:
          'Think ahead and plan your moves carefully. Focus on creating perfect matches to earn transmute abilities for challenging objectives.',
      imagePath: 'assets/onboarding/strategy.png',
      backgroundColor: AppColors.primaryDark.withRed(50),
      iconData: Icons.lightbulb,
      iconColor: Colors.amberAccent,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isLastPage = page == _pages.length - 1;
    });
  }

  void _nextPage() {
    if (_isLastPage) {
      _navigateToHome();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: const Interval(0.3, 1.0)),
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pages[_currentPage].backgroundColor,
      body: Stack(
        children: [
          // Background hexagon grid
          CustomPaint(
            painter: OnboardingBackgroundPainter(
              color: _pages[_currentPage].iconColor.withOpacity(0.1),
            ),
            size: Size.infinite,
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: _navigateToHome,
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page content
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

                // Page indicator and next button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page indicators
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => _buildPageIndicator(index == _currentPage),
                        ),
                      ),

                      // Next button
                      CyberButton(
                        text: _isLastPage ? 'START' : 'NEXT',
                        onPressed: _nextPage,
                        backgroundColor: _pages[_currentPage].iconColor,
                        textColor: AppColors.primaryDark,
                        height: 48,
                        width: 120,
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
    // We can use this offset for more advanced animations if needed
    // final pageOffset = _currentPage - index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with glow effect
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.iconColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(page.iconData, size: 60, color: page.iconColor),
            ),
          ),

          const SizedBox(height: 40),

          // Title and subtitle
          Text(
            page.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: page.iconColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            page.subtitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              page.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),

          // Placeholder for image (in a real app, you'd use Image.asset)
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: page.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: page.iconColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                _getImagePlaceholderIcon(index),
                size: 80,
                color: page.iconColor.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getImagePlaceholderIcon(int index) {
    switch (index) {
      case 0:
        return Icons.psychology;
      case 1:
        return Icons.grid_view;
      case 2:
        return Icons.auto_awesome;
      case 3:
        return Icons.lightbulb;
      default:
        return Icons.image;
    }
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? _pages[_currentPage].iconColor
            : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final IconData iconData;
  final Color iconColor;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.iconData,
    required this.iconColor,
  });
}

class OnboardingBackgroundPainter extends CustomPainter {
  final Color color;

  OnboardingBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const hexSize = 50.0;
    final rows = (size.height / (hexSize * 0.75)).ceil() + 1;
    final cols = (size.width / (hexSize * math.sqrt(3) / 2)).ceil() + 1;

    for (int r = -1; r < rows; r++) {
      for (int c = -1; c < cols; c++) {
        final isOffset = c % 2 == 0;
        final centerX = c * hexSize * math.sqrt(3) / 2;
        final centerY = r * hexSize * 1.5 + (isOffset ? hexSize * 0.75 : 0);

        // Calculate distance from center for opacity effect
        final centerDist = math.sqrt(
          math.pow((centerX - size.width / 2) / (size.width / 2), 2) +
              math.pow((centerY - size.height / 2) / (size.height / 2), 2),
        );

        // Skip drawing if too far from center
        if (centerDist > 1.5) continue;

        final opacity = math.max(0, 1 - centerDist);
        paint.color = color.withOpacity(opacity * 0.5);

        final path = Path();
        for (int i = 0; i < 6; i++) {
          final angle = (i * 60) * math.pi / 180;
          final x = centerX + hexSize * math.cos(angle);
          final y = centerY + hexSize * math.sin(angle);

          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant OnboardingBackgroundPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
