import '../services/local_storage_service.dart';
import '../../core/constants/app_constants.dart';

class SettingsRepository {
  final LocalStorageService _storage;

  SettingsRepository(this._storage);

  Future<bool> isDarkMode() async {
    return await _storage.getBool(StorageKeys.isDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    await _storage.setBool(StorageKeys.isDarkMode, value);
  }
}
