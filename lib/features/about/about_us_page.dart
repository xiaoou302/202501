import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_app_bar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

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
                title: 'About Us',
                showBackButton: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppStyles.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFeatureSection(
                        icon: Icons.brush_outlined,
                        iconColor: AppColors.accentPurple,
                        title: 'Creative Vision',
                        description:
                            'We believe in empowering storytellers with innovative tools that bring their ideas to life.',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildFeatureSection(
                        icon: Icons.auto_awesome,
                        iconColor: AppColors.accentBlue,
                        title: 'AI-Powered Innovation',
                        description:
                            'Our advanced AI technology helps transform your ideas into stunning visual narratives.',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildFeatureSection(
                        icon: Icons.people_outline,
                        iconColor: AppColors.accentGreen,
                        title: 'Community Driven',
                        description:
                            'Built with and for a community of passionate creators and storytellers.',
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildTeamSection(),
                      const SizedBox(height: AppStyles.paddingLarge),
                      _buildMissionSection(),
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

  Widget _buildFeatureSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: AppStyles.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.heading3,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
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

  Widget _buildTeamSection() {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Team',
            style: AppStyles.heading3,
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'A dedicated group of designers, developers, and AI specialists working together to revolutionize digital storytelling.',
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Mission',
            style: AppStyles.heading3,
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'To empower creators with cutting-edge tools that transform their storytelling journey, making the process of creation more intuitive, enjoyable, and accessible to everyone.',
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
