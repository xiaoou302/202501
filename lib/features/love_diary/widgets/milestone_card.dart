import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/app_strings.dart';
import '../models/milestone.dart';

class MilestoneCard extends StatelessWidget {
  final Milestone milestone;

  const MilestoneCard({super.key, required this.milestone});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${milestone.daysLeft} ${AppStrings.days} left',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              milestone.daysLeft.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.lightPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;

    switch (milestone.type) {
      case AppConstants.milestoneBirthday:
        iconData = Icons.cake;
        iconColor = Colors.pinkAccent;
        break;
      case AppConstants.milestoneAnniversary:
        iconData = Icons.favorite;
        iconColor = Colors.redAccent;
        break;
      case AppConstants.milestoneValentine:
        iconData = Icons.card_giftcard;
        iconColor = Colors.amberAccent;
        break;
      default:
        iconData = Icons.event;
        iconColor = Colors.blueAccent;
    }

    return Icon(iconData, color: iconColor, size: 24);
  }
}
