import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// 排行榜条目组件
class LeaderboardItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;
  final Function(int)? onDelete;

  const LeaderboardItem({
    super.key,
    required this.entry,
    this.isCurrentUser = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 根据排名确定奖牌颜色
    Color medalColor;
    IconData medalIcon;

    switch (entry.rank) {
      case 1:
        medalColor = AppColors.gold;
        medalIcon = Icons.emoji_events;
        break;
      case 2:
        medalColor = AppColors.silver;
        medalIcon = Icons.emoji_events;
        break;
      case 3:
        medalColor = AppColors.bronze;
        medalIcon = Icons.emoji_events;
        break;
      default:
        medalColor = AppColors.textMoonWhite;
        medalIcon = Icons.leaderboard;
    }

    // 日期和时间
    final date = DateTime.fromMillisecondsSinceEpoch(entry.dateTimeMillis);
    final formattedDate = formatDate(date);
    final formattedTime = formatTime(date);

    // 用时
    final duration = Duration(seconds: entry.timeSeconds);
    final formattedDuration = formatDuration(duration);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCurrentUser
              ? [
                  AppColors.accentMintGreen,
                  AppColors.accentMintGreen.withOpacity(0.8),
                ]
              : [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isCurrentUser
                ? AppColors.accentMintGreen.withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isCurrentUser
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 排名
          Container(
            width: 45,
            alignment: Alignment.center,
            child: entry.rank <= 3
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrentUser
                              ? AppColors.bgDeepSpaceGray.withOpacity(0.2)
                              : medalColor.withOpacity(0.2),
                          border: Border.all(
                            color: isCurrentUser
                                ? AppColors.bgDeepSpaceGray.withOpacity(0.5)
                                : medalColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      Icon(
                        medalIcon,
                        color: isCurrentUser
                            ? AppColors.bgDeepSpaceGray
                            : medalColor,
                        size: 20,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrentUser
                                ? AppColors.bgDeepSpaceGray
                                : medalColor,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.rank}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrentUser
                          ? AppColors.bgDeepSpaceGray.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.rank}',
                        style: TextStyle(
                          color: isCurrentUser
                              ? AppColors.bgDeepSpaceGray
                              : AppColors.textMoonWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
          ),

          // 日期和时间
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: isCurrentUser
                          ? AppColors.bgDeepSpaceGray
                          : AppColors.textMoonWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: isCurrentUser
                          ? AppColors.bgDeepSpaceGray.withOpacity(0.8)
                          : AppColors.textMoonWhite.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 用时
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppColors.bgDeepSpaceGray.withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrentUser
                    ? AppColors.bgDeepSpaceGray.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 14,
                  color: isCurrentUser
                      ? AppColors.bgDeepSpaceGray
                      : AppColors.textMoonWhite,
                ),
                const SizedBox(width: 4),
                Text(
                  formattedDuration,
                  style: TextStyle(
                    color: isCurrentUser
                        ? AppColors.bgDeepSpaceGray
                        : AppColors.textMoonWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Delete button
          if (onDelete != null)
            GestureDetector(
              onTap: () => onDelete!(entry.dateTimeMillis),
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: isCurrentUser
                        ? AppColors.bgDeepSpaceGray
                        : Colors.red.shade300,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
