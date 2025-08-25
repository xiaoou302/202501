import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/glass_card.dart';

/// Player Rules Screen
/// Displays the rules and guidelines for players
class PlayerRulesScreen extends StatelessWidget {
  const PlayerRulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Player Rules'),
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
                      color: Colors.greenAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.rule,
                      color: Colors.greenAccent,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PLAYER RULES',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Guidelines & Code of Conduct',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // General Rules Section
            const Text(
              'GENERAL RULES',
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
                  _buildRuleItem(
                    title: 'Fair Play',
                    description:
                        'Play fairly and do not use any third-party tools or modifications to gain unfair advantages.',
                    icon: Icons.verified_user,
                    iconColor: Colors.blueAccent,
                    ruleNumber: '1.1',
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildRuleItem(
                    title: 'Account Sharing',
                    description:
                        'Do not share your account credentials with others. Each account should be used by a single player only.',
                    icon: Icons.person_off,
                    iconColor: Colors.redAccent,
                    ruleNumber: '1.2',
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildRuleItem(
                    title: 'Multiple Accounts',
                    description:
                        'Creating multiple accounts to gain unfair advantages is prohibited.',
                    icon: Icons.people,
                    iconColor: Colors.orangeAccent,
                    ruleNumber: '1.3',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // In-Game Behavior Section
            const Text(
              'IN-GAME BEHAVIOR',
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
                  _buildRuleItem(
                    title: 'Exploits',
                    description:
                        'Do not exploit bugs or glitches. Report any issues to the game administrators.',
                    icon: Icons.bug_report,
                    iconColor: Colors.purpleAccent,
                    ruleNumber: '2.1',
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildRuleItem(
                    title: 'Game Disruption',
                    description:
                        'Actions that disrupt the normal functioning of the game are prohibited.',
                    icon: Icons.block,
                    iconColor: Colors.redAccent,
                    ruleNumber: '2.2',
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildRuleItem(
                    title: 'Automation',
                    description:
                        'The use of bots, scripts, or macros to automate gameplay is strictly forbidden.',
                    icon: Icons.smart_toy,
                    iconColor: Colors.orangeAccent,
                    ruleNumber: '2.3',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Community Guidelines Section
            const Text(
              'COMMUNITY GUIDELINES',
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
                  _buildRuleItem(
                    title: 'Respectful Communication',
                    description:
                        'Maintain respectful communication with other players and game staff at all times.',
                    icon: Icons.chat,
                    iconColor: Colors.greenAccent,
                    ruleNumber: '3.1',
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildRuleItem(
                    title: 'Inappropriate Content',
                    description:
                        'Do not share or promote inappropriate, offensive, or harmful content.',
                    icon: Icons.no_adult_content,
                    iconColor: Colors.redAccent,
                    ruleNumber: '3.2',
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildRuleItem(
                    title: 'Privacy',
                    description:
                        'Respect the privacy of other players. Do not share personal information without consent.',
                    icon: Icons.privacy_tip,
                    iconColor: Colors.blueAccent,
                    ruleNumber: '3.3',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Enforcement Section
            const Text(
              'ENFORCEMENT',
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
                  _buildRuleItem(
                    title: 'Rule Violations',
                    description:
                        'Violations of these rules may result in warnings, temporary suspensions, or permanent bans depending on severity.',
                    icon: Icons.gavel,
                    iconColor: Colors.amberAccent,
                    ruleNumber: '4.1',
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildRuleItem(
                    title: 'Appeals',
                    description:
                        'Players may appeal enforcement actions through the designated channels.',
                    icon: Icons.restore,
                    iconColor: Colors.tealAccent,
                    ruleNumber: '4.2',
                  ),
                  const Divider(color: Colors.grey, height: 24, thickness: 0.5),
                  _buildRuleItem(
                    title: 'Rule Updates',
                    description:
                        'These rules may be updated periodically. Players are responsible for staying informed about current rules.',
                    icon: Icons.update,
                    iconColor: Colors.cyanAccent,
                    ruleNumber: '4.3',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Disclaimer
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DISCLAIMER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'These rules are subject to interpretation by game administrators. The administration reserves the right to take appropriate action in situations not specifically covered by these rules to maintain a fair and enjoyable gaming environment for all players.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: January 2023',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.withOpacity(0.5),
                    ),
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

  // Helper method to build rule items
  Widget _buildRuleItem({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required String ruleNumber,
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: iconColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        ruleNumber,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ],
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
