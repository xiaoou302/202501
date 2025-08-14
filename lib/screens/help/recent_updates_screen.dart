import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Recent Updates screen showing latest app changes
class RecentUpdatesScreen extends StatelessWidget {
  const RecentUpdatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: const Text(
          'Recent Updates',
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
              _buildUpdateHeader(),
              const SizedBox(height: 24),
              _buildUpdateCard('1.0.0', 'June 2024', [
                'Initial release of Virelia',
                'Smart packing list generator with AI assistance',
                'Trip planning and organization features',
                'Dark mode UI for comfortable viewing',
                'Personalized travel suggestions',
              ]),
              const SizedBox(height: 16),
              _buildUpdateCard('0.9.5 Beta', 'May 2024', [
                'Final beta release with performance improvements',
                'Enhanced AI suggestions for packing lists',
                'Improved UI responsiveness and animations',
                'Bug fixes and stability improvements',
              ]),
              const SizedBox(height: 16),
              _buildUpdateCard('0.9.0 Beta', 'April 2024', [
                'Added weather-based packing suggestions',
                'Implemented search and filter functionality',
                'Enhanced mission hub with timeline view',
                'Added ability to edit and customize packing items',
              ]),
              const SizedBox(height: 16),
              _buildUpdateCard('0.8.0 Alpha', 'March 2024', [
                'First alpha release for internal testing',
                'Basic packing list functionality',
                'Simple AI integration for suggestions',
                'Core UI components and navigation',
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the update header with app logo
  Widget _buildUpdateHeader() {
    return Center(
      child: Column(
        children: [
          // App Logo
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
            'Virelia Updates',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'See what\'s new in each version',
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Build an update card for a specific version
  Widget _buildUpdateCard(String version, String date, List<String> changes) {
    return Card(
      color: AppTheme.surfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.brandBlue,
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
                const SizedBox(width: 12),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...changes.map((change) => _buildChangeItem(change)).toList(),
          ],
        ),
      ),
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
