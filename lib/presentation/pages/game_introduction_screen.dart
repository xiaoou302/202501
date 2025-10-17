import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'main_menu_page.dart';

/// Game introduction screen with swipeable content
class GameIntroductionScreen extends StatefulWidget {
  /// Constructor
  const GameIntroductionScreen({super.key});

  @override
  State<GameIntroductionScreen> createState() => _GameIntroductionScreenState();
}

class _GameIntroductionScreenState extends State<GameIntroductionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  final List<IntroductionContent> _introContents = [
    IntroductionContent(
      title: 'Welcome to ${AppConstants.appName}',
      description:
          'Embark on a journey of strategy and mindfulness with our zen-inspired tile matching game.',
      icon: Icons.spa,
      iconColor: AppColors.carvedJadeGreen,
    ),
    IntroductionContent(
      title: 'Mahjong-Inspired Design',
      description:
          'Our game features beautiful mahjong tile elements as a design choice, creating a visually appealing and culturally rich experience.',
      icon: Icons.grid_view,
      iconColor: AppColors.beeswaxAmber,
    ),
    IntroductionContent(
      title: 'Important Notice',
      description:
          '${AppConstants.appName} is purely a puzzle game that uses mahjong tile elements for its visual theme and mechanics. This game is NOT related to gambling in any way.',
      icon: Icons.info_outline,
      iconColor: Colors.blue,
      isDisclaimer: true,
    ),
    IntroductionContent(
      title: 'Ready to Play?',
      description:
          'Clear your mind, sharpen your focus, and enjoy the strategic challenge of ${AppConstants.appName}!',
      icon: Icons.play_arrow,
      iconColor: AppColors.mahjongRed,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToMainMenu();
    }
  }

  void _navigateToMainMenu() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainMenuPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutQuint;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _navigateToMainMenu,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
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
                  itemCount: _introContents.length,
                  itemBuilder: (context, index) {
                    return _buildIntroductionPage(_introContents[index]);
                  },
                ),
              ),

              // Page indicators and next button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicators
                    Row(
                      children: List.generate(
                        _totalPages,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.carvedJadeGreen
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Next button
                    ElevatedButton(
                      onPressed: _navigateToNextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.carvedJadeGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        _currentPage < _totalPages - 1 ? 'Next' : 'Start',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroductionPage(IntroductionContent content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: content.iconColor.withOpacity(0.2),
              border: Border.all(
                color: content.iconColor.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(content.icon, color: content.iconColor, size: 60),
          ),

          const SizedBox(height: 40),

          // Content card
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    // Title
                    Text(
                      content.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description
                    Text(
                      content.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 2,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),

                    // Disclaimer emphasis
                    if (content.isDisclaimer) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'This game is designed for entertainment purposes only',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Model for introduction content
class IntroductionContent {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isDisclaimer;

  IntroductionContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.isDisclaimer = false,
  });
}
