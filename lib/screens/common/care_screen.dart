import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'splash_screen.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.volunteer_activism_rounded,
      'title': 'Every life is\na miracle',
      'subtitle':
          'Treat them with tenderness and respect.\nThey may be just a part of your life, but to them, you are their entire world.',
      'image': 'assets/fm1.jpeg',
    },
    {
      'icon': Icons.handshake_rounded,
      'title': 'Companionship\nis love',
      'subtitle':
          'Your time is their entire world.\nA simple touch can heal a broken soul and build a bond that lasts a lifetime.',
      'image': 'assets/fm2.jpeg',
    },
    {
      'icon': Icons.home_rounded,
      'title': 'Give them\na home',
      'subtitle':
          'Adopt, rescue, and share the warmth.\nOpen your heart and your doors, and you will receive unconditional love in return.',
      'image': 'assets/fm3.jpeg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() {
    _timer = Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      if (_currentIndex < _pages.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        _navigateToSplash();
      }
    });
  }

  void _navigateToSplash() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const SplashScreen(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cocoaBrown,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1500),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _buildPage(_pages[_currentIndex], _currentIndex),
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page, int index) {
    return Stack(
      key: ValueKey<int>(index),
      fit: StackFit.expand,
      children: [
        // Background Image with Ken Burns effect
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 1.0, end: 1.15),
          duration: const Duration(milliseconds: 6000),
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: Image.asset(page['image'], fit: BoxFit.cover),
            );
          },
        ),
        // Gradient overlay for readability and premium feel
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.cocoaBrown.withValues(alpha: 0.4),
                AppColors.cocoaBrown.withValues(alpha: 0.95),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Glassmorphism Icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        page['icon'],
                        size: 48,
                        color: AppColors.peachFuzz,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  page['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                // Subtitle
                Text(
                  page['subtitle'],
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 48),
                // Progress indicator
                Row(
                  children: List.generate(
                    _pages.length,
                    (idx) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 4,
                        decoration: BoxDecoration(
                          color: index == idx
                              ? AppColors.peachFuzz
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
