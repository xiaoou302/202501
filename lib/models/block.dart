import 'package:flutter/material.dart';

/// 方块模型，表示游戏棋盘上的一个方块
class Block {
  /// 方块的颜色
  final Color color;

  /// 方块在棋盘上的行索引
  final int row;

  /// 方块在棋盘上的列索引
  final int col;

  /// 方块是否被选中
  bool isSelected;

  /// 方块是否已被消除
  bool isRemoved;

  Block({
    required this.color,
    required this.row,
    required this.col,
    this.isSelected = false,
    this.isRemoved = false,
  });

  /// 创建方块的副本
  Block copyWith({
    Color? color,
    int? row,
    int? col,
    bool? isSelected,
    bool? isRemoved,
  }) {
    return Block(
      color: color ?? this.color,
      row: row ?? this.row,
      col: col ?? this.col,
      isSelected: isSelected ?? this.isSelected,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }

  /// 判断两个方块是否相邻
  bool isAdjacentTo(Block other) {
    // 判断是否在同一行且列差为1
    final sameRowAdjacentCol =
        (row == other.row) && ((col - other.col).abs() == 1);

    // 判断是否在同一列且行差为1
    final sameColAdjacentRow =
        (col == other.col) && ((row - other.row).abs() == 1);

    return sameRowAdjacentCol || sameColAdjacentRow;
  }

  /// 计算与另一个方块的曼哈顿距离
  int getManhattanDistanceTo(Block other) {
    return (row - other.row).abs() + (col - other.col).abs();
  }

  /// 判断与另一个方块的排列方向
  /// 返回 Axis.horizontal 表示水平排列，Axis.vertical 表示垂直排列
  Axis getOrientationWith(Block other) {
    if (row == other.row) {
      return Axis.horizontal;
    } else if (col == other.col) {
      return Axis.vertical;
    }
    throw ArgumentError('Blocks are not adjacent');
  }
}
