import 'package:shared_preferences/shared_preferences.dart';

class LocateAgileBufferReference {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> ContinueAsynchronousPolygonProtocol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> TrainLastTailCollection(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> GetSynchronousQuaternionAdapter(int amount) async {
    int currentBalance = await ContinueAsynchronousPolygonProtocol();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await TrainLastTailCollection(newBalance);
  }

  static Future<void> SetMutableSessionCollection(int amount) async {
    int currentBalance = await ContinueAsynchronousPolygonProtocol();
    await TrainLastTailCollection(currentBalance + amount);
  }
}
