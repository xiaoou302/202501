import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Screen that explains how to play the game
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

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
              // Header with back button on left side
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      color: AppColors.textGraphite,
                      onPressed: () => Navigator.pop(context),
                    ),

                    // Centered title
                    const Text(
                      'How to Play',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGraphite,
                      ),
                    ),

                    // Empty space on right for balance
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Game instructions
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Introduction section
                    _buildSectionTitle('Game Introduction'),
                    _buildTextSection(
                      'Glyphion is a puzzle game where your goal is to clear all arrows from the board by tapping them in the correct sequence. The game challenges your strategic thinking and planning skills.',
                    ),

                    const SizedBox(height: 16),

                    // Game visualization
                    _buildGameVisualization(),

                    const SizedBox(height: 24),

                    // Basic rules section
                    _buildSectionTitle('Basic Rules'),

                    _buildInstructionCard(
                      icon: Icons.signpost,
                      iconColor: AppColors.arrowBlue,
                      title: 'Observe Paths',
                      description:
                          'Each arrow points in a direction. Its "flight path" is the entire row or column it\'s pointing to.',
                    ),

                    _buildInstructionCard(
                      icon: Icons.touch_app,
                      iconColor: AppColors.arrowTerracotta,
                      title: 'Find Clear Paths',
                      description:
                          'An arrow can only be tapped when its flight path is completely clear of obstacles and other arrows.',
                    ),

                    _buildInstructionCard(
                      icon: Icons.flight_takeoff,
                      iconColor: AppColors.arrowGreen,
                      title: 'Clear the Board',
                      description:
                          'Your goal is to tap all arrows in the correct sequence to clear the entire board. Each level has at least one solution.',
                    ),

                    const SizedBox(height: 24),

                    // Detailed gameplay section
                    _buildSectionTitle('Detailed Gameplay'),

                    _buildNumberedStep(
                      number: 1,
                      title: 'Analyze the Board',
                      description:
                          'Before making your first move, analyze the entire board. Look for arrows that have clear paths and can be tapped immediately.',
                      color: AppColors.arrowBlue,
                    ),

                    _buildNumberedStep(
                      number: 2,
                      title: 'Identify Blocking Arrows',
                      description:
                          'Some arrows block others. You\'ll need to remove blocking arrows first before you can tap the arrows they\'re blocking.',
                      color: AppColors.arrowTerracotta,
                    ),

                    _buildNumberedStep(
                      number: 3,
                      title: 'Plan Your Sequence',
                      description:
                          'The order in which you tap arrows is crucial. Planning several moves ahead will help you avoid getting stuck.',
                      color: AppColors.arrowGreen,
                    ),

                    _buildNumberedStep(
                      number: 4,
                      title: 'Complete the Level',
                      description:
                          'Once all arrows are cleared, you\'ve completed the level! The fewer moves you make, the better your score.',
                      color: AppColors.arrowPink,
                    ),

                    const SizedBox(height: 24),

                    // Arrow types section
                    _buildSectionTitle('Arrow Types'),

                    _buildArrowTypeCard(
                      color: AppColors.arrowBlue,
                      title: 'Blue Arrows',
                      description:
                          'Standard arrows that follow the basic rules.',
                    ),

                    _buildArrowTypeCard(
                      color: AppColors.arrowTerracotta,
                      title: 'Orange Arrows',
                      description:
                          'Direction changers that rotate the direction of your next move.',
                    ),

                    _buildArrowTypeCard(
                      color: AppColors.arrowGreen,
                      title: 'Green Arrows',
                      description:
                          'Teleporters that move you to another part of the board.',
                    ),

                    _buildArrowTypeCard(
                      color: AppColors.arrowPink,
                      title: 'Pink Arrows',
                      description:
                          'Special arrows with unique properties that vary by level.',
                    ),

                    const SizedBox(height: 24),

                    // Strategy tips section
                    _buildSectionTitle('Strategy Tips'),

                    _buildStrategyTip(
                      icon: Icons.lightbulb_outline,
                      title: 'Look for Starting Points',
                      description:
                          'Arrows at the edges of the board often make good starting points as they typically have fewer obstacles.',
                    ),

                    _buildStrategyTip(
                      icon: Icons.psychology,
                      title: 'Think Several Moves Ahead',
                      description:
                          'Like chess, planning your sequence several moves ahead is crucial for success.',
                    ),

                    _buildStrategyTip(
                      icon: Icons.replay,
                      title: 'Don\'t Be Afraid to Restart',
                      description:
                          'If you find yourself stuck, it\'s often better to restart the level with your new understanding than to continue a failed approach.',
                    ),

                    _buildStrategyTip(
                      icon: Icons.auto_awesome,
                      title: 'Perfect Solutions',
                      description:
                          'Each level has an optimal solution with the minimum number of moves. Try to find it for extra achievements!',
                    ),

                    const SizedBox(height: 24),

                    // Advanced mechanics section
                    _buildSectionTitle('Advanced Mechanics'),
                    _buildTextSection(
                      'As you progress through the game, you\'ll encounter more complex mechanics:',
                    ),

                    _buildAdvancedMechanicCard(
                      icon: Icons.change_circle,
                      title: 'Direction Changers',
                      description:
                          'These special tiles change the direction of your next move, adding a layer of complexity to your planning.',
                    ),

                    _buildAdvancedMechanicCard(
                      icon: Icons.block,
                      title: 'Obstacles',
                      description:
                          'Immovable blocks that obstruct arrow paths. You\'ll need to work around them.',
                    ),

                    _buildAdvancedMechanicCard(
                      icon: Icons.swap_horiz,
                      title: 'Teleporters',
                      description:
                          'Transport arrows from one location to another, creating interesting puzzle scenarios.',
                    ),

                    _buildAdvancedMechanicCard(
                      icon: Icons.timer,
                      title: 'Timed Challenges',
                      description:
                          'In some levels, you\'ll need to complete the puzzle within a time limit for bonus rewards.',
                    ),

                    const SizedBox(height: 32),

                    // Start playing button
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentCoral,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Start Playing',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textGraphite,
        ),
      ),
    );
  }

  Widget _buildTextSection(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.5,
        color: AppColors.textGraphite,
      ),
    );
  }

  Widget _buildInstructionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textGraphite,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF8A8A8E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedStep({
    required int number,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textGraphite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF8A8A8E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowTypeCard({
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.arrow_forward, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGraphite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyTip({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentCoral.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentCoral, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textGraphite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF8A8A8E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedMechanicCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.arrowBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.arrowBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textGraphite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF8A8A8E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameVisualization() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example Board',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textGraphite,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: Center(child: _buildGameGrid())),
        ],
      ),
    );
  }

  Widget _buildGameGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        // Define arrow directions and colors for the example
        IconData? icon;
        Color color;

        switch (index) {
          case 0:
            icon = Icons.arrow_downward;
            color = AppColors.arrowBlue;
            break;
          case 1:
            icon = null; // Empty cell
            color = Colors.transparent;
            break;
          case 2:
            icon = Icons.arrow_forward;
            color = AppColors.arrowTerracotta;
            break;
          case 3:
            icon = null; // Empty cell
            color = Colors.transparent;
            break;
          case 4:
            icon = Icons.arrow_back;
            color = AppColors.arrowGreen;
            break;
          case 5:
            icon = null; // Empty cell
            color = Colors.transparent;
            break;
          case 6:
            icon = Icons.arrow_upward;
            color = AppColors.arrowPink;
            break;
          case 7:
            icon = null; // Empty cell
            color = Colors.transparent;
            break;
          case 8:
            // Obstacle
            icon = Icons.block;
            color = Colors.grey;
            break;
          default:
            icon = null;
            color = Colors.transparent;
        }

        return Container(
          decoration: BoxDecoration(
            color: icon == null
                ? Colors.grey.withOpacity(0.1)
                : color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: icon == null ? Colors.transparent : color.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: icon != null
              ? Center(
                  child: Icon(
                    icon,
                    color: icon == Icons.block ? Colors.grey : color,
                    size: 24,
                  ),
                )
              : null,
        );
      },
    );
  }
}
