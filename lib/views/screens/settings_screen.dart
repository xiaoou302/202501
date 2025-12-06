import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../viewmodels/game_viewmodel.dart';
import 'settings/about_screen.dart';
import 'settings/privacy_screen.dart';
import 'settings/terms_screen.dart';
import 'settings/disclaimer_screen.dart';
import 'settings/feedback_screen.dart';
import 'settings/version_screen.dart';
import 'settings/tutorial_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<GameViewModel>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.inkGreen,
            AppColors.inkGreenLight,
            const Color(0xFF1A4D3E),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, viewModel),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Game Info Card
                  _buildCardSection(
                    title: 'GAME INFO',
                    items: [
                      _SettingsItem(
                        icon: Icons.info,
                        iconColor: AppColors.jadeBlue,
                        title: 'About Game',
                        onTap: () => _navigate(context, const AboutScreen()),
                      ),
                      _SettingsItem(
                        icon: Icons.school,
                        iconColor: AppColors.jadeGreen,
                        title: 'How to Play',
                        onTap: () => _navigate(context, const TutorialScreen()),
                      ),
                      _SettingsItem(
                        icon: Icons.new_releases,
                        iconColor: AppColors.antiqueGold,
                        title: 'Version Info',
                        onTap: () => _navigate(context, const VersionScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Legal Card
                  _buildCardSection(
                    title: 'LEGAL',
                    items: [
                      _SettingsItem(
                        icon: Icons.warning_amber_rounded,
                        iconColor: AppColors.vermillion,
                        title: 'Disclaimer',
                        onTap: () => _navigate(context, const DisclaimerScreen()),
                      ),
                      _SettingsItem(
                        icon: Icons.privacy_tip,
                        iconColor: Color(0xFF9C27B0),
                        title: 'Privacy Policy',
                        onTap: () => _navigate(context, const PrivacyScreen()),
                      ),
                      _SettingsItem(
                        icon: Icons.gavel,
                        iconColor: Color(0xFFD84315),
                        title: 'Terms of Service',
                        onTap: () => _navigate(context, const TermsScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Support Card
                  _buildCardSection(
                    title: 'SUPPORT',
                    items: [
                      _SettingsItem(
                        icon: Icons.bug_report,
                        iconColor: AppColors.vermillion,
                        title: 'Report a Bug',
                        onTap: () => _navigate(context, const FeedbackScreen()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.sandalwood.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.antiqueGold),
                  onPressed: () => viewModel.navigateToHome(),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  const Text(
                    'SETTINGS',
                    style: TextStyle(
                      color: AppColors.antiqueGold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 60,
                    height: 2,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.antiqueGold,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection({
    required String title,
    required List<_SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.antiqueGold.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.sandalwood.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.antiqueGold.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: List.generate(
              items.length,
              (index) => Column(
                children: [
                  items[index],
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      color: AppColors.antiqueGold.withValues(alpha: 0.1),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.antiqueGold.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
