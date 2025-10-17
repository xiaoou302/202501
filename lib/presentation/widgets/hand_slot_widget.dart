import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/mahjong_tile_model.dart';
import 'mahjong_tile_widget.dart';

/// Widget for rendering a hand slot
class HandSlotWidget extends StatelessWidget {
  /// The tile in this slot (null if empty)
  final MahjongTile? tile;

  /// Whether to use compact mode (smaller size)
  final bool isCompact;

  /// Constructor
  const HandSlotWidget({super.key, this.tile, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    // 检测是否为iPad设备
    final bool isIpad = _isIpadDevice(context);

    // 根据是否紧凑模式和设备类型计算尺寸
    final double ipadScaleFactor = isIpad ? 1.4 : 1.0; // 增加到 1.4 (40% 放大)

    final double width = isCompact
        ? UISizes.tileSizeWidth * 0.85 * ipadScaleFactor
        : (UISizes.tileSizeWidth + 4) * ipadScaleFactor;

    final double height = isCompact
        ? UISizes.tileSizeHeight * 0.85 * ipadScaleFactor
        : (UISizes.tileSizeHeight + 4) * ipadScaleFactor;

    final double borderRadius = isCompact ? 6 : 8;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.birchWood,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.ebonyBrown.withAlpha(77),
          width: isCompact ? 1 : 2,
          style: BorderStyle.none,
        ),
      ),
      child: Center(
        child: tile != null
            ? MahjongTileWidget(
                tile: tile!,
                isInHand: true,
                isCompact: isCompact,
              )
            : null,
      ),
    );
  }

  /// 检测当前设备是否为iPad
  bool _isIpadDevice(BuildContext context) {
    // 获取屏幕尺寸
    final Size screenSize = MediaQuery.of(context).size;
    final double shortestSide = screenSize.shortestSide;

    // iPad通常短边大于600dp
    return shortestSide >= 600;
  }
}
