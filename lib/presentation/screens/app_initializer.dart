import 'package:flutter/material.dart';
import '../../data/local/storage_service.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

/// App initializer that manages the startup flow
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _showSplash = true;
  bool _showOnboarding = false;
  StorageService? _storageService;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize storage
    _storageService = await StorageService.init();

    // Show splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check if this is the first launch
    final isFirstLaunch = _storageService!.isFirstLaunch();

    setState(() {
      _showSplash = false;
      _showOnboarding = isFirstLaunch;
    });
  }

  void _onOnboardingComplete() async {
    // Mark first launch as complete
    await _storageService?.setFirstLaunchComplete();

    if (!mounted) return;

    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen();
    } else if (_showOnboarding) {
      return OnboardingScreen(
        onComplete: _onOnboardingComplete,
      );
    } else {
      return const HomeScreen();
    }
  }
}

