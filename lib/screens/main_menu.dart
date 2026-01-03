import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/app_theme.dart';
import '../core/app_fonts.dart';
import '../core/routes.dart';
import '../core/constants.dart';


class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/18511766503223_.pic_hd.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Dark overlay for better readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Animated star field overlay
              _buildStarField(),
              
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeController,
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      _buildTitle(),
                      const SizedBox(height: 40),
                      Expanded(child: _buildCenterButton()),
                      _buildMenuButtons(),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
  
  Widget _buildStarField() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return CustomPaint(
            painter: StarFieldPainter(_rotationController.value),
            child: Container(),
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.deepAccent.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                AppTheme.deepAccent.withValues(alpha: 0.1),
                AppTheme.deepAccent.withValues(alpha: 0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.deepAccent.withValues(alpha: 0.2),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            'SYSTEM ${AppConstants.appVersion}',
            style: AppFonts.orbitron(
              fontSize: 10,
              color: AppTheme.deepAccent,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFB0C4DE),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            AppConstants.appName,
            style: AppFonts.orbitron(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 10,
              shadows: [
                Shadow(
                  color: Colors.white.withValues(alpha: 0.5),
                  blurRadius: 20,
                ),
                Shadow(
                  color: AppTheme.deepAccent.withValues(alpha: 0.3),
                  blurRadius: 30,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
          child: Text(
            AppConstants.appSubtitle.toUpperCase(),
            style: AppFonts.inter(
              fontSize: 11,
              color: Colors.grey.shade400,
              letterSpacing: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterButton() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotating ring with glow
          RotationTransition(
            turns: _rotationController,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.deepAccent.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.deepAccent.withValues(alpha: 0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: OrbitDotsPainter(AppTheme.deepAccent.withValues(alpha: 0.6)),
              ),
            ),
          ),
          
          // Middle counter-rotating ring
          RotationTransition(
            turns: Tween(begin: 1.0, end: 0.0).animate(_rotationController),
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // Inner pulsing ring
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = 1.0 + (_pulseController.value * 0.05);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.deepAccent.withValues(alpha: 0.2 + (_pulseController.value * 0.2)),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Main button
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.levelMap),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF2D3748),
                        const Color(0xFF1a202c),
                        Colors.black,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                    border: Border.all(
                      color: AppTheme.deepAccent.withValues(alpha: 0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.deepAccent.withValues(alpha: 0.4 + (_pulseController.value * 0.2)),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 56,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: AppTheme.deepAccent.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'INITIATE',
                        style: AppFonts.orbitron(
                          fontSize: 11,
                          color: Colors.grey.shade300,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Primary action cards
          Row(
            children: [
              Expanded(
                child: _buildPrimaryCard(
                  icon: Icons.bar_chart_rounded,
                  label: 'Statistics',
                  subtitle: 'Track progress',
                  color: const Color(0xFF3B82F6),
                  route: AppRoutes.statistics,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPrimaryCard(
                  icon: Icons.emoji_events_rounded,
                  label: 'Achievements',
                  subtitle: 'Unlock rewards',
                  color: const Color(0xFFF59E0B),
                  route: AppRoutes.archive,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Secondary action cards
          Row(
            children: [
              Expanded(
                child: _buildSecondaryCard(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  route: AppRoutes.settings,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSecondaryCard(
                  icon: Icons.help_outline_rounded,
                  label: 'Guide',
                  route: AppRoutes.howToPlay,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPrimaryCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppFonts.orbitron(
                        fontSize: 12,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppFonts.inter(
                        fontSize: 9,
                        color: Colors.grey.shade400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
  
  Widget _buildSecondaryCard({
    required IconData icon,
    required String label,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: AppFonts.inter(
                    fontSize: 13,
                    color: Colors.grey.shade300,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

// Custom painter for star field
class StarFieldPainter extends CustomPainter {
  final double animationValue;
  
  StarFieldPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);
    
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final brightness = random.nextDouble();
      final twinkle = (math.sin((animationValue * math.pi * 2) + (i * 0.1)) + 1) / 2;
      
      paint.color = Colors.white.withValues(alpha: brightness * 0.3 * twinkle);
      canvas.drawCircle(
        Offset(x, y),
        random.nextDouble() * 1.5 + 0.5,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) => true;
}

// Custom painter for orbit dots
class OrbitDotsPainter extends CustomPainter {
  final Color color;
  
  OrbitDotsPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2) / 8;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }
  
  @override
  bool shouldRepaint(OrbitDotsPainter oldDelegate) => false;
}
