/// 游戏相关常量
class GameConstants {
  // 游戏类型
  static const String memoryGame = 'memory_match';
  static const String rhythmGame = 'rhythm_flow';
  static const String numberGame = 'number_memory';

  // 记忆游戏难度
  static const String memoryLevel1 = 'level_1';
  static const String memoryLevel2 = 'level_2';
  static const String memoryLevel3 = 'level_3';
  static const String memoryLevel4 = 'level_4';
  static const String memoryLevel5 = 'level_5';
  static const String memoryLevel6 = 'level_6';
  static const String memoryLevel7 = 'level_7';

  // 旧的难度常量（保留向后兼容）
  static const String memoryEasy = memoryLevel1;
  static const String memoryNormal = memoryLevel3;
  static const String memoryHard = memoryLevel5;

  // 记忆游戏网格大小
  static const Map<String, int> memoryGridSize = {
    memoryLevel1: 4, // 4x4 (16张卡片)
    memoryLevel2: 4, // 4x4 (16张卡片，但有特殊卡片)
    memoryLevel3: 5, // 5x5 (25张卡片)
    memoryLevel4: 5, // 5x5 (25张卡片，但有更多特殊卡片)
    memoryLevel5: 6, // 6x6 (36张卡片)
    memoryLevel6: 6, // 6x6 (36张卡片，但有更多特殊卡片和时间限制)
    memoryLevel7: 7, // 7x7 (49张卡片，终极挑战)
  };

  // 记忆游戏模式
  static const String memoryClassic = 'classic'; // 经典模式
  static const String memoryTimed = 'timed'; // 限时模式
  static const String memoryChallenge = 'challenge'; // 挑战模式

  // 记忆游戏卡片类别
  static const String categoryStandard = 'standard'; // 标准卡片
  static const String categoryBonus = 'bonus'; // 奖励卡片
  static const String categorySpecial = 'special'; // 特殊卡片
  static const String categoryTrap = 'trap'; // 陷阱卡片

  // 记忆游戏卡片效果
  static const String effectNone = 'none'; // 无特殊效果
  static const String effectFreeze = 'freeze'; // 冻结效果
  static const String effectBonus = 'bonus'; // 奖励效果
  static const String effectShuffle = 'shuffle'; // 洗牌效果
  static const String effectPenalty = 'penalty'; // 惩罚效果

  // 记忆游戏关卡主题
  static const Map<String, String> memoryLevelThemes = {
    memoryLevel1: 'nature', // 自然主题（简单图标：树、花、云等）
    memoryLevel2: 'animals', // 动物主题（猫、狗、鸟等）
    memoryLevel3: 'food', // 食物主题（水果、蔬菜等）
    memoryLevel4: 'travel', // 旅行主题（飞机、汽车、船等）
    memoryLevel5: 'space', // 太空主题（行星、火箭、星星等）
    memoryLevel6: 'tech', // 科技主题（电脑、手机、设备等）
    memoryLevel7: 'fantasy', // 幻想主题（魔法、神话生物等）
  };

  // 记忆游戏关卡时间限制（秒）
  static const Map<String, int?> memoryLevelTimeLimit = {
    memoryLevel1: null, // 无时间限制
    memoryLevel2: 120, // 2分钟
    memoryLevel3: 180, // 3分钟
    memoryLevel4: 150, // 2分30秒
    memoryLevel5: 240, // 4分钟
    memoryLevel6: 180, // 3分钟
    memoryLevel7: 300, // 5分钟
  };

  // 记忆游戏关卡特殊卡片比例
  static const Map<String, Map<String, double>> memoryLevelSpecialCards = {
    memoryLevel1: {categoryBonus: 0.0, categoryTrap: 0.0}, // 无特殊卡片
    memoryLevel2: {categoryBonus: 0.1, categoryTrap: 0.0}, // 10%奖励卡片
    memoryLevel3: {categoryBonus: 0.1, categoryTrap: 0.05}, // 10%奖励卡片，5%陷阱卡片
    memoryLevel4: {categoryBonus: 0.15, categoryTrap: 0.1}, // 15%奖励卡片，10%陷阱卡片
    memoryLevel5: {categoryBonus: 0.15, categoryTrap: 0.15}, // 15%奖励卡片，15%陷阱卡片
    memoryLevel6: {categoryBonus: 0.2, categoryTrap: 0.2}, // 20%奖励卡片，20%陷阱卡片
    memoryLevel7: {categoryBonus: 0.25, categoryTrap: 0.25}, // 25%奖励卡片，25%陷阱卡片
  };

  // 音符匹配游戏难度
  static const String flowEasy = 'flow_easy';
  static const String flowNormal = 'flow_normal';
  static const String flowHard = 'flow_hard';
  static const String flowExpert = 'flow_expert';
  static const String flowMaster = 'flow_master';
  static const String flowGrandmaster = 'flow_grandmaster';
  static const String flowLegend = 'flow_legend';

  // 向后兼容的别名
  static const String rhythmChill = flowEasy;
  static const String rhythmTempo = flowNormal;
  static const String rhythmInsane = flowHard;

  // 音符匹配游戏速度 (像素/秒)
  static const Map<String, double> flowSpeed = {
    flowEasy: 150,
    flowNormal: 200,
    flowHard: 250,
    flowExpert: 300,
    flowMaster: 350,
    flowGrandmaster: 400,
    flowLegend: 450,
  };

  // 音符匹配游戏轨道数
  static const Map<String, int> flowColumns = {
    flowEasy: 4, // 四个轨道
    flowNormal: 4, // 四个轨道
    flowHard: 4, // 四个轨道
    flowExpert: 5, // 五个轨道
    flowMaster: 5, // 五个轨道
    flowGrandmaster: 6, // 六个轨道
    flowLegend: 6, // 六个轨道
  };

