import 'package:shared_preferences/shared_preferences.dart';
import '../models/restoration_record.dart';

class RestorationStorage {
  static const String _key = 'restoration_history';

  Future<List<RestorationRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recordsString = prefs.getString(_key);
    if (recordsString == null) return [];
    return RestorationRecord.decode(recordsString);
  }

  Future<void> addRecord(RestorationRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final List<RestorationRecord> records = await getRecords();
    
    // Add new record at the beginning
    records.insert(0, record);
    
    await prefs.setString(_key, RestorationRecord.encode(records));
  }

  Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<RestorationRecord> records = await getRecords();
    
    records.removeWhere((item) => item.id == id);
    
    await prefs.setString(_key, RestorationRecord.encode(records));
  }
  
  Future<void> clearAll() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
  }
}
