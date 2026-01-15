import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

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
          'User Guide',
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.menu_book,
                    color: Color(0xFF9C27B0),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Learn how to make the most of MeeMi',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppConstants.offwhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildGuideSection(
              icon: Icons.photo_library,
              iconColor: const Color(0xFF4CAF50),
              title: 'Gallery',
              steps: [
                'Browse artwork shared by other artists',
                'Tap on any artwork to view details',
                'Read artist reflections and insights',
                'Filter by category: Oil Painting, Sketch, Watercolor, Printmaking',
                'Tap the info icon for feature explanations',
              ],
            ),
            const SizedBox(height: 24),
            _buildGuideSection(
              icon: Icons.brush,
              iconColor: const Color(0xFF2196F3),
              title: 'Drawing Board',
              steps: [
                'Choose between Brush and Eraser modes',
                'Select stroke width (1-12 pixels)',
                'Pick from 12 different colors',
                'Draw on the white canvas with your finger',
                'Use Undo to remove the last stroke',
                'Save your artwork to device storage',
                'View saved drawings in the gallery',
                'Clear canvas to start fresh',
              ],
            ),
            const SizedBox(height: 24),
            _buildGuideSection(
              icon: Icons.chat_bubble_outline,
              iconColor: const Color(0xFFFF9800),
              title: 'AI Mentor',
              steps: [
                'Ask questions about painting techniques',
                'Tap hot topic cards for quick discussions',
                'Type your own questions in the input field',
                'Get personalized guidance on art concepts',
                'Long-press messages to delete or report',
                'Tap outside input to dismiss keyboard',
              ],
            ),
            const SizedBox(height: 24),
            _buildGuideSection(
              icon: Icons.settings,
              iconColor: const Color(0xFF9C27B0),
              title: 'Settings',
              steps: [
                'Access app information and legal documents',
                'View your favorite artworks',
                'Submit feedback or report issues',
                'Check app version and updates',
                'Read this user guide anytime',
              ],
            ),
            const SizedBox(height: 32),
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
                    Icons.lightbulb_outline,
                    color: AppConstants.gold,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pro Tips',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.offwhite,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem('💡', 'Explore different art styles in the gallery for inspiration'),
                  _buildTipItem('🎨', 'Practice regularly on the drawing board to improve your skills'),
                  _buildTipItem('🤖', 'Ask the AI mentor specific questions for better guidance'),
                  _buildTipItem('💾', 'Save your favorite artworks and drawings for future reference'),
                ],
              ),
            ),
            const SizedBox(height: 32),
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
                    Icons.help_outline,
                    color: AppConstants.gold,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Need More Help?',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.offwhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Visit the Feedback section to ask questions or report issues',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.metalgray.withValues(alpha: 0.8),
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

  Widget _buildGuideSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> steps,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.offwhite,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppConstants.offwhite,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppConstants.offwhite,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
