import 'package:flutter/material.dart';
import '../../core/app_fonts.dart';
import '../../core/app_theme.dart';
import '../../core/constants.dart';


class VersionInfoScreen extends StatelessWidget {
  const VersionInfoScreen({super.key});

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
                      _buildAppInfo(),
                      const SizedBox(height: 24),
                      _buildSection(
                        'Current Version',
                        'Version ${AppConstants.appVersion}\n\nYou are running the latest version of Solvion. This version includes all the latest features, improvements, and bug fixes.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'What\'s New',
                        '• Enhanced UI with space theme\n'
                        '• 52 challenging puzzle levels\n'
                        '• Achievement system\n'
                        '• Statistics tracking\n'
                        '• Improved performance\n'
                        '• Bug fixes and optimizations',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Technical Information',
                        'Platform: Flutter\n'
                        'Build: Release\n'
                        'Engine: Stable\n\n'
                        'Solvion is built with Flutter, ensuring smooth performance across all devices.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Credits',
                        'Game Design & Development: Solvion Team\n\n'
                        'Special thanks to all players who provided feedback and helped improve the game.',
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
            'VERSION INFO',
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

  Widget _buildAppInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.deepAccent.withValues(alpha: 0.15),
            AppTheme.deepAccent.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: AppTheme.deepAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  AppTheme.deepAccent,
                  AppTheme.deepBlue,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.deepAccent.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.stars_rounded, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            AppConstants.appName,
            style: AppFonts.orbitron(
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version ${AppConstants.appVersion}',
            style: AppFonts.inter(
              fontSize: 14,
              color: AppTheme.deepAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppConstants.appSubtitle,
            style: AppFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade400,
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
