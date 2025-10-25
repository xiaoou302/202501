import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/screens/app_initializer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const ZenionApp());
}

/// Main application widget
class ZenionApp extends StatelessWidget {
  const ZenionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenion - The Fading Codex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppInitializer(),
    );
  }
}
