import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_app_bar.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: 'Welcome to Ventrixalor',
      description:
          'Your creative companion for storytelling and task management.',
      icon: Icons.auto_awesome,
      color: AppColors.accentPurple,
    ),
    TutorialStep(
      title: 'Story Ideas',
      description:
          'Capture and organize your creative ideas with tags and chapters.',
      icon: Icons.lightbulb_outline,
      color: AppColors.accentBlue,
    ),
    TutorialStep(
      title: 'Priority Matrix',
      description:
          'Manage your tasks effectively with our four-quadrant system.',
      icon: Icons.grid_view,
      color: AppColors.accentGreen,
    ),
    TutorialStep(
      title: 'AI-Powered Creation',
      description:
          'Transform your ideas into visual stories with AI assistance.',
      icon: Icons.brush,
      color: AppColors.success,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

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
                title: 'Getting Started',
                showBackButton: true,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: _steps.length,
                        itemBuilder: (context, index) {
                          return _buildTutorialStep(_steps[index]);
                        },
                      ),
                    ),
                    _buildPageIndicator(),
                    _buildNavigationButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialStep(TutorialStep step) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppStyles.paddingLarge),
            decoration: BoxDecoration(
              color: step.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              size: 64,
              color: step.color,
            ),
          ),
          const SizedBox(height: AppStyles.paddingLarge),
          Text(
            step.title,
            style: AppStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            step.description,
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppStyles.paddingLarge),
          _buildFeatureCard(step),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(TutorialStep step) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        children: [
          _buildFeatureItem(
            icon: Icons.check_circle_outline,
            text: 'Simple and intuitive interface',
            color: step.color,
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          _buildFeatureItem(
            icon: Icons.touch_app,
            text: 'Interactive tutorials and tooltips',
            color: step.color,
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          _buildFeatureItem(
            icon: Icons.help_outline,
            text: '24/7 support and documentation',
            color: step.color,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
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
          child: Text(
            text,
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_steps.length, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? AppColors.accentPurple
                  : AppColors.accentPurple.withOpacity(0.2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton.icon(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              style: AppStyles.outlinedButtonStyle,
            )
          else
            const SizedBox.shrink(),
          ElevatedButton.icon(
            onPressed: () {
              if (_currentPage < _steps.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: Icon(
              _currentPage < _steps.length - 1
                  ? Icons.arrow_forward
                  : Icons.check,
            ),
            label: Text(
              _currentPage < _steps.length - 1 ? 'Next' : 'Get Started',
            ),
            style: AppStyles.primaryButtonStyle,
          ),
        ],
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
