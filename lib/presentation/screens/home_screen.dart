import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/haptic_utils.dart';
import '../widgets/particle_background.dart';
import 'level_select_screen.dart';
import 'achievements_screen.dart';
import 'settings_screen.dart';
import 'records_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Particle Background
          const ParticleBackground(),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    _buildLogo(),
                    const SizedBox(height: 32),
                    _buildGameIntro(),
                    const SizedBox(height: 32),
                    _buildButtons(context),
                    const SizedBox(height: 32),
                    _buildVersion(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF2ECC71).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Title with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.brain,
                    size: 18,
                    color: Color(0xFF2ECC71),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'About The Game',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 18,
                    color: const Color(0xFF2ECC71),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              'Embark on a memory journey through nature! Match pairs of animals and natural elements while racing against time.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                height: 1.6,
                color: AppColors.mica.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 16),
            // Features
            _buildFeature(FontAwesomeIcons.trophy, '12 Challenging Levels'),
            const SizedBox(height: 10),
            _buildFeature(FontAwesomeIcons.paw, 'Adorable Animal Icons'),
            const SizedBox(height: 10),
            _buildFeature(FontAwesomeIcons.star, 'Star Rating System'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FaIcon(icon, size: 11, color: const Color(0xFF2ECC71)),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            fontSize: 12,
            color: AppColors.mica.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Animated logo container with nature theme
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2ECC71), // Forest Green
                      const Color(0xFF27AE60), // Deep Green
                      const Color(0xFF16A085), // Teal
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2ECC71).withOpacity(0.5),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(painter: _NaturePatternPainter()),
                    ),
                    // Main icon
                    const FaIcon(
                      FontAwesomeIcons.leaf,
                      size: 45,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        // Animated title
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          builder: (context, double value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Text(
                  'MEMBLY',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 52,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF2ECC71), Color(0xFF00CEC9)],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                    shadows: [
                      Shadow(
                        color: const Color(0xFF2ECC71).withOpacity(0.6),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          'Nature Memory Journey',
          style: AppTextStyles.body.copyWith(
            color: AppColors.mint,
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        // Decorative leaf icons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFloatingLeaf(0),
            const SizedBox(width: 16),
            const FaIcon(
              FontAwesomeIcons.seedling,
              size: 16,
              color: Color(0xFF2ECC71),
            ),
            const SizedBox(width: 16),
            _buildFloatingLeaf(1000),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingLeaf(int delay) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
      onEnd: () {
        // Loop animation
      },
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 5 * sin(value * 2 * pi)),
          child: FaIcon(
            FontAwesomeIcons.leaf,
            size: 12,
            color: Color(0xFF2ECC71).withOpacity(0.6),
          ),
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Main action button
          _buildPrimaryButton(
            context,
            text: 'START ADVENTURE',
            icon: FontAwesomeIcons.play,
            onPressed: () => _navigateToLevelSelect(context),
          ),
          const SizedBox(height: 20),
          // Secondary buttons grid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.black.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF2ECC71).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryButton(
                        icon: FontAwesomeIcons.chartLine,
                        label: 'Records',
                        color: const Color(0xFF3498DB),
                        onPressed: () => _navigateToRecords(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSecondaryButton(
                        icon: FontAwesomeIcons.trophy,
                        label: 'Achievements',
                        color: const Color(0xFFF1C40F),
                        onPressed: () => _navigateToAchievements(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSecondaryButton(
                  icon: FontAwesomeIcons.gear,
                  label: 'Settings',
                  color: AppColors.electric,
                  onPressed: () => _navigateToSettings(context),
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: () {
        HapticUtils.mediumImpact();
        onPressed();
      },
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2ECC71), Color(0xFF27AE60), Color(0xFF16A085)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2ECC71).withOpacity(0.6),
              blurRadius: 30,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated shine effect (top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Decorative leaves
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.seedling,
                  size: 22,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.leaf,
                  size: 22,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            // Button content
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(icon, size: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    text,
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
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
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: () {
        HapticUtils.lightImpact();
        onPressed();
      },
      child: Container(
        height: isFullWidth ? 62 : 85,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.slate.withOpacity(0.85),
              AppColors.slate.withOpacity(0.65),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circle background
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.08),
                ),
              ),
            ),
            // Content
            Center(
              child: isFullWidth
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FaIcon(icon, color: color, size: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          label,
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 16,
                            color: color,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: FaIcon(icon, color: color, size: 20),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
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

  Widget _buildVersion() {
    return Text(
      'v1.0.4 // SYNC: ONLINE',
      style: AppTextStyles.label.copyWith(
        color: AppColors.textSecondary.withOpacity(0.5),
        fontSize: 10,
      ),
    );
  }

  void _navigateToLevelSelect(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LevelSelectScreen()));
  }

  void _navigateToRecords(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const RecordsScreen()));
  }

  void _navigateToAchievements(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AchievementsScreen()));
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }
}

// Custom painter for nature-themed logo pattern
class _NaturePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw leaf veins pattern
    for (int i = 0; i < 6; i++) {
      final angle = (2 * pi * i) / 6;
      final startX = centerX;
      final startY = centerY;
      final endX = centerX + cos(angle) * 30;
      final endY = centerY + sin(angle) * 30;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      // Draw smaller branches
      for (int j = 1; j <= 2; j++) {
        final branchRatio = j / 3;
        final branchX = startX + (endX - startX) * branchRatio;
        final branchY = startY + (endY - startY) * branchRatio;
        final branchEndX = branchX + cos(angle + pi / 4) * 10;
        final branchEndY = branchY + sin(angle + pi / 4) * 10;

        canvas.drawLine(
          Offset(branchX, branchY),
          Offset(branchEndX, branchEndY),
          paint..strokeWidth = 1,
        );
      }
    }

    // Draw center circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      8,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
