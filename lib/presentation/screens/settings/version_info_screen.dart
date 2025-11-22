import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../widgets/particle_background.dart';

class VersionInfoScreen extends StatelessWidget {
  const VersionInfoScreen({Key? key}) : super(key: key);

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
                        _buildCurrentVersion(),
                        const SizedBox(height: 24),
                        Text(
                          'What\'s New',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 20,
                            color: const Color(0xFF9B59B6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildUpdateItem(
                          'v2.1.0',
                          'Current Version',
                          [
                            'Enhanced Records screen with detailed statistics',
                            'Improved performance insights and analytics',
                            'New level difficulty grouping system',
                            'Beautiful card animations and transitions',
                            'Bug fixes and performance improvements',
                          ],
                          const Color(0xFF2ECC71),
                          true,
                        ),
                        const SizedBox(height: 16),
                        _buildUpdateItem(
                          'v2.0.0',
                          'Major Update',
                          [
                            'Complete UI redesign with nature theme',
                            'Added 12 progressive difficulty levels',
                            'Introduced combo system for scoring',
                            'Added achievements system',
                            'Observation phase for beginners',
                          ],
                          const Color(0xFF3498DB),
                          false,
                        ),
                        const SizedBox(height: 16),
                        _buildUpdateItem(
                          'v1.0.0',
                          'Initial Release',
                          [
                            'Core memory matching gameplay',
                            'Local storage for progress',
                            'Haptic feedback support',
                            'Basic level system',
                          ],
                          const Color(0xFF95A5A6),
                          false,
                        ),
                        const SizedBox(height: 24),
                        _buildTechInfo(),
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
                    const Color(0xFF9B59B6).withOpacity(0.3),
                    AppColors.slate,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF9B59B6).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF9B59B6),
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
                      FontAwesomeIcons.code,
                      size: 12,
                      color: Color(0xFF9B59B6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'APP VERSION',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFF9B59B6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Version Info',
                  style: AppTextStyles.h2.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentVersion() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF9B59B6).withOpacity(0.2),
            AppColors.slate.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF9B59B6).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B59B6).withOpacity(0.3),
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
                colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9B59B6).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const FaIcon(
              FontAwesomeIcons.rocket,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Version 2.1.0',
            style: AppTextStyles.h1.copyWith(
              fontSize: 36,
              color: const Color(0xFF9B59B6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF2ECC71),
                width: 1.5,
              ),
            ),
            child: Text(
              'LATEST',
              style: AppTextStyles.label.copyWith(
                fontSize: 11,
                color: const Color(0xFF2ECC71),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Released: November 2024',
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: AppColors.mica.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(
    String version,
    String label,
    List<String> features,
    Color color,
    bool isCurrent,
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
                child: FaIcon(
                  isCurrent
                      ? FontAwesomeIcons.star
                      : FontAwesomeIcons.clockRotateLeft,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      version,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 18,
                        color: color,
                      ),
                    ),
                    Text(
                      label,
                      style: AppTextStyles.label.copyWith(
                        fontSize: 11,
                        color: AppColors.mica.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: FaIcon(
                      FontAwesomeIcons.check,
                      size: 12,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.mica.withOpacity(0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3498DB).withOpacity(0.1),
            AppColors.slate.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3498DB).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleInfo,
                size: 18,
                color: Color(0xFF3498DB),
              ),
              const SizedBox(width: 12),
              Text(
                'Technical Information',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  color: const Color(0xFF3498DB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTechItem('Framework', 'Flutter 3.x'),
          _buildTechItem('Language', 'Dart 3.x'),
          _buildTechItem('Platform', 'iOS & Android'),
          _buildTechItem('Storage', 'Local (SharedPreferences)'),
          _buildTechItem('Theme', 'Nature & Animals'),
        ],
      ),
    );
  }

  Widget _buildTechItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: AppColors.mica.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3498DB),
            ),
          ),
        ],
      ),
    );
  }
}

