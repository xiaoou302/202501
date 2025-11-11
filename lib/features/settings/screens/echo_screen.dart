import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class EchoScreen extends StatefulWidget {
  const EchoScreen({Key? key}) : super(key: key);

  @override
  State<EchoScreen> createState() => _EchoScreenState();
}

class _EchoScreenState extends State<EchoScreen> {
  final List<_Testimonial> _testimonials = [
    _Testimonial(
      name: 'Sarah Mitchell',
      avatarPath: 'assets/rw/12221762707350_.pic_hd.jpg',
      rating: 5,
      date: 'November 2025',
      comment:
          'Leno has completely changed how I care for my pets. The AI assistant is incredibly helpful, and I love tracking my dog\'s growth milestones!',
    ),
    _Testimonial(
      name: 'James Chen',
      avatarPath: 'assets/rw/12231762707351_.pic_hd.jpg',
      rating: 5,
      date: 'November 2025',
      comment:
          'The interface is beautiful and intuitive. I especially appreciate the privacy-first approach. My pet data stays on my device.',
    ),
    _Testimonial(
      name: 'Emma Rodriguez',
      avatarPath: 'assets/rw/12241762707352_.pic_hd.jpg',
      rating: 5,
      date: 'October 2025',
      comment:
          'As a first-time pet owner, the Explore Guide and AI Pal have been invaluable. I feel so much more confident caring for my kitten now!',
    ),
    _Testimonial(
      name: 'Michael Brown',
      avatarPath: 'assets/rw/12251762707353_.pic_hd.jpg',
      rating: 4,
      date: 'October 2025',
      comment:
          'Great app with lots of useful features. The growth tracking timeline is my favorite. Would love to see cloud sync in future updates!',
    ),
    _Testimonial(
      name: 'Lisa Wang',
      avatarPath: 'assets/rw/12261762707354_.pic_hd.jpg',
      rating: 5,
      date: 'October 2025',
      comment:
          'The Paws Plaza community is so inspiring! I love seeing other people\'s pets and sharing my own. This app brings pet lovers together beautifully.',
    ),
    _Testimonial(
      name: 'David Kim',
      avatarPath: 'assets/rw/12271762707355_.pic_hd.jpg',
      rating: 5,
      date: 'September 2025',
      comment:
          'Been using Leno since beta. The team really listens to feedback and keeps improving. Dark mode is gorgeous!',
    ),
  ];

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
        title: const Text('Listening Echo'),
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
                    Icon(Icons.forum, size: 64, color: const Color(0xFF00BCD4)),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      'Voices from Our Community',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'We listen to every piece of feedback. Here\'s what our users are saying.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingL),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      isDark: isDark,
                      value: '4.9',
                      label: 'Average Rating',
                      icon: Icons.star,
                      color: const Color(0xFFFF9800),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      isDark: isDark,
                      value: '2.5K+',
                      label: 'Happy Users',
                      icon: Icons.people,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingL),

              // Testimonials
              Text('User Testimonials', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppConstants.spacingM),

              ..._testimonials.map(
                (testimonial) => Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
                  child: _buildTestimonialCard(
                    context: context,
                    isDark: isDark,
                    testimonial: testimonial,
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingL),

              // Call to Action
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00BCD4).withOpacity(0.1),
                      AppConstants.softCoral.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review,
                      size: 48,
                      color: const Color(0xFF00BCD4),
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      'Share Your Experience',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'Your feedback helps us improve Leno for everyone. Share your thoughts in the Experience Feedback section!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required bool isDark,
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppConstants.iconXL),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            value,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXS),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppConstants.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard({
    required BuildContext context,
    required bool isDark,
    required _Testimonial testimonial,
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
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(testimonial.avatarPath),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      testimonial.date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < testimonial.rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFF9800),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            testimonial.comment,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _Testimonial {
  final String name;
  final String avatarPath;
  final int rating;
  final String date;
  final String comment;

  _Testimonial({
    required this.name,
    required this.avatarPath,
    required this.rating,
    required this.date,
    required this.comment,
  });
}
