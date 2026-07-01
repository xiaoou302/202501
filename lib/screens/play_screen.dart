import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/pet_activity.dart';
import '../widgets/play/game_card.dart';
import 'play/activity_guide_screen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.creamWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.seafoam),
              SizedBox(width: 8),
              Text(
                'About Play & Training',
                style: TextStyle(
                  color: AppColors.cocoaBrown,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Purpose',
                  style: TextStyle(
                    color: AppColors.cocoaBrown,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This library provides hardware-free interaction guides to help you build a stronger bond with your rescued pet through training, mental stimulation, and physical play.',
                  style: TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'How to Use',
                  style: TextStyle(
                    color: AppColors.cocoaBrown,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Select an Activity: Tap any card to view step-by-step instructions.\n'
                  '• Start the Timer: Use the built-in timer while you play or train.\n'
                  '• Save to Journey: Once finished, the duration and activity tag will be seamlessly merged into today\'s Rescue Journey record.',
                  style: TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: AppColors.seafoam,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group activities by category
    final Map<String, List<PetActivity>> groupedActivities = {};
    for (var activity in activityLibrary) {
      if (!groupedActivities.containsKey(activity.category)) {
        groupedActivities[activity.category] = [];
      }
      groupedActivities[activity.category]!.add(activity);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Play & Training',
          style: TextStyle(
            color: AppColors.cocoaBrown,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.chestnutGray),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.mistyFoam.withOpacity(0.4),
              AppColors.pageBackground,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.25],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.peachFuzz.withValues(alpha: 0.15),
                          AppColors.morningPeach.withValues(alpha: 0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.peachFuzz.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.creamWhite.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: AppColors.peachFuzz,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time Together Heals',
                                style: TextStyle(
                                  color: AppColors.cocoaBrown,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Every minute of play, training, and touch builds trust. Engage with your rescued pet daily to help them feel safe, loved, and confident in their new world.',
                                style: TextStyle(
                                  color: AppColors.chestnutGray,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    String category = groupedActivities.keys.elementAt(index);
                    List<PetActivity> activities = groupedActivities[category]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.seafoam,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                category,
                                style: const TextStyle(
                                  color: AppColors.cocoaBrown,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...activities.map(
                          (activity) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ActivityGuideScreen(activity: activity),
                                  ),
                                );
                              },
                              child: GameCard(
                                title: activity.title,
                                description: activity.shortDesc,
                                icon: activity.icon,
                                iconColor: activity.color,
                                bgColor: AppColors.creamWhite,
                                iconBgColor: activity.bgColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }, childCount: groupedActivities.keys.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
