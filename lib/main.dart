import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/splash_screen.dart';
import 'screens/brew_inspiration_screen.dart';
import 'screens/bean_archive_screen.dart';
import 'screens/flavor_compass_screen.dart';
import 'screens/laboratory_config_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SelahApp());
}

class SelahApp extends StatelessWidget {
  const SelahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const BrewInspirationScreen(),
    const BeanArchiveScreen(),
    const FlavorCompassScreen(),
    const LaboratoryConfigScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _screens),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: IndustrialBottomNavBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
