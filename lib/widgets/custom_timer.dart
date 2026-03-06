import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/color_palette.dart';

class CustomTimer extends StatelessWidget {
  final int seconds;
  final double fontSize;
  final Color color;

  const CustomTimer({
    super.key,
    required this.seconds,
    this.fontSize = 80,
    this.color = ColorPalette.concrete,
  });

  String get _formattedTime {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedTime,
      style: AppTheme.monoStyle.copyWith(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w300,
        letterSpacing: -2.0,
      ),
    );
  }
}
