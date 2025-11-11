import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class VisionScreen extends StatelessWidget {
  const VisionScreen({Key? key}) : super(key: key);

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
        title: const Text('Vision & Mission'),
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
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.softCoral.withOpacity(0.2),
                      const Color(0xFFFF5722).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 64,
                      color: const Color(0xFFFF5722),
                    ),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      'Our Heart & Soul',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'Every pet deserves to be seen, recorded, and scientifically cared for.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingL),

              // Vision Section
              _buildSection(
                context: context,
                isDark: isDark,
                icon: Icons.visibility,
                iconColor: const Color(0xFF2196F3),
                title: 'Our Vision',
                content:
                    'To become the world\'s most trusted and beloved pet care companion, empowering pet owners with the tools and knowledge they need to provide the best possible care for their furry family members.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              // Mission Section
              _buildSection(
                context: context,
                isDark: isDark,
                icon: Icons.flag,
                iconColor: const Color(0xFF4CAF50),
                title: 'Our Mission',
                content:
                    'We strive to create a warm, intelligent, and comprehensive platform that combines community sharing, private recording, and AI-powered assistance to make pet care easier, more enjoyable, and more meaningful for every pet owner.',
              ),
              const SizedBox(height: AppConstants.spacingL),

              // Core Values
              Text('Core Values', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppConstants.spacingM),

              _buildValueCard(
                context: context,
                isDark: isDark,
                icon: Icons.favorite_border,
                iconColor: AppConstants.softCoral,
                title: 'Love & Care',
                description:
                    'We believe every pet deserves unconditional love and the best care possible. Our app is built with compassion at its core.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildValueCard(
                context: context,
                isDark: isDark,
                icon: Icons.lightbulb_outline,
                iconColor: const Color(0xFFFF9800),
                title: 'Innovation',
                description:
                    'We continuously innovate to bring cutting-edge AI technology and intuitive features that make pet care smarter and easier.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildValueCard(
                context: context,
                isDark: isDark,
                icon: Icons.groups,
                iconColor: const Color(0xFF9C27B0),
                title: 'Community',
                description:
                    'We foster a supportive community where pet lovers can connect, share experiences, and learn from each other.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildValueCard(
                context: context,
                isDark: isDark,
                icon: Icons.security,
                iconColor: const Color(0xFF2196F3),
                title: 'Privacy',
                description:
                    'Your data and your pet\'s information are sacred. We prioritize privacy and security in everything we do.',
              ),
              const SizedBox(height: AppConstants.spacingM),

              _buildValueCard(
                context: context,
                isDark: isDark,
                icon: Icons.auto_awesome,
                iconColor: const Color(0xFFE91E63),
                title: 'Excellence',
                description:
                    'We are committed to delivering a polished, delightful user experience that exceeds expectations.',
              ),
              const SizedBox(height: AppConstants.spacingL),

              // Closing Message
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
                    Icon(Icons.pets, size: 48, color: AppConstants.softCoral),
                    const SizedBox(height: AppConstants.spacingM),
                    Text(
                      'Thank You',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'Thank you for choosing Leno. Together, we\'re making the world a better place for pets and their humans.',
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

  Widget _buildSection({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
            ),
            child: Icon(icon, color: iconColor, size: AppConstants.iconXL),
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppConstants.mediumGray,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard({
    required BuildContext context,
    required bool isDark,
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Icon(icon, color: iconColor, size: AppConstants.iconL),
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
}
