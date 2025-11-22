import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';

class TimerBar extends StatelessWidget {
  final int timeLeft;
  final int totalTime;
  final Color? color;

  const TimerBar({
    Key? key,
    required this.timeLeft,
    required this.totalTime,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (timeLeft / totalTime).clamp(0.0, 1.0);
    final isLowTime = percentage < 0.3;
    final screenWidth = MediaQuery.of(context).size.width;
    final barColor = color ?? AppColors.mint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: isLowTime ? AppColors.danger : barColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'TIME',
                  style: AppTextStyles.label.copyWith(
                    color: isLowTime ? AppColors.danger : barColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (isLowTime ? AppColors.danger : barColor).withOpacity(
                  0.2,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isLowTime ? AppColors.danger : barColor,
                  width: 1.5,
                ),
              ),
              child: Text(
                '${timeLeft}s',
                style: AppTextStyles.label.copyWith(
                  color: isLowTime ? AppColors.danger : barColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 10,
          width: screenWidth - 48,
          decoration: BoxDecoration(
            color: AppColors.slate.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Stack(
            children: [
              // Background glow effect
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.linear,
                  width: (screenWidth - 48) * percentage,
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: isLowTime
                        ? LinearGradient(
                            colors: [
                              AppColors.danger,
                              AppColors.danger.withOpacity(0.7),
                            ],
                          )
                        : LinearGradient(
                            colors: [barColor, barColor.withOpacity(0.7)],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
