import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // 保存字符串
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // 获取字符串
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // 保存对象（转为JSON字符串）
  Future<bool> saveObject(String key, dynamic object) async {
    final jsonString = jsonEncode(object);
    return await saveString(key, jsonString);
  }

  // 获取对象（从JSON字符串）
  T? getObject<T>(String key, T Function(Map<String, dynamic> json) fromJson) {
    final jsonString = getString(key);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    } catch (e) {
      print('Error decoding object: $e');
      return null;
    }
  }

  // 保存对象列表（转为JSON字符串）
  Future<bool> saveObjectList<T>(String key, List<T> objects) async {
    final jsonStringList = jsonEncode(objects);
    return await saveString(key, jsonStringList);
  }

  // 获取对象列表（从JSON字符串）
  List<T> getObjectList<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final jsonString = getString(key);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error decoding object list: $e');
      return [];
    }
  }

  // 删除键
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // 清除所有数据
  Future<bool> clear() async {
    return await _prefs.clear();
  }
}
