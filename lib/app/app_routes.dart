import 'package:flutter/material.dart';
import 'package:zenithsprint/features/splash/splash_screen.dart';
import 'package:zenithsprint/features/onboarding/onboarding_screen.dart';
import 'package:zenithsprint/features/goal_selection/goal_selection_screen.dart';
import 'package:zenithsprint/features/baseline_test/baseline_test_screen.dart';
import 'package:zenithsprint/features/initial_report/initial_report_screen.dart';
import 'package:zenithsprint/features/home/home_screen.dart';
import 'package:zenithsprint/features/training/sprint_screen.dart';
import 'package:zenithsprint/features/training/sprint_results_screen.dart';
import 'package:zenithsprint/features/profile/settings/about_screen.dart';
import 'package:zenithsprint/features/profile/settings/agreement_screen.dart';
import 'package:zenithsprint/features/profile/settings/privacy_screen.dart';
import 'package:zenithsprint/features/profile/settings/feedback_screen.dart';
import 'package:zenithsprint/features/profile/settings/help_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String goalSelection = '/goal-selection';
  static const String baselineTest = '/baseline-test';
  static const String initialReport = '/initial-report';
  static const String home = '/home';
  static const String sprint = '/sprint';
  static const String sprintResults = '/sprint-results';
  static const String about = '/settings/about';
  static const String agreement = '/settings/agreement';
  static const String privacy = '/settings/privacy';
  static const String feedback = '/settings/feedback';
  static const String help = '/settings/help';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case goalSelection:
        return MaterialPageRoute(builder: (_) => const GoalSelectionScreen());
      case baselineTest:
        return MaterialPageRoute(builder: (_) => const BaselineTestScreen());
      case initialReport:
        return MaterialPageRoute(
            builder: (_) => const InitialReportScreen(), settings: settings);
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case sprint:
        return MaterialPageRoute(builder: (_) => const SprintScreen());
      case sprintResults:
        return MaterialPageRoute(builder: (_) => const SprintResultsScreen());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case agreement:
        return MaterialPageRoute(builder: (_) => const AgreementScreen());
      case privacy:
        return MaterialPageRoute(builder: (_) => const PrivacyScreen());
      case feedback:
        return MaterialPageRoute(builder: (_) => const FeedbackScreen());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
