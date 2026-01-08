import 'package:flutter/material.dart';
import '../../../../app/theme/color_palette.dart';
import '../../data/models/suggested_question.dart';

class TopicCard extends StatelessWidget {
  final SuggestedQuestion question;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.question,
    required this.onTap,
  });

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Photography':
        return const Color(0xFF6366F1);
      case 'Seasonal':
        return const Color(0xFFEC4899);
      case 'Body Type':
        return const Color(0xFF8B5CF6);
      case 'Style Guide':
        return const Color(0xFF10B981);
      case 'Color':
        return const Color(0xFFF59E0B);
      case 'Occasion':
        return const Color(0xFF06B6D4);
      case 'Posing':
        return const Color(0xFFEF4444);
      case 'Accessories':
        return const Color(0xFFF97316);
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(question.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.gray.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 背景装饰
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // 内容
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 图标和分类
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            question.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 分类标签
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        question.category,
                        style: TextStyle(
                          fontSize: 10,
                          color: categoryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 问题文本
                  Flexible(
                    child: Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: AppColors.text,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 箭头图标
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: categoryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
