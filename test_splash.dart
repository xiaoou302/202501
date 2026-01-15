import 'package:flutter/material.dart';
import 'package:cianeo/data/services/eula_service.dart';

/// 测试脚本 - 用于重置 EULA 状态
/// 
/// 使用方法：
/// 1. 在终端运行: dart test_splash.dart
/// 2. 或在应用中调用 resetEula() 函数

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final eulaService = EulaService();
  
  print('正在重置 EULA 状态...');
  await eulaService.resetEulaStatus();
  print('✅ EULA 状态已重置！');
  print('现在重新启动应用将显示启动界面。');
}

/// 在应用中调用此函数来重置 EULA 状态（用于测试）
Future<void> resetEula() async {
  final eulaService = EulaService();
  await eulaService.resetEulaStatus();
  print('EULA 状态已重置');
}
