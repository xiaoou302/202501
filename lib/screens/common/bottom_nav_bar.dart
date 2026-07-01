import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../scan_screen.dart';
import '../journal_screen.dart';
import '../play_screen.dart';
import '../moments_screen.dart';
import '../community/rescue_share_screen.dart';
import '../../models/journal_entry.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  JournalEntry? _pendingJournalEntry;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onScanSaved(JournalEntry entry) {
    setState(() {
      _pendingJournalEntry = entry;
      _currentIndex = 1; // Switch to Journal tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      ScanScreen(onSaveComplete: _onScanSaved),
      JournalScreen(initialEntry: _pendingJournalEntry),
      const RescueShareScreen(), // Placeholder for center button
      const PlayScreen(),
      const MomentsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index != 2) {
                _onTap(index);
              }
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.volunteer_activism_outlined),
                activeIcon: Icon(Icons.volunteer_activism),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined),
                activeIcon: Icon(Icons.book),
                label: 'Journal',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: '',
              ), // Empty space for FAB
              BottomNavigationBarItem(
                icon: Icon(Icons.star_border),
                activeIcon: Icon(Icons.star),
                label: 'Play',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
          Positioned(
            top: -16,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: GestureDetector(
              onTap: () => _onTap(2),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.peachFuzz,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.peachFuzz.withOpacity(0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.camera, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
