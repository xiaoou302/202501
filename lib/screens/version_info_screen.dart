import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';

class VersionInfoScreen extends StatelessWidget {
  const VersionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: 'Version Information',
        onHomePressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildCurrentVersion(),
            const SizedBox(height: AppSpacing.xl),
            _buildChangelogSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentVersion() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppColors.alchemicalGold.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        borderRadius: AppRadius.largeRadius,
        border: Border.all(
          color: AppColors.alchemicalGold.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: AppColors.alchemicalGold,
            shadows: [
              Shadow(
                color: AppColors.alchemicalGold.withOpacity(0.6),
                blurRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Cognifex',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.alchemicalGold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.alchemicalGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.alchemicalGold.withOpacity(0.5),
              ),
            ),
            child: const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.alchemicalGold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Released: November 2025',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.neutralSteel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangelogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Changelog',
          style: TextStyle(
            fontFamily: AppTextStyles.serifFont,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.alchemicalGold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildVersionCard(
          version: '1.0.0',
          date: 'November 2025',
          isLatest: true,
          changes: [
            'Initial release of Cognifex',
            'Three unique recipe variants (Phoenix, Serpent, Dragon)',
            'Two-stage gameplay: Study and Laboratory',
            'Progressive revelation system',
            'Crafting log with detailed attempt history',
            'Immersive alchemical narrative',
            'Encrypted journal with cryptic clues',
          ],
        ),
        _buildVersionCard(
          version: '0.9.0 Beta',
          date: 'October 2025',
          isLatest: false,
          changes: [
            'Beta testing phase',
            'Puzzle balancing and difficulty tuning',
            'UI/UX refinements',
            'Bug fixes and performance improvements',
          ],
        ),
        _buildVersionCard(
          version: '0.5.0 Alpha',
          date: 'September 2025',
          isLatest: false,
          changes: [
            'Core gameplay mechanics implemented',
            'Basic UI framework',
            'Single recipe variant',
            'Internal testing',
          ],
        ),
      ],
    );
  }

  Widget _buildVersionCard({
    required String version,
    required String date,
    required bool isLatest,
    required List<String> changes,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLatest
              ? [
                  AppColors.alchemicalGold.withOpacity(0.15),
                  Colors.black.withOpacity(0.3),
                ]
              : [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.2),
                ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: isLatest
              ? AppColors.alchemicalGold.withOpacity(0.4)
              : AppColors.neutralSteel.withOpacity(0.3),
          width: isLatest ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                version,
                style: TextStyle(
                  fontFamily: AppTextStyles.serifFont,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isLatest
                      ? AppColors.alchemicalGold
                      : AppColors.neutralSteel,
                ),
              ),
              if (isLatest) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.alchemicalGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.alchemicalGold,
                    ),
                  ),
                  child: const Text(
                    'LATEST',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.alchemicalGold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.neutralSteel,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...changes.map((change) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.fiber_manual_record,
                        size: 8,
                        color: isLatest
                            ? AppColors.alchemicalGold
                            : AppColors.neutralSteel,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        change,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.alabasterWhite,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

