import 'package:flutter/material.dart';
import '../../core/app_fonts.dart';
import '../../core/app_theme.dart';


class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

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
               // const SizedBox(height: 48),
                _buildHeader(context),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildSection(
                        '1. Acceptance of Terms',
                        'By downloading, installing, or playing Solvion, you agree to be bound by this User Agreement. If you do not agree to these terms, please do not use the game.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        '2. License Grant',
                        'We grant you a limited, non-exclusive, non-transferable license to use Solvion for personal, non-commercial entertainment purposes.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        '3. User Conduct',
                        'You agree to use Solvion only for lawful purposes and in accordance with this Agreement. You will not attempt to reverse engineer, decompile, or modify the game.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        '4. Intellectual Property',
                        'All content, features, and functionality of Solvion are owned by us and are protected by international copyright, trademark, and other intellectual property laws.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        '5. Privacy',
                        'Your privacy is important to us. Solvion stores game progress locally on your device. We do not collect, transmit, or share any personal information.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        '6. Updates and Modifications',
                        'We reserve the right to modify, update, or discontinue Solvion at any time without prior notice. We may also update these terms periodically.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        '7. Termination',
                        'This license is effective until terminated. Your rights will terminate automatically if you fail to comply with any terms of this Agreement.',
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
            'USER AGREEMENT',
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
