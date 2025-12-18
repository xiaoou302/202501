import 'package:flutter/material.dart';
import 'screens/discovery_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/workspace_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'styles/app_colors.dart';

class ZinaApp extends StatefulWidget {
  const ZinaApp({super.key});

  @override
  State<ZinaApp> createState() => _ZinaAppState();
}

class _ZinaAppState extends State<ZinaApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DiscoveryScreen(),
    AIChatScreen(),
    WorkspaceScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
