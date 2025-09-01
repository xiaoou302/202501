import 'package:flutter/material.dart';
import '../../core/constants/game_constants.dart';
import '../../models/rhythm_obstacle.dart';

/// 音符游戏元素组件
class ObstacleWidget extends StatelessWidget {
  /// 音符数据
  final RhythmObstacle obstacle;

  /// 是否在游戏区域内
  final bool isInGameArea;

  /// 是否是底部固定音符
  final bool isBottomNote;

  /// 点击音符回调
  final VoidCallback? onTap;

  /// 当前轨道总数
  final int laneCount;

  const ObstacleWidget({
    super.key,
    required this.obstacle,
    this.isInGameArea = true,
    this.isBottomNote = false,
    this.onTap,
    this.laneCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    // 根据音符类型选择样式
    Widget noteWidget;

    switch (obstacle.noteType) {
      case GameConstants.noteTypeQuarter:
        noteWidget = _buildQuarterNote();
        break;
      case GameConstants.noteTypeEighth:
        noteWidget = _buildEighthNote();
        break;
      case GameConstants.noteTypeHalf:
        noteWidget = _buildHalfNote();
        break;
      case GameConstants.noteTypeWhole:
        noteWidget = _buildWholeNote();
        break;
      default:
        noteWidget = _buildQuarterNote();
    }

    // 如果音符可点击，添加手势检测
    if (!isBottomNote && onTap != null) {
      return GestureDetector(onTap: onTap, child: noteWidget);
    }

    return noteWidget;
  }

  /// 构建四分音符
  Widget _buildQuarterNote() {
    // 获取音符颜色
    final Color noteColor = Color(obstacle.getNoteColor());

    // 计算元素大小
    final double elementSize = 60 * obstacle.size; // 减小音符大小以适应不同屏幕

    // 根据状态调整外观
    final bool isSelected = obstacle.isSelected;
    final bool isActive = isSelected || isBottomNote;
    final bool isMatched = obstacle.isMatched;
    final bool isMismatched = obstacle.isMismatched;
    final bool isInCorrectTrack = obstacle.isInCorrectTrack;

    // 确定最终颜色
    Color finalColor = noteColor;
    if (isMatched) {
      finalColor = Colors.green;
    } else if (isMismatched) {
      finalColor = Colors.red;
    } else if (isInCorrectTrack) {
      finalColor = noteColor.withOpacity(1.0); // 更亮
    }

    return Container(
      height: elementSize,
      width: elementSize,
      decoration: BoxDecoration(
        color: finalColor.withOpacity(isActive || isInCorrectTrack ? 0.9 : 0.6),
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? Colors.white
              : (isInCorrectTrack
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white.withOpacity(0.8)),
          width: isSelected ? 4 : (isActive || isInCorrectTrack ? 3 : 2),
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.white.withOpacity(0.8)
                : finalColor.withOpacity(
                    isActive || isInCorrectTrack ? 0.7 : 0.4,
                  ),
            blurRadius: isSelected
                ? 20
                : (isActive || isInCorrectTrack ? 15 : 10),
            spreadRadius: isSelected
                ? 4
                : (isActive || isInCorrectTrack ? 3 : 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 音符主体
          Center(
            child: Icon(
              Icons.music_note,
              color: Colors.white,
              size: elementSize * 0.6,
            ),
          ),

          // 匹配/错误指示器
          if (isMatched)
            Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
          if (isMismatched)
            Center(
              child: Icon(
                Icons.cancel,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
          if (isInCorrectTrack && !isMatched)
            Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
        ],
      ),
    );
  }

  /// 构建八分音符
  Widget _buildEighthNote() {
    // 获取音符颜色
    final Color noteColor = Color(obstacle.getNoteColor());

    // 计算元素大小
    final double elementSize = 60 * obstacle.size; // 减小音符大小以适应不同屏幕

    // 根据状态调整外观
    final bool isSelected = obstacle.isSelected;
    final bool isActive = isSelected || isBottomNote;
    final bool isMatched = obstacle.isMatched;
    final bool isMismatched = obstacle.isMismatched;
    final bool isInCorrectTrack = obstacle.isInCorrectTrack;

    // 确定最终颜色
    Color finalColor = noteColor;
    if (isMatched) {
      finalColor = Colors.green;
    } else if (isMismatched) {
      finalColor = Colors.red;
    } else if (isInCorrectTrack) {
      finalColor = noteColor.withOpacity(1.0); // 更亮
    }

    return Container(
      height: elementSize,
      width: elementSize,
      decoration: BoxDecoration(
        color: finalColor.withOpacity(isActive || isInCorrectTrack ? 0.9 : 0.6),
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? Colors.white
              : (isInCorrectTrack
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white.withOpacity(0.8)),
          width: isSelected ? 4 : (isActive || isInCorrectTrack ? 3 : 2),
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.white.withOpacity(0.8)
                : finalColor.withOpacity(
                    isActive || isInCorrectTrack ? 0.7 : 0.4,
                  ),
            blurRadius: isSelected
                ? 20
                : (isActive || isInCorrectTrack ? 15 : 10),
            spreadRadius: isSelected
                ? 4
                : (isActive || isInCorrectTrack ? 3 : 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 音符主体
          Center(
            child: Icon(
              Icons.music_note,
              color: Colors.white,
              size: elementSize * 0.6,
            ),
          ),

          // 八分音符特有的标记
          Positioned(
            top: elementSize * 0.25,
            right: elementSize * 0.25,
            child: Container(
              width: elementSize * 0.2,
              height: elementSize * 0.2,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 匹配/错误指示器
          if (isMatched)
            Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
          if (isMismatched)
            Center(
              child: Icon(
                Icons.cancel,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
          if (isInCorrectTrack && !isMatched)
            Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
        ],
      ),
    );
  }

  /// 构建二分音符
  Widget _buildHalfNote() {
    // 获取音符颜色
    final Color noteColor = Color(obstacle.getNoteColor());

    // 计算元素大小
    final double elementSize = 60 * obstacle.size; // 减小音符大小以适应不同屏幕

    // 根据状态调整外观
    final bool isSelected = obstacle.isSelected;
    final bool isActive = isSelected || isBottomNote;
    final bool isMatched = obstacle.isMatched;
    final bool isMismatched = obstacle.isMismatched;
    final bool isInCorrectTrack = obstacle.isInCorrectTrack;

    // 确定最终颜色
    Color finalColor = noteColor;
    if (isMatched) {
      finalColor = Colors.green;
    } else if (isMismatched) {
      finalColor = Colors.red;
    } else if (isInCorrectTrack) {
      finalColor = noteColor.withOpacity(1.0); // 更亮
    }

    return Container(
      height: elementSize,
      width: elementSize,
      decoration: BoxDecoration(
        color: finalColor.withOpacity(isActive || isInCorrectTrack ? 0.9 : 0.6),
        borderRadius: BorderRadius.circular(elementSize * 0.3),
        border: Border.all(
          color: isInCorrectTrack
              ? Colors.white
              : Colors.white.withOpacity(0.8),
          width: isActive || isInCorrectTrack ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: finalColor.withOpacity(
              isActive || isInCorrectTrack ? 0.7 : 0.4,
            ),
            blurRadius: isActive || isInCorrectTrack ? 15 : 10,
            spreadRadius: isActive || isInCorrectTrack ? 3 : 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 音符主体
          Center(
            child: Icon(
              Icons.music_note,
              color: Colors.white,
              size: elementSize * 0.6,
            ),
          ),

          // 二分音符特有的标记
          Positioned(
            bottom: elementSize * 0.2,
            right: elementSize * 0.2,
            child: Container(
              width: elementSize * 0.25,
              height: elementSize * 0.25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),

          // 匹配/错误指示器
          if (isMatched)
            Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
          if (isMismatched)
            Center(
              child: Icon(
                Icons.cancel,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
          if (isInCorrectTrack && !isMatched)
            Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
        ],
      ),
    );
  }

  /// 构建全音符
  Widget _buildWholeNote() {
    // 获取音符颜色
    final Color noteColor = Color(obstacle.getNoteColor());

    // 计算元素大小
    final double elementSize = 60 * obstacle.size; // 减小音符大小以适应不同屏幕

    // 根据状态调整外观
    final bool isSelected = obstacle.isSelected;
    final bool isActive = isSelected || isBottomNote;
    final bool isMatched = obstacle.isMatched;
    final bool isMismatched = obstacle.isMismatched;
    final bool isInCorrectTrack = obstacle.isInCorrectTrack;

    // 确定最终颜色
    Color finalColor = noteColor;
    if (isMatched) {
      finalColor = Colors.green;
    } else if (isMismatched) {
      finalColor = Colors.red;
    } else if (isInCorrectTrack) {
      finalColor = noteColor.withOpacity(1.0); // 更亮
    }

    return Container(
      height: elementSize,
      width: elementSize,
      decoration: BoxDecoration(
        color: finalColor.withOpacity(isActive || isInCorrectTrack ? 0.9 : 0.6),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(elementSize * 0.2),
        border: Border.all(
          color: isInCorrectTrack
              ? Colors.white
              : Colors.white.withOpacity(0.8),
          width: isActive || isInCorrectTrack ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: finalColor.withOpacity(
              isActive || isInCorrectTrack ? 0.7 : 0.4,
            ),
            blurRadius: isActive || isInCorrectTrack ? 15 : 10,
            spreadRadius: isActive || isInCorrectTrack ? 3 : 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 音符主体
          Center(
            child: Icon(
              Icons.music_note,
              color: Colors.white,
              size: elementSize * 0.6,
            ),
          ),

          // 全音符特有的标记
          Positioned(
            top: elementSize * 0.2,
            left: elementSize * 0.2,
            child: Container(
              width: elementSize * 0.2,
              height: elementSize * 0.2,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: elementSize * 0.2,
            right: elementSize * 0.2,
            child: Container(
              width: elementSize * 0.2,
              height: elementSize * 0.2,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 匹配/错误指示器
          if (isMatched)
            Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
          if (isMismatched)
            Center(
              child: Icon(
                Icons.cancel,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
          if (isInCorrectTrack && !isMatched)
            Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: elementSize * 0.4,
              ),
            ),
        ],
      ),
    );
  }
}
