import 'package:flutter/material.dart';
import '../../../../app/theme/color_palette.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Capu'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.2),
                      AppColors.accent.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.accent,
                      AppColors.accent.withValues(alpha: 0.7),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'Capu',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              icon: Icons.info_outline_rounded,
              iconColor: const Color(0xFF3B82F6),
              title: 'What is Capu?',
              content:
                  'Capu is your personal style companion, designed to help you discover, organize, and evolve your fashion sense. We combine AI-powered recommendations with a beautiful interface to make style exploration effortless and enjoyable.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              icon: Icons.auto_awesome_rounded,
              iconColor: const Color(0xFF8B5CF6),
              title: 'Our Mission',
              content:
                  'To empower everyone to express their unique style with confidence. We believe fashion should be accessible, personal, and fun for everyone.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              icon: Icons.favorite_outline_rounded,
              iconColor: const Color(0xFFEC4899),
              title: 'What We Offer',
              content:
                  '• Curated style inspiration\n• AI-powered outfit recommendations\n• Personal style archive\n• Community-driven content\n• Smart outfit tracking',
            ),
            const SizedBox(height: 24),
            _buildSection(
              icon: Icons.people_outline_rounded,
              iconColor: const Color(0xFF10B981),
              title: 'Our Team',
              content:
                  'Built by a passionate team of designers, developers, and fashion enthusiasts who believe technology can enhance personal style.',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withValues(alpha: 0.1),
                    AppColors.accent.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 32,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'support@zylo.app',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gray.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
