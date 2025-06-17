import 'package:flutter/material.dart';
import 'features/love_diary/screens/love_diary_screen.dart';
import 'features/love_diary/screens/add_memory_screen.dart';
import 'features/love_diary/screens/setup_relationship_screen.dart';
import 'features/luggage/screens/luggage_screen.dart';
import 'features/luggage/screens/add_trip_screen.dart';
import 'features/generator/screens/generator_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/about_us_screen.dart';
import 'features/profile/screens/user_guide_screen.dart';
import 'features/profile/screens/version_history_screen.dart';
import 'features/profile/screens/contact_us_screen.dart';
import 'features/profile/screens/feedback_screen.dart';
import 'features/profile/screens/terms_of_service_screen.dart';
import 'features/profile/screens/privacy_policy_screen.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/main_navigation.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String main = '/main';
  static const String loveDiary = '/love_diary';
  static const String addMemory = '/add_memory';
  static const String setupRelationship = '/setup_relationship';
  static const String luggage = '/luggage';
  static const String addTrip = '/add_trip';
  static const String generator = '/generator';
  static const String profile = '/profile';

  // Settings routes
  static const String aboutUs = '/about_us';
  static const String userGuide = '/user_guide';
  static const String versionHistory = '/version_history';
  static const String contactUs = '/contact_us';
  static const String feedback = '/feedback';
  static const String termsOfService = '/terms_of_service';
  static const String privacyPolicy = '/privacy_policy';

  // Route table
  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        main: (context) => const MainNavigation(),
        loveDiary: (context) => const MainNavigation(initialIndex: 0),
        luggage: (context) => const MainNavigation(initialIndex: 1),
        generator: (context) => const MainNavigation(initialIndex: 2),
        profile: (context) => const MainNavigation(initialIndex: 3),

        addMemory: (context) => const AddMemoryScreen(),
        setupRelationship: (context) => const SetupRelationshipScreen(),
        addTrip: (context) => const AddTripScreen(),

        // Settings screens
        aboutUs: (context) => const AboutUsScreen(),
        userGuide: (context) => const UserGuideScreen(),
        versionHistory: (context) => const VersionHistoryScreen(),
        contactUs: (context) => const ContactUsScreen(),
        feedback: (context) => const FeedbackScreen(),
        termsOfService: (context) => const TermsOfServiceScreen(),
        privacyPolicy: (context) => const PrivacyPolicyScreen(),
      };
}
