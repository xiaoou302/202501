import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../routes.dart';
import '../utils/app_strings.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTabTapped;

  const AppNavBar({super.key, required this.currentIndex, this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    // Get the bottom padding to account for safe area (like iPhone notch)
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height:
          60 + bottomPadding, // Adjust height based on device's bottom padding
      decoration: BoxDecoration(
        color: AppTheme.darkBlue.withOpacity(0.9),
        border: const Border(
          top: BorderSide(color: AppTheme.deepPurple, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.lightPurple,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped ?? (index) => _onItemTapped(context, index),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 24,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: AppStrings.loveDiary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.luggage),
            label: AppStrings.luggage,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high),
            label: AppStrings.generator,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    String route;
    switch (index) {
      case 0:
        route = AppRoutes.loveDiary;
        break;
      case 1:
        route = AppRoutes.luggage;
        break;
      case 2:
        route = AppRoutes.generator;
        break;
      case 3:
        route = AppRoutes.profile;
        break;
      default:
        route = AppRoutes.loveDiary;
    }

    Navigator.pushReplacementNamed(context, route);
  }
}
