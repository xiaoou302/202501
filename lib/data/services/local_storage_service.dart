import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<String?> getString(String key) async {
    return _preferences?.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return await _preferences?.setString(key, value) ?? false;
  }

  Future<bool?> getBool(String key) async {
    return _preferences?.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _preferences?.setBool(key, value) ?? false;
  }

  Future<int?> getInt(String key) async {
    return _preferences?.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _preferences?.setInt(key, value) ?? false;
  }

  Future<bool> remove(String key) async {
    return await _preferences?.remove(key) ?? false;
  }

  Future<bool> clear() async {
    return await _preferences?.clear() ?? false;
  }
}
