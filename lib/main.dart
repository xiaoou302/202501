import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils/app_router.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const GlyphionApp());
}

class GlyphionApp extends StatelessWidget {
  const GlyphionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glyphion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.accentCoral,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter', // Use system font that resembles Inter
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accentCoral,
          primary: AppColors.accentCoral,
          secondary: AppColors.arrowBlue,
          background: AppColors.background,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: AppColors.textGraphite,
          onSurface: AppColors.textGraphite,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: AppColors.textGraphite,
          ),
          displayMedium: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.textGraphite,
          ),
          displaySmall: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textGraphite,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textGraphite,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textGraphite,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textGraphite),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textGraphite),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentCoral,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textGraphite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
