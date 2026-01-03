import 'package:flutter/material.dart';
import '../../core/app_fonts.dart';
import '../../core/app_theme.dart';


class GameplayGuideScreen extends StatelessWidget {
  const GameplayGuideScreen({super.key});

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
                //const SizedBox(height: 48),
                _buildHeader(context),
               const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildSection(
                        'Objective',
                        'The goal of Solvion is to clear all cards from the board by making strategic matches. Each level presents a unique puzzle that requires careful planning and logical thinking.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'How to Play',
                        '1. Tap cards to select them\n'
                        '2. Match cards according to the level rules\n'
                        '3. Clear all cards to complete the level\n'
                        '4. Use undo if you make a mistake\n'
                        '5. Plan ahead for the best strategy',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Scoring System',
                        '• Complete levels to earn stars\n'
                        '• Faster completion = more stars\n'
                        '• Fewer moves = higher score\n'
                        '• Unlock achievements for special accomplishments',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Level Progression',
                        'Solvion features 52 levels organized in a cosmic map. Each level increases in difficulty, introducing new challenges and requiring more advanced strategies. Complete earlier levels to unlock later ones.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Tips for Success',
                        '• Take your time - there\'s no time limit\n'
                        '• Look for patterns in card arrangements\n'
                        '• Plan several moves ahead\n'
                        '• Use the undo button strategically\n'
                        '• Try different approaches if stuck',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Achievements',
                        'Complete special challenges to unlock achievements. Check the Achievements screen from the main menu to see your progress and discover new goals.',
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
            'GAMEPLAY GUIDE',
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.inter(
              fontSize: 14,
              color: AppTheme.deepAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade300,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
