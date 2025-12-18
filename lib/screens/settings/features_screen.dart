import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Features',
          style: AppTextStyles.poemTitle.copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFC107).withValues(alpha: 0.15),
                    const Color(0xFFFFC107).withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFFFC107),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Discover what makes Zina special',
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Features List
            _buildFeatureCard(
              icon: Icons.explore_rounded,
              iconColor: const Color(0xFF2196F3),
              title: 'Discovery',
              description: 'Explore a curated collection of beautiful poetry from talented writers around the world. Each poem is paired with stunning imagery to enhance your reading experience.',
              features: [
                'Curated poetry collection',
                'High-quality imagery',
                'Author profiles',
                'Like and bookmark poems',
              ],
            ),
            const SizedBox(height: 20),
            
            _buildFeatureCard(
              icon: Icons.psychology_rounded,
              iconColor: const Color(0xFF9C27B0),
              title: 'AI Assistant',
              description: 'Get creative inspiration and guidance from our AI-powered poetry assistant. Discuss techniques, explore themes, and refine your craft.',
              features: [
                'Creative writing guidance',
                'Poetry technique discussions',
                'Ethical AI boundaries',
                'Conversation history',
              ],
            ),
            const SizedBox(height: 20),
            
            _buildFeatureCard(
              icon: Icons.edit_note_rounded,
              iconColor: const Color(0xFF4CAF50),
              title: 'Creation Studio',
              description: 'A powerful yet simple editor designed for poets. Write, edit, and perfect your verses with tools built specifically for creative writing.',
              features: [
                'Distraction-free editor',
                'Multiple draft management',
                'Custom image uploads',
                'Version history',
              ],
            ),
            const SizedBox(height: 20),
            
            _buildFeatureCard(
              icon: Icons.bookmark_rounded,
              iconColor: const Color(0xFFE91E63),
              title: 'Collection',
              description: 'Build your personal library of inspiring poems. Organize and revisit your favorite works whenever inspiration strikes.',
              features: [
                'Bookmark favorite poems',
                'Grid view display',
                'Quick access',
                'Sync across devices',
              ],
            ),
            const SizedBox(height: 20),
            
            _buildFeatureCard(
              icon: Icons.palette_rounded,
              iconColor: const Color(0xFFFF5722),
              title: 'Beautiful Design',
              description: 'Experience poetry in a beautifully crafted interface inspired by vintage typewriters and classic literature.',
              features: [
                'Elegant gradients',
                'Smooth animations',
                'Thoughtful typography',
                'Artistic details',
              ],
            ),
            const SizedBox(height: 20),
            
            _buildFeatureCard(
              icon: Icons.security_rounded,
              iconColor: const Color(0xFF607D8B),
              title: 'Privacy & Security',
              description: 'Your creative work is yours. We respect your privacy and protect your data with industry-standard security measures.',
              features: [
                'Secure data storage',
                'Privacy-first approach',
                'No ads or tracking',
                'Local draft storage',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required List<String> features,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.paperLight.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconColor.withValues(alpha: 0.15),
                        iconColor.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.poemTitle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Features List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: AppTextStyles.bodyText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
