import 'dart:math';
import 'package:flutter/material.dart';
import '../models/block.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../models/match_template.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// 游戏逻辑服务，处理游戏的核心逻辑
class GameLogicService {
  /// 初始化游戏状态
  GameState initializeGame(Level level) {
    // 创建棋盘
    final board = generateRandomBoard(level.gridSize);

    // 创建匹配模板
    final templates = _generateRandomTemplates();

    // 确保生成的棋盘有可能的移动
    if (!_hasPossibleMoves(board, templates)) {
      // 如果没有可能的移动，重新生成棋盘
      return initializeGame(level);
    }

    // 创建初始游戏状态
    return GameState(
      currentLevel: level,
      board: board,
      templates: templates,
    );
  }

  /// 处理方块选择
  GameState handleBlockSelection(GameState gameState, Block block) {
    // 如果游戏已结束或暂停，不处理选择
    if (gameState.isGameOver || gameState.isPaused) {
      return gameState;
    }

    // 如果方块已被移除，不处理选择
    if (block.isRemoved) {
      return gameState;
    }

    List<Block> selectedBlocks = List.from(gameState.selectedBlocks);

    // 如果方块已被选中，取消选择
    if (block.isSelected) {
      selectedBlocks
          .removeWhere((b) => b.row == block.row && b.col == block.col);

      // 更新棋盘上方块的选中状态
      final newBoard = _updateBlockSelectionInBoard(
          gameState.board, block.copyWith(isSelected: false));

      return gameState.copyWith(
        selectedBlocks: selectedBlocks,
        board: newBoard,
      );
    }

    // 如果已选择两个方块，清除之前的选择
    if (selectedBlocks.length >= 2) {
      // 先将所有已选方块在棋盘上标记为未选中
      List<List<Block>> newBoard = gameState.board;
      for (final selectedBlock in selectedBlocks) {
        newBoard = _updateBlockSelectionInBoard(
            newBoard, selectedBlock.copyWith(isSelected: false));
      }

      // 清空已选方块列表
      selectedBlocks = [];

      // 将当前方块标记为选中
      selectedBlocks.add(block);
      newBoard = _updateBlockSelectionInBoard(
          newBoard, block.copyWith(isSelected: true));

      return gameState.copyWith(
        selectedBlocks: selectedBlocks,
        board: newBoard,
      );
    }

    // 如果已选择一个方块，检查是否可以选择新方块
    if (selectedBlocks.isNotEmpty) {
      final previousBlock = selectedBlocks[0];

      // 检查方块是否相邻
      final isAdjacent = previousBlock.isAdjacentTo(block);

      // 检查方块是否孤立（周围没有其他方块）
      final isPreviousIsolated =
          _isBlockIsolated(gameState.board, previousBlock);
      final isCurrentIsolated = _isBlockIsolated(gameState.board, block);

      // 如果两个方块相邻，或者其中一个是孤立方块，允许选择
      if (isAdjacent || isPreviousIsolated || isCurrentIsolated) {
        // 添加新选择的方块
        selectedBlocks.add(block);

        // 更新棋盘上方块的选中状态
        final newBoard = _updateBlockSelectionInBoard(
            gameState.board, block.copyWith(isSelected: true));

        return gameState.copyWith(
          selectedBlocks: selectedBlocks,
          board: newBoard,
        );
      } else {
        // 如果不相邻且不是孤立方块，取消之前的选择并选择新方块
        List<List<Block>> newBoard = _updateBlockSelectionInBoard(
            gameState.board, previousBlock.copyWith(isSelected: false));

        // 选择新方块
        selectedBlocks = [block];
        newBoard = _updateBlockSelectionInBoard(
            newBoard, block.copyWith(isSelected: true));

        return gameState.copyWith(
          selectedBlocks: selectedBlocks,
          board: newBoard,
        );
      }
    }

    // 如果尚未选择任何方块，选择当前方块
    selectedBlocks.add(block);

    // 更新棋盘上方块的选中状态
    final newBoard = _updateBlockSelectionInBoard(
        gameState.board, block.copyWith(isSelected: true));

    return gameState.copyWith(
      selectedBlocks: selectedBlocks,
      board: newBoard,
    );
  }

