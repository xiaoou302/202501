import 'package:flutter/material.dart';
import '../models/poem.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';

class PoemDetailDialog extends StatelessWidget {
  final Poem poem;

  const PoemDetailDialog({super.key, required this.poem});

  static Future<void> show(BuildContext context, Poem poem) {
    return showDialog(
      context: context,
      builder: (context) => PoemDetailDialog(poem: poem),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paperLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图片部分
            if (poem.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: poem.imageUrl!.startsWith('assets/')
                    ? Image.asset(
                        poem.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        poem.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            
            // 内容部分
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Text(
                      poem.title,
                      style: AppTextStyles.poemTitle.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 8),
                    
                    // 作者信息
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.cardBorder, width: 1),
                          ),
                          child: ClipOval(
                            child: poem.authorAvatarUrl.startsWith('assets/')
                                ? Image.asset(
                                    poem.authorAvatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: AppColors.paper,
                                        child: const Icon(Icons.person, size: 16, color: AppColors.textTertiary),
                                      );
                                    },
                                  )
                                : Image.network(
                                    poem.authorAvatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: AppColors.paper,
                                        child: const Icon(Icons.person, size: 16, color: AppColors.textTertiary),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              poem.authorName,
                              style: AppTextStyles.bodyText.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _formatDate(poem.createdAt),
                              style: AppTextStyles.caption.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 分隔线
                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.ribbon.withValues(alpha: 0.3),
                            AppColors.olive.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 诗歌内容
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        poem.content,
                        style: AppTextStyles.poemContent.copyWith(
                          fontSize: 17,
                          height: 2.0,
                          color: AppColors.ink,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 标签
                    if (poem.tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: poem.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.olive.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.olive.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              tag,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.olive,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // 互动按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.favorite_border,
                          label: '${poem.likes}',
                          onTap: () {},
                        ),
                        _buildActionButton(
                          icon: Icons.bookmark_border,
                          label: 'Save',
                          onTap: () {},
                        ),
                        _buildActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // 关闭按钮
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.ink.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                ),
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
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.ink),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodyText.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
