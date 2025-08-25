import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/glass_card.dart';

/// Combat Manual Screen
/// Displays combat mechanics and strategies for the game
class CombatManualScreen extends StatelessWidget {
  const CombatManualScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Combat Manual'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'COMBAT MANUAL',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Strategies & Tactics',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Basic Strategies Section
            const Text(
              'BASIC STRATEGIES',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildManualItem(
                    title: 'Pattern Recognition',
                    description:
                        'Look for potential matches before making moves. Plan 2-3 moves ahead when possible.',
                    icon: Icons.grid_on,
                    iconColor: Colors.blueAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildManualItem(
                    title: 'Corner Strategy',
                    description:
                        'Focus on clearing units from corners and edges to create more flexibility in the center.',
                    icon: Icons.crop_free,
                    iconColor: Colors.greenAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildManualItem(
                    title: 'Chain Reactions',
                    description:
                        'Set up cascading matches that trigger automatically after your first move.',
                    icon: Icons.bolt,
                    iconColor: Colors.orangeAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Advanced Tactics Section
            const Text(
              'ADVANCED TACTICS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildManualItem(
                    title: 'Transmute Conservation',
                    description:
                        'Save transmute abilities for critical situations rather than using them immediately.',
                    icon: Icons.save_alt,
                    iconColor: AppColors.secondaryAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildManualItem(
                    title: 'Perfect Match Farming',
                    description:
                        'Prioritize creating perfect matches (same color and shape) to earn transmute abilities.',
                    icon: Icons.auto_awesome,
                    iconColor: Colors.purpleAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildManualItem(
                    title: 'Board Control',
                    description:
                        'Maintain a balanced distribution of colors and shapes across the board.',
                    icon: Icons.dashboard,
                    iconColor: Colors.tealAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Level-Specific Strategies Section
            const Text(
              'LEVEL-SPECIFIC STRATEGIES',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildManualItem(
                    title: 'Locked Units (Level 2)',
                    description:
                        'Focus on matching adjacent to locked units to free them, then include them in matches.',
                    icon: Icons.lock_open,
                    iconColor: Colors.redAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildManualItem(
                    title: 'Changing Units (Level 4)',
                    description:
                        'Create perfect matches with normal units to earn transmute abilities, then use them to remove changing units.',
                    icon: Icons.change_circle,
                    iconColor: Colors.lightBlueAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildManualItem(
                    title: 'Polluted Tiles (Level 5)',
                    description:
                        'Convert polluted tiles to changing units with transmute, then remove them with another transmute.',
                    icon: Icons.cleaning_services,
                    iconColor: Colors.lightGreenAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildManualItem(
                    title: 'Ultimate Challenge (Level 6)',
                    description:
                        'Balance transmute usage between removing changing units and purifying polluted tiles.',
                    icon: Icons.military_tech,
                    iconColor: Colors.amberAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Combat Tips Section
            const Text(
              'COMBAT TIPS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildManualItem(
                    title: 'Time Management',
                    description:
                        'Don\'t rush your moves. Take time to analyze the board, especially in timed levels.',
                    icon: Icons.timer,
                    iconColor: Colors.redAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildManualItem(
                    title: 'Resource Optimization',
                    description:
                        'Use transmute abilities strategically to maximize their impact.',
                    icon: Icons.trending_up,
                    iconColor: Colors.greenAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildManualItem(
                    title: 'Objective Focus',
                    description:
                        'Always prioritize the level objective over high scores.',
                    icon: Icons.flag,
                    iconColor: Colors.blueAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Helper method to build manual items
  Widget _buildManualItem({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.7),
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
