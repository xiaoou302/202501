import 'package:flutter/material.dart';
import '../../core/app_fonts.dart';
import '../../core/app_theme.dart';


class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
               // const SizedBox(height: 48),
                _buildHeader(context),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildWarningBox(),
                      const SizedBox(height: 24),
                      _buildSection(
                        'No Gambling or Betting',
                        'Solvion is a pure logic puzzle game. Despite using playing cards as visual elements, this game has ABSOLUTELY NO connection to gambling, betting, or games of chance. There is no way to wager money, win money, or lose money in this game.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Entertainment Only',
                        'This game is designed solely for entertainment and mental exercise. It is a skill-based puzzle game where success depends entirely on strategic thinking and planning, not luck or chance.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'No Real Money Involved',
                        'Solvion does not involve any real money transactions, in-app purchases for advantages, virtual currency that can be converted to real money, or any form of monetary exchange.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Age Appropriate',
                        'While Solvion uses card imagery, it is appropriate for all ages. The game is a family-friendly puzzle experience with no gambling mechanics or inappropriate content.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Limitation of Liability',
                        'The developers of Solvion are not responsible for any misuse of the game or misinterpretation of its purpose. This is a puzzle game, nothing more.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Responsible Gaming',
                        'If you or someone you know has a gambling problem, please seek help from professional organizations. Solvion is not a gambling game, but we encourage responsible behavior in all forms of entertainment.',
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
            'DISCLAIMER',
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

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFEF4444).withValues(alpha: 0.15),
            const Color(0xFFEF4444).withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_rounded,
            color: const Color(0xFFEF4444),
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IMPORTANT NOTICE',
                  style: AppFonts.orbitron(
                    fontSize: 14,
                    color: const Color(0xFFEF4444),
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This is NOT a gambling game. No real money is involved. This is a puzzle game for entertainment only.',
                  style: AppFonts.inter(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
