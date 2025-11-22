import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../widgets/particle_background.dart';

class PlayerAgreementScreen extends StatelessWidget {
  const PlayerAgreementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildIntroCard(),
                        const SizedBox(height: 20),
                        _buildSection(
                          '1. Acceptance of Terms',
                          'By downloading, installing, or playing Membly, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use this game.',
                          FontAwesomeIcons.handshake,
                          const Color(0xFF3498DB),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          '2. License to Use',
                          'We grant you a limited, non-exclusive, non-transferable license to download and play Membly for your personal, non-commercial use. You may not modify, distribute, or create derivative works from this game.',
                          FontAwesomeIcons.key,
                          const Color(0xFF2ECC71),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          '3. User Conduct',
                          'You agree to use Membly in accordance with all applicable laws and regulations. You will not attempt to reverse engineer, hack, or exploit any part of the game for unauthorized purposes.',
                          FontAwesomeIcons.userCheck,
                          const Color(0xFF9B59B6),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          '4. Intellectual Property',
                          'All content in Membly, including graphics, icons, animations, and game mechanics, are protected by copyright and other intellectual property rights. All rights reserved.',
                          FontAwesomeIcons.copyright,
                          const Color(0xFFF1C40F),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          '5. Privacy Policy',
                          'We respect your privacy. Membly stores all game data locally on your device. We do not collect, transmit, or store any personal information on external servers. See our Game Security page for more details.',
                          FontAwesomeIcons.shield,
                          const Color(0xFF16A085),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          '6. Disclaimer of Warranties',
                          'Membly is provided "as is" without warranties of any kind. We do not guarantee that the game will be error-free or uninterrupted. Use at your own risk.',
                          FontAwesomeIcons.triangleExclamation,
                          const Color(0xFFE67E22),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          '7. Limitation of Liability',
                          'We shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of Membly. Our total liability shall not exceed the amount you paid for the game (if any).',
                          FontAwesomeIcons.scaleBalanced,
                          const Color(0xFFE74C3C),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          '8. Updates and Changes',
                          'We may update Membly from time to time to add new features, fix bugs, or improve performance. We reserve the right to modify these Terms of Service at any time.',
                          FontAwesomeIcons.arrowsRotate,
                          const Color(0xFF1ABC9C),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          '9. Termination',
                          'We reserve the right to terminate or suspend your access to Membly at any time without notice for any reason. Upon termination, you must cease all use of the game.',
                          FontAwesomeIcons.ban,
                          const Color(0xFF95A5A6),
                        ),
                        const SizedBox(height: 24),
                        _buildLastUpdated(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.midnight, AppColors.midnight.withOpacity(0)],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticUtils.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3498DB).withOpacity(0.3),
                    AppColors.slate,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF3498DB).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF3498DB),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.fileContract,
                      size: 12,
                      color: Color(0xFF3498DB),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'LEGAL',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFF3498DB),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Player Agreement',
                  style: AppTextStyles.h2.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3498DB).withOpacity(0.2),
            AppColors.slate.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3498DB).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3498DB).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3498DB).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const FaIcon(
              FontAwesomeIcons.fileContract,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Terms of Service',
            style: AppTextStyles.h2.copyWith(
              fontSize: 24,
              color: const Color(0xFF3498DB),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please read these terms carefully before using Membly. Your continued use constitutes acceptance of these terms.',
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              height: 1.6,
              color: AppColors.mica.withOpacity(0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            AppColors.slate.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              height: 1.6,
              color: AppColors.mica.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mica.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.clock,
            size: 16,
            color: Color(0xFF95A5A6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Last Updated: November 2024',
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                color: AppColors.mica.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

