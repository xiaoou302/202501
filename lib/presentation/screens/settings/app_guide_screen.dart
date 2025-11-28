import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AppGuideScreen extends StatelessWidget {
  const AppGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildGuideSection(
                    'Getting Started',
                    [
                      '1. Create your account and set up your profile',
                      '2. Explore the Home screen for personalized content',
                      '3. Browse Pose Flow for professional dance inspiration',
                      '4. Read Insights from amateur dancers sharing their journey',
                    ],
                    Icons.rocket_launch_rounded,
                    const Color(0xFF4A90E2),
                  ),
                  const SizedBox(height: 16),
                  _buildGuideSection(
                    'Logging Your Practice',
                    [
                      '1. Tap the Log tab in the bottom navigation',
                      '2. Select a date on the calendar',
                      '3. Add your practice session details',
                      '4. Track your progress over time',
                    ],
                    Icons.calendar_today_rounded,
                    const Color(0xFF50C878),
                  ),
                  const SizedBox(height: 16),
                  _buildGuideSection(
                    'AI Studio',
                    [
                      '1. Navigate to the Studio tab',
                      '2. Ask questions about dance techniques',
                      '3. Get personalized advice and tips',
                      '4. Save important conversations for later',
                    ],
                    Icons.auto_awesome_rounded,
                    const Color(0xFFFFB347),
                  ),
                  const SizedBox(height: 16),
                  _buildGuideSection(
                    'Following Dancers',
                    [
                      '1. Browse Pose Flow or Insights',
                      '2. Tap on a dancer\'s profile',
                      '3. Click the Follow button',
                      '4. View your favorites in the Profile tab',
                    ],
                    Icons.favorite_rounded,
                    const Color(0xFFFF6B6B),
                  ),
                  const SizedBox(height: 16),
                  _buildGuideSection(
                    'Tips & Tricks',
                    [
                      '• Swipe left/right to navigate between tabs',
                      '• Long press on items for quick actions',
                      '• Use the search feature to find specific content',
                      '• Enable notifications for daily practice reminders',
                    ],
                    Icons.lightbulb_rounded,
                    const Color(0xFF9B59B6),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: AppConstants.ebony.withValues(alpha: 0.95),
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConstants.graphite.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppConstants.offWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'App Guide',
        style: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildGuideSection(String title, List<String> steps, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.5),
            AppConstants.graphite.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.midGray.withValues(alpha: 0.1),
          width: 1,
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
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  step,
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.9),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
