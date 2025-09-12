/// 关卡模型，定义游戏关卡的属性和状态
class Level {
  /// 关卡唯一标识
  final String id;

  /// 关卡名称
  final String name;

  /// 棋盘大小
  final int gridSize;

  /// 是否已解锁
  final bool isUnlocked; //sssasdasdads

  /// 获得的星星数量（0-3）//sdasdadasd
  final int stars;

  /// 最佳完成时间（秒）
  final int? bestTimeSeconds;

  /// 最少步数
  final int? bestMoves;

  /// 关卡模式（classic 或 challenge）
  final String mode;

  Level({
    required this.id,
    required this.name,
    required this.gridSize,
    required this.isUnlocked,
    this.stars = 0,
    this.bestTimeSeconds,
    this.bestMoves,
    required this.mode,
  });

  /// 从JSON创建关卡对象
  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] as String,
      name: json['name'] as String,
      gridSize: json['gridSize'] as int,
      isUnlocked: json['isUnlocked'] as bool,
      stars: json['stars'] as int? ?? 0,
      bestTimeSeconds: json['bestTimeSeconds'] as int?,
      bestMoves: json['bestMoves'] as int?,
      mode: json['mode'] as String,
    );
  }

  /// 将关卡对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gridSize': gridSize,
      'isUnlocked': isUnlocked,
      'stars': stars,
      'bestTimeSeconds': bestTimeSeconds,
      'bestMoves': bestMoves,
      'mode': mode,
    };
  }

  /// 创建关卡的副本
  Level copyWith({
    String? id,
    String? name,
    int? gridSize,
    bool? isUnlocked,
    int? stars,
    int? bestTimeSeconds,
    int? bestMoves,
    String? mode,
  }) {
    return Level(
      id: id ?? this.id,
      name: name ?? this.name,
      gridSize: gridSize ?? this.gridSize,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      stars: stars ?? this.stars,
      bestTimeSeconds: bestTimeSeconds ?? this.bestTimeSeconds,
      bestMoves: bestMoves ?? this.bestMoves,
      mode: mode ?? this.mode,
    );
  }
}
