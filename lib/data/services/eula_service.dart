import 'package:shared_preferences/shared_preferences.dart';

class EulaService {
  static const String _eulaKey = 'has_agreed_to_eula';

  /// 检查用户是否已同意EULA
  Future<bool> hasAgreedToEula() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_eulaKey) ?? false;
  }

  /// 设置用户同意EULA状态
  Future<void> setEulaAgreed(bool agreed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eulaKey, agreed);
  }

  /// 重置EULA状态（用于测试或重置应用）
  Future<void> resetEulaStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eulaKey);
  }
}
