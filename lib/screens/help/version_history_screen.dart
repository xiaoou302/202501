import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Version History screen showing all app versions and changes
class VersionHistoryScreen extends StatelessWidget {
  const VersionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: const Text(
          'Version History',
          style: TextStyle(color: AppTheme.primaryText),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVersionHeader(),
              const SizedBox(height: 24),
              _buildVersionTimeline(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build version header with app logo
  Widget _buildVersionHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.brandBlue, AppTheme.accentOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'K',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Version History',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete changelog of all Virelia versions',
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Build version timeline with all versions
  Widget _buildVersionTimeline(BuildContext context) {
    // List of all versions with details
    final List<Map<String, dynamic>> versions = [
      {
        'version': '1.0.0',
        'date': 'June 15, 2024',
        'type': 'Major Release',
        'changes': [
          'Initial public release of Virelia',
          'Smart packing list generator with AI assistance',
          'Trip planning and organization features',
          'Dark mode UI for comfortable viewing',
          'Personalized travel suggestions based on destination and season',
          'Weather integration for packing recommendations',
          'Search and filter functionality for packing items',
          'User profile and settings management',
        ],
        'color': const Color(0xFF4CAF50), // Green
      },
      {
        'version': '0.9.5',
        'date': 'May 28, 2024',
        'type': 'Beta',
        'changes': [
          'Final beta release with performance improvements',
          'Enhanced AI suggestions for packing lists',
          'Improved UI responsiveness and animations',
          'Bug fixes and stability improvements',
          'Added haptic feedback for better user experience',
          'Optimized app size and loading times',
          'Fixed issues with dark mode consistency',
        ],
        'color': const Color(0xFF2196F3), // Blue
      },
      {
        'version': '0.9.0',
        'date': 'April 15, 2024',
        'type': 'Beta',
        'changes': [
          'Added weather-based packing suggestions',
          'Implemented search and filter functionality',
          'Enhanced mission hub with timeline view',
          'Added ability to edit and customize packing items',
          'Improved AI response quality and relevance',
          'Added category-based organization for packing items',
          'Implemented progress tracking for packing status',
        ],
        'color': const Color(0xFF2196F3), // Blue
      },
      {
        'version': '0.8.0',
        'date': 'March 10, 2024',
        'type': 'Alpha',
        'changes': [
          'First alpha release for internal testing',
          'Basic packing list functionality',
          'Simple AI integration for suggestions',
          'Core UI components and navigation',
          'Dark mode theme implementation',
          'Local storage for saving trip data',
          'Basic mission management features',
        ],
        'color': const Color(0xFFFF9800), // Orange
      },
      {
        'version': '0.7.0',
        'date': 'February 5, 2024',
        'type': 'Pre-Alpha',
        'changes': [
          'Initial concept development',
          'UI/UX design prototypes',
          'Core architecture planning',
          'AI integration research and testing',
          'Basic navigation structure',
        ],
        'color': const Color(0xFF9E9E9E), // Grey
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: versions.length,
      itemBuilder: (context, index) {
        final version = versions[index];
        final bool isLast = index == versions.length - 1;

        return _buildVersionItem(
          version['version'],
          version['date'],
          version['type'],
          version['changes'],
          version['color'],
          isLast,
        );
      },
    );
  }

  /// Build a single version item with timeline connector
  Widget _buildVersionItem(
    String version,
    String date,
    String type,
    List<String> changes,
    Color color,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline connector
        SizedBox(
          width: 30,
          child: Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 120 + (changes.length * 20),
                  color: AppTheme.secondaryText.withOpacity(0.3),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Version details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  version,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                date,
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: AppTheme.surfaceBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Changes:',
                        style: TextStyle(
                          color: AppTheme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...changes
                          .map((change) => _buildChangeItem(change))
                          .toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a single change item with bullet point
  Widget _buildChangeItem(String change) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: AppTheme.accentOrange,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              change,
              style: const TextStyle(color: AppTheme.primaryText, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
