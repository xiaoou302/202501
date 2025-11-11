import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class VersionHistoryScreen extends StatelessWidget {
  const VersionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppConstants.deepPlum : AppConstants.shellWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Version Story'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppConstants.darkGray
                      : AppConstants.panelWhite,
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: const Color(0xFFE91E63),
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      'Our Journey',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'Every update brings us closer to creating the perfect pet care companion.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingL),

              _buildVersionCard(
                context: context,
                isDark: isDark,
                version: '1.0.0',
                date: 'November 2025',
                badge: 'Current',
                badgeColor: AppConstants.softCoral,
                features: [
                  'Launch of Leno app',
                  'My Pets feature with growth tracking',
                  'AI Pal intelligent assistant',
                  'Paws Plaza community feed',
                  'Dark mode support',
                  'Local data storage',
                ],
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildVersionCard(
                context: context,
                isDark: isDark,
                version: '0.9.0',
                date: 'October 2025',
                badge: 'Beta',
                badgeColor: const Color(0xFF2196F3),
                features: [
                  'Beta testing with early adopters',
                  'Refined UI/UX based on feedback',
                  'Performance optimizations',
                  'Bug fixes and stability improvements',
                ],
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildVersionCard(
                context: context,
                isDark: isDark,
                version: '0.5.0',
                date: 'September 2025',
                badge: 'Alpha',
                badgeColor: const Color(0xFF9C27B0),
                features: [
                  'Initial prototype development',
                  'Core features implementation',
                  'Basic pet profile management',
                  'Simple timeline view',
                ],
              ),
              const SizedBox(height: AppConstants.spacingL),

              // Coming Soon Section
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4CAF50).withOpacity(0.1),
                      const Color(0xFF2196F3).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.rocket_launch,
                          color: const Color(0xFF4CAF50),
                          size: AppConstants.iconL,
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        Text(
                          'Coming Soon',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    _buildFeature('Cloud sync across devices'),
                    _buildFeature('Social sharing features'),
                    _buildFeature('Pet health records integration'),
                    _buildFeature('Veterinarian appointment booking'),
                    _buildFeature('Pet community groups'),
                    _buildFeature('Advanced AI recommendations'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionCard({
    required BuildContext context,
    required bool isDark,
    required String version,
    required String date,
    required String badge,
    required Color badgeColor,
    required List<String> features,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                  vertical: AppConstants.spacingS,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppConstants.mediumGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'Version $version',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 20, color: badgeColor),
                  const SizedBox(width: AppConstants.spacingS),
                  Expanded(
                    child: Text(
                      feature,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
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

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_forward,
            size: 20,
            color: AppConstants.mediumGray,
          ),
          const SizedBox(width: AppConstants.spacingS),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppConstants.mediumGray,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
