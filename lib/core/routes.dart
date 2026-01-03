import 'package:flutter/material.dart';
import '../screens/main_menu.dart';
import '../screens/level_map.dart';
import '../screens/game_board.dart';
import '../screens/archive.dart';
import '../screens/settings.dart';
import '../screens/how_to_play.dart';
import '../screens/statistics.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String mainMenu = '/main-menu';
  static const String levelMap = '/level-map';
  static const String gameBoard = '/game-board';
  static const String archive = '/archive';
  static const String settings = '/settings';
  static const String howToPlay = '/how-to-play';
  static const String statistics = '/statistics';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      mainMenu: (context) => const MainMenuScreen(),
      levelMap: (context) => const LevelMapScreen(),
      archive: (context) => const ArchiveScreen(),
      settings: (context) => const SettingsScreen(),
      howToPlay: (context) => const HowToPlayScreen(),
      statistics: (context) => const StatisticsScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case gameBoard:
        final levelId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) => GameBoardScreen(levelId: levelId),
        );
      default:
        return null;
    }
  }
}
