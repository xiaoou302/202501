import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// 成就卡片组件
class AchievementCard extends StatelessWidget {
  final String id;
  final String name;
  final IconData icon;
  final bool isUnlocked;

  const AchievementCard({
    super.key,
    required this.id,
    required this.name,
    required this.icon,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isUnlocked
              ? [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ]
              : [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? AppColors.accentMintGreen.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: AppColors.accentMintGreen.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppColors.accentMintGreen.withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked
                    ? AppColors.accentMintGreen.withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: AppColors.accentMintGreen.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              isUnlocked ? icon : Icons.lock_outline_rounded,
              color: isUnlocked
                  ? AppColors.accentMintGreen
                  : AppColors.textMoonWhite.withOpacity(0.3),
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isUnlocked ? name : 'Locked',
            style: TextStyle(
              color: isUnlocked
                  ? AppColors.textMoonWhite
                  : AppColors.textMoonWhite.withOpacity(0.4),
              fontSize: 14,
              fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
