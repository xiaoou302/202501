import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';
import 'core/themes.dart';
import 'viewmodels/game_viewmodel.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/game_screen.dart';
import 'views/screens/level_select_screen.dart';
import 'views/screens/achievements_screen.dart';
import 'views/screens/stats_screen.dart';
import 'views/screens/settings_screen.dart';
import 'views/screens/splash_screen.dart';
import 'views/screens/terms_agreement_screen.dart';
import 'services/preferences_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const PaikoApp());
}

class PaikoApp extends StatelessWidget {
  const PaikoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameViewModel(),
      child: MaterialApp(
        title: AppStrings.gameTitle,
        theme: AppThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const AppFrame(),
      ),
    );
  }
}

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> {
  bool _showSplash = true;
  bool _showTerms = false;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final hasAccepted = await PreferencesService.hasAcceptedTerms();
    setState(() {
      _showTerms = !hasAccepted;
    });
  }

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
      if (!_showTerms) {
        _isReady = true;
      }
    });
  }

  void _onTermsAccepted() async {
    await PreferencesService.setTermsAccepted(true);
    setState(() {
      _showTerms = false;
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(onComplete: _onSplashComplete);
    }

    if (_showTerms) {
      return TermsAgreementScreen(onAccept: _onTermsAccepted);
    }

    if (!_isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Consumer<GameViewModel>(
            builder: (context, viewModel, _) {
              switch (viewModel.currentScreen) {
                case GameScreen.home:
                  return const HomeScreen();
                case GameScreen.levelSelect:
                  return const LevelSelectScreen();
                case GameScreen.achievements:
                  return const AchievementsScreen();
                case GameScreen.stats:
                  return const StatsScreen();
                case GameScreen.settings:
                  return const SettingsScreen();
                case GameScreen.game:
                  return const GameScreenView();
              }
            },
          ),
          // Status Bar (iOS style)
        
        ],
      ),
    );
  }
}

enum GameScreen { home, levelSelect, achievements, stats, settings, game }
