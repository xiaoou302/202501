import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../models/game_state.dart';
import '../utils/storage_service.dart';
import 'about_team_screen.dart';
import 'bug_report_screen.dart';
import 'game_security_screen.dart';
import 'version_info_screen.dart';
import 'about_game_screen.dart';
import 'acknowledgments_screen.dart';

class SettingsScreen extends StatelessWidget {
  final GameState gameState;

  const SettingsScreen({super.key, required this.gameState});

  Future<void> _resetProgress(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.voidCharcoal,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.largeRadius,
          side: const BorderSide(color: AppColors.rubedoRed, width: 3),
        ),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppColors.rubedoRed),
            SizedBox(width: AppSpacing.sm),
            Text(
              'Reset Progress',
              style: TextStyle(color: AppColors.rubedoRed),
            ),
          ],
        ),
        content: const Text(
          'Are you absolutely certain? This will permanently delete:\n\n• All attempt history\n• All unlocked revelations\n• All game progress\n\nThis action cannot be undone.',
          style: TextStyle(color: AppColors.alabasterWhite, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.neutralSteel),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rubedoRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await StorageService().clearAll();
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All progress has been reset'),
            backgroundColor: AppColors.rubedoRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: AppStrings.settingsTitle,
        onHomePressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.xl),
            _buildSectionTitle('Information'),
            _buildMenuCard(
              context: context,
              icon: Icons.info_outline,
              iconColor: AppColors.alchemicalGold,
              title: 'About the Game',
              subtitle: 'Learn about Cognifex',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutGameScreen(),
                ),
              ),
            ),
            _buildMenuCard(
              context: context,
              icon: Icons.update,
              iconColor: Colors.blue,
              title: 'Version Information',
              subtitle: 'v1.0.0 • Changelog',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VersionInfoScreen(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Team & Credits'),
            _buildMenuCard(
              context: context,
              icon: Icons.groups,
              iconColor: Colors.purple,
              title: 'Development Team',
              subtitle: 'Meet the creators',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutTeamScreen(),
                ),
              ),
            ),
            _buildMenuCard(
              context: context,
              icon: Icons.emoji_events,
              iconColor: Colors.orange,
              title: 'Special Thanks',
              subtitle: 'Acknowledgments',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AcknowledgmentsScreen(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Support & Security'),
            _buildMenuCard(
              context: context,
              icon: Icons.bug_report,
              iconColor: AppColors.rubedoRed,
              title: 'Bug Report',
              subtitle: 'Report issues or feedback',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BugReportScreen(),
                ),
              ),
            ),
            _buildMenuCard(
              context: context,
              icon: Icons.security,
              iconColor: Colors.green,
              title: 'Game Security',
              subtitle: 'Privacy & data handling',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GameSecurityScreen(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildDangerZone(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppColors.alchemicalGold.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.alchemicalGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.settings,
            size: 40,
            color: AppColors.alchemicalGold,
            shadows: [
              Shadow(
                color: AppColors.alchemicalGold.withOpacity(0.6),
                blurRadius: 15,
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Text(
              'Explore game information, credits, and support options.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.alabasterWhite,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: AppTextStyles.serifFont,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.alchemicalGold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [iconColor.withOpacity(0.1), Colors.black.withOpacity(0.3)],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mediumRadius,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: iconColor.withOpacity(0.5)),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.alabasterWhite,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.neutralSteel.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.neutralSteel.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.rubedoRed.withOpacity(0.2),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: AppColors.rubedoRed.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.rubedoRed,
                size: 24,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Danger Zone',
                style: TextStyle(
                  fontFamily: AppTextStyles.serifFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.rubedoRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'This action will permanently delete all your game progress, including attempt history and unlocked revelations.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.alabasterWhite,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _resetProgress(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rubedoRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                elevation: 8,
                shadowColor: AppColors.rubedoRed.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.mediumRadius,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.delete_forever, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Reset All Progress',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
