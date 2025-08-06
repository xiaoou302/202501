import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_colors.dart';
import 'core/widgets/custom_app_bar.dart';
import 'core/widgets/custom_tab_bar.dart';
import 'features/analysis/analysis_screen.dart';
import 'features/market/market_screen.dart';
import 'features/insights/insights_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/splash/splash_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.midnightBlue,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Hide status bar
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.bottom],
  );

  runApp(const CoinAtlasApp());
}

class CoinAtlasApp extends StatelessWidget {
  const CoinAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinAtlas',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        nextScreen: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  // 移除PageController，不再需要

  final List<Widget> _screens = [
    const MarketScreen(),
    const AnalysisScreen(),
    const InsightsScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = [
    '市场',
    '分析',
    '讯息',
    '设置',
  ];

  // 移除dispose方法，不再需要处理PageController

  void _onTabTapped(int index) {
    // 直接切换索引，不使用页面滑动
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping anywhere in the app
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.midnightBlue,
        extendBodyBehindAppBar: true,
        extendBody: true,
        // Use our updated CustomAppBar with the current screen title
        appBar: CustomAppBar(title: _titles[_currentIndex]),
        body: SafeArea(
          // Only apply bottom padding, let top area extend into notch/Dynamic Island
          top: false,
          bottom: false,
          // 使用IndexedStack替代PageView，移除滑动功能
          child: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: CustomTabBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
