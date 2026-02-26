import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restoration_record.dart';

class HistoryRepository {
  static const String _recordsKey = 'restoration_records';

  Future<void> saveRecord(RestorationRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getRecords();
    records.insert(0, record); // Add new record to the top
    
    // Limit to last 20 records to avoid saving too much data
    if (records.length > 20) {
      records.removeLast();
    }
    
    await prefs.setStringList(_recordsKey, records.map((r) => jsonEncode(r.toMap())).toList());
  }

  Future<List<RestorationRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_recordsKey) ?? [];
    return recordsJson.map((json) => RestorationRecord.fromMap(jsonDecode(json))).toList();
  }
  
  Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getRecords();
    records.removeWhere((r) => r.id == id);
    await prefs.setStringList(_recordsKey, records.map((r) => jsonEncode(r.toMap())).toList());
  }
  
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recordsKey);
  }
}
