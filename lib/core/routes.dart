import 'package:flutter/material.dart';
import '../screens/settings/game_introduction_screen.dart';
import '../screens/settings/anti_addiction_policy_screen.dart';
import '../screens/settings/help_center_screen.dart';
import '../screens/settings/customer_support_screen.dart';
import '../screens/settings/safety_privacy_screen.dart';
import '../screens/settings/terms_of_service_screen.dart';

/// App routes configuration
class AppRoutes {
  /// Define named routes for the app
  static Map<String, WidgetBuilder> routes = {
    '/game_introduction': (context) => const GameIntroductionScreen(),
    '/anti_addiction_policy': (context) => const AntiAddictionPolicyScreen(),
    '/help_center': (context) => const HelpCenterScreen(),
    '/customer_support': (context) => const CustomerSupportScreen(),
    '/safety_privacy': (context) => const SafetyPrivacyScreen(),
    '/terms_of_service': (context) => const TermsOfServiceScreen(),
  };
}
