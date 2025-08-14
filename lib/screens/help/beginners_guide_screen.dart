import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Beginner's Guide screen with tips for new users
class BeginnersGuideScreen extends StatelessWidget {
  const BeginnersGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: const Text(
          'Beginner\'s Guide',
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
              _buildGuideHeader(),
              const SizedBox(height: 24),
              _buildGettingStarted(),
              const SizedBox(height: 24),
              _buildFeatureTips(),
              const SizedBox(height: 24),
              _buildTravelTips(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build guide header with illustration
  Widget _buildGuideHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB74D).withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Color(0xFFFFB74D),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to Virelia!',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'This guide will help you get started and make the most of your travel planning experience.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// Build getting started section
  Widget _buildGettingStarted() {
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: Color(0xFF4CAF50),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Getting Started',
                  style: TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStepItem(
              '1',
              'Create Your First Trip',
              'Go to the Smart Luggage tab and tap the "+" button to create a new trip. Enter your destination, travel dates, and number of travelers.',
              const Color(0xFF4CAF50),
            ),
            _buildStepItem(
              '2',
              'Generate a Packing List',
              'After entering your trip details, tap "Generate Packing List" to let our AI create a personalized list based on your destination and trip details.',
              const Color(0xFF4CAF50),
            ),
            _buildStepItem(
              '3',
              'Customize Your List',
              'Review the generated list and add, remove, or modify items as needed. You can mark items as packed by tapping on them.',
              const Color(0xFF4CAF50),
            ),
            _buildStepItem(
              '4',
              'Track Your Progress',
              'Use the progress indicators to see how much of your packing is complete. Filter by category or search for specific items.',
              const Color(0xFF4CAF50),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Build feature tips section
  Widget _buildFeatureTips() {
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.tips_and_updates_outlined,
                    color: Color(0xFF2196F3),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Feature Tips',
                  style: TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFeatureTip(
              'Smart Filtering',
              'Use the category filters to quickly find items by type (clothing, electronics, documents, etc.).',
              Icons.filter_list,
              const Color(0xFFE91E63),
            ),
            _buildFeatureTip(
              'Search Functionality',
              'Can\'t find an item? Use the search bar at the top of your packing list to quickly locate specific items.',
              Icons.search,
              const Color(0xFF9C27B0),
            ),
            _buildFeatureTip(
              'AI Assistant',
              'Chat with our AI assistant in the Explore tab for personalized travel advice and suggestions.',
              Icons.smart_toy_outlined,
              const Color(0xFF00BCD4),
            ),
            _buildFeatureTip(
              'Dark Mode',
              'Virelia is designed with a comfortable dark mode interface that\'s easy on the eyes, especially when planning at night.',
              Icons.dark_mode_outlined,
              const Color(0xFF3F51B5),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Build travel tips section
  Widget _buildTravelTips() {
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.flight_takeoff,
                    color: Color(0xFFFF9800),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Pro Travel Tips',
                  style: TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTravelTip(
              'Pack by Outfit',
              'Plan specific outfits for each day rather than packing individual items. This helps avoid overpacking.',
              const Color(0xFFFF9800),
            ),
            _buildTravelTip(
              'Roll, Don\'t Fold',
              'Rolling clothes instead of folding them saves space and reduces wrinkles.',
              const Color(0xFFFF9800),
            ),
            _buildTravelTip(
              'Important Documents First',
              'Always pack your passport, ID, and other essential documents in an easily accessible place.',
              const Color(0xFFFF9800),
            ),
            _buildTravelTip(
              'Check Weather Forecast',
              'Always check the weather forecast for your destination before finalizing your packing list.',
              const Color(0xFFFF9800),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Build a step item with number
  Widget _buildStepItem(
    String number,
    String title,
    String description,
    Color color, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 14,
                ),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a feature tip item
  Widget _buildFeatureTip(
    String title,
    String description,
    IconData icon,
    Color color, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a travel tip item
  Widget _buildTravelTip(
    String title,
    String description,
    Color color, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: AppTheme.accentOrange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 14,
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
