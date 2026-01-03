import 'package:flutter/material.dart';
import '../../core/app_fonts.dart';
import '../../core/app_theme.dart';


class GameIntroScreen extends StatelessWidget {
  const GameIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.8,
              colors: [
                Color(0xFF1a2332),
                Color(0xFF0f1419),
                Colors.black,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
              //  const SizedBox(height: 48),
                _buildHeader(context),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildSection(
                        'Welcome to Solvion',
                        'Solvion is a strategic card puzzle game that challenges your mind and tests your planning skills. Navigate through cosmic levels, solve intricate card arrangements, and unlock achievements as you progress.',
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        'The Concept',
                        'While Solvion uses playing cards as design elements, it is purely a logic puzzle game. There is absolutely no gambling, betting, or real money involved. Think of it as a sophisticated brain teaser wrapped in an elegant card-based interface.',
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        'Game Features',
                        '• 52 unique levels with increasing difficulty\n'
                        '• Strategic gameplay requiring careful planning\n'
                        '• Achievement system to track your progress\n'
                        '• Beautiful space-themed interface\n'
                        '• No time pressure - play at your own pace\n'
                        '• Completely free with no in-app purchases',
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        'Our Mission',
                        'We created Solvion to provide a relaxing yet challenging puzzle experience. Our goal is to offer players a mental workout that\'s both entertaining and rewarding, without any of the negative aspects associated with gambling games.',
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.01),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Icon(Icons.chevron_left, size: 14, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'GAME INTRODUCTION',
            style: AppFonts.orbitron(
              fontSize: 12,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.orbitron(
              fontSize: 16,
              color: AppTheme.deepAccent,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade300,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
