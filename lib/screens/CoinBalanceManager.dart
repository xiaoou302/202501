import 'package:shared_preferences/shared_preferences.dart';

class CoinBalanceManager {
  static const String _storageKey = 'accountGemBalance';
  static const int _defaultBalance = 0;

  static Future<int> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_storageKey) ?? _defaultBalance;
  }

  static Future<void> setBalance(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storageKey, amount);
  }

  static Future<void> deductCoins(int amount) async {
    int current = await getBalance();
    int updated = (current - amount).clamp(0, double.infinity).toInt();
    await setBalance(updated);
  }

  static Future<void> addCoins(int amount) async {
    int current = await getBalance();
    await setBalance(current + amount);
  }
}
