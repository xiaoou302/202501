import 'package:flutter/material.dart';
import '../screens/about_us_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/contact_support_screen.dart';
import '../screens/details_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/game_screen.dart';
import '../screens/help_center_screen.dart';
import '../screens/home_screen.dart';
import '../screens/level_check_screen.dart';
import '../screens/level_select_screen.dart';
import '../screens/level_validation_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/terms_of_service_screen.dart';
import '../utils/constants.dart';
import '../utils/custom_page_transitions.dart';

/// Router class for handling app navigation
class AppRouter {
  /// Generate routes for the app
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return CustomPageTransitions.fadeTransition(
          page: const SplashScreen(),
          settings: settings,
        );

      case AppRoutes.home:
        return CustomPageTransitions.fadeTransition(
          page: const HomeScreen(),
          settings: settings,
        );

      case AppRoutes.main:
        // 提取初始标签索引参数
        final args = settings.arguments as Map<String, dynamic>?;
        final initialTabIndex = args?['initialTabIndex'] as int? ?? 0;

        return CustomPageTransitions.fadeTransition(
          page: MainNavigationScreen(initialTabIndex: initialTabIndex),
          settings: settings,
        );

      case AppRoutes.levelSelect:
        // 现在这个路由只用于直接导航到关卡选择界面，而不是通过底部导航栏
        return CustomPageTransitions.slideAndFadeTransition(
          page: const LevelSelectScreen(),
          settings: settings,
        );

      case AppRoutes.gameScreen:
        // Extract level ID from arguments
        final args = settings.arguments as dynamic;
        int levelId;

        // 支持两种参数传递方式
        if (args is int) {
          levelId = args;
        } else if (args is Map<String, dynamic>) {
          levelId = args['levelId'] as int? ?? 1;
        } else {
          levelId = 1; // 默认值
        }

        return CustomPageTransitions.slideRightTransition(
          page: GameScreen(levelId: levelId),
          settings: settings,
        );

      case AppRoutes.details:
        return CustomPageTransitions.slideUpTransition(
          page: const DetailsScreen(),
          settings: settings,
        );

      case AppRoutes.achievements:
        // 这个路由现在只用于直接导航到成就界面，而不是通过底部导航栏
        return CustomPageTransitions.slideAndFadeTransition(
          page: const AchievementsScreen(),
          settings: settings,
        );

      case AppRoutes.settings:
        // 这个路由现在只用于直接导航到设置界面，而不是通过底部导航栏
        return CustomPageTransitions.slideAndFadeTransition(
          page: const SettingsScreen(),
          settings: settings,
        );

      case AppRoutes.levelValidation:
        return CustomPageTransitions.scaleTransition(
          page: const LevelValidationScreen(),
          settings: settings,
        );

      case AppRoutes.levelCheck:
        return CustomPageTransitions.scaleTransition(
          page: const LevelCheckScreen(),
          settings: settings,
        );

      // New settings-related routes
      case AppRoutes.aboutUs:
        return CustomPageTransitions.slideUpTransition(
          page: const AboutUsScreen(),
          settings: settings,
        );

      case AppRoutes.helpCenter:
        return CustomPageTransitions.slideUpTransition(
          page: const HelpCenterScreen(),
          settings: settings,
        );

      case AppRoutes.feedback:
        return CustomPageTransitions.slideUpTransition(
          page: const FeedbackScreen(),
          settings: settings,
        );

      case AppRoutes.contactSupport:
        return CustomPageTransitions.slideUpTransition(
          page: const ContactSupportScreen(),
          settings: settings,
        );

      case AppRoutes.privacyPolicy:
        return CustomPageTransitions.slideUpTransition(
          page: const PrivacyPolicyScreen(),
          settings: settings,
        );

      case AppRoutes.termsOfService:
        return CustomPageTransitions.slideUpTransition(
          page: const TermsOfServiceScreen(),
          settings: settings,
        );

      default:
        // If route not found, return error page
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }
}
