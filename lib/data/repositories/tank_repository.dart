import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';
import '../models/tank_config.dart';
import '../models/water_parameter.dart';

class TankRepository {
  final StorageService _storageService;

  TankRepository(this._storageService);

  Future<void> saveTank(TankConfig tank) async {
    await _storageService.saveTankConfig(tank.id, tank.toJson());
  }

  Future<void> deleteTank(String id) async {
    await _storageService.deleteTankConfig(id);
  }

  List<TankConfig> getAllTanks() {
    final data = _storageService.getAllTankConfigs();
    return data.map((e) => TankConfig.fromJson(e)).toList();
  }

  Future<void> addWaterLog(String tankId, WaterParameter log) async {
    await _storageService.addWaterLog(tankId, log.toJson());
  }

  List<WaterParameter> getWaterLogs(String tankId) {
    final data = _storageService.getWaterLogs(tankId);
    return data.map((e) => WaterParameter.fromJson(e)).toList();
  }
}

final tankRepositoryProvider = Provider<TankRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return TankRepository(storage);
});
