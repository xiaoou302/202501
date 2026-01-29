import 'package:shared_preferences/shared_preferences.dart';

class EndLastTailInstance {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 2100;

  static Future<int> GetHardMetadataTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> SetPrimaryCursorContainer(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> SetSharedScenarioHandler(int amount) async {
    int currentBalance = await GetHardMetadataTarget();
    int newBalance = (currentBalance - amount)
        .clamp(0, double.infinity)
        .toInt();
    await SetPrimaryCursorContainer(newBalance);
  }

  static Future<void> PauseActivatedSoundPool(int amount) async {
    int currentBalance = await GetHardMetadataTarget();
    await SetPrimaryCursorContainer(currentBalance + amount);
  }
}
