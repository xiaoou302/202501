import 'level_model.dart';

/// 关卡游戏配置
class LevelGameConfig {
  final String levelId;
  final int bufferSlots; // 缓冲区可用槽位数量（1-4）
  final Duration? timeLimit; // 时间限制（null表示无限制）
  final String hint; // 关卡提示

  const LevelGameConfig({
    required this.levelId,
    required this.bufferSlots,
    this.timeLimit,
    required this.hint,
  });
}

/// 所有关卡配置
class LevelConfigs {
  static const List<LevelGameConfig> configs = [
    // Level 1: Tutorial
    LevelGameConfig(
      levelId: 'level_01',
      bufferSlots: 4,
      timeLimit: null,
      hint: 'Use all 4 buffer slots with no time limit. Perfect for learning the game.',
    ),
    
    // Level 2: Easy
    LevelGameConfig(
      levelId: 'level_02',
      bufferSlots: 3,
      timeLimit: null,
      hint: 'Buffer reduced to 3 slots. Plan your moves more carefully.',
    ),
    
    // Level 3: Normal
    LevelGameConfig(
      levelId: 'level_03',
      bufferSlots: 2,
      timeLimit: null,
      hint: 'Only 2 buffer slots. Strategy becomes crucial.',
    ),
    
    // Level 4: Hard
    LevelGameConfig(
      levelId: 'level_04',
      bufferSlots: 1,
      timeLimit: null,
      hint: 'Just 1 buffer slot. Every move requires careful thought.',
    ),
    
    // Level 5: Expert + Time Limit
    LevelGameConfig(
      levelId: 'level_05',
      bufferSlots: 2,
      timeLimit: Duration(minutes: 10), // 10 minutes
      hint: '2 buffer slots. Complete within 10 minutes!',
    ),
    
    // Level 6: Master + Strict Time Limit
    LevelGameConfig(
      levelId: 'level_06',
      bufferSlots: 1,
      timeLimit: Duration(minutes: 8), // 8 minutes
      hint: 'Ultimate challenge: 1 buffer slot, 8-minute time limit!',
    ),
  ];

  /// 根据关卡ID获取配置
  static LevelGameConfig? getConfig(String levelId) {
    try {
      return configs.firstWhere((config) => config.levelId == levelId);
    } catch (e) {
      return null;
    }
  }

  /// 获取关卡的缓冲区数量
  static int getBufferSlots(String levelId) {
    final config = getConfig(levelId);
    return config?.bufferSlots ?? 4; // 默认4个
  }

  /// 获取关卡的时间限制
  static Duration? getTimeLimit(String levelId) {
    final config = getConfig(levelId);
    return config?.timeLimit;
  }

  /// 检查是否有时间限制
  static bool hasTimeLimit(String levelId) {
    return getTimeLimit(levelId) != null;
  }
}

/// 关卡数据
class LevelData {
  static final List<LevelModel> levels = [
    LevelModel(
      id: 'level_01',
      levelNumber: 1,
      name: 'Nebula Gate',
      sector: 'Sector 01',
      description: 'Begin your solitaire journey',
      difficulty: LevelDifficulty.tutorial,
      isUnlocked: true,
      prerequisites: [],
    ),
    LevelModel(
      id: 'level_02',
      levelNumber: 2,
      name: 'Quantum Maze',
      sector: 'Sector 01',
      description: 'Reduced buffer, increased challenge',
      difficulty: LevelDifficulty.easy,
      isUnlocked: true,
      prerequisites: ['level_01'],
    ),
    LevelModel(
      id: 'level_03',
      levelNumber: 3,
      name: 'Space Rift',
      sector: 'Sector 02',
      description: 'Strategy becomes crucial',
      difficulty: LevelDifficulty.normal,
      isUnlocked: true,
      prerequisites: ['level_02'],
    ),
    LevelModel(
      id: 'level_04',
      levelNumber: 4,
      name: 'Dark Matter Core',
      sector: 'Sector 02',
      description: 'Only one buffer remains',
      difficulty: LevelDifficulty.hard,
      isUnlocked: true,
      prerequisites: ['level_03'],
    ),
    LevelModel(
      id: 'level_05',
      levelNumber: 5,
      name: 'Supernova Burst',
      sector: 'Sector 03',
      description: 'Race against time',
      difficulty: LevelDifficulty.expert,
      isUnlocked: true,
      prerequisites: ['level_04'],
    ),
    LevelModel(
      id: 'level_06',
      levelNumber: 6,
      name: 'Black Hole Edge',
      sector: 'Sector 03',
      description: 'Ultimate challenge: speed meets strategy',
      difficulty: LevelDifficulty.expert,
      isUnlocked: true,
      prerequisites: ['level_05'],
    ),
  ];

  /// 根据ID获取关卡
  static LevelModel? getLevel(String levelId) {
    try {
      return levels.firstWhere((level) => level.id == levelId);
    } catch (e) {
      return null;
    }
  }

  /// 获取关卡索引
  static int getLevelIndex(String levelId) {
    return levels.indexWhere((level) => level.id == levelId);
  }
}
