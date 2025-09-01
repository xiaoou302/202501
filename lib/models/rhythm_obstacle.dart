import '../core/constants/game_constants.dart';

/// 音符游戏元素模型
class RhythmObstacle {
  /// 元素唯一标识符
  final String id;

  /// 音符类型
  /// - quarter: 四分音符
  /// - eighth: 八分音符
  /// - half: 二分音符
  /// - whole: 全音符
  final String noteType;

  /// 当前轨道位置（0-3 表示四个轨道）
  final double position;

  /// 音符在轨道中的垂直位置（0-n，表示在轨道中的位置）
  final int trackPosition;

  /// 音符大小（相对于列宽的比例）
  final double size;

  /// 音符是否被选中
  final bool isSelected;

  /// 音符是否已匹配
  final bool isMatched;

  /// 音符是否错误匹配
  final bool isMismatched;

  /// 音符是否处于正确的轨道（所有同类型音符都在同一轨道）
  final bool isInCorrectTrack;

  RhythmObstacle({
    required this.id,
    required this.noteType,
    required this.position,
    required this.trackPosition,
    this.size = 0.8,
    this.isSelected = false,
    this.isMatched = false,
    this.isMismatched = false,
    this.isInCorrectTrack = false,
  });

  /// 检查音符是否可选择
  bool isSelectable() {
    // 所有音符都可以选择，除非已经匹配
    return !isMatched;
  }

  /// 检查两个音符是否相邻
  bool isAdjacentTo(RhythmObstacle other) {
    // 如果在同一轨道，判断垂直位置是否相邻
    if (position == other.position) {
      return (trackPosition - other.trackPosition).abs() == 1;
    }

    // 如果在同一垂直位置，判断轨道是否相邻
    if (trackPosition == other.trackPosition) {
      return (position - other.position).abs() == 1.0;
    }

    // 其他情况不相邻
    return false;
  }

  /// 更新音符的轨道位置
  RhythmObstacle updateTrackPosition(double newPosition) {
    return RhythmObstacle(
      id: id,
      noteType: noteType,
      position: newPosition,
      trackPosition: trackPosition,
      size: size,
      isSelected: isSelected,
      isMatched: isMatched,
      isMismatched: isMismatched,
      isInCorrectTrack: isInCorrectTrack,
    );
  }

  /// 设置音符为选中状态
  RhythmObstacle select() {
    return RhythmObstacle(
      id: id,
      noteType: noteType,
      position: position,
      trackPosition: trackPosition,
      size: size,
      isSelected: true,
      isMatched: isMatched,
      isMismatched: isMismatched,
      isInCorrectTrack: isInCorrectTrack,
    );
  }

  /// 取消音符选中状态
  RhythmObstacle unselect() {
    return RhythmObstacle(
      id: id,
      noteType: noteType,
      position: position,
      trackPosition: trackPosition,
      size: size,
      isSelected: false,
      isMatched: isMatched,
      isMismatched: isMismatched,
      isInCorrectTrack: isInCorrectTrack,
    );
  }

  /// 设置音符为匹配状态
  RhythmObstacle match() {
    return RhythmObstacle(
      id: id,
      noteType: noteType,
      position: position,
      trackPosition: trackPosition,
      size: size,
      isSelected: isSelected,
      isMatched: true,
      isMismatched: false,
      isInCorrectTrack: true,
    );
  }

  /// 设置音符为错误匹配状态
  RhythmObstacle mismatch() {
    return RhythmObstacle(
      id: id,
      noteType: noteType,
      position: position,
      trackPosition: trackPosition,
      size: size,
      isSelected: isSelected,
      isMatched: false,
      isMismatched: true,
      isInCorrectTrack: false,
    );
  }

  /// 设置音符为正确轨道状态
  RhythmObstacle setCorrectTrack() {
    return RhythmObstacle(
      id: id,
      noteType: noteType,
      position: position,
      trackPosition: trackPosition,
      size: size,
      isSelected: isSelected,
      isMatched: isMatched,
      isMismatched: isMismatched,
      isInCorrectTrack: true,
    );
  }

  /// 复制音符并修改属性
  RhythmObstacle copyWith({
    String? id,
    String? noteType,
    double? position,
    int? trackPosition,
    double? size,
    bool? isSelected,
    bool? isMatched,
    bool? isMismatched,
    bool? isInCorrectTrack,
  }) {
    return RhythmObstacle(
      id: id ?? this.id,
      noteType: noteType ?? this.noteType,
      position: position ?? this.position,
      trackPosition: trackPosition ?? this.trackPosition,
      size: size ?? this.size,
      isSelected: isSelected ?? this.isSelected,
      isMatched: isMatched ?? this.isMatched,
      isMismatched: isMismatched ?? this.isMismatched,
      isInCorrectTrack: isInCorrectTrack ?? this.isInCorrectTrack,
    );
  }

  /// 获取音符颜色
  int getNoteColor() {
    return GameConstants.noteColors[noteType] ?? 0xFF3498DB;
  }
}
