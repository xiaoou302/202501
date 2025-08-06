import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/app_colors.dart';

/// Custom bottom navigation bar with icons and smooth transitions
class CustomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomTabBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取底部安全区域高度
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 68 + bottomPadding, // 减小高度并考虑底部安全区域
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.midnightBlue.withOpacity(0.85),
            AppColors.midnightBlue.withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(0, Icons.bar_chart, '市场'),
              _buildTabItem(1, Icons.satellite_alt, '分析'),
              _buildTabItem(2, Icons.bolt, '讯息'),
              _buildTabItem(3, Icons.settings, '设置'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标容器
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isActive ? 12 : 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.goldenHighlight.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color:
                    isActive ? AppColors.goldenHighlight : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 4),
            // 标签文字
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color:
                    isActive ? AppColors.goldenHighlight : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
