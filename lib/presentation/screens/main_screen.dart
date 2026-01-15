import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/bottom_nav_bar.dart';
import 'gallery_screen.dart';
import 'chat_screen.dart';
import 'journal_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 懒加载页面，只在需要时构建
  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const GalleryScreen();
      case 1:
        return const ChatScreen();
      case 2:
        return const JournalScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const GalleryScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.midnight,
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
