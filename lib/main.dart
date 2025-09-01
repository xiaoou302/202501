import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/audio_manager.dart';
import 'core/utils/haptic_feedback.dart';
import 'core/routes.dart';
import 'services/storage_service.dart';
import 'services/level_service.dart';
import 'services/achievement_service.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 设置应用方向为竖屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 设置状态栏为透明
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // 初始化服务
  await _initServices();

  runApp(const MyApp());
}

/// 初始化应用服务
Future<void> _initServices() async {
  // 初始化存储服务
  final storageService = StorageService();
  await storageService.init();

  // 初始化音频管理器
  final audioManager = AudioManager();
  await audioManager.init();

  // 初始化触觉反馈管理器
  final hapticManager = HapticFeedbackManager();
  await hapticManager.init();

  // 初始化关卡服务
  LevelService();

  // 初始化成就服务
  AchievementService();
  // 这里只需要创建实例，不需要保存引用，因为它们是单例模式
}

/// 应用主类
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyquinoxa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getDarkTheme(),
      home: const SplashScreen(),
      routes: AppRoutes.routes,
    );
  }
}
