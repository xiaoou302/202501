import 'package:flutter/material.dart';
import '../../data/models/insight_model.dart';
import '../../core/constants/app_constants.dart';
import 'emotion_tag_chip.dart';

class InsightCard extends StatelessWidget {
  final Insight insight;
  final VoidCallback? onTap;
  final Function(String)? onDelete;
  final Function(String)? onReport;

  const InsightCard({
    super.key,
    required this.insight,
    this.onTap,
    this.onDelete,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showActionMenu(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.graphite,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (insight.imageUrl.isNotEmpty)
              Hero(
                tag: 'insight_${insight.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.radiusMedium),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // 保持16:9比例，完整显示图片
                    child: Image.asset(
                      insight.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 作者信息
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppConstants.theatreRed,
                        child: Text(
                          insight.author.displayName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              insight.author.displayName,
                              style: const TextStyle(
                                color: AppConstants.offWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatTimeAgo(insight.timestamp),
                              style: const TextStyle(
                                color: AppConstants.midGray,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 阅读量
                      Row(
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: AppConstants.midGray,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatCount(insight.readCount),
                            style: const TextStyle(
                              color: AppConstants.midGray,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 标题
                  Text(
                    insight.title,
                    style: const TextStyle(
                      color: AppConstants.offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // 摘要
                  Text(
                    insight.content,
                    style: const TextStyle(
                      color: AppConstants.midGray,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // 情感标签
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: insight.emotionTags
                        .map((tag) => EmotionTagChip(tag: tag))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${difference.inDays ~/ 7}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppConstants.graphite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppConstants.midGray.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.theatreRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.block_rounded,
                    color: AppConstants.theatreRed,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Delete & Block User',
                  style: TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Remove content and block ${insight.author.displayName}',
                  style: TextStyle(
                    color: AppConstants.midGray.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog(context);
                },
              ),
              Divider(
                color: AppConstants.midGray.withValues(alpha: 0.1),
                height: 1,
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE67E22).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flag_rounded,
                    color: Color(0xFFE67E22),
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Report',
                  style: TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Report inappropriate content',
                  style: TextStyle(
                    color: AppConstants.midGray,
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (onReport != null) {
                    onReport!(insight.author.displayName);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.graphite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.theatreRed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.block_rounded,
                color: AppConstants.theatreRed,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Delete & Block User',
                style: TextStyle(
                  color: AppConstants.offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will:',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.9),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '• Delete this content\n'
              '• Block ${insight.author.displayName}\n'
              '• Hide all their future content\n'
              '• This action cannot be undone',
              style: TextStyle(
                color: AppConstants.midGray.withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppConstants.midGray,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onDelete != null) {
                onDelete!(insight.author.displayName);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: AppConstants.theatreRed,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Delete & Block',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
