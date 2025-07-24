import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'journal_screen.dart';
import 'share_screen.dart';
import 'breathe_screen.dart';
import 'settings_screen.dart';
import '../widgets/nav_bar.dart';
import '../theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isOnline = true;

  final List<Widget> _screens = [
    JournalScreen(),
    ShareScreen(),
    BreatheScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    // Check internet connectivity
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      });
    } on SocketException catch (_) {
      setState(() {
        _isOnline = false;
      });
      _showConnectivityWarning();
    }
  }

  void _showConnectivityWarning() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 8),
            Text('No internet connection'),
          ],
        ),
        backgroundColor: AppTheme.accentYellow,
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 70, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'RETRY',
          textColor: Colors.white,
          onPressed: _checkConnectivity,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeTab(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      _animationController.reset();
      _animationController.forward();

      // Check connectivity when switching to Share tab
      if (index == 1) {
        _checkConnectivity();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Main content - Expanded to take all available space
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _screens[_currentIndex],
              ),
            ),

            // Bottom navigation - Fixed at the bottom
            NavBar(currentIndex: _currentIndex, onTap: _changeTab),
          ],
        ),
      ),
    );
  }
}
