import 'package:flutter/material.dart';

import 'core/themes/app_theme.dart';
import 'services/audio.dart';
import 'services/storage.dart';
import 'screens/onboarding/splash_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style
  AppTheme.setSystemUIOverlayStyle();

  // Set preferred orientations
  AppTheme.setPreferredOrientations();

  // Initialize services
  await _initServices();

  // Run application
  runApp(const MyApp());
}

// Initialize services
Future<void> _initServices() async {
  // Initialize storage service
  await StorageService.instance.checkVersionAndMigrate();

  // Initialize audio service
  await AudioService.instance.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChroPlexiGnosis',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
