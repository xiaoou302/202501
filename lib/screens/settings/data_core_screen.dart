import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/glass_card.dart';

/// Data Core Screen
/// Displays information about the game's data structure and mechanics
class DataCoreScreen extends StatelessWidget {
  const DataCoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Data Core'),
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
                      color: Colors.cyan.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.data_usage,
                      color: Colors.cyan,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CHROPLEXIGNOSIS DATA CORE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Game Units Section
            const Text(
              'GAME UNITS',
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
                  _buildDataItem(
                    title: 'Unit Types',
                    description: 'Standard, Locked, Changing, Polluted',
                    icon: Icons.category,
                    iconColor: Colors.amber,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildDataItem(
                    title: 'Unit Colors',
                    description: 'Red, Green, Blue, Yellow, Purple',
                    icon: Icons.palette,
                    iconColor: Colors.pinkAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildDataItem(
                    title: 'Unit Shapes',
                    description: 'Circle, Square, Triangle, Hexagon, Star',
                    icon: Icons.category,
                    iconColor: Colors.greenAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Game Mechanics Section
            const Text(
              'GAME MECHANICS',
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
                  _buildDataItem(
                    title: 'Basic Match',
                    description:
                        'Match 3+ units of the same color or shape in a line',
                    icon: Icons.view_comfy,
                    iconColor: Colors.blueAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildDataItem(
                    title: 'Plexi-Match',
                    description:
                        'Match 3+ units with identical color AND shape',
                    icon: Icons.auto_awesome,
                    iconColor: Colors.purpleAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildDataItem(
                    title: 'Transmute',
                    description: 'Special ability earned from Plexi-Matches',
                    icon: Icons.swap_horiz,
                    iconColor: AppColors.secondaryAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Level Objectives Section
            const Text(
              'LEVEL OBJECTIVES',
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
                  _buildDataItem(
                    title: 'Score',
                    description: 'Reach target score within move limit',
                    icon: Icons.score,
                    iconColor: Colors.orangeAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildDataItem(
                    title: 'Locked Units',
                    description: 'Remove specific number of locked units',
                    icon: Icons.lock,
                    iconColor: Colors.redAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildDataItem(
                    title: 'Changing Units',
                    description: 'Remove specific number of changing units',
                    icon: Icons.change_circle,
                    iconColor: Colors.tealAccent,
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildDataItem(
                    title: 'Purify Tiles',
                    description: 'Purify specific number of polluted tiles',
                    icon: Icons.cleaning_services,
                    iconColor: Colors.lightGreenAccent,
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

  // Helper method to build data items
  Widget _buildDataItem({
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
