import 'package:flutter/material.dart';
import '../models/match_template.dart';
import '../utils/constants.dart';

/// 匹配模板项组件
class MatchTemplateItem extends StatelessWidget {
  final MatchTemplate template;
  final bool isActive;
  final VoidCallback onTap;

  const MatchTemplateItem({
    super.key,
    required this.template,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [
                    AppColors.accentMintGreen.withOpacity(0.3),
                    AppColors.accentMintGreen.withOpacity(0.1),
                  ]
                : [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.15),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.accentMintGreen.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ],
          border: Border.all(
            color: isActive
                ? AppColors.accentMintGreen
                : Colors.white.withOpacity(0.1),
            width: isActive ? 2 : 1,
          ),
        ),
        child: _buildTemplateBlocks(),
      ),
    );
  }

  Widget _buildTemplateBlocks() {
    // 根据模板方向构建不同的布局
    if (template.orientation == Axis.horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildColorBlocks(),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildColorBlocks(),
      );
    }
  }

  List<Widget> _buildColorBlocks() {
    return template.colors.map((color) {
      return Container(
        width: 28,
        height: 28,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.9),
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 3,
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 0.5,
          ),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }).toList();
  }
}
