import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageService {
  static const String _tankBoxName = 'tank_configs';
  static const String _waterLogBoxName = 'water_logs';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_tankBoxName);
    await Hive.openBox(_waterLogBoxName);
  }

  Box get _tankBox => Hive.box(_tankBoxName);
  Box get _waterLogBox => Hive.box(_waterLogBoxName);

  // Generic methods could be added, but specific ones are safer given manual serialization

  Future<void> saveTankConfig(String id, Map<String, dynamic> data) async {
    await _tankBox.put(id, data);
  }

  Map<String, dynamic>? getTankConfig(String id) {
    final data = _tankBox.get(id);
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  List<Map<String, dynamic>> getAllTankConfigs() {
    return _tankBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> deleteTankConfig(String id) async {
    await _tankBox.delete(id);
  }

  // Water Logs (stored by tankId)
  // Structure: tankId -> List<WaterParameterJson>
  Future<void> addWaterLog(String tankId, Map<String, dynamic> log) async {
    List<dynamic> logs = _waterLogBox.get(tankId) ?? [];
    logs.add(log);
    await _waterLogBox.put(tankId, logs);
  }

  List<Map<String, dynamic>> getWaterLogs(String tankId) {
    final logs = _waterLogBox.get(tankId);
    if (logs != null) {
      return (logs as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
