/// 表示游戏棋盘上的位置
class Position {
  final int row;
  final int col;

  const Position({required this.row, required this.col});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'Position(row: $row, col: $col)';
}

/// 游戏单元类
/// 代表棋盘上的一个游戏单元，包含颜色和形状两个属性
class GameUnit {
  // 单元属性
  final String color; // 'r', 'g', 'b', 'y', 'p' 分别代表红、绿、蓝、黄、紫
  final String shape; // 'c', 's', 't' 分别代表圆形、方形、三角形
  final Position position; // 在棋盘上的位置
  bool isSelected; // 是否被选中
  bool isLocked; // 是否被锁定（第二关特性）
  bool isChanging; // 是否为变色龙单元（第四关特性）
  bool isPolluted; // 是否被污染（第五关特性）

  GameUnit({
    required this.color,
    required this.shape,
    required this.position,
    this.isSelected = false,
    this.isLocked = false,
    this.isChanging = false,
    this.isPolluted = false,
  });

  // 检查颜色匹配
  bool matchesColorWith(GameUnit other) => color == other.color;

  // 检查形状匹配
  bool matchesShapeWith(GameUnit other) => shape == other.shape;

  // 检查完美匹配（颜色和形状都匹配）
  bool isPerfectMatchWith(GameUnit other) =>
      matchesColorWith(other) && matchesShapeWith(other);

  // 创建副本并修改属性
  GameUnit copyWith({
    String? color,
    String? shape,
    Position? position,
    bool? isSelected,
    bool? isLocked,
    bool? isChanging,
    bool? isPolluted,
  }) {
    return GameUnit(
      color: color ?? this.color,
      shape: shape ?? this.shape,
      position: position ?? this.position,
      isSelected: isSelected ?? this.isSelected,
      isLocked: isLocked ?? this.isLocked,
      isChanging: isChanging ?? this.isChanging,
      isPolluted: isPolluted ?? this.isPolluted,
    );
  }

  // 序列化为JSON
  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'shape': shape,
      'position': {'row': position.row, 'col': position.col},
      'isLocked': isLocked,
      'isChanging': isChanging,
      'isPolluted': isPolluted,
    };
  }

  // 从JSON反序列化
  factory GameUnit.fromJson(Map<String, dynamic> json) {
    return GameUnit(
      color: json['color'],
      shape: json['shape'],
      position: Position(
        row: json['position']['row'],
        col: json['position']['col'],
      ),
      isLocked: json['isLocked'] ?? false,
      isChanging: json['isChanging'] ?? false,
      isPolluted: json['isPolluted'] ?? false,
    );
  }

  @override
  String toString() {
    return 'GameUnit(color: $color, shape: $shape, position: $position, isSelected: $isSelected, isLocked: $isLocked, isChanging: $isChanging, isPolluted: $isPolluted)';
  }
}
