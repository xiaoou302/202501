import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oravie/core/constants/app_colors.dart';
import 'package:oravie/data/models/inspiration_post.dart';

import 'package:oravie/core/services/follow_service.dart';
import 'package:oravie/core/services/collection_service.dart';

class PostDetailScreen extends StatefulWidget {
  final InspirationPost post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background behind the image
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.3,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => _FullScreenImageView(
                      imagePath: widget.post.imagePath,
                      tag: 'post_image_${widget.post.id}',
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'post_image_${widget.post.id}',
                child: Image.asset(widget.post.imagePath, fit: BoxFit.cover),
              ),
            ),
          ),

          // 2. Navigation & Actions (Top)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBlurIconBtn(
                  context,
                  icon: FontAwesomeIcons.chevronLeft,
                  onTap: () => Navigator.pop(context),
                ),
                // Share icon removed as per request
              ],
            ),
          ),

          // 3. Draggable Content Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.6,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.snowWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 30,
                      offset: Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Pull Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(top: 16, bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Content List
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                        children: [
                          _buildHeaderSection(),
                          const SizedBox(height: 24),
                          _buildQuoteSection(),
                          const SizedBox(height: 24),
                          _buildDescriptionSection(),
                          const SizedBox(height: 32),
                          _buildEvaluationSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 4. Floating Action Bar (Bottom)
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: _buildBottomActionBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurIconBtn(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            color: Colors.black.withOpacity(0.2),
            child: Center(child: Icon(icon, color: Colors.white, size: 18)),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final categoryColor = AppColors.getCategoryTextColor(widget.post.category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.post.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: categoryColor,
                      ),
                    ),
                  ),
                  Text(
                    widget.post.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.charcoal,
                      height: 1.1,
                      fontFamily: 'Playfair Display',
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [_buildTag(widget.post.styleTag)]),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildAvatar(),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String text, {bool isLocation = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLocation
            ? Colors.transparent
            : AppColors.charcoal.withOpacity(0.05),
        border: Border.all(
          color: isLocation ? Colors.grey[300]! : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLocation) ...[
            const Icon(
              Icons.location_on_outlined,
              size: 12,
              color: AppColors.coolGray,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isLocation
                  ? AppColors.coolGray
                  : AppColors.charcoal.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(2), // Border width
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(widget.post.avatarPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteSection() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          decoration: BoxDecoration(
            color: AppColors.warmBeige.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Icon(
                FontAwesomeIcons.quoteLeft,
                size: 20,
                color: AppColors.terracotta,
              ),
              const SizedBox(height: 16),
              Text(
                '"Home is not a showroom, but a vessel for emotions."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontStyle: FontStyle.italic,
                  color: AppColors.charcoal.withOpacity(0.8),
                  fontSize: 18,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 2,
                color: AppColors.terracotta.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Text(
      widget.post.description,
      style: const TextStyle(
        color: Color(0xFF4B5563),
        fontSize: 16,
        height: 1.8,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildEvaluationSection() {
    return Column(
      children: [
        _buildEvaluationCard(
          title: 'Design Highlights',
          content: widget.post.pros,
          icon: FontAwesomeIcons.star,
          color: AppColors.olive,
          bgColor: AppColors.softSage,
        ),
        const SizedBox(height: 16),
        _buildEvaluationCard(
          title: 'Considerations',
          content: widget.post.cons,
          icon: FontAwesomeIcons.lightbulb,
          color: AppColors.terracotta,
          bgColor: AppColors.warmBeige,
        ),
      ],
    );
  }

  Widget _buildEvaluationCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: FollowService.instance.followedPostsNotifier,
      builder: (context, followedPosts, child) {
        final isFollowed = followedPosts.contains(widget.post.id);

        return ValueListenableBuilder<Set<String>>(
          valueListenable: CollectionService.instance.collectedPostsNotifier,
          builder: (context, collectedPosts, child) {
            final isCollected = collectedPosts.contains(widget.post.id);

            return Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: isFollowed ? 'Following' : 'Follow',
                    icon: isFollowed
                        ? FontAwesomeIcons.check
                        : FontAwesomeIcons.plus,
                    isPrimary: false,
                    onTap: () {
                      FollowService.instance.toggleFollow(widget.post.id);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    label: isCollected ? 'Saved' : 'Save',
                    icon: isCollected
                        ? FontAwesomeIcons.solidBookmark
                        : FontAwesomeIcons.bookmark,
                    isPrimary: true,
                    onTap: () {
                      CollectionService.instance.toggleCollection(
                        widget.post.id,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.slateGreen : Colors.white,
        borderRadius: BorderRadius.circular(28), // Pill shape
        border: isPrimary ? null : Border.all(color: Colors.grey[300]!),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.slateGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : AppColors.charcoal,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.white : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullScreenImageView extends StatelessWidget {
  final String imagePath;
  final String tag;

  const _FullScreenImageView({required this.imagePath, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(tag: tag, child: Image.asset(imagePath)),
        ),
      ),
    );
  }
}
