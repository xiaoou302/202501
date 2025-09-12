import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/level_selection_screen.dart';
import 'screens/game_screen.dart';
import 'screens/game_over_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/help_screen.dart';
import 'utils/constants.dart';

class BlokkoApp extends StatelessWidget {
  const BlokkoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Force portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Blokko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgDeepSpaceGray,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textMoonWhite,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: AppColors.textMoonWhite,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: AppColors.textMoonWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: AppColors.textMoonWhite, fontSize: 16),
          bodyMedium: TextStyle(color: AppColors.textMoonWhite, fontSize: 14),
          bodySmall: TextStyle(
            color: AppColors.textMoonWhite,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentMintGreen,
            foregroundColor: AppColors.bgDeepSpaceGray,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/': (context) => const HomeScreen(),
        '/level_selection': (context) => const LevelSelectionScreen(),
        '/game': (context) => const GameScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/help': (context) => const HelpScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/game_over') {
          final args = settings.arguments as GameOverArguments;
          return MaterialPageRoute(
            builder: (context) => GameOverScreen(
              time: args.time,
              levelId: args.levelId,
            ),
          );
        }
        return null;
      },
    );
  }
}

class GameOverArguments {
  final Duration time;
  final String levelId;

  GameOverArguments({
    required this.time,
    required this.levelId,
  });
}
