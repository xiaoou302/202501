import 'package:flutter/material.dart';
import '../models/poem.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';

class PoemCard extends StatelessWidget {
  final Poem poem;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onBookmark;

  const PoemCard({
    super.key,
    required this.poem,
    this.onTap,
    this.onLike,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.paperLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (poem.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: poem.imageUrl!.startsWith('assets/')
                    ? Image.asset(
                        poem.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: AppColors.paper,
                          child: const Icon(Icons.image, size: 50, color: AppColors.textTertiary),
                        ),
                      )
                    : Image.network(
                        poem.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: AppColors.paper,
                          child: const Icon(Icons.image, size: 50, color: AppColors.textTertiary),
                        ),
                      ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EDITOR\'S PICK',
                        style: AppTextStyles.caption.copyWith(color: AppColors.ribbon),
                      ),
                      IconButton(
                        icon: Icon(
                          poem.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: poem.isBookmarked ? AppColors.ribbon : AppColors.textTertiary,
                          size: 20,
                        ),
                        onPressed: onBookmark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(poem.title, style: AppTextStyles.poemTitle),
                  const SizedBox(height: 12),
                  Text(
                    poem.content,
                    style: AppTextStyles.poemContent.copyWith(fontSize: 16),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: AppColors.cardBorder,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
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
                                          child: const Icon(Icons.person, size: 12, color: AppColors.textTertiary),
                                        );
                                      },
                                    )
                                  : Image.network(
                                      poem.authorAvatarUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.paper,
                                          child: const Icon(Icons.person, size: 12, color: AppColors.textTertiary),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(poem.authorName, style: AppTextStyles.authorName),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              poem.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: poem.isLiked ? AppColors.ribbon : AppColors.textTertiary,
                              size: 18,
                            ),
                            onPressed: onLike,
                          ),
                          Text('${poem.likes}', style: AppTextStyles.caption),
                        ],
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
