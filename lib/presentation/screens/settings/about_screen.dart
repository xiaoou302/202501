import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.midnight,
      appBar: AppBar(
        backgroundColor: AppConstants.midnight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.offwhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About App',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: AppConstants.offwhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppConstants.gold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.palette,
                  size: 64,
                  color: AppConstants.gold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'MeeMi',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 32,
                  color: AppConstants.offwhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Your Creative Art Companion',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.gold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildSection(
              'Our Mission',
              'MeeMi is designed to inspire and empower artists of all levels. Whether you\'re a beginner exploring your creativity or an experienced artist seeking new inspiration, our app provides the tools and community to help you grow.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Features',
              '• Gallery: Discover and share artwork from fellow artists\n'
              '• Drawing Board: Create digital art with intuitive tools\n'
              '• AI Mentor: Get personalized guidance on techniques and concepts\n'
              '• Community: Connect with artists who share your passion',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Our Vision',
              'We believe that everyone has the potential to create beautiful art. MeeMi aims to make art education accessible, engaging, and inspiring for everyone, everywhere.',
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: AppConstants.gold,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Made with passion for artists',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.offwhite,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© 2026 MeeMi. All rights reserved.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppConstants.metalgray.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.gold,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: AppConstants.offwhite,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
