import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../widgets/particle_background.dart';

class GameBenefitsScreen extends StatelessWidget {
  const GameBenefitsScreen({Key? key}) : super(key: key);

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
                        _buildWelcomeCard(),
                        const SizedBox(height: 24),
                        Text(
                          'Core Features',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 20,
                            color: const Color(0xFFE67E22),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'Completely Free',
                          'Membly is 100% free to play with no hidden costs, in-app purchases, or subscriptions. Enjoy the full game experience at no charge!',
                          FontAwesomeIcons.gift,
                          const Color(0xFF2ECC71),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'No Ads Experience',
                          'Play without interruptions! We don\'t show any advertisements, ensuring a smooth and enjoyable gaming experience.',
                          FontAwesomeIcons.ban,
                          const Color(0xFF3498DB),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'Offline Gameplay',
                          'No internet connection required! Play anywhere, anytime without using your mobile data or needing Wi-Fi.',
                          FontAwesomeIcons.wifi,
                          const Color(0xFF9B59B6),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'Privacy First',
                          'Your data stays on your device. We don\'t collect, store, or share any personal information. Complete privacy guaranteed.',
                          FontAwesomeIcons.userShield,
                          const Color(0xFF16A085),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Game Benefits',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 20,
                            color: const Color(0xFFE67E22),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'Memory Enhancement',
                          'Regular gameplay helps improve short-term memory, concentration, and cognitive skills through engaging challenges.',
                          FontAwesomeIcons.brain,
                          const Color(0xFFF1C40F),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'Stress Relief',
                          'Enjoy a calming nature theme with beautiful visuals and soothing gameplay that helps reduce stress and anxiety.',
                          FontAwesomeIcons.spa,
                          const Color(0xFF2ECC71),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'Progressive Difficulty',
                          'Start easy and gradually increase difficulty. Perfect for all skill levels, from beginners to memory champions!',
                          FontAwesomeIcons.chartLine,
                          const Color(0xFFE67E22),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'Achievement System',
                          'Unlock special achievements as you master the game. Track your progress and celebrate your accomplishments!',
                          FontAwesomeIcons.trophy,
                          const Color(0xFFF39C12),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'Beautiful Design',
                          'Immerse yourself in a stunning nature-themed interface with smooth animations and delightful animal icons.',
                          FontAwesomeIcons.palette,
                          const Color(0xFF9B59B6),
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          'Family Friendly',
                          'Safe for all ages! No inappropriate content, perfect for family game time and educational play.',
                          FontAwesomeIcons.users,
                          const Color(0xFF3498DB),
                        ),
                        const SizedBox(height: 24),
                        _buildSpecialNote(),
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
                    const Color(0xFFE67E22).withOpacity(0.3),
                    AppColors.slate,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFE67E22).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFFE67E22),
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
                      FontAwesomeIcons.gift,
                      size: 12,
                      color: Color(0xFFE67E22),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'BENEFITS',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFFE67E22),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Game Benefits',
                  style: AppTextStyles.h2.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE67E22).withOpacity(0.2),
            AppColors.slate.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE67E22).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE67E22).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE67E22), Color(0xFFD35400)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE67E22).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const FaIcon(
              FontAwesomeIcons.star,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Why Choose Membly?',
            style: AppTextStyles.h2.copyWith(
              fontSize: 24,
              color: const Color(0xFFE67E22),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Discover all the amazing features and benefits that make Membly the perfect memory game for everyone!',
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

  Widget _buildBenefitItem(
    String title,
    String description,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: FaIcon(icon, size: 20, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 17,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.mica.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialNote() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1ABC9C).withOpacity(0.15),
            AppColors.slate.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1ABC9C).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1ABC9C).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const FaIcon(
              FontAwesomeIcons.heart,
              size: 20,
              color: Color(0xFF1ABC9C),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Made with Love',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 18,
                    color: const Color(0xFF1ABC9C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Membly is crafted with passion to provide you with the best memory gaming experience. We hope you enjoy every moment of your journey through nature!',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    height: 1.6,
                    color: AppColors.mica.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

