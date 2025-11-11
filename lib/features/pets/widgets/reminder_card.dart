import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/reminder_model.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const ReminderCard({Key? key, required this.reminder}) : super(key: key);

  String _getDaysUntilDue() {
    final now = DateTime.now();
    final difference = reminder.dueDate.difference(now).inDays;

    if (difference < 0) return 'Overdue';
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    return 'In $difference days';
  }

  bool _isUrgent() {
    final now = DateTime.now();
    final difference = reminder.dueDate.difference(now).inDays;
    return difference <= 7;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUrgent = _isUrgent();

    return Container(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isUrgent ? AppConstants.softCoral : null,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due: ${_getDaysUntilDue()}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.notifications,
            color: isUrgent ? AppConstants.softCoral : AppConstants.mediumGray,
            size: 20,
          ),
        ],
      ),
    );
  }
}
