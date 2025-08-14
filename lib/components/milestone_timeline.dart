import 'package:flutter/material.dart';
import '../models/milestone.dart';
import '../theme/app_theme.dart';

/// Milestone timeline component, displays mission progress and stages
class MilestoneTimeline extends StatelessWidget {
  final List<Milestone> milestones;
  final Function(Milestone)? onTap;

  const MilestoneTimeline({Key? key, required this.milestones, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Handle empty milestones list
    if (milestones.isEmpty) {
      return const Center(
        child: Text(
          'No milestones available',
          style: TextStyle(color: AppTheme.secondaryText),
        ),
      );
    }

    return Column(
      children: List.generate(milestones.length, (index) {
        final milestone = milestones[index];
        final isLast = index == milestones.length - 1;

        return Column(
          children: [
            _buildMilestoneItem(milestone, context),
            if (!isLast) _buildConnector(milestone.status),
          ],
        );
      }),
    );
  }

  /// Build milestone item
  Widget _buildMilestoneItem(Milestone milestone, BuildContext context) {
    Color circleColor;
    Color borderColor;
    IconData icon;
    Color iconColor;

    switch (milestone.status) {
      case MilestoneStatus.completed:
        circleColor = AppTheme.successGreen;
        borderColor = AppTheme.successGreen;
        icon = Icons.check;
        iconColor = Colors.white;
        break;
      case MilestoneStatus.inProgress:
        circleColor = Colors.transparent;
        borderColor = AppTheme.brandBlue;
        icon = Icons.circle;
        iconColor = AppTheme.brandBlue;
        break;
      case MilestoneStatus.notStarted:
        circleColor = Colors.transparent;
        borderColor = AppTheme.secondaryText;
        icon = Icons.circle_outlined;
        iconColor = AppTheme.secondaryText;
        break;
    }

    return GestureDetector(
      onTap: onTap != null ? () => onTap!(milestone) : null,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: circleColor,
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: milestone.status == MilestoneStatus.completed
                  ? Icon(icon, color: iconColor, size: 16)
                  : Text(
                      '${milestones.indexOf(milestone) + 1}',
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              milestone.title,
              style: TextStyle(
                color: milestone.status == MilestoneStatus.completed
                    ? AppTheme.secondaryText
                    : AppTheme.primaryText,
                fontWeight: milestone.status == MilestoneStatus.inProgress
                    ? FontWeight.bold
                    : FontWeight.normal,
                decoration: milestone.status == MilestoneStatus.completed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build connector
  Widget _buildConnector(MilestoneStatus status) {
    Color connectorColor;

    switch (status) {
      case MilestoneStatus.completed:
        connectorColor = AppTheme.successGreen;
        break;
      case MilestoneStatus.inProgress:
        connectorColor = AppTheme.brandBlue;
        break;
      case MilestoneStatus.notStarted:
        connectorColor = AppTheme.secondaryText.withOpacity(0.5);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: 2,
      height: 24,
      color: connectorColor,
    );
  }
}
