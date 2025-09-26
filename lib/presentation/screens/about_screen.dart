import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';

/// About Soli screen
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        backgroundColor: AppTheme.deepSpace,
        title: const Text(
          'About Soli',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.champagne),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Animations.fadeSlideIn(
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.champagne,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.champagne.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: AppTheme.deepSpace,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App Version
            Animations.fadeSlideIn(
              delay: 100,
              child: const Center(
                child: Text(
                  'Soli v1.0.0',
                  style: TextStyle(
                    color: AppTheme.champagne,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // App Description
            Animations.fadeSlideIn(
              delay: 200,
              child: _buildSection(
                'About',
                'Soli is a relationship companion app designed to help couples capture, share, and cherish their precious moments together. The app provides tools for memory collection, proposal planning, and community engagement.',
              ),
            ),
            const SizedBox(height: 24),

            // Mission Statement
            Animations.fadeSlideIn(
              delay: 300,
              child: _buildSection(
                'Our Mission',
                'We believe that love deserves to be celebrated and remembered. Our mission is to provide couples with beautiful digital spaces to document their journey together and plan for meaningful milestones.',
              ),
            ),
            const SizedBox(height: 24),

            // Features
            Animations.fadeSlideIn(
              delay: 400,
              child: _buildSection(
                'Key Features',
                '• Memory Gallery - Store and organize your special moments\n'
                    '• Ceremony Planning - Tools to help plan your perfect proposal\n'
                    '• Emotional Community - Connect with others and share experiences\n'
                    '• AI Assistant - Get personalized relationship advice',
              ),
            ),
            const SizedBox(height: 24),

            // Development Team
            Animations.fadeSlideIn(
              delay: 500,
              child: _buildSection(
                'Development Team',
                'Soli was created by a dedicated team of designers and developers passionate about building technology that strengthens relationships.',
              ),
            ),
            const SizedBox(height: 24),

            // Copyright
            Animations.fadeSlideIn(
              delay: 600,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '© 2025 Soli. All rights reserved.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build content section with title and description
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.champagne,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.silverstone,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            style: const TextStyle(
              color: AppTheme.moonlight,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
