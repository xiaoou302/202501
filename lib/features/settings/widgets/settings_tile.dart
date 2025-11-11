import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppConstants.softCoral, size: AppConstants.iconM),
            const SizedBox(width: AppConstants.spacingM),
            Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
            trailing ??
                const Icon(Icons.chevron_right, color: AppConstants.mediumGray),
          ],
        ),
      ),
    );
  }
}
