import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/services/mock_data_service.dart';
import '../../data/services/follow_service.dart';
import 'widgets/timeline_item.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    final isFollowing = await FollowService.isFollowing(widget.user.id);
    if (mounted) {
      setState(() {
        _isFollowing = isFollowing;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFollow() async {
    final newStatus = await FollowService.toggleFollow(widget.user.id);
    if (mounted) {
      setState(() {
        _isFollowing = newStatus;
      });

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus
                ? 'Following ${widget.user.displayName}'
                : 'Unfollowed ${widget.user.displayName}',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppConstants.softCoral,
        ),
      );

      // Return true to indicate follow status changed
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final timelineStories = MockDataService.getTimelineStoriesForUser(
      widget.user.id,
    );
    final post = MockDataService.getSamplePosts().firstWhere(
      (post) => post.userId == widget.user.id,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppConstants.deepPlum,
                    AppConstants.deepPlum,
                    AppConstants.darkGray.withOpacity(0.9),
                  ]
                : [
                    AppConstants.softCoral.withOpacity(0.08),
                    AppConstants.shellWhite,
                    AppConstants.shellWhite,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header with Glass Effect
              Container(
                margin: const EdgeInsets.all(AppConstants.spacingM),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                  vertical: AppConstants.spacingS,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.softCoral.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppConstants.softCoral.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          size: AppConstants.iconL,
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: AppConstants.softCoral,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      child: Text(
                        widget.user.username,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Info Section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingM,
                        ),
                        child: Column(
                          children: [
                            // Avatar
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppConstants.softCoral,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppConstants.softCoral.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundImage: widget.user.avatarUrl != null
                                    ? AssetImage(widget.user.avatarUrl!)
                                    : null,
                                child: widget.user.avatarUrl == null
                                    ? const Icon(Icons.person, size: 48)
                                    : null,
                              ),
                            ),

                            const SizedBox(height: AppConstants.spacingM),

                            // Name
                            Text(
                              widget.user.displayName,
                              style: theme.textTheme.displaySmall,
                            ),

                            const SizedBox(height: AppConstants.spacingS),

                            // Bio
                            if (widget.user.bio != null)
                              Text(
                                widget.user.bio!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppConstants.mediumGray,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),

                            const SizedBox(height: AppConstants.spacingM),

                            // Quote
                            if (widget.user.quote != null)
                              Container(
                                padding: const EdgeInsets.all(
                                  AppConstants.spacingM,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.softCoral.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.radiusM,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.format_quote,
                                      color: AppConstants.softCoral,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: AppConstants.spacingS,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.user.quote!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                              color: AppConstants.softCoral,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: AppConstants.spacingL),

                            // Pet Image Section
                            if (post.imageUrls.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Furry Companion',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: AppConstants.spacingM),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.radiusL,
                                    ),
                                    child: Image.asset(
                                      post.imageUrls.first,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              height: 300,
                                              color: AppConstants.mediumGray
                                                  .withOpacity(0.2),
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: AppConstants.mediumGray,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: AppConstants.spacingXL),

                            // Follow Button
                            SizedBox(
                              width: double.infinity,
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppConstants.softCoral,
                                            ),
                                      ),
                                    )
                                  : ElevatedButton.icon(
                                      onPressed: _toggleFollow,
                                      icon: Icon(
                                        _isFollowing ? Icons.check : Icons.add,
                                        size: 20,
                                      ),
                                      label: Text(
                                        _isFollowing ? 'Following' : 'Follow',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isFollowing
                                            ? (isDark
                                                  ? AppConstants.darkGray
                                                  : AppConstants.mediumGray
                                                        .withOpacity(0.2))
                                            : AppConstants.softCoral,
                                        foregroundColor: _isFollowing
                                            ? AppConstants.mediumGray
                                            : Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppConstants.radiusFull,
                                          ),
                                          side: _isFollowing
                                              ? BorderSide(
                                                  color: AppConstants.mediumGray
                                                      .withOpacity(0.3),
                                                  width: 1,
                                                )
                                              : BorderSide.none,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.spacingXL),

                      // Divider
                      Container(
                        height: 8,
                        color: isDark
                            ? Colors.black.withOpacity(0.2)
                            : Colors.grey[100],
                      ),

                      const SizedBox(height: AppConstants.spacingL),

                      // Timeline Section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingM,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_stories,
                                  color: AppConstants.softCoral,
                                  size: 24,
                                ),
                                const SizedBox(width: AppConstants.spacingS),
                                Text(
                                  'Our Journey Together',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.spacingS),
                            Text(
                              'A timeline of precious moments and memories',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppConstants.mediumGray,
                              ),
                            ),
                            const SizedBox(height: AppConstants.spacingL),

                            // Timeline Items
                            ...timelineStories.asMap().entries.map((entry) {
                              final index = entry.key;
                              final story = entry.value;
                              return TimelineItem(
                                story: story,
                                isLast: index == timelineStories.length - 1,
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.spacingXL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
