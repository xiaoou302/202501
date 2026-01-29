import 'package:flutter/material.dart';
import 'package:oravie/core/theme/app_theme.dart';
import 'package:oravie/presentation/screens/splash_screen.dart';

class StridaApp extends StatelessWidget {
  const StridaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strida',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
