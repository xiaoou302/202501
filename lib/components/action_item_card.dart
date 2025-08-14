import 'package:flutter/material.dart';
import '../models/action_item.dart';
import '../theme/app_theme.dart';

/// Action item card component, displays task items and their completion status
class ActionItemCard extends StatelessWidget {
  final ActionItem item;
  final Function(bool) onToggleComplete;
  final bool showDueDate;

  const ActionItemCard({
    Key? key,
    required this.item,
    required this.onToggleComplete,
    this.showDueDate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onToggleComplete(!item.isCompleted),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Completion status icon
                _buildCompletionIcon(),
                const SizedBox(width: 12),
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          color: item.isCompleted
                              ? AppTheme.secondaryText
                              : AppTheme.primaryText,
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (item.description != null &&
                          item.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            item.description!,
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontSize: 12,
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      if (showDueDate && item.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Due: ${_formatDate(item.dueDate!)}',
                            style: TextStyle(
                              color: _isOverdue(item.dueDate!)
                                  ? AppTheme.errorRed
                                  : AppTheme.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build completion status icon
  Widget _buildCompletionIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: item.isCompleted ? AppTheme.successGreen : Colors.transparent,
        border: Border.all(
          color: item.isCompleted
              ? AppTheme.successGreen
              : AppTheme.secondaryText,
          width: 2,
        ),
      ),
      child: item.isCompleted
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }

  /// Format date
  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  /// Check if overdue
  bool _isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now()) && !item.isCompleted;
  }
}
