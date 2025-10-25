import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Timer bar widget with progress indicator
class TimerBar extends StatelessWidget {
  final int timeLeft;
  final int totalTime;

  const TimerBar({super.key, required this.timeLeft, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    final percentage = totalTime > 0 ? timeLeft / totalTime : 0.0;
    final isLowTime = percentage < 0.2;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          // 沙漏图标
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.magicGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.magicGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.hourglass_bottom_rounded,
              color: isLowTime ? AppColors.dangerRed : AppColors.magicGold,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // 时间进度条
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Remaining',
                  style: TextStyle(
                    color: AppColors.inkFaded,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.parchmentDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: MediaQuery.of(context).size.width * percentage,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: isLowTime
                              ? [AppColors.dangerRed, const Color(0xFFFF5B5B)]
                              : AppColors.goldGradient,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isLowTime
                                        ? AppColors.dangerRed
                                        : AppColors.magicGold)
                                    .withOpacity(0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // 时间数字
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isLowTime
                  ? AppColors.dangerRed.withOpacity(0.15)
                  : AppColors.magicGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isLowTime
                    ? AppColors.dangerRed.withOpacity(0.3)
                    : AppColors.magicGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '${timeLeft}s',
              style: TextStyle(
                color: isLowTime ? AppColors.dangerRed : AppColors.magicGold,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
