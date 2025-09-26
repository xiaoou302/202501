import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/data/models/hot_topic_model.dart';

/// 热门话题卡片组件
class HotTopicCard extends StatefulWidget {
  final HotTopicModel topic;
  final VoidCallback? onTap;

  const HotTopicCard({super.key, required this.topic, this.onTap});

  @override
  State<HotTopicCard> createState() => _HotTopicCardState();
}

class _HotTopicCardState extends State<HotTopicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 根据分类获取颜色
  Color _getCategoryColor() {
    switch (widget.topic.category) {
      case 'Dating':
        return const Color(0xFFFF6B8B); // Soft pink
      case 'Marriage':
        return const Color(0xFF9C89FF); // Soft purple
      case 'Conflict':
        return const Color(0xFFFF9F45); // Soft orange
      case 'Communication':
        return const Color(0xFF5EBBFF); // Soft blue
      case 'Growth':
        return const Color(0xFF5BD6B8); // Soft teal
      default:
        return AppTheme.champagne;
    }
  }

  // 根据分类获取图标
  IconData _getCategoryIcon() {
    switch (widget.topic.category) {
      case 'Dating':
        return Icons.favorite_rounded;
      case 'Marriage':
        return Icons.volunteer_activism_rounded;
      case 'Conflict':
        return Icons.psychology_rounded;
      case 'Communication':
        return Icons.forum_rounded;
      case 'Growth':
        return Icons.trending_up_rounded;
      default:
        return Icons.lightbulb_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();
    final categoryIcon = _getCategoryIcon();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
            _animationController.forward();
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
            _animationController.reverse();
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
            _animationController.reverse();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isPressed
                    ? categoryColor
                    : ColorUtils.withOpacity(categoryColor, 0.3),
                width: _isPressed ? 2.0 : 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: null, // 使用GestureDetector处理点击
                  borderRadius: BorderRadius.circular(20),
                  splashColor: ColorUtils.withOpacity(categoryColor, 0.2),
                  highlightColor: ColorUtils.withOpacity(categoryColor, 0.1),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorUtils.withOpacity(AppTheme.deepSpace, 0.95),
                          ColorUtils.withOpacity(AppTheme.silverstone, 0.85),
                        ],
                        stops: const [0.2, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.2),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题和图标
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.topic.title,
                                style: const TextStyle(
                                  color: AppTheme.moonlight,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    categoryColor.withOpacity(0.8),
                                    categoryColor.withOpacity(0.6),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: categoryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                categoryIcon,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // 描述
                        Text(
                          widget.topic.description,
                          style: TextStyle(
                            color: ColorUtils.withOpacity(
                              AppTheme.moonlight,
                              0.8,
                            ),
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        // 底部信息
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 分类标签
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    categoryColor.withOpacity(0.3),
                                    categoryColor.withOpacity(0.15),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: categoryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: categoryColor.withOpacity(0.1),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.topic.category,
                                style: TextStyle(
                                  color: categoryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 热度指标和NEW标签
                            Row(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: ColorUtils.withOpacity(
                                    AppTheme.moonlight,
                                    0.6,
                                  ),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.topic.popularity}',
                                  style: TextStyle(
                                    color: ColorUtils.withOpacity(
                                      AppTheme.moonlight,
                                      0.6,
                                    ),
                                    fontSize: 12,
                                  ),
                                ),

                                if (widget.topic.isNew) ...[
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFFF5252),
                                          Color(0xFFFF1744),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.redAccent.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 6,
                                          spreadRadius: 0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'NEW',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
