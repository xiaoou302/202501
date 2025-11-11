import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({Key? key}) : super(key: key);

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
        title: const Text('Explore Guide'),
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
                      Icons.explore,
                      size: 64,
                      color: const Color(0xFFFF9800),
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      'Getting Started with Leno',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'Learn how to make the most of your pet care companion.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingL),

              _buildGuideStep(
                context: context,
                isDark: isDark,
                stepNumber: '1',
                icon: Icons.pets,
                iconColor: AppConstants.softCoral,
                title: 'Add Your Pets',
                description:
                    'Start by adding your beloved pets to the app. Include their photos, names, breeds, and important dates like birthdays.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildGuideStep(
                context: context,
                isDark: isDark,
                stepNumber: '2',
                icon: Icons.timeline,
                iconColor: const Color(0xFF4CAF50),
                title: 'Track Growth Milestones',
                description:
                    'Record important moments in your pet\'s life. Add photos, notes, and track their growth over time with our intuitive timeline feature.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildGuideStep(
                context: context,
                isDark: isDark,
                stepNumber: '3',
                icon: Icons.smart_toy,
                iconColor: const Color(0xFF2196F3),
                title: 'Chat with AI Pal',
                description:
                    'Get instant answers to your pet care questions. Our AI assistant is available 24/7 to help with health, training, and behavior advice.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildGuideStep(
                context: context,
                isDark: isDark,
                stepNumber: '4',
                icon: Icons.explore,
                iconColor: const Color(0xFF9C27B0),
                title: 'Explore Paws Plaza',
                description:
                    'Discover inspiring pet content from the community. Like, save, and share adorable moments with fellow pet lovers.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildGuideStep(
                context: context,
                isDark: isDark,
                stepNumber: '5',
                icon: Icons.notifications,
                iconColor: const Color(0xFFFF5722),
                title: 'Set Reminders',
                description:
                    'Never miss important dates! Set reminders for vet appointments, vaccinations, grooming sessions, and more.',
              ),
              const SizedBox(height: AppConstants.spacingL),

              // Tips Section
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.softCoral.withOpacity(0.1),
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
                          Icons.lightbulb,
                          color: const Color(0xFFFF9800),
                          size: AppConstants.iconL,
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        Text(
                          'Pro Tips',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    _buildTip(
                      'Take regular photos to see your pet\'s growth journey',
                    ),
                    _buildTip(
                      'Use specific questions when chatting with AI Pal',
                    ),
                    _buildTip(
                      'Enable notifications to stay on top of pet care',
                    ),
                    _buildTip('Export your data regularly to keep a backup'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideStep({
    required BuildContext context,
    required bool isDark,
    required String stepNumber,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Icon(icon, color: iconColor, size: AppConstants.iconL),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      stepNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppConstants.mediumGray,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
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
