import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// 嬗变能力槽组件
class TransmuteSlot extends StatelessWidget {
  final bool isFilled;
  final VoidCallback? onTap;

  const TransmuteSlot({Key? key, this.isFilled = false, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isFilled) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondaryAccent,
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryAccent.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: AppColors.secondaryAccent.withOpacity(0.6),
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Icon(Icons.bolt, color: Colors.white, size: 24),
        ),
      );
    } else {
      return SizedBox(
        width: 48,
        height: 48,
        child: CustomPaint(
          painter: HexagonOutlinePainter(
            color: AppColors.secondaryAccent,
            strokeWidth: 3,
          ),
        ),
      );
    }
  }
}

/// 六边形轮廓绘制器
class HexagonOutlinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  HexagonOutlinePainter({required this.color, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(width * 0.25, 0); // 左上角
    path.lineTo(width * 0.75, 0); // 右上角
    path.lineTo(width, height * 0.5); // 右中
    path.lineTo(width * 0.75, height); // 右下角
    path.lineTo(width * 0.25, height); // 左下角
    path.lineTo(0, height * 0.5); // 左中
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 嬗变能力组件
class TransmuteWidget extends StatelessWidget {
  final int count;
  final int maxCount;
  final Function(int index) onSlotTap;

  const TransmuteWidget({
    Key? key,
    required this.count,
    this.maxCount = 3,
    required this.onSlotTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Transmute',
          style: TextStyle(
            color: AppColors.secondaryAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxCount, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: TransmuteSlot(
                isFilled: index < count,
                onTap: index < count ? () => onSlotTap(index) : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
