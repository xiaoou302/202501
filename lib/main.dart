import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, //dfdfsdfsdfsfd
    ),
  );

  // Override HTTP client timeout settings
  HttpClient.enableTimelineLogging = true;
  HttpOverrides.global = CustomHttpOverrides();

  runApp(const AzenquoriaApp());
}

// Custom HTTP overrides to handle network issues
class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context);
    client.connectionTimeout = const Duration(seconds: 10);
    client.idleTimeout = const Duration(seconds: 10);
    return client;
  }
}

class AzenquoriaApp extends StatelessWidget {
  const AzenquoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azenquoria',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getThemeData(),
      home: const SplashScreen(),
      builder: (context, child) {
        // Add error handling at the app level
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Material(
            color: AppTheme.backgroundColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppTheme.accentRed,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The application encountered an error. Please try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        };
        return child!;
      },
    );
  }
}
