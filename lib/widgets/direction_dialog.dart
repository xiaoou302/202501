import 'package:flutter/material.dart';
import '../models/arrow_tile.dart';
import '../utils/constants.dart';

/// 箭头方向选择对话框
class DirectionDialog extends StatefulWidget {
  /// 当前箭头方向（用于排除此方向）
  final ArrowDirection currentDirection;

  /// 方向选择回调
  final Function(ArrowDirection) onDirectionSelected;

  const DirectionDialog({
    Key? key,
    required this.currentDirection,
    required this.onDirectionSelected,
  }) : super(key: key);

  @override
  State<DirectionDialog> createState() => _DirectionDialogState();
}

class _DirectionDialogState extends State<DirectionDialog> {
  // 当前选中的方向
  ArrowDirection? _selectedDirection;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '选择新的箭头方向',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textGraphite,
              ),
            ),
            const SizedBox(height: 16),
            _buildDirectionOptions(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedDirection != null
                      ? () {
                          widget.onDirectionSelected(_selectedDirection!);
                          Navigator.of(context).pop();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCoral,
                  ),
                  child: const Text('确定'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建方向选项
  Widget _buildDirectionOptions() {
    // 获取所有可用方向（排除当前方向）
    final availableDirections = ArrowDirection.values
        .where((direction) => direction != widget.currentDirection)
        .toList();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: availableDirections.map((direction) {
        return _buildDirectionOption(direction);
      }).toList(),
    );
  }

  /// 构建单个方向选项
  Widget _buildDirectionOption(ArrowDirection direction) {
    final isSelected = _selectedDirection == direction;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDirection = direction;
        });
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentCoral : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentCoral : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getDirectionIcon(direction),
              size: 32,
              color: isSelected ? Colors.white : AppColors.textGraphite,
            ),
            const SizedBox(height: 4),
            Text(
              _getDirectionName(direction),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.textGraphite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取方向图标
  IconData _getDirectionIcon(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return Icons.arrow_upward;
      case ArrowDirection.down:
        return Icons.arrow_downward;
      case ArrowDirection.left:
        return Icons.arrow_back;
      case ArrowDirection.right:
        return Icons.arrow_forward;
    }
  }

  /// 获取方向名称
  String _getDirectionName(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return '向上';
      case ArrowDirection.down:
        return '向下';
      case ArrowDirection.left:
        return '向左';
      case ArrowDirection.right:
        return '向右';
    }
  }
}
