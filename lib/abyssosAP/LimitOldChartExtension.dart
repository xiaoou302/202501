import 'package:shared_preferences/shared_preferences.dart';

class SetGranularStatusDecorator {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 188;

  static Future<int> GetComprehensiveIndexCreator() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> InitializeLocalProgressBarFilter(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> TrainDifficultLogObserver(int amount) async {
    int currentBalance = await GetComprehensiveIndexCreator();
    int newBalance = (currentBalance - amount)
        .clamp(0, double.infinity)
        .toInt();
    await InitializeLocalProgressBarFilter(newBalance);
  }

  static Future<void> GetIntermediateDialogsTarget(int amount) async {
    int currentBalance = await GetComprehensiveIndexCreator();
    await InitializeLocalProgressBarFilter(currentBalance + amount);
  }
}
