import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/power_up.dart';
import '../../core/utils/haptic_feedback.dart';

/// 能力道具组件
class PowerUpWidget extends StatelessWidget {
  /// 能力道具数据
  final PowerUp powerUp;

  /// 点击回调
  final VoidCallback onTap;

  const PowerUpWidget({super.key, required this.powerUp, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final HapticFeedbackManager hapticFeedback = HapticFeedbackManager();

    return GestureDetector(
      onTap: () {
        if (powerUp.isAvailable) {
          hapticFeedback.mediumImpact();
          onTap();
        }
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: powerUp.isAvailable
                  ? AppColors.cardBackground
                  : Colors.grey.shade800,
              border: powerUp.isAvailable
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              boxShadow: powerUp.isAvailable
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: _getIconForPowerUp(
                powerUp.icon,
                powerUp.isAvailable ? AppColors.primary : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            powerUp.name,
            style: TextStyle(
              color: powerUp.isAvailable ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIconForPowerUp(String iconName, Color color) {
    IconData iconData;

    switch (iconName) {
      case 'stopwatch':
        iconData = Icons.timer;
        break;
      case 'shuffle':
        iconData = Icons.shuffle;
        break;
      case 'eye':
        iconData = Icons.visibility;
        break;
      default:
        iconData = Icons.help_outline;
    }

    return Icon(iconData, size: 24, color: color);
  }
}