  /// 检查方块是否孤立（周围没有其他未移除的方块）
  bool _isBlockIsolated(List<List<Block>> board, Block block) {
    final int maxRow = board.length - 1;
    final int maxCol = board[0].length - 1;

    // 检查上方
    if (block.row > 0 && !board[block.row - 1][block.col].isRemoved) {
      return false;
    }

    // 检查下方
    if (block.row < maxRow && !board[block.row + 1][block.col].isRemoved) {
      return false;
    }

    // 检查左侧
    if (block.col > 0 && !board[block.row][block.col - 1].isRemoved) {
      return false;
    }

    // 检查右侧
    if (block.col < maxCol && !board[block.row][block.col + 1].isRemoved) {
      return false;
    }

    // 如果周围没有未移除的方块，则认为是孤立的
    return true;
  }

  /// 检查是否可以与模板匹配
  bool canMatchWithTemplate(List<Block> blocks, MatchTemplate template) {
    if (blocks.length != 2) return false;

    // 检查方块是否相邻（此处不需要检查，因为我们允许非相邻方块匹配）

    // 获取方块的排列方向
    Axis orientation;
    try {
      orientation = blocks[0].getOrientationWith(blocks[1]);
    } catch (e) {
      // 如果方块不相邻，根据它们的位置决定方向
      if (blocks[0].row == blocks[1].row) {
        orientation = Axis.horizontal;
      } else if (blocks[0].col == blocks[1].col) {
        orientation = Axis.vertical;
      } else {
        // 默认使用水平方向
        orientation = Axis.horizontal;
      }
    }

    // 获取方块的颜色
    final colors = blocks.map((block) => block.color).toList();

    // 检查是否与模板匹配
    return template.matches(colors, orientation);
  }

  /// 处理模板匹配
  GameState handleTemplateMatch(GameState gameState, MatchTemplate template) {
    // 如果游戏已结束或暂停，不处理匹配
    if (gameState.isGameOver || gameState.isPaused) {
      return gameState;
    }

    // 如果选择的方块不足两个，不处理匹配
    if (gameState.selectedBlocks.length != 2) {
      return gameState;
    }

    // 获取选择的方块
    final blocks = gameState.selectedBlocks;
    final block1 = blocks[0];
    final block2 = blocks[1];

    // 检查是否有孤立方块
    final isBlock1Isolated = _isBlockIsolated(gameState.board, block1);
    final isBlock2Isolated = _isBlockIsolated(gameState.board, block2);
    final isAdjacent = block1.isAdjacentTo(block2);

    // 获取方块的排列方向
    Axis orientation;
    try {
      orientation = block1.getOrientationWith(block2);
    } catch (e) {
      // 如果方块不相邻，根据它们的位置决定方向
      if (block1.row == block2.row) {
        orientation = Axis.horizontal;
      } else if (block1.col == block2.col) {
        orientation = Axis.vertical;
      } else {
        // 默认使用水平方向
        orientation = Axis.horizontal;
      }
    }

    // 获取方块的颜色
    final colors = blocks.map((block) => block.color).toList();

    // 检查是否与模板匹配
    if (!template.matches(colors, orientation)) {
      return gameState;
    }

    // 如果方块不相邻且都不是孤立方块，不允许匹配
    if (!isAdjacent && !isBlock1Isolated && !isBlock2Isolated) {
      return gameState;
    }

    // 匹配成功，移除方块
    List<List<Block>> newBoard = gameState.board;
    for (final block in blocks) {
      newBoard = _updateBlockRemovalInBoard(newBoard, block);
    }

    // 不再计算步数
    final newMoves = gameState.moves;

    // 检查游戏是否结束 - 只有当棋盘上所有方块都被消除时才结束游戏
    final remainingBlocks = _countRemainingBlocks(newBoard);
    final isVictory = remainingBlocks == 0;

    // 生成新的匹配模板
    final newTemplates = _generateRandomTemplates();

    // 游戏结束条件仅为胜利（清除所有方块）
    bool isGameOver = isVictory;

    // 如果没有可能的移动，但还有剩余方块，刷新模板
    if (!isVictory && !_hasPossibleMoves(newBoard, newTemplates)) {
      debugPrint('没有可能的移动，自动刷新模板');
      // 再次生成新的匹配模板
      newTemplates.clear();
      newTemplates.addAll(_generateRandomTemplates());
    }

    return gameState.copyWith(
      board: newBoard,
      selectedBlocks: [], // 清空选择的方块，以便玩家可以继续选择新的方块
      moves: newMoves,
      templates: newTemplates,
      isGameOver: isGameOver,
      isVictory: isVictory,
    );
  }

  /// 处理游戏暂停/恢复
  GameState togglePause(GameState gameState) {
    return gameState.copyWith(isPaused: !gameState.isPaused);
  }

