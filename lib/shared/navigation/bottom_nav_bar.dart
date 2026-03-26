import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for glass effect
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 100, // Matches prototype ~96px
        decoration: BoxDecoration(
          color: AppColors.deepTeal.withValues(
            alpha: 0.95,
          ), // Solid color since blur is removed
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              0,
              FontAwesomeIcons.layerGroup,
              'Dash',
              AppColors.floraNeon,
            ),
            _buildNavItem(
              1,
              FontAwesomeIcons.compass,
              'Gallery',
              AppColors.starlightWhite,
            ),
            _buildNavItem(
              2,
              FontAwesomeIcons.stethoscope,
              'Diag',
              AppColors.alienPurple,
            ),
            _buildNavItem(
              3,
              FontAwesomeIcons.flask,
              'Dose',
              AppColors.aquaCyan,
            ),
            _buildNavItem(
              4,
              FontAwesomeIcons.gear,
              'Settings',
              AppColors.starlightWhite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    Color activeColor,
  ) {
    final isSelected = navigationShell.currentIndex == index;
    final color = isSelected ? activeColor : AppColors.mossMuted;

    return InkWell(
      onTap: () => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
            shadows: isSelected
                ? [Shadow(color: activeColor.withOpacity(0.6), blurRadius: 10)]
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
