import 'package:shared_preferences/shared_preferences.dart';

class StopSubtleOpacityGroup {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 1688;

  static Future<int> FinishTensorParameterObserver() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> SetDirectParamBase(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> GetOriginalNumberType(int amount) async {
    int currentBalance = await FinishTensorParameterObserver();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await SetDirectParamBase(newBalance);
  }

  static Future<void> RenameGranularAspectInstance(int amount) async {
    int currentBalance = await FinishTensorParameterObserver();
    await SetDirectParamBase(currentBalance + amount);
  }
}
