import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';

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
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.voidCharcoal,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const CognifexApp());
}

class CognifexApp extends StatelessWidget {
  const CognifexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.voidCharcoal,
        colorScheme: ColorScheme.dark(
          primary: AppColors.alchemicalGold,
          secondary: AppColors.rubedoRed,
          surface: AppColors.voidCharcoal,
        ),
        textTheme: const TextTheme(
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          headlineLarge: AppTextStyles.header1,
          headlineMedium: AppTextStyles.header2,
          headlineSmall: AppTextStyles.header3,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.voidCharcoal,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.alabasterWhite),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
