import 'package:flutter/material.dart';
import '../models/arrow_tile.dart';
import '../utils/constants.dart';

/// 箭头方向选择器小部件
class DirectionSelectorWidget extends StatelessWidget {
  /// 当前选择的方向
  final ArrowDirection? selectedDirection;

  /// 方向选择回调
  final Function(ArrowDirection) onDirectionSelected;

  const DirectionSelectorWidget({
    Key? key,
    this.selectedDirection,
    required this.onDirectionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '选择箭头方向',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textGraphite,
            ),
          ),
          const SizedBox(height: 8),
          // 更紧凑的方向按钮布局
          Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              TableRow(
                children: [
                  const SizedBox(), // 空白单元格
                  Center(
                    child: _buildDirectionButton(
                      context,
                      ArrowDirection.up,
                      Icons.arrow_upward,
                    ),
                  ),
                  const SizedBox(), // 空白单元格
                ],
              ),
              TableRow(
                children: [
                  _buildDirectionButton(
                    context,
                    ArrowDirection.left,
                    Icons.arrow_back,
                  ),
                  const SizedBox(height: 50), // 中间的空白区域
                  _buildDirectionButton(
                    context,
                    ArrowDirection.right,
                    Icons.arrow_forward,
                  ),
                ],
              ),
              TableRow(
                children: [
                  const SizedBox(), // 空白单元格
                  Center(
                    child: _buildDirectionButton(
                      context,
                      ArrowDirection.down,
                      Icons.arrow_downward,
                    ),
                  ),
                  const SizedBox(), // 空白单元格
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建方向按钮
  Widget _buildDirectionButton(
    BuildContext context,
    ArrowDirection direction,
    IconData iconData,
  ) {
    final isSelected = selectedDirection == direction;

    return GestureDetector(
      onTap: () => onDirectionSelected(direction),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentCoral : Colors.white,
          borderRadius: BorderRadius.circular(10),
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
        child: Icon(
          iconData,
          size: 28,
          color: isSelected ? Colors.white : AppColors.textGraphite,
        ),
      ),
    );
  }
}
