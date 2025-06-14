import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/settings/about_us_screen.dart';
import 'screens/settings/help_center_screen.dart';
import 'screens/settings/terms_of_service_screen.dart';
import 'screens/settings/privacy_policy_screen.dart';
import 'screens/settings/contact_us_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置状态栏为透明
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // 初始化SharedPreferences
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luxanvoryx',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0a0a1f),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00e5ff), // electric-blue
          secondary: Color(0xFFb967ff), // hologram-purple
          background: Color(0xFF0a0a1f), // deep-space
          surface: Color(0xFF1a0630), // nebula-purple
          error: Color(0xFFff4d94), // 错误颜色
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1f1f4b).withOpacity(0.6),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: const Color(0xFF6043ff).withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFe0e0ff),
          ),
          displayMedium: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFe0e0ff),
          ),
          displaySmall: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFe0e0ff),
          ),
          headlineLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFe0e0ff),
          ),
          headlineMedium: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFe0e0ff),
          ),
          headlineSmall: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFe0e0ff),
          ),
          titleLarge: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFe0e0ff),
          ),
          titleMedium: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFe0e0ff),
          ),
          titleSmall: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFe0e0ff),
          ),
          bodyLarge: const TextStyle(color: Color(0xFFe0e0ff)),
          bodyMedium: const TextStyle(color: Color(0xFFe0e0ff)),
          bodySmall: TextStyle(color: const Color(0xFFe0e0ff).withOpacity(0.8)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFb967ff)),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const HomeScreen(),
        '/settings/about_us': (context) => const AboutUsScreen(),
        '/settings/help_center': (context) => const HelpCenterScreen(),
        '/settings/terms_of_service': (context) => const TermsOfServiceScreen(),
        '/settings/privacy_policy': (context) => const PrivacyPolicyScreen(),
        '/settings/contact_us': (context) => const ContactUsScreen(),
      },
    );
  }
}
