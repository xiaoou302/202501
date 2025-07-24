import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TagInput extends StatefulWidget {
  final List<String> tags;
  final Function(List<String>) onTagsChanged;
  final Color accentColor;

  const TagInput({
    Key? key,
    required this.tags,
    required this.onTagsChanged,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _suggestedTags = [
    '工作',
    '学习',
    '旅行',
    '家庭',
    '健康',
    '运动',
    '美食',
    '电影',
    '音乐',
    '阅读',
    '写作',
    '思考',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _controller.text.trim();
    if (tag.isNotEmpty && !widget.tags.contains(tag)) {
      final updatedTags = List<String>.from(widget.tags)..add(tag);
      widget.onTagsChanged(updatedTags);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  void _removeTag(String tag) {
    final updatedTags = List<String>.from(widget.tags)..remove(tag);
    widget.onTagsChanged(updatedTags);
  }

  void _addSuggestedTag(String tag) {
    if (!widget.tags.contains(tag)) {
      final updatedTags = List<String>.from(widget.tags)..add(tag);
      widget.onTagsChanged(updatedTags);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '添加标签',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE0E0E0),
          ),
        ),
        SizedBox(height: 12),

        // Tag input field
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: '输入标签',
                  hintStyle: TextStyle(
                    color: Color(0xFFE0E0E0).withOpacity(0.5),
                  ),
                  prefixIcon: Icon(
                    FontAwesomeIcons.tag,
                    color: widget.accentColor,
                    size: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _addTag(),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: _addTag,
              icon: Icon(Icons.add_circle, color: widget.accentColor),
            ),
          ],
        ),

        // Current tags
        if (widget.tags.isNotEmpty) ...[
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tags.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: TextStyle(color: widget.accentColor, fontSize: 12),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeTag(tag),
                      child: Icon(
                        Icons.close,
                        color: widget.accentColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

        // Suggested tags
        if (_suggestedTags.isNotEmpty && widget.tags.length < 5) ...[
          SizedBox(height: 20),
          Text(
            '推荐标签',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFE0E0E0).withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _suggestedTags
                  .where((tag) => !widget.tags.contains(tag))
                  .take(8)
                  .map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(tag),
                        backgroundColor: Color(0xFF152642),
                        labelStyle: TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 12,
                        ),
                        onPressed: () => _addSuggestedTag(tag),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}
