import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tank_config.dart';
import '../models/water_parameter.dart';
import '../repositories/tank_repository.dart';

// Current selected tank ID
final selectedTankIdProvider = StateProvider<String?>((ref) => null);

// List of all tanks
final tankListProvider = FutureProvider<List<TankConfig>>((ref) async {
  final repository = ref.watch(tankRepositoryProvider);
  // In a real app, this might be async. For Hive synchronous read, we wrap it.
  // Actually Hive read is synchronous, but we can treat it as Future for consistency.
  return repository.getAllTanks();
});

// The actual selected Tank object
final currentTankProvider = Provider<TankConfig?>((ref) {
  final selectedId = ref.watch(selectedTankIdProvider);
  final tankListAsync = ref.watch(tankListProvider);

  return tankListAsync.when(
    data: (tanks) {
      if (tanks.isEmpty) return null;

      if (selectedId == null) {
        return tanks.first;
      }
      return tanks.firstWhere(
        (t) => t.id == selectedId,
        orElse: () => tanks.first,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Water logs for the current tank
final waterLogsProvider = FutureProvider<List<WaterParameter>>((ref) async {
  final currentTank = ref.watch(currentTankProvider);
  if (currentTank == null) return [];

  final repository = ref.watch(tankRepositoryProvider);
  return repository.getWaterLogs(currentTank.id);
});

class TankNotifier extends StateNotifier<AsyncValue<void>> {
  final TankRepository _repository;
  final Ref _ref;

  TankNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> addTank(TankConfig tank) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveTank(tank);
      _ref.invalidate(tankListProvider);
    });
  }

  Future<void> deleteTank(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteTank(id);
      _ref.invalidate(tankListProvider);
    });
  }

  Future<void> addWaterLog(String tankId, WaterParameter log) async {
    // Optimistic update or just invalidate? Invalidate is safer.
    await _repository.addWaterLog(tankId, log);
    _ref.invalidate(waterLogsProvider);
  }
}

final tankActionsProvider =
    StateNotifierProvider<TankNotifier, AsyncValue<void>>((ref) {
      return TankNotifier(ref.watch(tankRepositoryProvider), ref);
    });
