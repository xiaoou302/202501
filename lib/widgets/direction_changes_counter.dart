import 'package:flutter/material.dart';
import '../models/direction_changer.dart';
import '../utils/constants.dart';

/// 方向修改机会计数器小部件
class DirectionChangesCounter extends StatelessWidget {
  /// 方向修改器
  final DirectionChanger directionChanger;

  /// 点击回调
  final VoidCallback? onTap;

  const DirectionChangesCounter({
    Key? key,
    required this.directionChanger,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final remainingChanges = directionChanger.remainingChanges;
    final bool hasChanges = remainingChanges > 0;

    return GestureDetector(
      onTap: hasChanges ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: hasChanges
              ? AppColors.accentCoral.withOpacity(0.9)
              : Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              remainingChanges > 0
                  ? '点击修改箭头方向 ($remainingChanges次)'
                  : '修改机会已用完',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
