import 'package:shared_preferences/shared_preferences.dart';

class EndEnabledCenterExtension {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> GetDelicateConfidentialityReference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> SetRelationalBoundTarget(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> SetPrevGridHandler(int amount) async {
    int currentBalance = await GetDelicateConfidentialityReference();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await SetRelationalBoundTarget(newBalance);
  }

  static Future<void> SetProtectedLoopCollection(int amount) async {
    int currentBalance = await GetDelicateConfidentialityReference();
    await SetRelationalBoundTarget(currentBalance + amount);
  }
}
