import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/idea_model.dart';

/// 灵感卡片组件
class IdeaCard extends StatelessWidget {
  /// 灵感模型
  final IdeaModel idea;

  /// 删除灵感回调
  final Function(String) onDelete;

  /// 编辑灵感回调（续写）
  final Function(IdeaModel) onEdit;

  /// 标签点击回调
  final Function(String)? onTagTap;

  const IdeaCard({
    Key? key,
    required this.idea,
    required this.onDelete,
    required this.onEdit,
    this.onTagTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagColor =
        AppColors.tagColors[idea.id.hashCode % AppColors.tagColors.length];

    return GestureDetector(
      onTap: () => _showDetailDialog(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusLarge),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: AppStyles.elevationMedium,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppStyles.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          idea.title,
                          style: AppStyles.heading3.copyWith(
                            color: tagColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppStyles.paddingSmall,
                          vertical: AppStyles.paddingTiny,
                        ),
                        decoration: AppStyles.tagDecoration(tagColor),
                        child: Text(
                          '${idea.chapterCount} ${idea.chapterCount == 1 ? 'Chapter' : 'Chapters'}',
                          style: AppStyles.caption.copyWith(
                            color: tagColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (idea.latestChapter != null) ...[
                    const SizedBox(height: AppStyles.paddingMedium),
                    Text(
                      idea.latestChapter!.title,
                      style: AppStyles.bodyText.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppStyles.paddingTiny),
                    Text(
                      idea.latestChapter!.content,
                      style: AppStyles.bodyText.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppStyles.paddingMedium),
                  Wrap(
                    spacing: AppStyles.paddingSmall,
                    runSpacing: AppStyles.paddingSmall,
                    children: idea.tags
                        .map((tag) => _buildTag(tag, tagColor))
                        .toList(),
                  ),
                  if (idea.updatedAt != null) ...[
                    const SizedBox(height: AppStyles.paddingSmall),
                    Text(
                      'Last updated ${_formatDate(idea.updatedAt!)}',
                      style: AppStyles.caption.copyWith(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundAlt,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppStyles.borderRadiusLarge),
                  bottomRight: Radius.circular(AppStyles.borderRadiusLarge),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.edit,
                      label: 'Continue',
                      onTap: () => onEdit(idea),
                      color: tagColor,
                    ),
                  ),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.delete,
                      label: 'Delete',
                      onTap: () => onDelete(idea.id),
                      color: tagColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag, Color color) {
    return GestureDetector(
      onTap: onTagTap != null ? () => onTagTap!(tag) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppStyles.paddingMedium,
          vertical: AppStyles.paddingSmall,
        ),
        decoration: AppStyles.tagDecoration(color),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_offer,
              size: AppStyles.iconSizeSmall,
              color: color,
            ),
            const SizedBox(width: AppStyles.paddingTiny),
            Text(
              tag,
              style: AppStyles.bodyTextSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppStyles.paddingMedium),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppColors.cardBorder,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppStyles.iconSizeSmall,
              color: color.withOpacity(0.9),
            ),
            const SizedBox(width: AppStyles.paddingSmall),
            Text(
              label,
              style: AppStyles.buttonTextSmall.copyWith(
                color: color.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    final tagColor =
        AppColors.tagColors[idea.id.hashCode % AppColors.tagColors.length];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusLarge),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppStyles.paddingMedium),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppStyles.paddingSmall),
                      decoration: BoxDecoration(
                        color: tagColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.menu_book, color: tagColor),
                    ),
                    const SizedBox(width: AppStyles.paddingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(idea.title, style: AppStyles.heading3),
                          Text(
                            '${idea.chapterCount} ${idea.chapterCount == 1 ? 'Chapter' : 'Chapters'}',
                            style: AppStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppStyles.paddingMedium),
                  itemCount: idea.chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = idea.chapters[index];
                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: AppStyles.paddingMedium),
                      padding: const EdgeInsets.all(AppStyles.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius:
                            BorderRadius.circular(AppStyles.borderRadiusMedium),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppStyles.paddingSmall,
                                  vertical: AppStyles.paddingTiny,
                                ),
                                decoration: AppStyles.tagDecoration(tagColor),
                                child: Text(
                                  'Chapter ${index + 1}',
                                  style: AppStyles.caption.copyWith(
                                    color: tagColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppStyles.paddingSmall),
                              Expanded(
                                child: Text(
                                  chapter.title,
                                  style: AppStyles.bodyText.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppStyles.paddingSmall),
                          Text(
                            chapter.content,
                            style: AppStyles.bodyText.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: AppStyles.paddingSmall),
                          Text(
                            _formatDate(chapter.createdAt),
                            style: AppStyles.caption.copyWith(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppStyles.paddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: AppStyles.buttonText.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppStyles.paddingSmall),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onEdit(idea);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Continue Writing'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tagColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppStyles.paddingLarge,
                          vertical: AppStyles.paddingSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(date);
    }
  }
}
