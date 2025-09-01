import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../home/home_screen.dart';

/// Interactive onboarding screen with game-themed content
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // Page controller for onboarding slides
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation controllers
  late AnimationController _backgroundAnimController;
  late AnimationController _contentAnimController;

  // Animations
  late Animation<double> _backgroundAnimation;
  late Animation<double> _contentOpacityAnimation;
  late Animation<double> _contentScaleAnimation;

  // Game-specific animations
  late AnimationController _memoryCardAnimController;
  late AnimationController _rhythmTileAnimController;
  late AnimationController _numberTileAnimController;

  // Define onboarding pages with enhanced content
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Hyquinoxa',
      description:
          'A collection of brain training games designed to challenge and enhance your cognitive abilities.',
      primaryColor: AppColors.primary,
      secondaryColor: Colors.blue,
      mainIcon: Icons.auto_awesome,
      backgroundIcons: [
        Icons.psychology,
        Icons.lightbulb_outline,
        Icons.emoji_events_outlined,
        Icons.trending_up,
        Icons.extension,
      ],
    ),
    OnboardingPage(
      title: 'Memory Match',
      description:
          'Challenge your memory by finding matching pairs. Use special power-ups and unlock increasingly difficult levels as you improve.',
      primaryColor: Colors.blue,
      secondaryColor: Colors.lightBlue,
      mainIcon: Icons.grid_view_rounded,
      backgroundIcons: [
        Icons.grid_3x3,
        Icons.grid_4x4,
        Icons.grid_goldenratio,
        Icons.grid_on,
        Icons.memory,
      ],
    ),
    OnboardingPage(
      title: 'Flow Rush',
      description:
          'Test your reflexes and rhythm by tapping tiles in sequence. Dodge obstacles and ride the flow to achieve the highest score.',
      primaryColor: Colors.purple,
      secondaryColor: Colors.deepPurple,
      mainIcon: Icons.music_note_rounded,
      backgroundIcons: [
        Icons.music_note,
        Icons.speed,
        Icons.gesture,
        Icons.waves,
        Icons.surround_sound,
      ],
    ),
    OnboardingPage(
      title: 'Number Memory',
      description:
          'Remember sequences of numbers and symbols to boost your short-term memory and concentration skills.',
      primaryColor: Colors.green,
      secondaryColor: Colors.lightGreen,
      mainIcon: Icons.format_list_numbered_rounded,
      backgroundIcons: [
        Icons.pin,
        Icons.tag,
        Icons.onetwothree,
        Icons.password,
        Icons.numbers,
      ],
    ),
    OnboardingPage(
      title: 'Ready to Play?',
      description:
          'Track your progress, earn achievements, and challenge yourself to improve your cognitive abilities.',
      primaryColor: Colors.amber,
      secondaryColor: Colors.orange,
      mainIcon: Icons.sports_esports,
      backgroundIcons: [
        Icons.emoji_events,
        Icons.star,
        Icons.leaderboard,
        Icons.trending_up,
        Icons.celebration,
      ],
    ),
  ];

  // Memory card animation variables
  final List<bool> _cardFlipped = [false, false, false, false];
  final List<Color> _cardColors = [
    Colors.blue,
    Colors.red,
    Colors.blue,
    Colors.red,
  ];

  // Rhythm tile animation variables
  final List<double> _tilePositions = [0.2, 0.4, 0.6, 0.8];
  final List<bool> _tileVisible = [true, true, true, true];

  // Number memory animation variables
  final List<String> _numberSequence = ['3', '7', '1', '9', '4'];
  int _highlightedNumber = -1;

  @override
  void initState() {
    super.initState();

    // Background animation controller
    _backgroundAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20000),
    )..repeat();

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_backgroundAnimController);

    // Content animation controller
    _contentAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _contentScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start content animation
    _contentAnimController.forward();

    // Memory card animation controller
    _memoryCardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // Rhythm tile animation controller
    _rhythmTileAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Number tile animation controller
    _numberTileAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    // Animate memory cards
    _memoryCardAnimController.addListener(() {
      if (_currentPage == 1) {
        final value = _memoryCardAnimController.value;
        if (value < 0.25 && _cardFlipped[0] == false) {
          setState(() => _cardFlipped[0] = true);
        } else if (value < 0.5 && value >= 0.25 && _cardFlipped[2] == false) {
          setState(() => _cardFlipped[2] = true);
        } else if (value < 0.75 && value >= 0.5 && _cardFlipped[0] == true) {
          setState(() => _cardFlipped[0] = false);
        } else if (value >= 0.75 && _cardFlipped[2] == true) {
          setState(() => _cardFlipped[2] = false);
        }
      }
    });

    // Animate rhythm tiles
    _rhythmTileAnimController.addListener(() {
      if (_currentPage == 2) {
        setState(() {
          // Move tiles up
          for (int i = 0; i < _tilePositions.length; i++) {
            _tilePositions[i] -= 0.01;
            if (_tilePositions[i] < 0) {
              _tilePositions[i] = 1.0;
              _tileVisible[i] = true;
            }
            // Hide tile when it reaches top
            if (_tilePositions[i] < 0.1 && _tileVisible[i]) {
              _tileVisible[i] = false;
            }
          }
        });
      }
    });

    // Animate number sequence
    _numberTileAnimController.addListener(() {
      if (_currentPage == 3) {
        final value = _numberTileAnimController.value * 5;
        setState(() {
          _highlightedNumber = value.floor() % 5;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundAnimController.dispose();
    _contentAnimController.dispose();
    _memoryCardAnimController.dispose();
    _rhythmTileAnimController.dispose();
    _numberTileAnimController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Reset and restart content animation
    _contentAnimController.reset();
    _contentAnimController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to home screen with hero animation
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Animated background
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundPainter(
                    animation: _backgroundAnimation.value,
                    page: _currentPage,
                    pageColor: _pages[_currentPage].primaryColor,
                  ),
                  size: MediaQuery.of(context).size,
                );
              },
            ),

            // Main content
            Column(
              children: [
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

                // Bottom navigation area
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => _buildPageIndicator(
                            index == _currentPage,
                            _pages[index].primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Next/Get Started button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pages[_currentPage].primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                            shadowColor: _pages[_currentPage].primaryColor
                                .withOpacity(0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage < _pages.length - 1
                                    ? 'Next'
                                    : 'Get Started',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentPage < _pages.length - 1
                                    ? Icons.arrow_forward_rounded
                                    : Icons.sports_esports_rounded,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Skip button (not on last page)
                      if (_currentPage < _pages.length - 1)
                        TextButton(
                          onPressed: () {
                            _pageController.animateToPage(
                              _pages.length - 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[400],
                          ),
                          child: const Text('Skip'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, int pageIndex) {
    return AnimatedBuilder(
      animation: _contentAnimController,
      builder: (context, child) {
        return Opacity(
          opacity: _contentOpacityAnimation.value,
          child: Transform.scale(
            scale: _contentScaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game-specific interactive demo
            SizedBox(height: 200, child: _buildInteractiveDemo(pageIndex)),
            const SizedBox(height: 40),

            // Title with gradient
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [page.primaryColor, page.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                page.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Description
            Text(
              page.description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[300],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveDemo(int pageIndex) {
    switch (pageIndex) {
      case 0:
        // Welcome page with floating icons
        return Stack(
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _pages[pageIndex].primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: _pages[pageIndex].primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  _pages[pageIndex].mainIcon,
                  size: 60,
                  color: _pages[pageIndex].primaryColor,
                ),
              ),
            ),
            ..._buildFloatingIcons(pageIndex),
          ],
        );

      case 1:
        // Memory Match demo with flipping cards
        return Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _cardFlipped[index] = !_cardFlipped[index];
                  });
                },
                child: _buildFlippingCard(index),
              );
            }),
          ),
        );

      case 2:
        // Flow Rush demo with moving tiles
        return Stack(
          children: List.generate(4, (index) {
            return _buildMovingTile(index);
          }),
        );

      case 3:
        // Number Memory demo with sequence
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_numberSequence.length, (index) {
              return _buildNumberTile(index);
            }),
          ),
        );

      case 4:
        // Ready to play page with trophy animation
        return Stack(
          children: [
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: _pages[pageIndex].primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(70),
                  boxShadow: [
                    BoxShadow(
                      color: _pages[pageIndex].primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  _pages[pageIndex].mainIcon,
                  size: 70,
                  color: _pages[pageIndex].primaryColor,
                ),
              ),
            ),
            ..._buildFloatingIcons(pageIndex),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // Build floating background icons for welcome and final pages
  List<Widget> _buildFloatingIcons(int pageIndex) {
    final List<Widget> icons = [];
    final random = math.Random(pageIndex);

    for (int i = 0; i < _pages[pageIndex].backgroundIcons.length; i++) {
      final iconData = _pages[pageIndex].backgroundIcons[i];
      final size = 20.0 + random.nextDouble() * 20;
      final left = random.nextDouble() * 300;
      final top = random.nextDouble() * 180;
      final opacity = 0.3 + random.nextDouble() * 0.3;

      icons.add(
        Positioned(
          left: left,
          top: top,
          child: AnimatedBuilder(
            animation: _backgroundAnimController,
            builder: (context, child) {
              final sinValue = math.sin(
                _backgroundAnimController.value * 2 * math.pi + i,
              );
              final translateY = sinValue * 10;

              return Transform.translate(
                offset: Offset(0, translateY),
                child: Opacity(
                  opacity: opacity,
                  child: Icon(
                    iconData,
                    size: size,
                    color: _pages[pageIndex].primaryColor.withOpacity(0.7),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return icons;
  }

  // Build flipping memory card for Memory Match demo
  Widget _buildFlippingCard(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: _cardFlipped[index] ? 180 : 0),
      duration: const Duration(milliseconds: 400),
      builder: (context, double value, child) {
        // Calculate if card is showing front or back
        final showFront = value < 90;
        final rotationY = showFront ? value : 180 - value;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(rotationY * math.pi / 180),
          alignment: Alignment.center,
          child: Container(
            width: 70,
            height: 100,
            decoration: BoxDecoration(
              color: showFront ? Colors.grey[800] : _cardColors[index],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: showFront
                  ? const Icon(
                      Icons.question_mark,
                      color: Colors.white70,
                      size: 30,
                    )
                  : Icon(
                      index % 2 == 0 ? Icons.favorite : Icons.star,
                      color: Colors.white,
                      size: 30,
                    ),
            ),
          ),
        );
      },
    );
  }

  // Build moving tile for Flow Rush demo
  Widget _buildMovingTile(int index) {
    if (!_tileVisible[index]) return const SizedBox.shrink();

    return Positioned(
      left: 70.0 + index * 50,
      top: _tilePositions[index] * 200,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tileVisible[index] = false;
          });
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: index % 2 == 0 ? Colors.purple : Colors.deepPurple,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build number tile for Number Memory demo
  Widget _buildNumberTile(int index) {
    final isHighlighted = index == _highlightedNumber;

    return Container(
      width: 40,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isHighlighted
            ? Colors.green.withOpacity(0.8)
            : Colors.green.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          _numberSequence[index],
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.grey[700],
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Onboarding page data model
class OnboardingPage {
  final String title;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData mainIcon;
  final List<IconData> backgroundIcons;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.mainIcon,
    required this.backgroundIcons,
  });
}

/// Custom painter for animated background
class BackgroundPainter extends CustomPainter {
  final double animation;
  final int page;
  final Color pageColor;

  BackgroundPainter({
    required this.animation,
    required this.page,
    required this.pageColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = pageColor.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Create multiple circles with different sizes and positions
    for (int i = 0; i < 5; i++) {
      final offset = 0.2 * i;
      final circleAnimation = (animation + offset) % (2 * math.pi);
      final x = size.width * 0.5 + math.cos(circleAnimation) * size.width * 0.4;
      final y =
          size.height * 0.5 + math.sin(circleAnimation) * size.height * 0.3;
      final radius = 50.0 + 20.0 * i;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Add some smaller particles
    final particlePaint = Paint()
      ..color = pageColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final offset = 0.1 * i;
      final particleAnimation = (animation * 2 + offset) % (2 * math.pi);
      final x =
          size.width * 0.5 +
          math.cos(particleAnimation * 3) * size.width * 0.45;
      final y =
          size.height * 0.5 +
          math.sin(particleAnimation * 2) * size.height * 0.4;
      final radius = 3.0 + (i % 4) * 2.0;

      canvas.drawCircle(Offset(x, y), radius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.page != page ||
      oldDelegate.pageColor != pageColor;
}
