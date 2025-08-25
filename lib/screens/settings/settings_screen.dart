import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../widgets/common/glass_card.dart';
import 'data_core_screen.dart';
import 'combat_manual_screen.dart';
import 'player_rules_screen.dart';
import 'privacy_protection_screen.dart';
import 'contact_gm_screen.dart';
import 'version_info_screen.dart';

/// Settings Screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // Navigate to Data Core screen
  void _navigateToDataCore() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DataCoreScreen()),
    );
  }

  // Navigate to Combat Manual screen
  void _navigateToCombatManual() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CombatManualScreen()),
    );
  }

  // Navigate to Player Rules screen
  void _navigateToPlayerRules() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlayerRulesScreen()),
    );
  }

  // Navigate to Privacy Protection screen
  void _navigateToPrivacyProtection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyProtectionScreen()),
    );
  }

  // Navigate to Contact GM screen
  void _navigateToContactGM() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactGMScreen()),
    );
  }

  // Navigate to Version Info screen
  void _navigateToVersionInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VersionInfoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryAccent,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Title
                    const Center(
                      child: Text('SETTINGS', style: AppStyles.titleLarge),
                    ),

                    const SizedBox(height: 32),

                    // Settings items
                    Expanded(
                      child: ListView(
                        children: [
                          // Game Information Card
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'GAME INFORMATION',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryAccent,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Data Core
                                _buildSettingsItem(
                                  icon: Icons.data_usage,
                                  iconColor: Colors.cyan,
                                  title: 'Data Core',
                                  onTap: _navigateToDataCore,
                                ),

                                const Divider(
                                  color: Colors.grey,
                                  height: 24,
                                  thickness: 0.5,
                                ),

                                // Combat Manual
                                _buildSettingsItem(
                                  icon: Icons.menu_book,
                                  iconColor: Colors.amber,
                                  title: 'Combat Manual',
                                  onTap: _navigateToCombatManual,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Player Information Card
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PLAYER INFORMATION',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryAccent,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Player Rules
                                _buildSettingsItem(
                                  icon: Icons.rule,
                                  iconColor: Colors.greenAccent,
                                  title: 'Player Rules',
                                  onTap: _navigateToPlayerRules,
                                ),

                                const Divider(
                                  color: Colors.grey,
                                  height: 24,
                                  thickness: 0.5,
                                ),

                                // Adventurer Information Protection
                                _buildSettingsItem(
                                  icon: Icons.security,
                                  iconColor: Colors.purpleAccent,
                                  title: 'Adventurer Information Protection',
                                  onTap: _navigateToPrivacyProtection,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Support Card
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SUPPORT',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryAccent,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Contact GM
                                _buildSettingsItem(
                                  icon: Icons.contact_support,
                                  iconColor: Colors.orangeAccent,
                                  title: 'Contact GM',
                                  onTap: _navigateToContactGM,
                                ),

                                const Divider(
                                  color: Colors.grey,
                                  height: 24,
                                  thickness: 0.5,
                                ),

                                // Version Info
                                _buildSettingsItem(
                                  icon: Icons.info,
                                  iconColor: Colors.blueAccent,
                                  title: 'Version Info',
                                  subtitle: 'v1.0.0',
                                  onTap: _navigateToVersionInfo,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Helper method to build settings items
  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
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
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}

// Data Core Screen
// Removed placeholder screen classes as we're using the actual implementations from separate files
