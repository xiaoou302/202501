import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:oravie/data/models/renovation_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordService {
  static final RecordService _instance = RecordService._internal();
  static RecordService get instance => _instance;

  final ValueNotifier<List<RenovationRecord>> recordsNotifier = ValueNotifier([]);
  static const String _storageKey = 'renovation_records';

  RecordService._internal() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stored = prefs.getStringList(_storageKey);
    if (stored != null) {
      recordsNotifier.value = stored
          .map((e) => RenovationRecord.fromJson(jsonDecode(e)))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending
    }
  }

  Future<void> addRecord(RenovationRecord record) async {
    final List<RenovationRecord> current = List.from(recordsNotifier.value);
    current.insert(0, record); // Add to top
    
    // Update notifier
    recordsNotifier.value = current;

    // Persist
    await _saveToStorage(current);
  }

  Future<void> deleteRecord(String id) async {
    final List<RenovationRecord> current = List.from(recordsNotifier.value);
    current.removeWhere((element) => element.id == id);
    
    // Update notifier
    recordsNotifier.value = current;

    // Persist
    await _saveToStorage(current);
  }

  Future<void> _saveToStorage(List<RenovationRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded = records
        .map((e) => jsonEncode(e.toJson()))
        .toList();
    await prefs.setStringList(_storageKey, encoded);
  }
}
