import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/mahjong_constants.dart';
import '../../data/models/mahjong_tile_model.dart';

/// Widget for rendering a mahjong tile
class MahjongTileWidget extends StatelessWidget {
  /// The tile data
  final MahjongTile tile;

  /// Callback when the tile is tapped
  final VoidCallback? onTap;

  /// Whether the tile is in the hand
  final bool isInHand;

  /// Whether to use compact mode (smaller size)
  final bool isCompact;

  /// Constructor
  const MahjongTileWidget({
    super.key,
    required this.tile,
    this.onTap,
    this.isInHand = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    // 检测是否为iPad设备
    final bool isIpad = _isIpadDevice(context);

    // 计算尺寸缩放比例
    final double ipadScaleFactor = isIpad ? 1.4 : 1.0; // 增加到 1.4 (40% 放大)

    final double scaleFactor = isCompact
        ? 0.75
        : (isInHand ? UISizes.handTileScale : 1.0);

    final double width = UISizes.tileSizeWidth * scaleFactor * ipadScaleFactor;
    final double height =
        UISizes.tileSizeHeight * scaleFactor * ipadScaleFactor;

    return GestureDetector(
      onTap: tile.isSelectable ? onTap : null,
      child: AnimatedContainer(
        duration: AnimationDurations.tileSelect,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.birchWood),
          boxShadow: [
            BoxShadow(
              color: AppColors.birchWood,
              offset: const Offset(1, 1),
              blurRadius: 0,
            ),
            BoxShadow(
              color: AppColors.birchWood,
              offset: const Offset(2, 2),
              blurRadius: 0,
            ),
            BoxShadow(
              color: AppColors.birchWood,
              offset: const Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: _buildTileFace(),
      ),
    );
  }

  Widget _buildTileFace() {
    // Check if this is a wan (character) tile
    if (tile.type.startsWith(MahjongConstants.wanSuit)) {
      final num = int.parse(tile.type.substring(1));
      return _buildWanTile(num);
    }

    // Check if this is a tong (circle) tile
    if (tile.type.startsWith(MahjongConstants.tongSuit)) {
      final num = int.parse(tile.type.substring(1));
      return _buildTongTile(num);
    }

    // Check if this is a tiao (bamboo) tile
    if (tile.type.startsWith(MahjongConstants.tiaoSuit)) {
      final num = int.parse(tile.type.substring(1));
      return _buildTiaoTile(num);
    }

    // Check if this is a wind tile
    if (tile.type.startsWith(MahjongConstants.windPrefix)) {
      return _buildWindTile();
    }

    // Check if this is a dragon tile
    if (tile.type.startsWith(MahjongConstants.dragonPrefix)) {
      return _buildDragonTile();
    }

    // Default fallback
    return const Center(child: Text('?'));
  }

  Widget _buildWanTile(int number) {
    final Map<int, String> wanChars = {
      1: '一',
      2: '二',
      3: '三',
      4: '四',
      5: '五',
      6: '六',
      7: '七',
      8: '八',
      9: '九',
    };

    // Fix for overflow: use FittedBox to ensure text fits within the container
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use min to avoid expansion
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              wanChars[number] ?? '?',
              style: TextStyle(
                fontSize: isInHand ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: AppColors.ebonyBrown,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '萬',
              style: TextStyle(
                fontSize: isInHand ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: AppColors.mahjongRed,
                fontFamily: 'serif',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTongTile(int number) {
    return Center(
      child: CustomPaint(
        size: Size(isInHand ? 36 : 40, isInHand ? 54 : 60),
        painter: TongPainter(number),
      ),
    );
  }

  Widget _buildTiaoTile(int number) {
    if (number == 1) {
      return Center(
        child: Icon(
          Icons.spa,
          size: isInHand ? 32 : 36,
          color: AppColors.mahjongGreen,
        ),
      );
    }

    return Center(
      child: CustomPaint(
        size: Size(isInHand ? 36 : 40, isInHand ? 54 : 60),
        painter: TiaoPainter(number),
      ),
    );
  }

  Widget _buildWindTile() {
    final Map<String, String> windChars = {
      MahjongConstants.eastWind: '東',
      MahjongConstants.southWind: '南',
      MahjongConstants.westWind: '西',
      MahjongConstants.northWind: '北',
    };

    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          windChars[tile.type] ?? '?',
          style: TextStyle(
            fontSize: isInHand ? 22 : 26,
            fontWeight: FontWeight.bold,
            color: AppColors.ebonyBrown,
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }

  Widget _buildDragonTile() {
    if (tile.type == MahjongConstants.redDragon) {
      return Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            '中',
            style: TextStyle(
              fontSize: isInHand ? 22 : 26,
              fontWeight: FontWeight.bold,
              color: AppColors.mahjongRed,
              fontFamily: 'serif',
            ),
          ),
        ),
      );
    }

    if (tile.type == MahjongConstants.greenDragon) {
      return Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            '發',
            style: TextStyle(
              fontSize: isInHand ? 22 : 26,
              fontWeight: FontWeight.bold,
              color: AppColors.carvedJadeGreen,
              fontFamily: 'serif',
            ),
          ),
        ),
      );
    }

    if (tile.type == MahjongConstants.whiteDragon) {
      return Center(
        child: Container(
          width: isInHand ? 24 : 28,
          height: isInHand ? 30 : 36,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mahjongBlue, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    return const Center(child: Text('?'));
  }
}

/// Custom painter for tong (circle) tiles
class TongPainter extends CustomPainter {
  final int number;

  TongPainter(this.number);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.carvedJadeGreen
      ..style = PaintingStyle.fill;

    final positions = _getPositions(number, size);
    final radius = number == 1 ? 9.0 : 4.0;

    for (final position in positions) {
      canvas.drawCircle(Offset(position.dx, position.dy), radius, paint);
    }
  }

  List<Offset> _getPositions(int number, Size size) {
    final width = size.width;
    final height = size.height;

    switch (number) {
      case 1:
        return [Offset(width / 2, height / 2)];
      case 2:
        return [
          Offset(width / 2, height * 0.25),
          Offset(width / 2, height * 0.75),
        ];
      case 3:
        return [
          Offset(width * 0.25, height * 0.25),
          Offset(width / 2, height / 2),
          Offset(width * 0.75, height * 0.75),
        ];
      case 4:
        return [
          Offset(width * 0.3, height * 0.25),
          Offset(width * 0.7, height * 0.25),
          Offset(width * 0.3, height * 0.75),
          Offset(width * 0.7, height * 0.75),
        ];
      case 5:
        return [
          Offset(width * 0.3, height * 0.25),
          Offset(width * 0.7, height * 0.25),
          Offset(width / 2, height / 2),
          Offset(width * 0.3, height * 0.75),
          Offset(width * 0.7, height * 0.75),
        ];
      case 6:
        return [
          Offset(width * 0.3, height * 0.2),
          Offset(width * 0.7, height * 0.2),
          Offset(width * 0.3, height * 0.5),
          Offset(width * 0.7, height * 0.5),
          Offset(width * 0.3, height * 0.8),
          Offset(width * 0.7, height * 0.8),
        ];
      case 7:
        return [
          Offset(width * 0.3, height * 0.17),
          Offset(width * 0.7, height * 0.17),
          Offset(width / 2, height * 0.37),
          Offset(width * 0.3, height * 0.57),
          Offset(width * 0.7, height * 0.57),
          Offset(width * 0.3, height * 0.77),
          Offset(width * 0.7, height * 0.77),
        ];
      case 8:
        return [
          Offset(width * 0.3, height * 0.2),
          Offset(width * 0.7, height * 0.2),
          Offset(width * 0.3, height * 0.4),
          Offset(width * 0.7, height * 0.4),
          Offset(width * 0.3, height * 0.6),
          Offset(width * 0.7, height * 0.6),
          Offset(width * 0.3, height * 0.8),
          Offset(width * 0.7, height * 0.8),
        ];
      case 9:
        return [
          Offset(width * 0.25, height * 0.17),
          Offset(width * 0.5, height * 0.17),
          Offset(width * 0.75, height * 0.17),
          Offset(width * 0.25, height * 0.5),
          Offset(width * 0.5, height * 0.5),
          Offset(width * 0.75, height * 0.5),
          Offset(width * 0.25, height * 0.83),
          Offset(width * 0.5, height * 0.83),
          Offset(width * 0.75, height * 0.83),
        ];
      default:
        return [];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for tiao (bamboo) tiles
class TiaoPainter extends CustomPainter {
  final int number;

  TiaoPainter(this.number);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.mahjongGreen
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final positions = _getPositions(number, size);

    for (final position in positions) {
      final rect = Rect.fromCenter(
        center: Offset(position.dx, position.dy),
        width: 6,
        height: 14,
      );

      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));

      canvas.drawRRect(rrect, paint);
    }
  }

  List<Offset> _getPositions(int number, Size size) {
    final width = size.width;
    final height = size.height;

    switch (number) {
      case 2:
        return [Offset(width / 2, height / 2)];
      case 3:
        return [
          Offset(width / 2, height * 0.3),
          Offset(width * 0.3, height * 0.7),
          Offset(width * 0.7, height * 0.7),
        ];
      case 4:
        return [
          Offset(width * 0.3, height * 0.3),
          Offset(width * 0.7, height * 0.3),
          Offset(width * 0.3, height * 0.7),
          Offset(width * 0.7, height * 0.7),
        ];
      case 5:
        return [
          Offset(width * 0.3, height * 0.3),
          Offset(width * 0.7, height * 0.3),
          Offset(width / 2, height / 2),
          Offset(width * 0.3, height * 0.7),
          Offset(width * 0.7, height * 0.7),
        ];
      case 6:
        return [
          Offset(width * 0.3, height * 0.3),
          Offset(width / 2, height * 0.3),
          Offset(width * 0.7, height * 0.3),
          Offset(width * 0.3, height * 0.7),
          Offset(width / 2, height * 0.7),
          Offset(width * 0.7, height * 0.7),
        ];
      case 7:
        return [
          Offset(width / 2, height * 0.17),
          Offset(width * 0.3, height * 0.47),
          Offset(width / 2, height * 0.47),
          Offset(width * 0.7, height * 0.47),
          Offset(width * 0.3, height * 0.77),
          Offset(width / 2, height * 0.77),
          Offset(width * 0.7, height * 0.77),
        ];
      case 8:
        return [
          Offset(width * 0.3, height * 0.2),
          Offset(width * 0.7, height * 0.2),
          Offset(width * 0.3, height * 0.4),
          Offset(width * 0.7, height * 0.4),
          Offset(width * 0.3, height * 0.6),
          Offset(width * 0.7, height * 0.6),
          Offset(width * 0.3, height * 0.8),
          Offset(width * 0.7, height * 0.8),
        ];
      case 9:
        return [
          Offset(width * 0.25, height * 0.17),
          Offset(width * 0.5, height * 0.17),
          Offset(width * 0.75, height * 0.17),
          Offset(width * 0.25, height * 0.5),
          Offset(width * 0.5, height * 0.5),
          Offset(width * 0.75, height * 0.5),
          Offset(width * 0.25, height * 0.83),
          Offset(width * 0.5, height * 0.83),
          Offset(width * 0.75, height * 0.83),
        ];
      default:
        return [];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 检测当前设备是否为iPad
bool _isIpadDevice(BuildContext context) {
  // 获取屏幕尺寸
  final Size screenSize = MediaQuery.of(context).size;
  final double shortestSide = screenSize.shortestSide;

  // iPad通常短边大于600dp
  return shortestSide >= 600;
}
