import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'scan_screen.dart';
import 'tunnel_screen.dart';
import 'library_screen.dart';
import 'showcase_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Shared State for Custom Airfoil
  List<Offset> _sharedUpperSurface = [];
  List<Offset> _sharedLowerSurface = [];
  double _sharedCamber = 4.0;

  // Keys to force rebuilds
  Key _tunnelKey = UniqueKey();
  Key _libraryKey = UniqueKey();

  List<Widget> get _pages {
    return [
      ScanScreen(
        onTestRequested: (upper, lower, camber) {
          setState(() {
            _sharedUpperSurface = upper;
            _sharedLowerSurface = lower;
            _sharedCamber = camber;
            _currentIndex = 1; // Switch to Tunnel tab
            _tunnelKey =
                UniqueKey(); // Force TunnelScreen to rebuild with new initialCamber
          });
        },
      ),
      TunnelScreen(
        key: _tunnelKey,
        customUpperSurface: _sharedUpperSurface,
        customLowerSurface: _sharedLowerSurface,
        initialCamber: _sharedCamber,
      ),
      LibraryScreen(key: _libraryKey),
      const ShowcaseScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          border: const Border(top: BorderSide(color: Colors.white, width: 1)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.aeroNavy.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                if (index == 2) {
                  // Refresh LibraryScreen when tapped to show latest saved profiles
                  _libraryKey = UniqueKey();
                }
              });
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppTheme.aeroNavy,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem(Icons.camera_alt_outlined, 0),
              _buildNavItem(Icons.air, 1),
              _buildNavItem(Icons.folder_open, 2),
              _buildNavItem(Icons.flight_takeoff, 3),
              _buildNavItem(Icons.settings_outlined, 4),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(icon, size: isSelected ? 28 : 24),
          if (isSelected)
            Positioned(
              top: -15,
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.aeroNavy,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.aeroNavy.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      label: '',
    );
  }
}
