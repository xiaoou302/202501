import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/post_model.dart';
import '../../../data/services/mock_data_service.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({Key? key, required this.post, required this.onTap})
    : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.getUserById(widget.post.userId);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
            borderRadius: BorderRadius.circular(AppConstants.radiusXL),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.03),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : AppConstants.softCoral.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.white.withOpacity(0.02)
                    : Colors.white.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with gradient overlay
              if (widget.post.imageUrls.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppConstants.radiusXL),
                      ),
                      child: Image.asset(
                        widget.post.imageUrls.first,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            color: AppConstants.mediumGray.withOpacity(0.2),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: AppConstants.mediumGray,
                            ),
                          );
                        },
                      ),
                    ),
                    // Gradient overlay at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Caption
                    Text(
                      widget.post.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppConstants.spacingM),

                    // Stats Row
                    Row(
                      children: [
                        _buildStatItem(
                          Icons.favorite_border,
                          widget.post.likes.toString(),
                          isDark,
                        ),
                        const SizedBox(width: AppConstants.spacingM),
                        _buildStatItem(
                          Icons.chat_bubble_outline,
                          widget.post.comments.toString(),
                          isDark,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingM),

                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.spacingM),

                    // Author
                    if (user != null)
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppConstants.softCoral.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage: user.avatarUrl != null
                                  ? AssetImage(user.avatarUrl!)
                                  : null,
                              child: user.avatarUrl == null
                                  ? const Icon(Icons.person, size: 16)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingS),
                          Expanded(
                            child: Text(
                              user.username,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppConstants.softCoral,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: AppConstants.mediumGray.withOpacity(0.5),
                          ),
                        ],
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

  Widget _buildStatItem(IconData icon, String count, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark
              ? AppConstants.mediumGray
              : AppConstants.mediumGray.withOpacity(0.8),
        ),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppConstants.mediumGray
                : AppConstants.mediumGray.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
