import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/constants.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  // Animation controllers
  late AnimationController _backgroundAnimationController;
  late AnimationController _floatingBlocksController;

  // List of floating blocks for background animation
  final List<_FloatingBlock> _floatingBlocks = [];

  @override
  void initState() {
    super.initState();

    // Initialize background animation controller
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Initialize floating blocks animation controller
    _floatingBlocksController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Create floating blocks for background animation
    _createFloatingBlocks();
  }

  void _createFloatingBlocks() {
    final random = math.Random();

    // Create 15 floating blocks with random properties
    for (int i = 0; i < 15; i++) {
      _floatingBlocks.add(
        _FloatingBlock(
          position: Offset(
            random.nextDouble() * 400 - 100,
            random.nextDouble() * 800 - 100,
          ),
          size: 10 + random.nextDouble() * 30,
          color: _getRandomBlockColor(random),
          speed: 0.2 + random.nextDouble() * 0.6,
          angle: random.nextDouble() * math.pi * 2,
          rotationSpeed: (random.nextDouble() - 0.5) * 0.05,
        ),
      );
    }
  }

  Color _getRandomBlockColor(math.Random random) {
    final colors = [
      AppColors.blockCoralPink,
      AppColors.blockSunnyYellow,
      AppColors.blockSkyBlue,
      AppColors.blockGrapePurple,
      AppColors.blockJadeGreen,
      AppColors.blockTerracottaOrange,
    ];

    return colors[random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundAnimationController.dispose();
    _floatingBlocksController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundAnimationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.bgDeepSpaceGray,
                      AppColors.bgDeepSpaceGray.withBlue(70),
                    ],
                    stops: const [0.2, 1.0],
                    transform: GradientRotation(
                        _backgroundAnimationController.value * math.pi * 2),
                  ),
                ),
              );
            },
          ),

          // Floating blocks background animation
          AnimatedBuilder(
            animation: _floatingBlocksController,
            builder: (context, child) {
              return CustomPaint(
                painter: _FloatingBlocksPainter(
                  blocks: _floatingBlocks,
                  animationValue: _floatingBlocksController.value,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Skip button at top right
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: _navigateToHome,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.accentMintGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [
                      _buildOnboardingPage(
                        title: 'Welcome to Blokko',
                        description:
                            'A strategic puzzle-matching game where your pattern recognition skills will be put to the test.',
                        icon: Icons.grid_view_rounded,
                        illustration: _buildWelcomeIllustration(),
                      ),
                      _buildOnboardingPage(
                        title: 'How to Play',
                        description:
                            'Select two adjacent blocks and match them with one of the templates shown at the bottom. Clear all blocks to win!',
                        icon: Icons.sports_esports_rounded,
                        illustration: _buildGameplayIllustration(),
                      ),
                      _buildOnboardingPage(
                        title: 'Game Modes',
                        description:
                            'Challenge yourself with 6x6 Classic mode or test your skills with the more difficult 8x8 Challenge mode.',
                        icon: Icons.dashboard_customize_rounded,
                        illustration: _buildGameModesIllustration(),
                      ),
                      _buildOnboardingPage(
                        title: 'Pro Tips',
                        description:
                            'Plan your moves carefully. Look for isolated blocks that can match with any other block. Use the refresh button when stuck.',
                        icon: Icons.lightbulb_rounded,
                        illustration: _buildTipsIllustration(),
                      ),
                    ],
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
                        children: List.generate(_totalPages, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: index == _currentPage ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == _currentPage
                                  ? AppColors.accentMintGreen
                                  : AppColors.accentMintGreen.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      // Next/Start button
                      ElevatedButton(
                        onPressed: _navigateToNextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentMintGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == _totalPages - 1
                                  ? 'Start Playing'
                                  : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentPage == _totalPages - 1
                                  ? Icons.play_arrow_rounded
                                  : Icons.arrow_forward_rounded,
                            ),
                          ],
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

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required IconData icon,
    required Widget illustration,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.accentMintGreen,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textMoonWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Illustration
          SizedBox(
            height: 240,
            child: illustration,
          ),

          const SizedBox(height: 40),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMoonWhite.withOpacity(0.9),
              fontSize: 18,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeIllustration() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentMintGreen,
              AppColors.accentMintGreen.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentMintGreen.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(
          Icons.grid_view_rounded,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  Widget _buildGameplayIllustration() {
    return LayoutBuilder(builder: (context, constraints) {
      // Calculate sizes based on available height
      final availableHeight = constraints.maxHeight;
      final boardSize =
          availableHeight * 0.75; // 75% of available height for board
      final paddingSize = 8.0;

      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Game board representation
            Container(
              width: boardSize,
              height: boardSize,
              padding: EdgeInsets.all(paddingSize),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accentMintGreen.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  // Create a pattern of blocks with some highlighted
                  final isHighlighted = index == 5 || index == 6;
                  final isTemplate = index == 9 || index == 10;

                  final colors = [
                    AppColors.blockCoralPink,
                    AppColors.blockSunnyYellow,
                    AppColors.blockSkyBlue,
                    AppColors.blockGrapePurple,
                    AppColors.blockJadeGreen,
                    AppColors.blockTerracottaOrange,
                  ];

                  final color = colors[index % colors.length];

                  return Container(
                    decoration: BoxDecoration(
                      color: isHighlighted || isTemplate
                          ? color
                          : color.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: isHighlighted
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                      boxShadow: isHighlighted
                          ? [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8), // Reduced spacing

            // Template indicators
            SizedBox(
              height: availableHeight *
                  0.15, // 15% of available height for templates
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTemplateIndicator(
                    AppColors.blockSkyBlue,
                    AppColors.blockCoralPink,
                  ),
                  const SizedBox(width: 16),
                  _buildTemplateIndicator(
                    AppColors.blockGrapePurple,
                    AppColors.blockJadeGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTemplateIndicator(Color color1, Color color2) {
    return LayoutBuilder(builder: (context, constraints) {
      // Calculate sizes based on available height
      final blockSize = constraints.maxHeight * 0.7;
      final padding = constraints.maxHeight * 0.15;

      return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: blockSize,
              height: blockSize,
              decoration: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: padding),
            Container(
              width: blockSize,
              height: blockSize,
              decoration: BoxDecoration(
                color: color2,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGameModesIllustration() {
    return LayoutBuilder(builder: (context, constraints) {
      final availableHeight = constraints.maxHeight;
      final gridSize =
          availableHeight * 0.55; // 55% of available height for grid
      final textAreaHeight = availableHeight * 0.35; // 35% for text
      final spacing = availableHeight * 0.05; // 5% for spacing

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 6x6 Classic mode
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Grid container
                Container(
                  width: gridSize,
                  height: gridSize,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.blockSkyBlue.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: 36,
                    itemBuilder: (context, index) {
                      final colors = [
                        AppColors.blockCoralPink,
                        AppColors.blockSunnyYellow,
                        AppColors.blockSkyBlue,
                        AppColors.blockGrapePurple,
                        AppColors.blockJadeGreen,
                      ];

                      return Container(
                        decoration: BoxDecoration(
                          color: colors[index % colors.length].withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: spacing),

                // Text area
                SizedBox(
                  height: textAreaHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '6x6 Classic',
                        style: TextStyle(
                          color: AppColors.blockSkyBlue,
                          fontSize: availableHeight *
                              0.075, // 7.5% of height for title
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: spacing * 0.5),
                      Text(
                        'Perfect for beginners',
                        style: TextStyle(
                          color: AppColors.textMoonWhite.withOpacity(0.8),
                          fontSize: availableHeight *
                              0.055, // 5.5% of height for subtitle
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
              width: constraints.maxWidth * 0.05), // 5% of width for spacing

          // 8x8 Challenge mode
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Grid container
                Container(
                  width: gridSize,
                  height: gridSize,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.blockGrapePurple.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: 64,
                    itemBuilder: (context, index) {
                      final colors = [
                        AppColors.blockCoralPink,
                        AppColors.blockSunnyYellow,
                        AppColors.blockSkyBlue,
                        AppColors.blockGrapePurple,
                        AppColors.blockJadeGreen,
                        AppColors.blockTerracottaOrange,
                      ];

                      return Container(
                        decoration: BoxDecoration(
                          color: colors[index % colors.length].withOpacity(0.7),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: spacing),

                // Text area
                SizedBox(
                  height: textAreaHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '8x8 Challenge',
                        style: TextStyle(
                          color: AppColors.blockGrapePurple,
                          fontSize: availableHeight *
                              0.075, // 7.5% of height for title
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: spacing * 0.5),
                      Text(
                        'For experienced players',
                        style: TextStyle(
                          color: AppColors.textMoonWhite.withOpacity(0.8),
                          fontSize: availableHeight *
                              0.055, // 5.5% of height for subtitle
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTipsIllustration() {
    return LayoutBuilder(builder: (context, constraints) {
      final availableHeight = constraints.maxHeight;
      final cardHeight =
          availableHeight * 0.45; // 45% of available height for each row
      final spacing = availableHeight * 0.05; // 5% spacing

      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // First row
            SizedBox(
              height: cardHeight,
              width: constraints.maxWidth, // Constrain width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Prevent expanding to infinity
                children: [
                  _buildTipCard(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Plan Ahead',
                    color: AppColors.blockSunnyYellow,
                    maxHeight: cardHeight,
                  ),
                  SizedBox(width: spacing * 2),
                  _buildTipCard(
                    icon: Icons.refresh_rounded,
                    title: 'Refresh When Stuck',
                    color: AppColors.blockSkyBlue,
                    maxHeight: cardHeight,
                  ),
                ],
              ),
            ),

            SizedBox(height: spacing),

            // Second row
            SizedBox(
              height: cardHeight,
              width: constraints.maxWidth, // Constrain width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Prevent expanding to infinity
                children: [
                  _buildTipCard(
                    icon: Icons.timer_outlined,
                    title: 'Be Quick',
                    color: AppColors.blockCoralPink,
                    maxHeight: cardHeight,
                  ),
                  SizedBox(width: spacing * 2),
                  _buildTipCard(
                    icon: Icons.extension_rounded,
                    title: 'Find Patterns',
                    color: AppColors.blockJadeGreen,
                    maxHeight: cardHeight,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required Color color,
    required double maxHeight,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      // Check if we have a valid maxWidth, if not use a default value
      final double effectiveMaxWidth = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : 160.0; // Default width if constraint is infinite

      final cardWidth = effectiveMaxWidth * 0.45; // Responsive width
      final iconSize = maxHeight * 0.3; // 30% of card height for icon
      final padding = maxHeight * 0.1; // 10% of card height for padding
      final textSize = maxHeight * 0.14; // 14% of card height for text size

      return Container(
        width: cardWidth,
        height: maxHeight,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: iconSize,
            ),
            SizedBox(height: padding),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Class to represent a floating block in the background
class _FloatingBlock {
  Offset position;
  final double size;
  final Color color;
  final double speed;
  double angle;
  final double rotationSpeed;

  _FloatingBlock({
    required this.position,
    required this.size,
    required this.color,
    required this.speed,
    required this.angle,
    required this.rotationSpeed,
  });
}

// Custom painter for floating blocks animation
class _FloatingBlocksPainter extends CustomPainter {
  final List<_FloatingBlock> blocks;
  final double animationValue;

  _FloatingBlocksPainter({
    required this.blocks,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var block in blocks) {
      // Update position based on animation value
      final dx = math.sin(animationValue * math.pi * 2 + block.angle) *
          block.speed *
          30;
      final dy = math.cos(animationValue * math.pi * 2 + block.angle) *
          block.speed *
          20;

      // Update angle
      block.angle += block.rotationSpeed;

      // Draw block
      final paint = Paint()
        ..color = block.color.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(block.position.dx + dx, block.position.dy + dy);
      canvas.rotate(block.angle);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: block.size,
            height: block.size,
          ),
          Radius.circular(block.size / 4),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_FloatingBlocksPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
