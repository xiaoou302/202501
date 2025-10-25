import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'library_screen.dart';
import 'records_screen.dart';
import 'settings_screen.dart';
import 'story_screen.dart';

/// Home screen - Main entry point with enhanced UI
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final maxWidth = isTablet ? 800.0 : double.infinity;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.parchmentLight,
              AppColors.parchmentMedium,
              AppColors.parchmentDark,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 48.0 : 24.0,
                    vertical: isTablet ? 32.0 : 16.0,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: isTablet ? 60 : 40),

                      // Title section with enhanced styling
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildTitleSection(context, isTablet),
                      ),

                      SizedBox(height: isTablet ? 48 : 32),

                      // Game introduction card
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildIntroductionCard(context, isTablet),
                        ),
                      ),

                      SizedBox(height: isTablet ? 48 : 32),

                      // Primary action button
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildPrimaryButton(context, isTablet),
                        ),
                      ),

                      SizedBox(height: isTablet ? 32 : 24),

                      // Navigation cards
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildNavigationGrid(context, isTablet),
                        ),
                      ),

                      SizedBox(height: isTablet ? 32 : 24),

                      // Footer with version
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildFooter(context),
                      ),

                      SizedBox(height: isTablet ? 32 : 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Title section with magical styling
  Widget _buildTitleSection(BuildContext context, bool isTablet) {
    final titleSize = isTablet ? 96.0 : 72.0;
    final subtitleSize = isTablet ? 24.0 : 20.0;
    final lineWidth = isTablet ? 60.0 : 40.0;

    return Column(
      children: [
        // Decorative top line
        Container(
          width: isTablet ? 80 : 60,
          height: isTablet ? 4 : 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.magicGold.withOpacity(0.3),
                AppColors.magicGold,
                AppColors.magicGold.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(height: isTablet ? 32 : 24),

        // Main title with glow effect
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.magicBlue,
              AppColors.magicPurple,
              AppColors.magicBlue,
            ],
          ).createShader(bounds),
          child: Text(
            'Zenion',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: titleSize,
              fontWeight: FontWeight.w900,
              letterSpacing: isTablet ? 3 : 2,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: isTablet ? 30 : 20,
                  color: AppColors.magicBlue.withOpacity(0.5),
                ),
                Shadow(
                  blurRadius: isTablet ? 60 : 40,
                  color: AppColors.magicPurple.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: isTablet ? 12 : 8),

        // Subtitle
        Text(
          'The Fading Codex',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontStyle: FontStyle.italic,
            fontSize: subtitleSize,
            color: AppColors.inkBrown,
            letterSpacing: isTablet ? 4 : 3,
            fontWeight: FontWeight.w300,
          ),
        ),

        SizedBox(height: isTablet ? 20 : 12),

        // Decorative bottom ornament
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOrnamentDot(),
            SizedBox(width: isTablet ? 12 : 8),
            Container(
              width: lineWidth,
              height: isTablet ? 1.5 : 1,
              color: AppColors.magicGold.withOpacity(0.4),
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Icon(
              Icons.auto_stories,
              size: isTablet ? 20 : 16,
              color: AppColors.magicGold.withOpacity(0.6),
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Container(
              width: lineWidth,
              height: isTablet ? 1.5 : 1,
              color: AppColors.magicGold.withOpacity(0.4),
            ),
            SizedBox(width: isTablet ? 12 : 8),
            _buildOrnamentDot(),
          ],
        ),
      ],
    );
  }

  Widget _buildOrnamentDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.magicGold.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    );
  }

  /// Introduction card with game description
  Widget _buildIntroductionCard(BuildContext context, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.magicGold.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.magicBlue.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.magicPurple.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Decorative background pattern
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.magicPurple.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isTablet ? 14.0 : 10.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.magicBlue,
                              AppColors.magicPurple,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.magicBlue.withOpacity(0.3),
                              blurRadius: isTablet ? 16 : 12,
                              offset: Offset(0, isTablet ? 6 : 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: isTablet ? 32 : 24,
                        ),
                      ),
                      SizedBox(width: isTablet ? 20 : 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About the Journey',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.inkBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isTablet ? 22 : null,
                                  ),
                            ),
                            SizedBox(height: isTablet ? 4 : 2),
                            Text(
                              'A tale of memory and mystery',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.inkFaded,
                                    fontStyle: FontStyle.italic,
                                    fontSize: isTablet ? 16 : null,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isTablet ? 28 : 20),

                  // Description text
                  Text(
                    'In a world where words hold power and memories fade like ink on ancient pages, you are the keeper of the Codex. Each chapter you read brings you closer to understanding the truth, but time is your enemy.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.inkBrown,
                      height: 1.6,
                      fontSize: isTablet ? 18 : 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.inkBrown,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Primary action button with enhanced styling
  Widget _buildPrimaryButton(BuildContext context, bool isTablet) {
    return Container(
      width: double.infinity,
      height: isTablet ? 80.0 : 64.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.glowAmber, AppColors.magicGold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowAmber.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.magicGold.withOpacity(0.2),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LibraryScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: isTablet ? 36 : 28,
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Text(
                  'Begin Your Journey',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 22 : 18,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigation grid with enhanced cards
  Widget _buildNavigationGrid(BuildContext context, bool isTablet) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildNavigationCard(
                context,
                icon: Icons.auto_stories_rounded,
                label: 'Story',
                description: 'Read the tale',
                gradient: [AppColors.magicBlue, AppColors.infoBlue],
                onTap: () =>
                    _navigateWithAnimation(context, const StoryScreen()),
                isTablet: isTablet,
              ),
            ),
            SizedBox(width: isTablet ? 24 : 16),
            Expanded(
              child: _buildNavigationCard(
                context,
                icon: Icons.history,
                label: 'Records',
                description: 'View progress',
                gradient: [AppColors.magicPurple, AppColors.accentPurple],
                onTap: () =>
                    _navigateWithAnimation(context, const RecordsScreen()),
                isTablet: isTablet,
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 24 : 16),
        _buildNavigationCard(
          context,
          icon: Icons.settings,
          label: 'Settings',
          description: 'Customize your experience',
          gradient: [AppColors.inkBrown, AppColors.inkFaded],
          onTap: () => _navigateWithAnimation(context, const SettingsScreen()),
          isFullWidth: true,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required List<Color> gradient,
    required VoidCallback onTap,
    bool isFullWidth = false,
    bool isTablet = false,
  }) {
    final cardHeight = isFullWidth
        ? (isTablet ? 100.0 : 80.0)
        : (isTablet ? 180.0 : 140.0);

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradient[0].withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: isFullWidth
                ? const EdgeInsets.all(16.0)
                : const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
            child: isFullWidth
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradient),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.inkBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.inkFaded,
                                    fontSize: 13,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: gradient[0].withOpacity(0.5),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradient),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: gradient[0].withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 26),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.inkBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.inkFaded,
                                fontSize: 11,
                                height: 1.2,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.inkFaded.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Version 1.0.0',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted.withOpacity(0.6),
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '© 2025 Zenion',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted.withOpacity(0.4),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _navigateWithAnimation(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
