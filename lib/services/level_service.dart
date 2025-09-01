import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/game_constants.dart';

/// 游戏关卡服务
class LevelService {
  static final LevelService _instance = LevelService._internal();

  factory LevelService() {
    return _instance;
  }

  LevelService._internal() {
    // 在构造函数中调用初始化方法
    _initializeData();
  }

  /// 初始化数据
  Future<void> _initializeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 检查记忆游戏关卡数据是否存在，如果不存在则初始化
      if (!prefs.containsKey(GameConstants.keyUnlockedMemoryLevels)) {
        await prefs.setStringList(GameConstants.keyUnlockedMemoryLevels, [
          GameConstants.memoryLevel1,
        ]);
      }

      // 检查当前关卡是否存在，如果不存在则初始化
      if (!prefs.containsKey(GameConstants.keyCurrentLevel)) {
        await prefs.setString(
          GameConstants.keyCurrentLevel,
          GameConstants.memoryLevel1,
        );
      }

      // 检查节奏游戏关卡数据是否存在，如果不存在则初始化
      // 注意：节奏游戏使用JSON字符串存储关卡数据
      if (!prefs.containsKey(GameConstants.keyUnlockedLevels)) {
        await prefs.setString(
          GameConstants.keyUnlockedLevels,
          '["flow_easy","flow_normal"]', // 默认解锁前两关
        );
      }

      print('LevelService initialized successfully');
    } catch (e) {
      print('Error initializing LevelService: $e');
    }
  }

  /// 获取已解锁的关卡列表
  Future<List<String>> getUnlockedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> unlockedLevels =
        prefs.getStringList(GameConstants.keyUnlockedMemoryLevels) ??
        [GameConstants.memoryLevel1]; // 默认只解锁第一关

    return unlockedLevels;
  }

  /// 检查关卡是否已解锁
  Future<bool> isLevelUnlocked(String level) async {
    final unlockedLevels = await getUnlockedLevels();
    return unlockedLevels.contains(level);
  }

  /// 解锁下一关卡
  Future<void> unlockNextLevel(String currentLevel) async {
    // 获取所有关卡列表
    final List<String> allLevels = [
      GameConstants.memoryLevel1,
      GameConstants.memoryLevel2,
      GameConstants.memoryLevel3,
      GameConstants.memoryLevel4,
      GameConstants.memoryLevel5,
      GameConstants.memoryLevel6,
      GameConstants.memoryLevel7,
    ];

    // 找到当前关卡的索引
    final int currentIndex = allLevels.indexOf(currentLevel);

    // 如果已经是最后一关或找不到当前关卡，则不解锁
    if (currentIndex == -1 || currentIndex >= allLevels.length - 1) {
      return;
    }

    // 获取下一关卡
    final String nextLevel = allLevels[currentIndex + 1];

    // 获取已解锁关卡列表
    final List<String> unlockedLevels = await getUnlockedLevels();

    // 如果下一关卡已解锁，则不需要再解锁
    if (unlockedLevels.contains(nextLevel)) {
      return;
    }

    // 添加下一关卡到已解锁列表
    unlockedLevels.add(nextLevel);

    // 保存已解锁关卡列表
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      GameConstants.keyUnlockedMemoryLevels,
      unlockedLevels,
    );
  }

  /// 获取当前关卡
  Future<String> getCurrentLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(GameConstants.keyCurrentLevel) ??
        GameConstants.memoryLevel1;
  }

  /// 设置当前关卡
  Future<void> setCurrentLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(GameConstants.keyCurrentLevel, level);
  }

  /// 获取关卡名称
  String getLevelName(String level) {
    switch (level) {
      case GameConstants.memoryLevel1:
        return "Level 1: Nature";
      case GameConstants.memoryLevel2:
        return "Level 2: Animals";
      case GameConstants.memoryLevel3:
        return "Level 3: Food";
      case GameConstants.memoryLevel4:
        return "Level 4: Travel";
      case GameConstants.memoryLevel5:
        return "Level 5: Space";
      case GameConstants.memoryLevel6:
        return "Level 6: Technology";
      case GameConstants.memoryLevel7:
        return "Level 7: Fantasy";
      default:
        return "Unknown Level";
    }
  }

  /// 获取关卡描述
  String getLevelDescription(String level) {
    switch (level) {
      case GameConstants.memoryLevel1:
        return "4×4 grid with nature icons. A gentle start to your memory journey.";
      case GameConstants.memoryLevel2:
        return "4×4 grid with animal icons and bonus cards. Time limit: 2 minutes.";
      case GameConstants.memoryLevel3:
        return "5×5 grid with food icons. More cards to match. Time limit: 3 minutes.";
      case GameConstants.memoryLevel4:
        return "5×5 grid with travel icons, bonus and trap cards. Time limit: 2:30 minutes.";
      case GameConstants.memoryLevel5:
        return "6×6 grid with space icons. A challenging cosmic memory test. Time limit: 4 minutes.";
      case GameConstants.memoryLevel6:
        return "6×6 grid with technology icons, more special cards. Time limit: 3 minutes.";
      case GameConstants.memoryLevel7:
        return "7×7 grid with fantasy icons. The ultimate memory challenge. Time limit: 5 minutes.";
      default:
        return "Complete previous levels to unlock.";
    }
  }

  /// 重置所有关卡进度（仅用于测试）
  Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(GameConstants.keyUnlockedMemoryLevels, [
      GameConstants.memoryLevel1,
    ]);
    await prefs.setString(
      GameConstants.keyCurrentLevel,
      GameConstants.memoryLevel1,
    );
  }
}
