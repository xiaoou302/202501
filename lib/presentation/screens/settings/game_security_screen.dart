import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../widgets/particle_background.dart';

class GameSecurityScreen extends StatelessWidget {
  const GameSecurityScreen({Key? key}) : super(key: key);

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
                        _buildSecurityBadge(),
                        const SizedBox(height: 24),
                        _buildSecurityItem(
                          'Data Privacy',
                          'All game data is stored locally on your device. We do not collect, store, or transmit any personal information to external servers.',
                          FontAwesomeIcons.lock,
                          const Color(0xFF2ECC71),
                        ),
                        const SizedBox(height: 16),
                        _buildSecurityItem(
                          'No Account Required',
                          'Play without creating an account. Your progress is automatically saved on your device without any login requirements.',
                          FontAwesomeIcons.userSlash,
                          const Color(0xFF3498DB),
                        ),
                        const SizedBox(height: 16),
                        _buildSecurityItem(
                          'Offline Play',
                          'Membly works completely offline. No internet connection is required to play, ensuring your privacy and security.',
                          FontAwesomeIcons.wifi,
                          const Color(0xFF9B59B6),
                        ),
                        const SizedBox(height: 16),
                        _buildSecurityItem(
                          'Local Storage Only',
                          'Game preferences, scores, and achievements are stored using secure local storage (SharedPreferences) on your device.',
                          FontAwesomeIcons.database,
                          const Color(0xFFF1C40F),
                        ),
                        const SizedBox(height: 16),
                        _buildSecurityItem(
                          'No Ads or Tracking',
                          'We do not display advertisements or use any tracking technologies. Your gaming experience is private and uninterrupted.',
                          FontAwesomeIcons.shieldHalved,
                          const Color(0xFFE67E22),
                        ),
                        const SizedBox(height: 16),
                        _buildSecurityItem(
                          'Data Control',
                          'You have full control over your data. Clear all game data anytime from the settings menu if needed.',
                          FontAwesomeIcons.gears,
                          const Color(0xFF16A085),
                        ),
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
                    const Color(0xFF16A085).withOpacity(0.3),
                    AppColors.slate,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF16A085).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF16A085),
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
                      FontAwesomeIcons.userShield,
                      size: 12,
                      color: Color(0xFF16A085),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PRIVACY & SECURITY',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFF16A085),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Game Security',
                  style: AppTextStyles.h2.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBadge() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2ECC71).withOpacity(0.2),
            AppColors.slate.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF2ECC71).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2ECC71).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
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
                  color: const Color(0xFF2ECC71).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.shieldHalved,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Privacy Protected',
            style: AppTextStyles.h2.copyWith(
              fontSize: 24,
              color: const Color(0xFF2ECC71),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '100% Local Storage • No Data Collection',
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: AppColors.mica.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(
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
}

