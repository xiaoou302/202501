import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/themes/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/screens/welcome_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/analysis_report_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppConstants.graphite,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MireyaApp());
}

class MireyaApp extends StatelessWidget {
  const MireyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const WelcomeScreen(),
      routes: {
        AppConstants.settingsRoute: (context) => const SettingsScreen(),
        AppConstants.analysisReportRoute: (context) => const AnalysisReportScreen(),
      },
      // Note: Pose and Insight detail screens use Navigator.push with arguments
      // so they don't need named routes
    );
  }
}
