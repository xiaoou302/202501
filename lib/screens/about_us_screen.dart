import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Screen for About Us information
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Color(0xFFEAE5E1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.textGraphite,
                    ),
                    const Expanded(
                      child: Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGraphite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the header
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                AppColors.arrowBlue,
                                AppColors.accentCoral,
                                AppColors.arrowGreen,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Icon(
                              Icons.extension,
                              size: 70,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // App name
                      const Text(
                        'Glyphion',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGraphite,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // App version
                      const Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.disabledGray,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // App description
                      _buildInfoSection(
                        title: 'About Glyphion',
                        content:
                            'Glyphion is a captivating puzzle game that challenges your strategic thinking and problem-solving skills. Navigate through a series of increasingly complex levels by tapping arrows in the correct sequence to clear the board.',
                      ),

                      const SizedBox(height: 24),

                      // Developer info
                      _buildInfoSection(
                        title: 'Developer',
                        content:
                            'Developed with passion by the Glyphion Team. We are dedicated to creating thoughtful, engaging puzzle games that exercise your mind while providing a beautiful, relaxing experience.',
                      ),

                      const SizedBox(height: 24),

                      // Contact info
                      _buildInfoSection(
                        title: 'Contact',
                        content:
                            'Email: support@glyphion.com\nWebsite: www.glyphion.com',
                      ),

                      const SizedBox(height: 32),

                      // Social media links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            icon: Icons.language,
                            color: AppColors.arrowBlue,
                            onTap: () {},
                          ),
                          _buildSocialButton(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                            onTap: () {},
                          ),
                          _buildSocialButton(
                            icon: Icons.alternate_email,
                            color: AppColors.accentCoral,
                            onTap: () {},
                          ),
                          _buildSocialButton(
                            icon: Icons.camera_alt,
                            color: const Color(0xFFE4405F),
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Copyright
                      const Text(
                        '© 2025 Glyphion. All rights reserved.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.disabledGray,
                        ),
                      ),

                      const SizedBox(height: 16),
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

  Widget _buildInfoSection({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textGraphite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textGraphite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
