import 'package:flutter/material.dart';
import '../../data/models/emotion_tag_model.dart';

class EmotionTagChip extends StatelessWidget {
  final EmotionTag tag;

  const EmotionTagChip({
    super.key,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tag.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag.name,
        style: TextStyle(
          color: tag.color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
