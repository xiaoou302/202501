import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 触觉反馈管理类
///
/// 管理游戏中的触觉反馈
class HapticFeedbackManager {
  static final HapticFeedbackManager _instance =
      HapticFeedbackManager._internal();

  factory HapticFeedbackManager() {
    return _instance;
  }

  HapticFeedbackManager._internal();

  bool _hapticEnabled = true;

  /// 初始化触觉反馈管理器
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _hapticEnabled = prefs.getBool('haptic_enabled') ?? true;
  }

  /// 获取触觉反馈是否启用
  bool get isHapticEnabled => _hapticEnabled;

  /// 设置触觉反馈状态
  Future<void> setHapticEnabled(bool enabled) async {
    _hapticEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptic_enabled', enabled);
  }

  /// 轻度触觉反馈
  void lightImpact() {
    if (!_hapticEnabled) return;
    HapticFeedback.lightImpact();
  }

  /// 中度触觉反馈
  void mediumImpact() {
    if (!_hapticEnabled) return;
    HapticFeedback.mediumImpact();
  }

  /// 重度触觉反馈
  void heavyImpact() {
    if (!_hapticEnabled) return;
    HapticFeedback.heavyImpact();
  }

  /// 点击触觉反馈
  void click() {
    if (!_hapticEnabled) return;
    HapticFeedback.selectionClick();
  }

  /// 振动触觉反馈
  void vibrate() {
    if (!_hapticEnabled) return;
    HapticFeedback.vibrate();
  }
}
