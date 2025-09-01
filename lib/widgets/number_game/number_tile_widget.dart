import 'package:flutter/material.dart';
import '../../models/number_tile.dart';

/// 数字/字母方块组件
class NumberTileWidget extends StatelessWidget {
  /// 方块数据
  final NumberTile tile;

  /// 点击回调
  final VoidCallback? onTap;

  const NumberTileWidget({super.key, required this.tile, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: tile.x * (MediaQuery.of(context).size.width - tile.size),
      top: tile.y * (MediaQuery.of(context).size.height * 0.6 - tile.size),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: tile.size,
          height: tile.size,
          decoration: BoxDecoration(
            color: _getTileColor(),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _getTileShadowColor(),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
            border: tile.isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
          child: Center(
            child: tile.showValue
                ? Text(
                    tile.displayText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : tile.isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : null,
          ),
        ),
      ),
    );
  }

  /// 获取方块颜色
  Color _getTileColor() {
    if (tile.isSelected) {
      return Colors.green;
    }

    // 根据值和元素类型生成不同的颜色
    if (tile.elementType == 'letters') {
      // 字母模式，使用不同的颜色范围
      final hue = (tile.value * 15) % 360;
      return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.5).toColor();
    } else {
      // 数字模式
      final actualValue = tile.value - 1 + tile.startValue;
      final hue = (actualValue * 30) % 360;
      return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.6, 0.5).toColor();
    }
  }

  /// 获取方块阴影颜色
  Color _getTileShadowColor() {
    if (tile.isSelected) {
      return Colors.green.withOpacity(0.5);
    }

    // 根据值和元素类型生成不同的阴影颜色
    if (tile.elementType == 'letters') {
      // 字母模式
      final hue = (tile.value * 15) % 360;
      return HSLColor.fromAHSL(0.5, hue.toDouble(), 0.7, 0.5).toColor();
    } else {
      // 数字模式
      final actualValue = tile.value - 1 + tile.startValue;
      final hue = (actualValue * 30) % 360;
      return HSLColor.fromAHSL(0.5, hue.toDouble(), 0.6, 0.5).toColor();
    }
  }
}
