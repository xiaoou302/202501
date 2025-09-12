import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/level.dart';
import '../models/player.dart';
import '../models/leaderboard_entry.dart';
import '../utils/constants.dart';

/// 本地存储服务，管理游戏数据的持久化
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// 检查是否首次运行游戏
  Future<bool> isFirstRun() async {
    return _prefs.getBool(StorageKeys.firstRun) ?? true; //sssawww
  }

  /// 初始化游戏数据
  Future<void> initializeGameData() async {
    // 设置首次运行标志
    await _prefs.setBool(StorageKeys.firstRun, false);

    // 初始化玩家数据
    final player = Player();
    await savePlayer(player);

    // 初始化关卡数据
    final levels = _generateInitialLevels();
    await saveLevels(levels);

    // 初始化排行榜数据
    final leaderboard = <LeaderboardEntry>[];
    await saveLeaderboard(leaderboard);

    // 初始化设置
    await _prefs.setBool(StorageKeys.soundEnabled, true);
    await _prefs.setBool(StorageKeys.musicEnabled, false);
    await _prefs.setBool(StorageKeys.colorBlindMode, false);
    await _prefs.setString(StorageKeys.language, 'en_US');
  }

  /// 获取玩家数据
  Future<Player> getPlayer() async {
    final String? playerJson = _prefs.getString(StorageKeys.playerData);
    if (playerJson == null) {
      return Player();
    }

    try {
      final Map<String, dynamic> playerMap = jsonDecode(playerJson);
      return Player.fromJson(playerMap);
    } catch (e) {
      return Player();
    }
  }

  /// 保存玩家数据
  Future<void> savePlayer(Player player) async {
    final String playerJson = jsonEncode(player.toJson());
    await _prefs.setString(StorageKeys.playerData, playerJson);
  }

  /// 获取所有关卡数据
  Future<List<Level>> getLevels() async {
    final String? levelsJson = _prefs.getString(StorageKeys.levelsData);
    if (levelsJson == null) {
      return _generateInitialLevels();
    }

    try {
      final List<dynamic> levelsList = jsonDecode(levelsJson);
      return levelsList.map((level) => Level.fromJson(level)).toList();
    } catch (e) {
      return _generateInitialLevels();
    }
  }

  /// 保存所有关卡数据
  Future<void> saveLevels(List<Level> levels) async {
    final List<Map<String, dynamic>> levelsJson =
        levels.map((level) => level.toJson()).toList();
    await _prefs.setString(StorageKeys.levelsData, jsonEncode(levelsJson));
  }

  /// 获取排行榜数据
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final String? leaderboardJson =
        _prefs.getString(StorageKeys.leaderboardData);
    if (leaderboardJson == null) {
      return [];
    }

    try {
      final List<dynamic> leaderboardList = jsonDecode(leaderboardJson);
      return leaderboardList
          .map((entry) => LeaderboardEntry.fromJson(entry))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 保存排行榜数据
  Future<void> saveLeaderboard(List<LeaderboardEntry> leaderboard) async {
    final List<Map<String, dynamic>> leaderboardJson =
        leaderboard.map((entry) => entry.toJson()).toList();
    await _prefs.setString(
        StorageKeys.leaderboardData, jsonEncode(leaderboardJson));
  }

  /// 获取设置项
  Future<Map<String, dynamic>> getSettings() async {
    return {
      StorageKeys.soundEnabled:
          _prefs.getBool(StorageKeys.soundEnabled) ?? true,
      StorageKeys.musicEnabled:
          _prefs.getBool(StorageKeys.musicEnabled) ?? false,
      StorageKeys.colorBlindMode:
          _prefs.getBool(StorageKeys.colorBlindMode) ?? false,
      StorageKeys.language: _prefs.getString(StorageKeys.language) ?? 'zh_CN',
    };
  }

  /// 更新设置项
  Future<void> updateSetting(String key, dynamic value) async {
    if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    }
  }

  /// 生成初始关卡数据
  List<Level> _generateInitialLevels() {
    List<Level> levels = [];

    // 6x6 Classic mode levels
    for (int i = 1; i <= 10; i++) {
      levels.add(Level(
        id: 'classic_$i',
        name: 'Level $i',
        gridSize: GameConstants.classicGridSize,
        isUnlocked: i == 1, // Only unlock the first level
        mode: GameConstants.classicMode,
      ));
    }

    // 8x8 Challenge mode levels
    for (int i = 1; i <= 10; i++) {
      levels.add(Level(
        id: 'challenge_$i',
        name: 'Level $i',
        gridSize: GameConstants.challengeGridSize,
        isUnlocked: i == 1, // Only unlock the first level
        mode: GameConstants.challengeMode,
      ));
    }

    return levels;
  }
}
