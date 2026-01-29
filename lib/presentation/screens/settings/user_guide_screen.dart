import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oravie/core/constants/app_colors.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.snowWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.snowWhite,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.charcoal,
                  size: 18,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.slateGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.bookOpenReader,
                        size: 40,
                        color: AppColors.slateGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'User Guide',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Playfair Display',
                      color: AppColors.charcoal,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Learn how to get the most out of Strida.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildGuideItem(
                    step: '01',
                    icon: FontAwesomeIcons.layerGroup,
                    title: 'Inspiration Gallery',
                    content:
                        'Browse through our curated collection of interior design ideas. Tap on any image to view details, design highlights, and considerations.',
                    color: const Color(0xFF6C63FF),
                  ),
                  _buildGuideItem(
                    step: '02',
                    icon: FontAwesomeIcons.comments,
                    title: 'AI Discourse',
                    content:
                        'Chat with our AI assistant about decoration topics. Tap on the topic chips for quick questions or type your own.',
                    color: const Color(0xFF00BFA5),
                  ),
                  _buildGuideItem(
                    step: '03',
                    icon: FontAwesomeIcons.wandMagicSparkles,
                    title: 'AI Visualization',
                    content:
                        'Upload a photo of your room and select a style. Our AI will generate a redesigned version of your space in seconds.',
                    color: const Color(0xFFFF6584),
                  ),
                  _buildGuideItem(
                    step: '04',
                    icon: FontAwesomeIcons.bookmark,
                    title: 'Favorites',
                    content:
                        'Save your favorite designs by tapping the bookmark icon. Access them anytime from your Profile page.',
                    color: const Color(0xFFFFC107),
                  ),
                  _buildGuideItem(
                    step: '05',
                    icon: FontAwesomeIcons.clock,
                    title: 'Renovation Records',
                    content:
                        'Document your renovation journey. Add photos and notes to create a timeline of your progress.',
                    color: const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem({
    required String step,
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            padding: const EdgeInsets.fromLTRB(32, 24, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 24,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.charcoal.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  step,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
