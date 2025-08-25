import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// 六边形剪裁路径
class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
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

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// 六边形组件
class Hexagon extends StatelessWidget {
  final Widget child;
  final double size;
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final bool isGlowing;
  final Color glowColor;
  final VoidCallback? onTap;

  const Hexagon({
    Key? key,
    required this.child,
    this.size = 80.0,
    this.color = AppColors.primaryAccent,
    this.borderColor,
    this.borderWidth = 2.0,
    this.isGlowing = false,
    this.glowColor = AppColors.primaryAccent,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size * 0.866, // 六边形高度与宽度的比例约为0.866
        decoration: isGlowing
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: glowColor.withOpacity(0.6),
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ],
              )
            : null,
        child: Stack(
          children: [
            if (borderColor != null)
              ClipPath(
                clipper: HexagonClipper(),
                child: Container(
                  width: size,
                  height: size * 0.866,
                  color: borderColor,
                ),
              ),
            Padding(
              padding: EdgeInsets.all(borderColor != null ? borderWidth : 0),
              child: ClipPath(
                clipper: HexagonClipper(),
                child: Container(
                  width: size - (borderColor != null ? borderWidth * 2 : 0),
                  height:
                      (size * 0.866) -
                      (borderColor != null ? borderWidth * 2 : 0),
                  color: color,
                  child: Center(child: child),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 六边形关卡组件
class LevelHexagon extends StatelessWidget {
  final int level;
  final int stars;
  final bool isUnlocked;
  final bool isSelected;
  final VoidCallback? onTap;

  const LevelHexagon({
    Key? key,
    required this.level,
    this.stars = 0,
    this.isUnlocked = false,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 根据状态确定颜色和内容
    Color hexColor;
    Color textColor;
    Widget content;

    if (isSelected) {
      hexColor = AppColors.secondaryAccent;
      textColor = Colors.white;
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$level',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else if (isUnlocked) {
      hexColor = AppColors.primaryAccent;
      textColor = AppColors.primaryDark;
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$level',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: textColor,
                size: 12,
              );
            }),
          ),
        ],
      );
    } else {
      hexColor = Colors.transparent;
      textColor = AppColors.textColor.withOpacity(0.5);
      content = Icon(Icons.lock, color: textColor, size: 24);
    }

    return Hexagon(
      color: hexColor,
      borderColor: isUnlocked ? null : AppColors.textColor.withOpacity(0.3),
      isGlowing: isUnlocked || isSelected,
      glowColor: isSelected
          ? AppColors.secondaryAccent
          : AppColors.primaryAccent,
      onTap: isUnlocked ? onTap : null,
      child: content,
    );
  }
}
