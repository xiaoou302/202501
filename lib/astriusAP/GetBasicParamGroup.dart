import 'package:shared_preferences/shared_preferences.dart';

class RefreshCommonBottomProtocol {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 1688;

  static Future<int> SyncIterativeDepthImplement() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> MakeProtectedActivityObserver(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> ReleaseActivatedVarCreator(int amount) async {
    int currentBalance = await SyncIterativeDepthImplement();
    int newBalance = (currentBalance - amount)
        .clamp(0, double.infinity)
        .toInt();
    await MakeProtectedActivityObserver(newBalance);
  }

  static Future<void> PlayAsynchronousSignOwner(int amount) async {
    int currentBalance = await SyncIterativeDepthImplement();
    await MakeProtectedActivityObserver(currentBalance + amount);
  }
}
