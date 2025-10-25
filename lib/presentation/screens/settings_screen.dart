import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/local/storage_service.dart';
import '../theme/app_colors.dart';
import 'settings/credits_screen.dart';
import 'settings/terms_screen.dart';
import 'settings/privacy_screen.dart';
import 'settings/feedback_screen.dart';
import 'settings/health_screen.dart';

/// Settings screen - App configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserRepository _userRepository;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRepository();
  }

  Future<void> _loadRepository() async {
    final storage = await StorageService.init();
    _userRepository = UserRepository(storage);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showResetDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Progress?'),
        content: const Text(
          'This will delete all your saved progress, statistics, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerRed,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _userRepository.resetProgress();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All progress has been reset'),
            backgroundColor: AppColors.dangerRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.parchmentGradient,
          ),
          image: DecorationImage(
            image: NetworkImage(
              'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAFElEQVQI12P4//8/AwMDAwMDAwMAFwMBAweciQsAAAAASUVORK5CYII=',
            ),
            repeat: ImageRepeat.repeat,
            opacity: 0.03,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.parchmentDark.withOpacity(0.3),
                      AppColors.parchmentMedium.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderMedium, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowBrown.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inkBlack.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                        iconSize: 20,
                        onPressed: () => Navigator.pop(context),
                        color: AppColors.inkBrown,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings & Info',
                            style: TextStyle(
                              color: AppColors.inkBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Support & Information',
                            style: TextStyle(
                              color: AppColors.inkFaded,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.settings_rounded,
                      color: AppColors.magicGold,
                      size: 28,
                    ),
                  ],
                ),
              ),

              // Settings list
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // About & Legal Card
                            _buildSectionCard(
                              title: 'About & Legal',
                              icon: Icons.info_rounded,
                              color: AppColors.magicBlue,
                              items: [
                                _buildListItem(
                                  icon: Icons.people_rounded,
                                  title: 'Credits',
                                  subtitle: 'Meet the development team',
                                  color: AppColors.magicBlue,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreditsScreen(),
                                    ),
                                  ),
                                ),
                                _buildListItem(
                                  icon: Icons.description_rounded,
                                  title: 'Terms of Service',
                                  subtitle: 'User agreement & policies',
                                  color: AppColors.magicPurple,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TermsScreen(),
                                    ),
                                  ),
                                ),
                                _buildListItem(
                                  icon: Icons.shield_rounded,
                                  title: 'Privacy Policy',
                                  subtitle: 'Data protection & security',
                                  color: AppColors.arcaneGreen,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PrivacyScreen(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Support & Wellness Card
                            _buildSectionCard(
                              title: 'Support & Wellness',
                              icon: Icons.favorite_rounded,
                              color: AppColors.dangerRed,
                              items: [
                                _buildListItem(
                                  icon: Icons.bug_report_rounded,
                                  title: 'Send Feedback',
                                  subtitle: 'Report bugs or suggestions',
                                  color: AppColors.glowAmber,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FeedbackScreen(),
                                    ),
                                  ),
                                ),
                                _buildListItem(
                                  icon: Icons.health_and_safety_rounded,
                                  title: 'Health Reminders',
                                  subtitle: 'Gaming wellness tips',
                                  color: AppColors.dangerRed,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HealthScreen(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Reset Progress Button
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.dangerRed,
                                    AppColors.dangerRed.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.dangerRed.withOpacity(0.5),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.dangerRed.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: _showResetDialog,
                                icon: const Icon(
                                  Icons.restart_alt_rounded,
                                  size: 24,
                                ),
                                label: const Text(
                                  'Reset All Progress',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Version info
                            Text(
                              'Zenion v1.0.0',
                              style: TextStyle(
                                color: AppColors.inkFaded.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentLight,
            AppColors.parchmentMedium.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBrown.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.3), width: 1),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.inkBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.3), width: 1),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.inkBlack,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(color: AppColors.inkFaded, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color.withOpacity(0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
