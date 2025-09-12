import 'package:flutter/material.dart';
import '../models/block.dart';
import '../utils/constants.dart';

/// 脉冲动画组件，用于选中的方块
class PulsingBlockAnimation extends StatefulWidget {
  final Widget child;

  const PulsingBlockAnimation({
    super.key,
    required this.child,
  });

  @override
  State<PulsingBlockAnimation> createState() => _PulsingBlockAnimationState();
}

class _PulsingBlockAnimationState
    extends State<PulsingBlockAnimation> //sdasdasd
    with
        SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // 创建缩放动画
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 创建透明度动画，使边缘发光效果闪烁
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.4, end: 1.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.4),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 设置动画重复
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// 游戏棋盘组件
class GameBoard extends StatelessWidget {
  final List<List<Block>> board;
  final Function(Block) onBlockTap;

  const GameBoard({
    super.key,
    required this.board,
    required this.onBlockTap,
  });

  @override
  Widget build(BuildContext context) {
    // 计算方块大小，根据棋盘大小自适应
    // 获取屏幕宽度的85%作为棋盘最大宽度
    final maxBoardSize = MediaQuery.of(context).size.width * 0.85;
    // 每行方块数量
    final blocksPerRow = board[0].length;
    // 计算每个方块的大小，留出边距和padding
    final blockSize = (maxBoardSize - 24.0) / blocksPerRow - 4.0;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          board.length,
          (rowIndex) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                board[rowIndex].length,
                (colIndex) => _buildBlockItem(
                  board[rowIndex][colIndex],
                  blockSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlockItem(Block block, double size) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: block.isRemoved
          ? Container(
              key: ValueKey('removed-${block.row}-${block.col}'),
              width: size,
              height: size,
              margin: const EdgeInsets.all(2),
            )
          : Material(
              key: ValueKey('block-${block.row}-${block.col}'),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(size * 0.2),
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.1),
                onTap: () => onBlockTap(block),
                child: block.isSelected
                    ? _buildSelectedBlock(block, size)
                    : _buildNormalBlock(block, size),
              ),
            ),
    );
  }

  Widget _buildSelectedBlock(Block block, double size) {
    final innerCircleSize = size * 0.33; // 内部圆圈大小比例
    final borderWidth = size * 0.05; // 边框宽度比例

    return PulsingBlockAnimation(
      child: Stack(
        children: [
          // 发光效果底层
          Container(
            width: size,
            height: size,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentMintGreen.withOpacity(0.6),
                  blurRadius: size * 0.25,
                  spreadRadius: size * 0.04,
                ),
              ],
            ),
          ),
          // 方块主体
          Container(
            width: size,
            height: size,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  block.color.withOpacity(0.9),
                  block.color,
                ],
              ),
              borderRadius: BorderRadius.circular(size * 0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, size * 0.04),
                  blurRadius: size * 0.08,
                ),
              ],
              border: Border.all(
                color: AppColors.accentMintGreen,
                width: borderWidth,
              ),
            ),
            // 内部装饰
            child: Center(
              child: Container(
                width: innerCircleSize,
                height: innerCircleSize,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: size * 0.16,
                      spreadRadius: size * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalBlock(Block block, double size) {
    final innerCircleSize = size * 0.25; // 内部圆圈大小比例
    final borderWidth = size * 0.01; // 边框宽度比例

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            block.color.withOpacity(0.9),
            block.color,
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: Offset(0, size * 0.06),
            blurRadius: size * 0.1,
            spreadRadius: size * 0.01,
          ),
          BoxShadow(
            color: block.color.withOpacity(0.3),
            offset: Offset(0, size * 0.02),
            blurRadius: size * 0.08,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: borderWidth,
        ),
      ),
      child: Center(
        child: Container(
          width: innerCircleSize,
          height: innerCircleSize,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
