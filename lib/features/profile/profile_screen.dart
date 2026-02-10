import 'package:flutter/material.dart';
import 'package:zenithsprint/app/app_routes.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.symmetric(vertical: AppValues.padding_large),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.padding_large),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: AppValues.margin_large),
            _buildSettingsSection(
              context,
              items: [
                _buildSettingsItem(context, 'About Us', () {
                  Navigator.of(context).pushNamed(AppRoutes.about);
                }),
                _buildSettingsItem(context, 'User Agreement', () {
                  Navigator.of(context).pushNamed(AppRoutes.agreement);
                }),
                _buildSettingsItem(context, 'Privacy Policy', () {
                  Navigator.of(context).pushNamed(AppRoutes.privacy);
                }),
              ],
            ),
            const SizedBox(height: AppValues.margin_large),
            _buildSettingsSection(
              context,
              items: [
                _buildSettingsItem(context, 'Help', () {
                  Navigator.of(context).pushNamed(AppRoutes.help);
                }),
                _buildSettingsItem(context, 'Feedback and Suggestions', () {
                  Navigator.of(context).pushNamed(AppRoutes.feedback);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context,
      {required List<Widget> items}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_large),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(AppValues.radius),
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: AppColors.white, fontSize: 16),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.neutralLight,
      ),
      onTap: onTap,
    );
  }
}
