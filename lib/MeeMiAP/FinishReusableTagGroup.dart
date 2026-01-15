import 'package:shared_preferences/shared_preferences.dart';

class CaptureSpecifyTempleManager {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> RestartLastEquivalentFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> SetConcreteIntensityArray(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> PauseResilientMapProtocol(int amount) async {
    int currentBalance = await RestartLastEquivalentFilter();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await SetConcreteIntensityArray(newBalance);
  }

  static Future<void> SkipUniformTagDelegate(int amount) async {
    int currentBalance = await RestartLastEquivalentFilter();
    await SetConcreteIntensityArray(currentBalance + amount);
  }
}
