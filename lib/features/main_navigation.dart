import 'package:flutter/material.dart';
import '../shared/widgets/nav_bar.dart';
import 'love_diary/screens/love_diary_screen.dart';
import 'luggage/screens/luggage_screen.dart';
import 'generator/screens/generator_screen.dart';
import 'profile/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with AutomaticKeepAliveClientMixin {
  late int _currentIndex;

  // Pre-load all screens and keep them in memory
  final List<Widget> _screens = [
    const LoveDiaryScreen(useNavBar: false),
    const LuggageScreen(useNavBar: false),
    const GeneratorScreen(useNavBar: false),
    const ProfileScreen(useNavBar: false),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppNavBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
