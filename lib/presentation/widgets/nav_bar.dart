import 'package:flutter/material.dart';
import 'package:soli/core/constants/app_constants.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';

/// 底部导航栏组件
class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: AppTheme.deepSpace,
        border: Border(
          top: BorderSide(
            color: ColorUtils.withOpacity(AppTheme.silverstone, 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.photo_library, AppConstants.navGallery),
          _buildNavItem(1, Icons.chat_bubble, AppConstants.navCommunity),
          _buildNavItem(2, Icons.diamond, AppConstants.navPlanner),
          _buildNavItem(3, Icons.person, AppConstants.navProfile),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.champagne : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.champagne : Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            if (isActive)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.champagne,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
