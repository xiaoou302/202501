import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../models/memory_card.dart';
import '../../core/utils/haptic_feedback.dart';
import '../../utils/card_icons.dart';

/// 卡片背景绘制器
class CardBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // 绘制网格图案
    final double gridSize = 10;
    for (double i = 0; i <= size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i <= size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // 绘制对角线
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);

    // 绘制圆形
    final Paint circlePaint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 3,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 记忆游戏卡片组件
class MemoryCardWidget extends StatefulWidget {
  /// 卡片数据
  final MemoryCard card;

  /// 点击回调
  final VoidCallback onTap;

  const MemoryCardWidget({super.key, required this.card, required this.onTap});

  @override
  State<MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<MemoryCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = false;
  final HapticFeedbackManager _hapticFeedback = HapticFeedbackManager();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _animation.addListener(() {
      if (_animation.value >= 0.5 && !_isFrontVisible) {
        setState(() {
          _isFrontVisible = true;
        });
      } else if (_animation.value < 0.5 && _isFrontVisible) {
        setState(() {
          _isFrontVisible = false;
        });
      }
    });

    if (widget.card.isFlipped || widget.card.isMatched) {
      _isFrontVisible = true;
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(MemoryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.isFlipped != oldWidget.card.isFlipped) {
      if (widget.card.isFlipped) {
        _controller.forward();
        _hapticFeedback.lightImpact();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.card.isFlipped && !widget.card.isMatched) {
          widget.onTap();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final double value = _animation.value;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(math.pi * value);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: _isFrontVisible ? _buildFrontCard() : _buildBackCard(),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    final cardColor = _getCardColor(widget.card.cardColor);
    final bool isMatched = widget.card.isMatched;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isMatched ? cardColor.withOpacity(0.3) : cardColor.withOpacity(0.7),
            isMatched ? cardColor.withOpacity(0.1) : cardColor.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isMatched
            ? [
                BoxShadow(
                  color: cardColor.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
        border: Border.all(
          color: isMatched ? cardColor : cardColor.withOpacity(0.3),
          width: isMatched ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          if (widget.card.scoreMultiplier > 1.0)
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.card.scoreMultiplier}x',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

          Center(child: _getIconForCard(widget.card.icon)),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..rotateY(math.pi),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.cardBackground, const Color(0xFF333333)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // 背景图案
            Positioned.fill(
              child: CustomPaint(painter: CardBackgroundPainter()),
            ),
            // 中心图标
            Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.question_mark,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取卡片颜色
  Color _getCardColor(CardColor cardColor) {
    switch (cardColor) {
      case CardColor.blue:
        return Colors.blue;
      case CardColor.green:
        return Colors.green;
      case CardColor.orange:
        return Colors.orange;
      case CardColor.purple:
        return Colors.purple;
      case CardColor.red:
        return Colors.red;
      case CardColor.teal:
        return Colors.teal;
      case CardColor.pink:
        return Colors.pink;
      case CardColor.amber:
        return Colors.amber;
    }
  }

  Widget _getIconForCard(String iconName) {
    // 使用CardIcons工具类获取图标数据
    IconData iconData = CardIcons.getIconData(iconName);

    // 卡片匹配后使用卡片颜色，否则使用白色
    final Color iconColor = widget.card.isMatched
        ? _getCardColor(widget.card.cardColor)
        : Colors.white;

    return Icon(iconData, size: 40, color: iconColor);
  }
}
