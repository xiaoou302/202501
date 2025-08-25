import 'game_unit.dart';

/// 关卡目标类型
enum LevelObjectiveType {
  score, // 达到指定分数
  matches, // 达成指定次数的匹配
  plexiMatches, // 达成指定次数的完美匹配
  lockedUnits, // 消除指定数量的锁定单元
  changingUnits, // 消除指定数量的变色龙单元
  purifyTiles, // 净化指定数量的污染格子
}

/// 关卡目标
class LevelObjective {
  final LevelObjectiveType type;
  int target; // 目标值，可修改以适应动态生成的关卡
  int current;

  LevelObjective({required this.type, required this.target, this.current = 0});

  // 检查是否完成目标
  bool get isCompleted => current >= target;

  // 进度百分比
  double get progressPercentage => target > 0 ? current / target : 0;

  // 序列化为JSON
  Map<String, dynamic> toJson() {
    return {'type': type.toString(), 'target': target, 'current': current};
  }

  // 从JSON反序列化
  factory LevelObjective.fromJson(Map<String, dynamic> json) {
    return LevelObjective(
      type: LevelObjectiveType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => LevelObjectiveType.score,
      ),
      target: json['target'],
      current: json['current'] ?? 0,
    );
  }
}

/// 关卡模型
class Level {
  final int id;
  final String name;
  final String description;
  final LevelObjective objective;
  final List<List<GameUnit?>> initialBoard;
  final int maxMoves;
  final int timeLimit; // 时间限制（秒）
  final int boardWidth;
  final int boardHeight;
  bool isUnlocked;
  int starsEarned;

  Level({
    required this.id,
    required this.name,
    required this.description,
    required this.objective,
    required this.initialBoard,
    required this.maxMoves,
    this.timeLimit = 300, // 默认5分钟
    required this.boardWidth,
    required this.boardHeight,
    this.isUnlocked = false,
    this.starsEarned = 0,
  });

  // 序列化为JSON
  Map<String, dynamic> toJson() {
    // 将棋盘转换为JSON
    List<List<Map<String, dynamic>?>> boardJson = [];
    for (var row in initialBoard) {
      List<Map<String, dynamic>?> rowJson = [];
      for (var unit in row) {
        rowJson.add(unit?.toJson());
      }
      boardJson.add(rowJson);
    }

    return {
      'id': id,
      'name': name,
      'description': description,
      'objective': objective.toJson(),
      'initialBoard': boardJson,
      'maxMoves': maxMoves,
      'timeLimit': timeLimit,
      'boardWidth': boardWidth,
      'boardHeight': boardHeight,
      'isUnlocked': isUnlocked,
      'starsEarned': starsEarned,
    };
  }

  // 从JSON反序列化
  factory Level.fromJson(Map<String, dynamic> json) {
    // 从JSON转换棋盘
    List<List<GameUnit?>> board = [];
    List<dynamic> boardJson = json['initialBoard'];
    for (var rowJson in boardJson) {
      List<GameUnit?> row = [];
      for (var unitJson in rowJson) {
        row.add(unitJson != null ? GameUnit.fromJson(unitJson) : null);
      }
      board.add(row);
    }

    return Level(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      objective: LevelObjective.fromJson(json['objective']),
      initialBoard: board,
      maxMoves: json['maxMoves'],
      timeLimit: json['timeLimit'] ?? 300, // 默认5分钟
      boardWidth: json['boardWidth'],
      boardHeight: json['boardHeight'],
      isUnlocked: json['isUnlocked'] ?? false,
      starsEarned: json['starsEarned'] ?? 0,
    );
  }

  // 计算星级评价
  int calculateStars(int score, int movesLeft) {
    // 基本通关 = 1星
    if (score > 0) {
      // 高分通关 = 2星
      if (score >= objective.target * 1.5) {
        // 高分且有剩余步数 = 3星
        if (movesLeft > 0) {
          return 3;
        }
        return 2;
      }
      return 1;
    }
    return 0;
  }
}
