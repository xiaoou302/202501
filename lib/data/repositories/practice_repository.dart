import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/practice_log_model.dart';

class PracticeRepository {
  static const String _practiceLogsKey = 'practice_logs';

  Future<List<PracticeLog>> getPracticeLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = prefs.getString(_practiceLogsKey);
    
    if (logsJson == null) return [];
    
    final List<dynamic> decoded = json.decode(logsJson);
    return decoded.map((log) => PracticeLog.fromJson(log)).toList();
  }

  Future<void> savePracticeLog(PracticeLog log) async {
    final logs = await getPracticeLogs();
    logs.add(log);
    
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(logs.map((log) => log.toJson()).toList());
    await prefs.setString(_practiceLogsKey, encoded);
  }

  Future<void> deletePracticeLog(String id) async {
    final logs = await getPracticeLogs();
    logs.removeWhere((log) => log.id == id);
    
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(logs.map((log) => log.toJson()).toList());
    await prefs.setString(_practiceLogsKey, encoded);
  }

  Future<List<DateTime>> getLoggedDates() async {
    final logs = await getPracticeLogs();
    return logs.map((log) => log.date).toList();
  }

  Future<int> getTotalPracticeDays() async {
    final logs = await getPracticeLogs();
    return logs.length;
  }

  Future<Duration> getTotalPracticeTime() async {
    final logs = await getPracticeLogs();
    return logs.fold<Duration>(
      Duration.zero,
      (total, log) => total + Duration(minutes: log.durationMinutes),
    );
  }
}
