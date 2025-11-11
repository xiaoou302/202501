import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/settings_repository.dart';
import 'data/services/local_storage_service.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final storage = await LocalStorageService.getInstance();
      final settingsRepo = SettingsRepository(storage);
      final isDark = await settingsRepo.isDarkMode();

      if (mounted) {
        setState(() {
          _isDarkMode = isDark;
          _isLoading = false;
        });
      }
    } catch (e) {
      // If there's any error loading preferences, just use default values
      if (mounted) {
        setState(() {
          _isDarkMode = false;
          _isLoading = false;
        });
      }
    }
  }

  void _toggleTheme(bool isDark) async {
    setState(() {
      _isDarkMode = isDark;
    });

    try {
      final storage = await LocalStorageService.getInstance();
      final settingsRepo = SettingsRepository(storage);
      await settingsRepo.setDarkMode(isDark);
    } catch (e) {
      // Silently fail if we can't save the preference
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Leno',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(onThemeToggle: _toggleTheme),
    );
  }
}