  // 音符匹配游戏生成频率 (毫秒)
  static const Map<String, int> flowNoteInterval = {
    flowEasy: 2000, // 2秒一个音符
    flowNormal: 1500, // 1.5秒一个音符
    flowHard: 1200, // 1.2秒一个音符
    flowExpert: 1000, // 1秒一个音符
    flowMaster: 800, // 0.8秒一个音符
    flowGrandmaster: 700, // 0.7秒一个音符
    flowLegend: 600, // 0.6秒一个音符
  };

  // 音符匹配游戏通过条件 (需要匹配的音符数)
  static const Map<String, int> flowPassCondition = {
    flowEasy: 20, // 匹配20个音符
    flowNormal: 30, // 匹配30个音符
    flowHard: 40, // 匹配40个音符
    flowExpert: 50, // 匹配50个音符
    flowMaster: 60, // 匹配60个音符
    flowGrandmaster: 70, // 匹配70个音符
    flowLegend: 80, // 匹配80个音符
  };

  // 音符匹配游戏失败条件 (允许的错误次数)
  static const Map<String, int> flowFailCondition = {
    flowEasy: 10, // 允许10次错误
    flowNormal: 8, // 允许8次错误
    flowHard: 6, // 允许6次错误
    flowExpert: 5, // 允许5次错误
    flowMaster: 4, // 允许4次错误
    flowGrandmaster: 3, // 允许3次错误
    flowLegend: 2, // 允许2次错误
  };

  // 音符类型
  static const String noteTypeQuarter = 'quarter'; // 四分音符
  static const String noteTypeEighth = 'eighth'; // 八分音符
  static const String noteTypeHalf = 'half'; // 二分音符
  static const String noteTypeWhole = 'whole'; // 全音符

  // 音符颜色
  static const Map<String, int> noteColors = {
    noteTypeQuarter: 0xFF3498DB, // 蓝色
    noteTypeEighth: 0xFF2ECC71, // 绿色
    noteTypeHalf: 0xFFE74C3C, // 红色
    noteTypeWhole: 0xFFF39C12, // 橙色
  };

  // 数字记忆游戏关卡
  static const String numberLevel1 = 'number_level1';
  static const String numberLevel2 = 'number_level2';
  static const String numberLevel3 = 'number_level3';
  static const String numberLevel4 = 'number_level4';
  static const String numberLevel5 = 'number_level5';
  static const String numberLevel6 = 'number_level6';
  static const String numberLevel7 = 'number_level7';

  // 向后兼容的别名
  static const String numberEasy = numberLevel1;
  static const String numberMedium = numberLevel2;
  static const String numberHard = numberLevel3;
  static const String numberExpert = numberLevel5;
  static const String numberMaster = numberLevel7;

  // 数字记忆游戏配置
  static const Map<String, int> numberTileCount = {
    numberLevel1: 3, // 3个元素
    numberLevel2: 4, // 4个元素
    numberLevel3: 5, // 5个元素
    numberLevel4: 6, // 6个元素
    numberLevel5: 7, // 7个元素
    numberLevel6: 9, // 9个元素
    numberLevel7: 12, // 12个元素
  };

  // 数字记忆游戏记忆时间（秒）
  static const Map<String, int> numberMemoryTime = {
    numberLevel1: 5, // 5秒
    numberLevel2: 5, // 5秒
    numberLevel3: 4, // 4秒
    numberLevel4: 4, // 4秒
    numberLevel5: 3, // 3秒
    numberLevel6: 3, // 3秒
    numberLevel7: 3, // 3秒
  };

  // 数字记忆游戏元素类型
  static const String elementTypeNumbers = 'numbers'; // 从1开始的数字
  static const String elementTypeCustom = 'custom'; // 自定义起始数字
  static const String elementTypeLetters = 'letters'; // 字母

  // 数字记忆游戏关卡元素类型
  static const Map<String, String> numberLevelElementType = {
    numberLevel1: elementTypeNumbers, // 从1开始的数字
    numberLevel2: elementTypeNumbers, // 从1开始的数字
    numberLevel3: elementTypeCustom, // 从6开始的数字
    numberLevel4: elementTypeLetters, // 字母A-Z
    numberLevel5: elementTypeCustom, // 从10开始的数字
    numberLevel6: elementTypeLetters, // 字母A-Z（更多字母）
    numberLevel7: elementTypeCustom, // 从15开始的数字（更多数字）
  };

  // 数字记忆游戏自定义起始数字
  static const Map<String, int> numberLevelStartValue = {
    numberLevel1: 1, // 从1开始
    numberLevel2: 1, // 从1开始
    numberLevel3: 6, // 从6开始
    numberLevel4: 0, // 字母模式，从A开始 (0=A)
    numberLevel5: 10, // 从10开始
    numberLevel6: 0, // 字母模式，从A开始 (0=A)
    numberLevel7: 15, // 从15开始
  };

  // 存储键
  static const String keyHighScores = 'high_scores';
  static const String keyAchievements = 'achievements';
  static const String keySettings = 'settings';
  static const String keyUnlockedLevels = 'unlocked_levels'; // 节奏游戏使用，存储JSON字符串
  static const String keyUnlockedMemoryLevels =
      'unlocked_memory_levels'; // 记忆游戏使用，存储字符串列表
  static const String keyCurrentLevel = 'current_level';
  static const String keyUnlockedNumberLevels = 'unlocked_number_levels';
}
