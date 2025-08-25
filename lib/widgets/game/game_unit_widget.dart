import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../models/game_unit.dart';

/// 游戏单元图标
class UnitIcon extends StatelessWidget {
  final String shape;
  final Color color;
  final double size;

  const UnitIcon({
    Key? key,
    required this.shape,
    required this.color,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (shape) {
      case 'c': // 圆形
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      case 's': // 方形
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(size * 0.2),
          ),
        );
      case 't': // 三角形
        return CustomPaint(
          size: Size(size, size),
          painter: TrianglePainter(color: color),
        );
      default:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
    }
  }
}

/// 三角形绘制器
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 游戏单元组件
class GameUnitWidget extends StatefulWidget {
  final GameUnit unit;
  final double size;
  final VoidCallback? onTap;
  final bool showEffects;

  const GameUnitWidget({
    Key? key,
    required this.unit,
    this.size = 50.0,
    this.onTap,
    this.showEffects = true,
  }) : super(key: key);

  @override
  State<GameUnitWidget> createState() => _GameUnitWidgetState();
}

class _GameUnitWidgetState extends State<GameUnitWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _appearAnimation;

  // 用于标记单元是否是新创建的
  bool _isNewUnit = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 新单元出现动画
    _appearAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // 如果是选中状态，启动选中动画
    if (widget.unit.isSelected) {
      _controller.repeat(reverse: true);
    }
    // 否则，播放新单元出现动画
    else {
      _controller.forward().then((_) {
        // 动画完成后标记为非新单元
        setState(() {
          _isNewUnit = false;
        });
      });
    }
  }

  @override
  void didUpdateWidget(GameUnitWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 当选中状态改变时更新动画
    if (widget.unit.isSelected != oldWidget.unit.isSelected) {
      if (widget.unit.isSelected) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }

    // 检测位置变化，如果位置发生变化，播放动画
    if (widget.unit.position.row != oldWidget.unit.position.row ||
        widget.unit.position.col != oldWidget.unit.position.col) {
      // 位置变化时重置动画控制器并播放动画
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitColor = AppColors.getUnitColor(widget.unit.color);

    // 特殊效果
    final isSelected = widget.unit.isSelected;
    final isLocked = widget.unit.isLocked;
    final isChanging = widget.unit.isChanging;
    final isPolluted = widget.unit.isPolluted;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // 计算缩放和旋转效果
          double scale = isSelected ? _scaleAnimation.value : 1.0;
          double angle = isSelected ? _rotateAnimation.value : 0.0;

          // 如果是新单元或位置变化，应用出现动画
          if (_isNewUnit) {
            // 从上方掉落的效果
            return Transform.translate(
              offset: Offset(0, -50 * (1 - _appearAnimation.value)),
              child: Opacity(
                opacity: _appearAnimation.value,
                child: Transform.scale(
                  scale: 0.5 + 0.5 * _appearAnimation.value, // 从0.5倍大小开始
                  child: _buildUnitContent(
                    unitColor,
                    scale,
                    angle,
                    isSelected,
                    isLocked,
                    isChanging,
                    isPolluted,
                  ),
                ),
              ),
            );
          } else {
            // 正常显示
            return Transform.scale(
              scale: scale,
              child: Transform.rotate(
                angle: angle,
                child: _buildUnitContent(
                  unitColor,
                  scale,
                  angle,
                  isSelected,
                  isLocked,
                  isChanging,
                  isPolluted,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // 构建单元内容
  Widget _buildUnitContent(
    Color unitColor,
    double scale,
    double angle,
    bool isSelected,
    bool isLocked,
    bool isChanging,
    bool isPolluted,
  ) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isSelected && widget.showEffects
            ? [
                BoxShadow(
                  color: unitColor.withOpacity(0.7),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 主单元
          Container(
            width: widget.size * 0.85,
            height: widget.size * 0.85,
            decoration: BoxDecoration(
              color: unitColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: unitColor.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            child: Center(
              child: UnitIcon(
                shape: widget.unit.shape,
                color: Colors.white.withOpacity(0.8),
                size: widget.size * 0.5,
              ),
            ),
          ),

          // 锁定效果
          if (isLocked && widget.showEffects) _buildLockEffect(),

          // 变色龙效果
          if (isChanging && widget.showEffects) _buildChangingEffect(),

          // 污染效果
          if (isPolluted && widget.showEffects) _buildPollutedEffect(),
        ],
      ),
    );
  }

  // 锁定效果
  Widget _buildLockEffect() {
    return Container(
      width: widget.size * 0.85,
      height: widget.size * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withOpacity(0.5),
      ),
      child: Center(
        child: Icon(
          Icons.lock,
          color: Colors.white,
          size: widget.size * 0.5,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 5),
          ],
        ),
      ),
    );
  }

  // 变色龙效果
  Widget _buildChangingEffect() {
    return Container(
      width: widget.size * 0.85,
      height: widget.size * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white,
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        gradient: const SweepGradient(
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.purple,
            Colors.red,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.autorenew,
          color: Colors.white,
          size: widget.size * 0.4,
        ),
      ),
    );
  }

  // 污染效果
  Widget _buildPollutedEffect() {
    return Container(
      width: widget.size * 0.85,
      height: widget.size * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: RadialGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          stops: const [0.5, 1.0],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.warning_amber_rounded,
          color: Colors.amber,
          size: widget.size * 0.4,
        ),
      ),
    );
  }
}
