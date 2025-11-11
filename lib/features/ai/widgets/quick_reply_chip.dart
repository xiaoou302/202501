import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class QuickReplyChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const QuickReplyChip({Key? key, required this.text, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(text, style: theme.textTheme.bodySmall),
      ),
    );
  }
}
