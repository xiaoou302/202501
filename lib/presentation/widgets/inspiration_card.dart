import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oravie/core/constants/app_colors.dart';
import 'package:oravie/data/models/inspiration_post.dart';
import 'package:oravie/core/services/follow_service.dart';

class InspirationCard extends StatelessWidget {
  final InspirationPost post;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const InspirationCard({
    super.key,
    required this.post,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Overlay
            Stack(
              children: [
                Hero(
                  tag: 'post_image_${post.id}',
                  child: AspectRatio(
                    aspectRatio: 1 / post.heightRatio, // Width / Height
                    child: Image.asset(
                      post.imagePath,
                      fit: BoxFit.cover,
                      cacheWidth: 800,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Category Tag
                Positioned(
                  top: 12,
                  left: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          post.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getCategoryTextColor(
                              post.category,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Like Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: ValueListenableBuilder<Set<String>>(
                    valueListenable:
                        FollowService.instance.followedPostsNotifier,
                    builder: (context, followedPosts, child) {
                      final isFollowed = followedPosts.contains(post.id);
                      return Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFollowed
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          size: 12,
                          color: isFollowed
                              ? const Color(0xFFFF5252)
                              : Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tags Row
                  Row(
                    children: [
                      _buildMiniTag(
                        post.styleTag,
                        Colors.grey[100]!,
                        Colors.grey[600]!,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // User Row
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          image: DecorationImage(
                            image: AssetImage(post.avatarPath),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          post.userName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.coolGray,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Optional: Like count or similar
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

  Widget _buildMiniTag(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
