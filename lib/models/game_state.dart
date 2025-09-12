import 'package:flutter/material.dart';
import 'block.dart';
import 'level.dart';
import 'match_template.dart';

/// 游戏状态模型，管理当前游戏的所有状态
class GameState {
  /// 当前关卡
  final Level currentLevel;

  /// 已用步数
  final int moves;

  /// 游戏开始时间
  final DateTime startTime;

  /// 棋盘数据
  final List<List<Block>> board;

  /// 匹配模板
  final List<MatchTemplate> templates;

  /// 已选择的方块
  final List<Block> selectedBlocks;

  /// 游戏是否结束
  final bool isGameOver;

  /// 是否胜利
  final bool isVictory;

  /// 游戏暂停状态
  final bool isPaused;

  /// 暂停时间点
  final DateTime? pauseTime;

  /// 累计暂停时长（毫秒）
  final int totalPauseDurationMs;

  GameState({
    required this.currentLevel,
    this.moves = 0,
    DateTime? startTime,
    required this.board,
    required this.templates,
    List<Block>? selectedBlocks,
    this.isGameOver = false,
    this.isVictory = false,
    this.isPaused = false,
    this.pauseTime,
    this.totalPauseDurationMs = 0,
  })  : startTime = startTime ?? DateTime.now(),
        selectedBlocks = selectedBlocks ?? [];

  /// 获取游戏已进行的时间
  Duration get elapsedTime {
    if (isGameOver) {
      // 如果游戏已结束，返回结束时的时间
      return Duration(milliseconds: _calculateElapsedTimeMs());
    }

    if (isPaused && pauseTime != null) {
      // 如果游戏暂停，返回暂停时的时间
      return Duration(
          milliseconds: pauseTime!.difference(startTime).inMilliseconds -
              totalPauseDurationMs);
    }

    // 游戏进行中，计算当前时间减去开始时间和暂停时间
    return Duration(
        milliseconds: DateTime.now().difference(startTime).inMilliseconds -
            totalPauseDurationMs);
  }

  /// 计算已经过的游戏时间（毫秒）
  int _calculateElapsedTimeMs() {
    if (isPaused && pauseTime != null) {
      return pauseTime!.difference(startTime).inMilliseconds -
          totalPauseDurationMs;
    }
    return DateTime.now().difference(startTime).inMilliseconds -
        totalPauseDurationMs;
  }

  /// 检查棋盘上是否还有可消除的方块
  bool get hasRemainingBlocks {
    return getRemainingBlocks().isNotEmpty;
  }

  /// 获取棋盘上剩余的方块
  List<Block> getRemainingBlocks() {
    List<Block> remainingBlocks = [];

    for (var row in board) {
      for (var block in row) {
        if (!block.isRemoved) {
          remainingBlocks.add(block);
        }
      }
    }

    return remainingBlocks;
  }

  /// 获取棋盘上剩余的方块总数
  int getTotalRemainingBlocks() {
    int count = 0;

    for (var row in board) {
      for (var block in row) {
        if (!block.isRemoved) {
          count++;
        }
      }
    }

    return count;
  }

  /// 检查给定的方块组合是否可以与任何模板匹配
  bool canMatchWithTemplates(List<Block> blocks) {
    if (blocks.length != 2) return false;

    // 检查方块是否相邻或者是否有孤立方块
    bool isAdjacent = blocks[0].isAdjacentTo(blocks[1]);
    bool isIsolated = _isAnyBlockIsolated(blocks);

    if (!isAdjacent && !isIsolated) {
      return false;
    }

    // 获取方块的排列方向
    Axis orientation;
    try {
      orientation = blocks[0].getOrientationWith(blocks[1]);
    } catch (e) {
      // 如果方块不相邻，默认使用水平方向
      orientation = Axis.horizontal;

      // 如果方块在同一列，则使用垂直方向
      if (blocks[0].col == blocks[1].col) {
        orientation = Axis.vertical;
      }
    }

    // 获取方块的颜色
    final colors = blocks.map((block) => block.color).toList();

    // 检查是否与任何模板匹配
    for (var template in templates) {
      if (template.matches(colors, orientation)) {
        return true;
      }
    }

    return false;
  }

  /// 检查是否有孤立的方块
  bool _isAnyBlockIsolated(List<Block> blocks) {
    for (var block in blocks) {
      bool isIsolated = true;

      // 检查上方
      if (block.row > 0) {
        final upBlock = board[block.row - 1][block.col];
        if (!upBlock.isRemoved) {
          isIsolated = false;
          break;
        }
      }

      // 检查下方
      if (block.row < board.length - 1) {
        final downBlock = board[block.row + 1][block.col];
        if (!downBlock.isRemoved) {
          isIsolated = false;
          break;
        }
      }

      // 检查左侧
      if (block.col > 0) {
        final leftBlock = board[block.row][block.col - 1];
        if (!leftBlock.isRemoved) {
          isIsolated = false;
          break;
        }
      }

      // 检查右侧
      if (block.col < board[0].length - 1) {
        final rightBlock = board[block.row][block.col + 1];
        if (!rightBlock.isRemoved) {
          isIsolated = false;
          break;
        }
      }

      if (isIsolated) {
        return true;
      }
    }

    return false;
  }

  /// 创建游戏状态的副本
  GameState copyWith({
    Level? currentLevel,
    int? moves,
    DateTime? startTime,
    List<List<Block>>? board,
    List<MatchTemplate>? templates,
    List<Block>? selectedBlocks,
    bool? isGameOver,
    bool? isVictory,
    bool? isPaused,
    DateTime? pauseTime,
    int? totalPauseDurationMs,
  }) {
    // 处理暂停/恢复时的时间计算
    int newTotalPauseDurationMs =
        totalPauseDurationMs ?? this.totalPauseDurationMs;
    DateTime? newPauseTime = pauseTime;

    // 如果从非暂停状态变为暂停状态，记录暂停时间点
    if (isPaused == true && this.isPaused == false) {
      newPauseTime = DateTime.now();
    }

    // 如果从暂停状态变为非暂停状态，计算暂停时长
    if (isPaused == false && this.isPaused == true && this.pauseTime != null) {
      final pauseDuration =
          DateTime.now().difference(this.pauseTime!).inMilliseconds;
      newTotalPauseDurationMs += pauseDuration;
      newPauseTime = null;
    }

    return GameState(
      currentLevel: currentLevel ?? this.currentLevel,
      moves: moves ?? this.moves,
      startTime: startTime ?? this.startTime,
      board: board ?? this.board,
      templates: templates ?? this.templates,
      selectedBlocks: selectedBlocks ?? List.from(this.selectedBlocks),
      isGameOver: isGameOver ?? this.isGameOver,
      isVictory: isVictory ?? this.isVictory,
      isPaused: isPaused ?? this.isPaused,
      pauseTime: newPauseTime,
      totalPauseDurationMs: newTotalPauseDurationMs,
    );
  }
}
