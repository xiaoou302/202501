import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final Function(String) onMoodSelected;

  const MoodSelector({
    Key? key,
    this.selectedMood,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '你现在的心情如何？',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE0E0E0),
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildMoodItem('开心', '😊', Color(0xFFFEE440)),
              _buildMoodItem('平静', '😌', Color(0xFF4FC1B9)),
              _buildMoodItem('疲惫', '😴', Color(0xFF9B5DE5)),
              _buildMoodItem('焦虑', '😰', Color(0xFF00BBF9)),
              _buildMoodItem('伤心', '😢', Color(0xFFFF6B6B)),
              _buildMoodItem('愤怒', '😠', Color(0xFFD97C29)),
              _buildMoodItem('惊喜', '😲', Color(0xFFF15BB5)),
              _buildMoodItem('困惑', '🤔', Color(0xFF00F5D4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodItem(String mood, String emoji, Color color) {
    final isSelected = selectedMood == mood;

    return GestureDetector(
      onTap: () => onMoodSelected(mood),
      child: Container(
        width: 70,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Color(0xFF152642),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            SizedBox(height: 4),
            Text(
              mood,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? color : Color(0xFFE0E0E0).withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
