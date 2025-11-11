import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../features/plaza/plaza_screen.dart';
import '../features/pets/pets_screen.dart';
import '../features/ai/ai_screen.dart';
import '../features/settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  final Function(bool)? onThemeToggle;

  const MainScreen({Key? key, this.onThemeToggle}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const PlazaScreen(),
      const PetsScreen(),
      const AIScreen(),
      SettingsScreen(onThemeToggle: widget.onThemeToggle),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: (isDark ? AppConstants.darkGray : AppConstants.panelWhite)
              .withOpacity(0.95),
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppConstants.darkGraphite.withOpacity(0.3)
                  : Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.grid_view, 'Plaza'),
                _buildNavItem(1, Icons.pets, 'My Pets'),
                _buildNavItem(2, Icons.smart_toy, 'AI Pal'),
                _buildNavItem(3, Icons.settings, 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    final color = isActive ? AppConstants.softCoral : AppConstants.mediumGray;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
