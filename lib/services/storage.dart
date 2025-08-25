import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/level.dart';
import '../models/achievement.dart';
import '../models/player_stats.dart';
import 'level_service.dart';

/// 存储服务
/// 负责游戏数据的持久化存储
class StorageService {
  // 单例模式
  StorageService._();
  static final StorageService _instance = StorageService._();
  static StorageService get instance => _instance;

  // 键名常量
  static const String _keyPlayerStats = 'player_stats';
  static const String _keyAchievements = 'achievements';
  static const String _keyLevels = 'levels';
  static const String _keyCurrentLevel = 'current_level';
  static const String _keySettings = 'settings';
  static const String _keyGameVersion = 'game_version';

  // 当前游戏版本
  static const int _currentVersion = 1;

  // 保存玩家统计数据
  Future<void> savePlayerStats(PlayerStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPlayerStats, jsonEncode(stats.toJson()));
  }

  // 加载玩家统计数据
  Future<PlayerStats> loadPlayerStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyPlayerStats);
      if (jsonString == null) {
        return PlayerStats(); // 返回默认值
      }
      return PlayerStats.fromJson(jsonDecode(jsonString));
    } catch (e) {
      print('Error loading player stats: $e');
      return PlayerStats(); // 返回默认值
    }
  }

  // 保存成就列表
  Future<void> saveAchievements(List<Achievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = achievements.map((a) => a.toJson()).toList();
    await prefs.setString(_keyAchievements, jsonEncode(jsonList));
  }

  // 加载成就列表
  Future<List<Achievement>> loadAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyAchievements);
      if (jsonString == null) {
        return Achievements.getAll(); // 返回默认成就列表
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Achievement.fromJson(json)).toList();
    } catch (e) {
      print('Error loading achievements: $e');
      return Achievements.getAll(); // 返回默认成就列表
    }
  }

  // 保存关卡列表
  Future<void> saveLevels(List<Level> levels) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = levels.map((l) => l.toJson()).toList();
    await prefs.setString(_keyLevels, jsonEncode(jsonList));
  }

  // 加载关卡列表
  Future<List<Level>> loadLevels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyLevels);
      if (jsonString == null) {
        // 如果没有保存的关卡数据，创建默认关卡
        final defaultLevels = LevelService.instance.createLevels();
        // 保存默认关卡
        await saveLevels(defaultLevels);
        return defaultLevels;
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Level.fromJson(json)).toList();
    } catch (e) {
      print('Error loading levels: $e');
      // 发生错误时，返回默认关卡
      final defaultLevels = LevelService.instance.createLevels();
      return defaultLevels;
    }
  }

  // 保存当前关卡ID
  Future<void> saveCurrentLevelId(int levelId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCurrentLevel, levelId);
  }

  // 加载当前关卡ID
  Future<int> loadCurrentLevelId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCurrentLevel) ?? 1; // 默认返回第一关
  }

  // 保存游戏设置
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySettings, jsonEncode(settings));
  }

  // 加载游戏设置
  Future<Map<String, dynamic>> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keySettings);
      if (jsonString == null) {
        return _getDefaultSettings(); // 返回默认设置
      }
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      print('Error loading settings: $e');
      return _getDefaultSettings(); // 返回默认设置
    }
  }

  // 默认游戏设置
  Map<String, dynamic> _getDefaultSettings() {
    return {
      'musicEnabled': true,
      'sfxEnabled': true,
      'musicVolume': 0.8,
      'sfxVolume': 0.9,
      'colorblindMode': false,
    };
  }

  // 检查版本并执行数据迁移
  Future<void> checkVersionAndMigrate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVersion = prefs.getInt(_keyGameVersion) ?? 1;

    if (savedVersion < _currentVersion) {
      // 执行数据迁移逻辑
      await _migrateData(savedVersion, _currentVersion);

      // 更新版本号
      await prefs.setInt(_keyGameVersion, _currentVersion);
    }
  }

  // 数据迁移
  Future<void> _migrateData(int fromVersion, int toVersion) async {
    // 这里实现版本之间的数据迁移逻辑
    print('Migrating data from version $fromVersion to $toVersion');

    // 示例：如果从版本1迁移到版本2
    if (fromVersion == 1 && toVersion >= 2) {
      // 执行版本1到版本2的迁移
    }

    // 如果有更多版本，继续添加迁移逻辑
  }

  // 重置所有游戏数据
  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPlayerStats);
    await prefs.remove(_keyAchievements);
    await prefs.remove(_keyLevels);
    await prefs.remove(_keyCurrentLevel);

    // 保留设置和版本号
    final settings = await loadSettings();
    await prefs.setString(_keySettings, jsonEncode(settings));
    await prefs.setInt(_keyGameVersion, _currentVersion);
  }

  // 重置关卡进度
  Future<void> resetLevelProgress() async {
    // 创建默认关卡
    final defaultLevels = LevelService.instance.createLevels();
    // 只保留第一关解锁
    for (int i = 0; i < defaultLevels.length; i++) {
      if (i == 0) {
        defaultLevels[i].isUnlocked = true;
      } else {
        defaultLevels[i].isUnlocked = false;
      }
      defaultLevels[i].starsEarned = 0;
    }
    // 保存重置后的关卡
    await saveLevels(defaultLevels);
    // 重置当前关卡为第一关
    await saveCurrentLevelId(1);
  }
}
