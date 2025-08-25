import '../models/level.dart';

/// 关卡服务
/// 负责创建和管理关卡配置
class LevelService {
  // 单例模式
  LevelService._();
  static final LevelService _instance = LevelService._();
  static LevelService get instance => _instance;

  // 创建所有关卡
  List<Level> createLevels() {
    return [
      _createLevel1(),
      _createLevel2(),
      _createLevel3(),
      _createLevel4(),
      _createLevel5(),
      _createLevel6(),
    ];
  }

  // 创建第一关：基础教程关卡
  Level _createLevel1() {
    return Level(
      id: 1,
      name: "Color departure",
      description:
          "Score points by matching units of the same color or shape. Reach the target score to complete the level.",
      objective: LevelObjective(
        type: LevelObjectiveType.score,
        target: 3000, // 提高分数目标
      ),
      initialBoard: [], // 空棋盘，由游戏逻辑生成
      maxMoves: 18, // 减少移动次数
      timeLimit: 150, // 减少时间限制
      boardWidth: 8,
      boardHeight: 8,
      isUnlocked: true,
    );
  }

  // 创建第二关：锁定单元关卡
  Level _createLevel2() {
    return Level(
      id: 2,
      name: "Unlock the mystery",
      description:
          "Clear locked units to complete the level. Locked units can't be moved but can be cleared by matching adjacent units.",
      objective: LevelObjective(
        type: LevelObjectiveType.lockedUnits,
        target: 8, // 增加目标数量
      ),
      initialBoard: [], // 空棋盘，由游戏逻辑生成
      maxMoves: 22, // 减少移动次数
      timeLimit: 210, // 减少时间限制
      boardWidth: 8,
      boardHeight: 8,
    );
  }

  // 创建第三关：空洞挑战关卡
  Level _createLevel3() {
    return Level(
      id: 3,
      name: "Void Challenge",
      description:
          "The board has empty spaces increasing difficulty. Complete Plexi-Matches to gain Transmute ability.",
      objective: LevelObjective(
        type: LevelObjectiveType.plexiMatches,
        target: 7, // 增加完美匹配目标数量
      ),
      initialBoard: [], // 空棋盘，由游戏逻辑生成
      maxMoves: 25, // 减少移动次数
      timeLimit: 270, // 减少时间限制
      boardWidth: 8,
      boardHeight: 8,
    );
  }

  // 创建第四关：变色龙单元关卡
  Level _createLevel4() {
    return Level(
      id: 4,
      name: "Chameleon Dance",
      description:
          "Clear chameleon units to complete the objective. Chameleon units randomly change color or shape, making them harder to match.",
      //  End of Selection
      objective: LevelObjective(
        type: LevelObjectiveType.changingUnits,
        target: 10, // 增加目标数量
      ),
      initialBoard: [], // 空棋盘，由游戏逻辑生成
      maxMoves: 28, // 减少移动次数
      timeLimit: 270, // 减少时间限制
      boardWidth: 8,
      boardHeight: 8,
    );
  }

  // 创建第五关：污染格子关卡
  Level _createLevel5() {
    return Level(
      id: 5,
      name: "Purification Light",
      description:
          "Purify polluted tiles to complete the objective. Polluted tiles must be cleared by matching units above them. Each match will generate new polluted tiles.",
      objective: LevelObjective(
        type: LevelObjectiveType.purifyTiles,
        target: 12, // 增加目标数量
      ),
      initialBoard: [], // 空棋盘，由游戏逻辑生成
      maxMoves: 30, // 减少移动次数
      timeLimit: 330, // 减少时间限制
      boardWidth: 8,
      boardHeight: 8,
    );
  }

  // 创建第六关：终极挑战关卡
  Level _createLevel6() {
    return Level(
      id: 6,
      name: "Ultimate Challenge",
      description:
          "Remove changing units and purify polluted tiles simultaneously. You must first complete perfect matches with normal units to earn transmute abilities, then use them strategically to complete both objectives.",
      objective: LevelObjective(
        type: LevelObjectiveType.score,
        target: 1500, // 大幅提高分数目标
      ),
      initialBoard: [], // 空棋盘，由游戏逻辑生成
      maxMoves: 35, // 减少移动次数
      timeLimit: 390, // 减少时间限制
      boardWidth: 8,
      boardHeight: 8,
    );
  }
}
