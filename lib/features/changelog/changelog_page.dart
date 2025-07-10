import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_app_bar.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'What\'s New',
                showBackButton: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppStyles.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildVersionSection(
                        version: '1.2.0',
                        date: 'March 2024',
                        changes: [
                          ChangelogItem(
                            type: ChangeType.feature,
                            title: 'AI-Powered Story Generation',
                            description:
                                'Transform your ideas into visual stories with our new AI assistant.',
                          ),
                          ChangelogItem(
                            type: ChangeType.improvement,
                            title: 'Enhanced Task Management',
                            description:
                                'Redesigned priority matrix with better organization and visual feedback.',
                          ),
                          ChangelogItem(
                            type: ChangeType.fix,
                            title: 'Performance Optimization',
                            description:
                                'Improved app loading times and reduced memory usage.',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildVersionSection(
                        version: '1.1.0',
                        date: 'February 2024',
                        changes: [
                          ChangelogItem(
                            type: ChangeType.feature,
                            title: 'Cloud Sync',
                            description:
                                'Securely backup and sync your data across devices.',
                          ),
                          ChangelogItem(
                            type: ChangeType.improvement,
                            title: 'Dark Mode',
                            description:
                                'Added system-wide dark mode support for better visibility.',
                          ),
                          ChangelogItem(
                            type: ChangeType.fix,
                            title: 'Bug Fixes',
                            description:
                                'Fixed various UI issues and improved stability.',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildVersionSection(
                        version: '1.0.0',
                        date: 'January 2024',
                        changes: [
                          ChangelogItem(
                            type: ChangeType.feature,
                            title: 'Initial Release',
                            description:
                                'First public release with core features.',
                          ),
                          ChangelogItem(
                            type: ChangeType.feature,
                            title: 'Story Management',
                            description:
                                'Create and organize your story ideas with chapters.',
                          ),
                          ChangelogItem(
                            type: ChangeType.feature,
                            title: 'Task Organization',
                            description:
                                'Manage tasks with our priority matrix system.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.update,
                  color: AppColors.accentPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppStyles.paddingMedium),
              const Expanded(
                child: Text(
                  'Latest Updates',
                  style: AppStyles.heading3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'Stay up to date with the latest features, improvements, and bug fixes.',
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionSection({
    required String version,
    required String date,
    required List<ChangelogItem> changes,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Version $version',
                style: AppStyles.heading3,
              ),
              const SizedBox(width: AppStyles.paddingMedium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppStyles.paddingSmall,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  date,
                  style: AppStyles.caption.copyWith(
                    color: AppColors.accentPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          ...changes.map((change) => _buildChangeItem(change)).toList(),
        ],
      ),
    );
  }

  Widget _buildChangeItem(ChangelogItem item) {
    final IconData icon;
    final Color color;

    switch (item.type) {
      case ChangeType.feature:
        icon = Icons.star;
        color = AppColors.accentPurple;
        break;
      case ChangeType.improvement:
        icon = Icons.trending_up;
        color = AppColors.accentBlue;
        break;
      case ChangeType.fix:
        icon = Icons.build;
        color = AppColors.accentGreen;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppStyles.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppStyles.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: AppStyles.bodyText.copyWith(
                    color: Colors.white70,
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

enum ChangeType {
  feature,
  improvement,
  fix,
}

class ChangelogItem {
  final ChangeType type;
  final String title;
  final String description;

  const ChangelogItem({
    required this.type,
    required this.title,
    required this.description,
  });
}
