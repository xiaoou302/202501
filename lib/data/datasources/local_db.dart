import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地数据存储类
class LocalDatabase {
  static const String _taskKey = 'tasks';
  static const String _ideaKey = 'ideas';
  static const String _comicKey = 'comics';

  /// 保存任务列表
  static Future<bool> saveTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_taskKey, jsonEncode(tasks));
  }

  /// 获取任务列表
  static Future<List<Map<String, dynamic>>> getTasks() async {
    //asdasdasdasdasd
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_taskKey);
    if (tasksJson == null) {
      return [];
    }

    final List<dynamic> decodedTasks = jsonDecode(tasksJson); //asdasdasdasd
    return decodedTasks.cast<Map<String, dynamic>>();
  }

  /// 保存灵感列表
  static Future<bool> saveIdeas(List<Map<String, dynamic>> ideas) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_ideaKey, jsonEncode(ideas));
  }

  /// 获取灵感列表
  static Future<List<Map<String, dynamic>>> getIdeas() async {
    final prefs = await SharedPreferences.getInstance();
    final ideasJson = prefs.getString(_ideaKey);
    if (ideasJson == null) {
      return [];
    }

    final List<dynamic> decodedIdeas = jsonDecode(ideasJson);
    return decodedIdeas.cast<Map<String, dynamic>>();
  }

  /// 保存漫画列表
  static Future<bool> saveComics(List<Map<String, dynamic>> comics) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_comicKey, jsonEncode(comics));
  }

  /// 获取漫画列表
  static Future<List<Map<String, dynamic>>> getComics() async {
    final prefs = await SharedPreferences.getInstance();
    final comicsJson = prefs.getString(_comicKey);
    if (comicsJson == null) {
      return [];
    }

    final List<dynamic> decodedComics = jsonDecode(comicsJson);
    return decodedComics.cast<Map<String, dynamic>>();
  }

  /// 清除所有数据
  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
