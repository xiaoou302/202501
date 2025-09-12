import 'package:flutter/material.dart';

/// 匹配模板模型，表示游戏中可以消除的方块组合模式
class MatchTemplate {
  /// 模板中的颜色组合
  final List<Color> colors;

  /// 模板的排列方向
  final Axis orientation;

  /// 模板的唯一标识
  final String id;

  MatchTemplate({
    required this.colors,
    required this.orientation,
    String? id,
  }) : id = id ?? '${colors.hashCode}_${orientation.hashCode}';

  /// 检查给定的方块颜色组合是否与此模板匹配
  bool matches(List<Color> blockColors, Axis blockOrientation) {
    // 方向必须匹配
    if (orientation != blockOrientation) {
      return false;
    }

    // 颜色数量必须相同
    if (colors.length != blockColors.length) {
      return false;
    }

    // 颜色顺序必须匹配（考虑可能的顺序反转）
    bool forwardMatch = true;
    bool reverseMatch = true;

    for (int i = 0; i < colors.length; i++) {
      if (colors[i] != blockColors[i]) {
        forwardMatch = false;
      }

      if (colors[i] != blockColors[colors.length - 1 - i]) {
        reverseMatch = false;
      }
    }

    return forwardMatch || reverseMatch;
  }

  /// 创建模板的副本
  MatchTemplate copyWith({
    List<Color>? colors,
    Axis? orientation,
  }) {
    return MatchTemplate(
      colors: colors ?? List.from(this.colors),
      orientation: orientation ?? this.orientation,
    );
  }
}
