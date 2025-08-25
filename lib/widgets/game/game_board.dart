import 'package:flutter/material.dart';
import '../../models/game_unit.dart';
import 'game_unit_widget.dart';

/// 游戏棋盘组件
class GameBoard extends StatelessWidget {
  final List<List<GameUnit?>> board;
  final Function(int row, int col) onUnitTap;
  final double cellSize;
  final double spacing;

  const GameBoard({
    Key? key,
    required this.board,
    required this.onUnitTap,
    this.cellSize = 40.0,
    this.spacing = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardHeight = board.length;
    final boardWidth = boardHeight > 0 ? board[0].length : 0;

    // 计算实际可用宽度
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 32; // 32是两侧的padding

    // 根据可用宽度重新计算单元格大小
    final adjustedCellSize =
        (availableWidth - (boardWidth - 1) * spacing) / boardWidth;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(boardHeight, (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center, // 居中对齐
            mainAxisSize: MainAxisSize.min,
            children: List.generate(boardWidth, (col) {
              return Padding(
                padding: EdgeInsets.all(spacing / 2), // 减小间距以适应屏幕
                child: _buildCell(row, col, adjustedCellSize),
              );
            }),
          );
        }),
      ),
    );
  }

  /// 构建单元格
  Widget _buildCell(int row, int col, double size) {
    final unit = board[row][col];

    if (unit == null) {
      // 空单元格
      return SizedBox(width: size, height: size);
    }

    return GameUnitWidget(
      unit: unit,
      size: size,
      onTap: () => onUnitTap(row, col),
    );
  }
}

/// 游戏棋盘控制器
class GameBoardController {
  // 选中的单元
  Position? _selectedPosition;
  Position? get selectedPosition => _selectedPosition;

  // 设置选中的单元
  void setSelectedPosition(Position? position) {
    _selectedPosition = position;
  }

  // 清除选中的单元
  void clearSelection() {
    _selectedPosition = null;
  }

  // 检查是否有选中的单元
  bool hasSelection() {
    return _selectedPosition != null;
  }
}
