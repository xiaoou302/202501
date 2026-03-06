import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bean.dart';

class BeanService {
  static List<Bean> _beans = [];
  static const String _storageKey = 'saved_beans';

  static Future<void> loadBeans() async {
    final prefs = await SharedPreferences.getInstance();
    final String? beansJson = prefs.getString(_storageKey);
    if (beansJson != null) {
      final List<dynamic> decodedList = jsonDecode(beansJson);
      _beans = decodedList.map((json) => Bean.fromJson(json)).toList();
    }
  }

  static List<Bean> getBeans() {
    return _beans;
  }

  static Future<void> saveBean(Bean bean) async {
    final index = _beans.indexWhere((b) => b.id == bean.id);
    if (index >= 0) {
      _beans[index] = bean;
    } else {
      _beans.insert(0, bean);
    }
    await _saveBeans();
  }

  static Future<void> deleteBean(String id) async {
    _beans.removeWhere((bean) => bean.id == id);
    await _saveBeans();
  }

  static Future<void> _saveBeans() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(
      _beans.map((b) => b.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedList);
  }
}
