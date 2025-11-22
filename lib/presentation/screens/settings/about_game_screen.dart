import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../widgets/particle_background.dart';

class AboutGameScreen extends StatelessWidget {
  const AboutGameScreen({Key? key}) : super(key: key);

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
                        _buildGameLogo(),
                        const SizedBox(height: 24),
                        _buildInfoSection(
                          'What is Membly?',
                          'Membly is a memory matching card game with a beautiful nature and animals theme. Test your memory skills by matching pairs of cards featuring various animals and natural elements.',
                          FontAwesomeIcons.paw,
                          const Color(0xFF2ECC71),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          'Game Features',
                          '• 12 progressive difficulty levels\n• Beautiful nature-themed design\n• Combo system for high scores\n• Achievements and records\n• Observation phase for beginners\n• Smooth animations and haptic feedback',
                          FontAwesomeIcons.star,
                          const Color(0xFFF1C40F),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          'Our Mission',
                          'We aim to provide a relaxing yet challenging memory game experience that celebrates the beauty of nature and wildlife. Perfect for players of all ages looking to improve their memory and have fun!',
                          FontAwesomeIcons.heart,
                          const Color(0xFFE74C3C),
                        ),
                        const SizedBox(height: 16),
                        _buildStatsCard(),
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
                    const Color(0xFF2ECC71).withOpacity(0.3),
                    AppColors.slate,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF2ECC71).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF2ECC71),
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
                      FontAwesomeIcons.bookOpen,
                      size: 12,
                      color: Color(0xFF2ECC71),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'INFORMATION',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFF2ECC71),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'About Game',
                  style: AppTextStyles.h2.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameLogo() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2ECC71).withOpacity(0.2),
            const Color(0xFF3498DB).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF2ECC71).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2ECC71).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.paw,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'MEMBLY',
            style: AppTextStyles.h1.copyWith(
              fontSize: 36,
              color: const Color(0xFF2ECC71),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nature Memory Match',
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: AppColors.mica.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            AppColors.slate.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FaIcon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 18,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              height: 1.6,
              color: AppColors.mica.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9B59B6).withOpacity(0.15),
            AppColors.slate.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF9B59B6).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.chartBar,
                size: 18,
                color: Color(0xFF9B59B6),
              ),
              const SizedBox(width: 12),
              Text(
                'Game Statistics',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  color: const Color(0xFF9B59B6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('12', 'Levels', const Color(0xFF3498DB)),
              ),
              Expanded(
                child: _buildStatItem('29', 'Icons', const Color(0xFF2ECC71)),
              ),
              Expanded(
                child: _buildStatItem('36', 'Cards', const Color(0xFFF1C40F)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h2.copyWith(
            fontSize: 32,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            fontSize: 11,
            color: AppColors.mica.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

