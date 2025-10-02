import 'arrow_tile.dart';

/// 箭头方向修改器模型
class DirectionChanger {
  /// 每个关卡的修改机会总数
  static const int maxChangesPerLevel = 3;

  /// 当前关卡已使用的修改次数
  int usedChanges;

  /// 是否处于修改模式
  bool isChangingDirection;

  /// 当前选中的箭头索引（用于修改方向）
  int? selectedArrowIndex;

  DirectionChanger({
    this.usedChanges = 0,
    this.isChangingDirection = false,
    this.selectedArrowIndex,
  });

  /// 获取剩余的修改机会
  int get remainingChanges => maxChangesPerLevel - usedChanges;

  /// 是否还有修改机会
  bool get hasRemainingChanges => remainingChanges > 0;

  /// 进入修改模式
  void enterChangeMode() {
    if (hasRemainingChanges) {
      isChangingDirection = true;
      selectedArrowIndex = null;
    }
  }

  /// 退出修改模式
  void exitChangeMode() {
    isChangingDirection = false;
    selectedArrowIndex = null;
  }

  /// 选择要修改的箭头
  void selectArrow(int index) {
    if (isChangingDirection) {
      selectedArrowIndex = index;
    }
  }

  /// 修改箭头方向
  bool changeArrowDirection(
    List<ArrowTile?> layout,
    ArrowDirection newDirection,
  ) {
    if (!isChangingDirection ||
        selectedArrowIndex == null ||
        !hasRemainingChanges) {
      return false;
    }

    final arrowTile = layout[selectedArrowIndex!];
    if (arrowTile == null || arrowTile.isObstacle) {
      return false;
    }

    // 如果新方向与当前方向相同，不消耗修改机会
    if (arrowTile.direction == newDirection) {
      return false;
    }

    // 消耗一次修改机会
    usedChanges++;

    // 退出修改模式
    exitChangeMode();

    return true;
  }

  /// 重置修改器状态（用于新关卡）
  DirectionChanger reset() {
    return DirectionChanger(
      usedChanges: 0,
      isChangingDirection: false,
      selectedArrowIndex: null,
    );
  }

  /// 创建副本
  DirectionChanger copyWith({
    int? usedChanges,
    bool? isChangingDirection,
    int? selectedArrowIndex,
  }) {
    return DirectionChanger(
      usedChanges: usedChanges ?? this.usedChanges,
      isChangingDirection: isChangingDirection ?? this.isChangingDirection,
      selectedArrowIndex: selectedArrowIndex ?? this.selectedArrowIndex,
    );
  }
}