  /// 刷新匹配模板（不改变棋盘）
  GameState refreshTemplates(GameState gameState) {
    // 如果游戏已结束，不允许刷新
    if (gameState.isGameOver) {
      return gameState;
    }

    // 生成新的匹配模板
    List<MatchTemplate> newTemplates = _generateRandomTemplates();

    // 尝试最多10次生成有可能移动的模板
    int attempts = 0;
    int maxAttempts = 10;

    while (!_hasPossibleMoves(gameState.board, newTemplates) &&
        attempts < maxAttempts) {
      newTemplates = _generateRandomTemplates();
      attempts++;
    }

    // 如果尝试多次后仍无可能的移动，生成特殊模板以确保有可能的移动
    if (!_hasPossibleMoves(gameState.board, newTemplates)) {
      newTemplates = _generateGuaranteedTemplates(gameState.board);
    }

    // 清空已选择的方块
    List<List<Block>> newBoard = gameState.board;
    for (final selectedBlock in gameState.selectedBlocks) {
      newBoard = _updateBlockSelectionInBoard(
          newBoard, selectedBlock.copyWith(isSelected: false));
    }

    return gameState.copyWith(
      board: newBoard,
      selectedBlocks: [],
      templates: newTemplates,
    );
  }

  /// 生成保证有可能移动的模板
  List<MatchTemplate> _generateGuaranteedTemplates(List<List<Block>> board) {
    debugPrint('生成保证可匹配的模板');
    List<MatchTemplate> templates = [];

    // 获取所有未移除的方块
    List<Block> remainingBlocks = [];
    for (var row in board) {
      for (var block in row) {
        if (!block.isRemoved) {
          remainingBlocks.add(block);
        }
      }
    }

    if (remainingBlocks.isEmpty) {
      return _generateRandomTemplates();
    }

    // 查找相邻的方块对
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        final block = board[i][j];
        if (block.isRemoved) continue;

        // 检查右侧相邻方块
        if (j + 1 < board[i].length) {
          final rightBlock = board[i][j + 1];
          if (!rightBlock.isRemoved) {
            // 创建匹配这对方块的模板
            templates.add(MatchTemplate(
              colors: [block.color, rightBlock.color],
              orientation: Axis.horizontal,
            ));

            // 如果已有足够的模板，返回
            if (templates.length >= 4) {
              return templates;
            }
          }
        }

        // 检查下方相邻方块
        if (i + 1 < board.length) {
          final bottomBlock = board[i + 1][j];
          if (!bottomBlock.isRemoved) {
            // 创建匹配这对方块的模板
            templates.add(MatchTemplate(
              colors: [block.color, bottomBlock.color],
              orientation: Axis.vertical,
            ));

            // 如果已有足够的模板，返回
            if (templates.length >= 4) {
              return templates;
            }
          }
        }
      }
    }

    // 如果没有找到足够的相邻方块对，添加随机模板补充
    while (templates.length < 4) {
      templates.add(_generateRandomTemplates()[0]);
    }

    return templates;
  }

  /// 更新棋盘上方块的选中状态
  List<List<Block>> _updateBlockSelectionInBoard(
      List<List<Block>> board, Block block) {
    List<List<Block>> newBoard = List.generate(
      board.length,
      (i) => List.generate(
        board[i].length,
        (j) => board[i][j],
      ),
    );

    newBoard[block.row][block.col] = block;
    return newBoard;
  }

  /// 更新棋盘上方块的移除状态
  List<List<Block>> _updateBlockRemovalInBoard(
      List<List<Block>> board, Block block) {
    List<List<Block>> newBoard = List.generate(
      board.length,
      (i) => List.generate(
        board[i].length,
        (j) => board[i][j],
      ),
    );

    newBoard[block.row][block.col] = block.copyWith(
      isSelected: false,
      isRemoved: true,
    );

    return newBoard;
  }

  /// 计算棋盘上剩余的方块数量
  int _countRemainingBlocks(List<List<Block>> board) {
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

  /// 检查棋盘上是否还有可能的移动
  bool _hasPossibleMoves(
      List<List<Block>> board, List<MatchTemplate> templates) {
    // 获取所有未移除的方块
    List<Block> remainingBlocks = [];
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        final block = board[i][j];
        if (!block.isRemoved) {
          remainingBlocks.add(block);
        }
      }
    }

    debugPrint('剩余方块总数: ${remainingBlocks.length}');

    // 检查是否有孤立方块
    List<Block> isolatedBlocks = [];
    for (final block in remainingBlocks) {
      if (_isBlockIsolated(board, block)) {
        isolatedBlocks.add(block);
      }
    }

    debugPrint('孤立方块数: ${isolatedBlocks.length}');

    // 如果有孤立方块，检查它们是否可以与其他方块匹配
    if (isolatedBlocks.isNotEmpty) {
      for (final isolatedBlock in isolatedBlocks) {
        for (final otherBlock in remainingBlocks) {
          if (isolatedBlock != otherBlock) {
            // 尝试匹配孤立方块与其他方块
            if (_canMatchIsolatedBlocks(isolatedBlock, otherBlock, templates)) {
              debugPrint('找到可匹配的孤立方块');
              return true;
            }
          }
        }
      }
    }

    // 检查常规相邻方块
    int possibleMatches = 0;
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        final block = board[i][j];
        if (block.isRemoved) continue;

        // 检查右侧相邻方块
        if (j + 1 < board[i].length) {
          final rightBlock = board[i][j + 1];
          if (!rightBlock.isRemoved &&
              _canMatchWithTemplates(block, rightBlock, templates)) {
            possibleMatches++;
          }
        }

        // 检查下方相邻方块
        if (i + 1 < board.length) {
          final bottomBlock = board[i + 1][j];
          if (!bottomBlock.isRemoved &&
              _canMatchWithTemplates(block, bottomBlock, templates)) {
            possibleMatches++;
          }
        }
      }
    }

    debugPrint('可能的相邻方块匹配数: $possibleMatches');

    return possibleMatches > 0;
  }

  /// 检查孤立方块是否可以与其他方块匹配
  bool _canMatchIsolatedBlocks(
      Block isolatedBlock, Block otherBlock, List<MatchTemplate> templates) {
    // 获取方块的排列方向
    Axis orientation;

    // 如果方块在同一行，使用水平方向
    if (isolatedBlock.row == otherBlock.row) {
      orientation = Axis.horizontal;
    }
    // 如果方块在同一列，使用垂直方向
    else if (isolatedBlock.col == otherBlock.col) {
      orientation = Axis.vertical;
    }
    // 默认使用水平方向
    else {
      orientation = Axis.horizontal;
    }

    // 获取方块的颜色
    final colors = [isolatedBlock.color, otherBlock.color];

    // 检查是否与任何模板匹配
    for (var template in templates) {
      if (template.matches(colors, orientation)) {
        debugPrint(
            '孤立方块匹配成功: ${isolatedBlock.row},${isolatedBlock.col} 和 ${otherBlock.row},${otherBlock.col}');
        debugPrint('颜色: ${colors[0]} 和 ${colors[1]}');
        debugPrint('方向: $orientation');
        debugPrint(
            '模板: ${template.colors[0]} 和 ${template.colors[1]}, 方向: ${template.orientation}');
        return true;
      }
    }

    return false;
  }

  /// 检查两个方块是否可以与任何模板匹配
  bool _canMatchWithTemplates(
      Block block1, Block block2, List<MatchTemplate> templates) {
    // 检查方块是否相邻
    bool isAdjacent = block1.isAdjacentTo(block2);

    if (!isAdjacent) {
      return false;
    }

    // 获取方块的排列方向
    final orientation = block1.getOrientationWith(block2);

    // 获取方块的颜色
    final colors = [block1.color, block2.color];

    // 检查是否与任何模板匹配
    for (var template in templates) {
      if (template.matches(colors, orientation)) {
        debugPrint(
            '相邻方块匹配成功: ${block1.row},${block1.col} 和 ${block2.row},${block2.col}');
        debugPrint('颜色: ${colors[0]} 和 ${colors[1]}');
        debugPrint('方向: $orientation');
        debugPrint(
            '模板: ${template.colors[0]} 和 ${template.colors[1]}, 方向: ${template.orientation}');
        return true;
      }
    }

    return false;
  }

  /// 生成随机匹配模板
  List<MatchTemplate> _generateRandomTemplates() {
    final List<Color> colors = getAllBlockColors();
    final List<MatchTemplate> templates = [];
    final random = Random();

    for (int i = 0; i < GameConstants.templateCount; i++) {
      // 随机选择两个颜色
      final color1 = colors[random.nextInt(colors.length)];
      final color2 = colors[random.nextInt(colors.length)];

      // 随机选择方向
      final orientation = random.nextBool() ? Axis.horizontal : Axis.vertical;

      templates.add(MatchTemplate(
        colors: [color1, color2],
        orientation: orientation,
      ));
    }

    return templates;
  }
}
