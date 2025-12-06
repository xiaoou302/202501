import 'package:flutter/material.dart';
import '../../models/tile_model.dart';
import '../../core/constants.dart';

class TileContent extends StatelessWidget {
  final TileType type;
  final int number;
  final double scale;

  const TileContent({
    super.key,
    required this.type,
    required this.number,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TileType.wan:
        return _buildWan();
      case TileType.tong:
        return _buildTong();
      case TileType.tiao:
        return _buildTiao();
    }
  }

  // 万字牌
  Widget _buildWan() {
    return Transform.scale(
      scale: scale,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            GameConstants.chineseNums[number - 1],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.vermillion,
              height: 0.9,
              shadows: [
                Shadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: const Offset(0, 1),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          Text(
            '萬',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.vermillion,
              height: 1.0,
              shadows: [
                Shadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: const Offset(0, 1),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 筒字牌（饼子）
  Widget _buildTong() {
    // 一筒特殊设计：大圆圈+红色中心
    if (number == 1) {
      return Transform.scale(
        scale: scale,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.jadeGreen,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 3,
                offset: const Offset(0, 1),
                spreadRadius: -1,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.vermillion,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Transform.scale(scale: scale, child: _buildTongLayout());
  }

  Widget _buildTongLayout() {
    // 二筒：上下排列
    if (number == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(16, AppColors.jadeBlue),
          const SizedBox(height: 18),
          _buildDot(16, AppColors.jadeGreen),
        ],
      );
    }

    // 三筒：对角线排列（45度旋转）
    if (number == 3) {
      return Transform.rotate(
        angle: 0.785398,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(11, AppColors.jadeBlue),
            const SizedBox(height: 5),
            _buildDot(11, AppColors.vermillion),
            const SizedBox(height: 5),
            _buildDot(11, AppColors.jadeGreen),
          ],
        ),
      );
    }

    // 四筒：2x2网格
    if (number == 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(11, AppColors.jadeBlue),
              const SizedBox(height: 10),
              _buildDot(11, AppColors.jadeBlue),
            ],
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(11, AppColors.jadeBlue),
              const SizedBox(height: 10),
              _buildDot(11, AppColors.jadeBlue),
            ],
          ),
        ],
      );
    }

    // 五筒：四角+中心
    if (number == 5) {
      return SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: 0, left: 0, child: _buildDot(11, AppColors.jadeBlue)),
            Positioned(top: 0, right: 0, child: _buildDot(11, AppColors.jadeBlue)),
            Positioned(bottom: 0, left: 0, child: _buildDot(11, AppColors.jadeBlue)),
            Positioned(bottom: 0, right: 0, child: _buildDot(11, AppColors.jadeBlue)),
            Center(child: _buildDot(13, AppColors.vermillion)),
          ],
        ),
      );
    }

    // 六筒：两列各三个
    if (number == 6) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(11, AppColors.jadeBlue),
              const SizedBox(height: 5),
              _buildDot(11, AppColors.jadeBlue),
              const SizedBox(height: 5),
              _buildDot(11, AppColors.jadeBlue),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(11, AppColors.jadeBlue),
              const SizedBox(height: 5),
              _buildDot(11, AppColors.jadeBlue),
              const SizedBox(height: 5),
              _buildDot(11, AppColors.jadeBlue),
            ],
          ),
        ],
      );
    }

    // 七筒：3+2+2布局，前3个绿色
    if (number == 7) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(10, AppColors.jadeGreen),
              const SizedBox(width: 4),
              _buildDot(10, AppColors.jadeGreen),
              const SizedBox(width: 4),
              _buildDot(10, AppColors.jadeGreen),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(10, AppColors.jadeBlue),
              const SizedBox(width: 4),
              _buildDot(10, AppColors.jadeBlue),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(10, AppColors.jadeBlue),
              const SizedBox(width: 4),
              _buildDot(10, AppColors.jadeBlue),
            ],
          ),
        ],
      );
    }

    // 八筒：两列各四个
    if (number == 8) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(height: 4),
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(height: 4),
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(height: 4),
              _buildDot(9, AppColors.jadeBlue),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(height: 4),
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(height: 4),
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(height: 4),
              _buildDot(9, AppColors.jadeBlue),
            ],
          ),
        ],
      );
    }

    // 九筒：3x3网格
    if (number == 9) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(width: 3),
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(width: 3),
              _buildDot(9, AppColors.jadeBlue),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(width: 3),
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(width: 3),
              _buildDot(9, AppColors.jadeBlue),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(width: 3),
              _buildDot(9, AppColors.jadeBlue),
              const SizedBox(width: 3),
              _buildDot(9, AppColors.jadeBlue),
            ],
          ),
        ],
      );
    }

    return const SizedBox();
  }

  // 创建圆点
  Widget _buildDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 2,
            offset: const Offset(0.5, 0.5),
            spreadRadius: -0.5,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
    );
  }

  // 条字牌（竹条）
  Widget _buildTiao() {
    // 一条特殊：鸟图标
    if (number == 1) {
      return Transform.scale(
        scale: scale,
        child: Icon(
          Icons.flutter_dash,
          size: 32,
          color: AppColors.jadeGreen,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      );
    }

    return Transform.scale(scale: scale, child: _buildTiaoLayout());
  }

  Widget _buildTiaoLayout() {
    // 二条：竖直排列
    if (number == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBamboo(AppColors.jadeGreen),
          const SizedBox(height: 10),
          _buildBamboo(AppColors.jadeGreen),
        ],
      );
    }

    // 三条：中间红色
    if (number == 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBamboo(AppColors.jadeGreen),
          const SizedBox(height: 5),
          _buildBamboo(AppColors.vermillion),
          const SizedBox(height: 5),
          _buildBamboo(AppColors.jadeGreen),
        ],
      );
    }

    // 四条：2x2布局
    if (number == 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 10),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 10),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
        ],
      );
    }

    // 五条：2+1+2布局，中间红色
    if (number == 5) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 10),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
          const SizedBox(width: 6),
          _buildBamboo(AppColors.vermillion),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 10),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
        ],
      );
    }

    // 六条：两列各三个
    if (number == 6) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 5),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 5),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 5),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 5),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
        ],
      );
    }

    // 七条：3+2+2布局
    if (number == 7) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
        ],
      );
    }

    // 八条：两列各四个
    if (number == 8) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 4),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 4),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 4),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 4),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 4),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(height: 4),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
        ],
      );
    }

    // 九条：3x3网格
    if (number == 9) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
              const SizedBox(width: 3),
              _buildBamboo(AppColors.jadeGreen),
            ],
          ),
        ],
      );
    }

    return const SizedBox();
  }

  // 创建竹条
  Widget _buildBamboo(Color color) {
    return Container(
      width: 4,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(0.5, 0.5),
            spreadRadius: -0.5,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
    );
  }
}
