import 'package:shared_preferences/shared_preferences.dart';

class PausePermanentFlagsPool {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 1228;

  static Future<int> WriteDisplayableVideoCollection() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> DecoupleNormalSpecifierImplement(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> SpinSortedOperationProtocol(int amount) async {
    int currentBalance = await WriteDisplayableVideoCollection();
    int newBalance = (currentBalance - amount)
        .clamp(0, double.infinity)
        .toInt();
    await DecoupleNormalSpecifierImplement(newBalance);
  }

  static Future<void> CancelPermanentBoundHandler(int amount) async {
    int currentBalance = await WriteDisplayableVideoCollection();
    await DecoupleNormalSpecifierImplement(currentBalance + amount);
  }
}
