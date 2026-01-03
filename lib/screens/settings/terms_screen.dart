import 'package:flutter/material.dart';
import '../../core/app_fonts.dart';
import '../../core/app_theme.dart';


class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
              //  const SizedBox(height: 48),
                _buildHeader(context),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildSection(
                        'Service Description',
                        'Solvion provides a free puzzle game service for entertainment purposes. The service is provided "as is" without warranties of any kind.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Disclaimer of Warranties',
                        'We make no warranties or representations about the accuracy or completeness of the game content. The game is provided without warranty of any kind, either express or implied.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Limitation of Liability',
                        'In no event shall we be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or relating to your use of Solvion.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Indemnification',
                        'You agree to indemnify and hold us harmless from any claims, damages, or expenses arising from your use of the game or violation of these terms.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Governing Law',
                        'These terms shall be governed by and construed in accordance with applicable laws, without regard to conflict of law principles.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Changes to Terms',
                        'We reserve the right to modify these terms at any time. Continued use of Solvion after changes constitutes acceptance of the modified terms.',
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Contact',
                        'If you have any questions about these Terms of Service, please contact us through the Feedback section in Settings.',
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
            'TERMS OF SERVICE',
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
