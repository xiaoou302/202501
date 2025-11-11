import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/post_model.dart';
import '../../data/services/mock_data_service.dart';
import '../../data/services/follow_service.dart';
import 'widgets/post_card.dart';
import 'widgets/filter_chips.dart';
import 'widgets/empty_following_state.dart';
import 'widgets/search_dialog.dart';
import 'profile_screen.dart';

class PlazaScreen extends StatefulWidget {
  const PlazaScreen({Key? key}) : super(key: key);

  @override
  State<PlazaScreen> createState() => _PlazaScreenState();
}

class _PlazaScreenState extends State<PlazaScreen> {
  List<Post> _allPosts = [];
  List<Post> _filteredPosts = [];
  String _selectedFilter = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _allPosts = MockDataService.getSamplePosts();
          _filteredPosts = _allPosts;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _onFilterChanged(String filter) async {
    setState(() {
      _selectedFilter = filter;
      _isLoading = true;
    });

    if (filter == 'All') {
      setState(() {
        _filteredPosts = _allPosts;
        _isLoading = false;
      });
    } else if (filter == 'Following') {
      // Filter posts by followed users
      final followedUsers = await FollowService.getFollowedUsers();
      setState(() {
        _filteredPosts = _allPosts
            .where((post) => followedUsers.contains(post.userId))
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _filteredPosts = _allPosts
            .where((post) => post.tags.contains(filter))
            .toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _onPostTap(Post post) async {
    final user = MockDataService.getUserById(post.userId);
    if (user != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
      );

      // Refresh the filter if we're on Following tab and something changed
      if (result == true && _selectedFilter == 'Following') {
        _onFilterChanged('Following');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppConstants.deepPlum,
                    AppConstants.deepPlum,
                    AppConstants.darkGray.withOpacity(0.8),
                  ]
                : [
                    AppConstants.shellWhite,
                    AppConstants.softCoral.withOpacity(0.05),
                    AppConstants.shellWhite,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Glass Effect
              Container(
                margin: const EdgeInsets.all(AppConstants.spacingM),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingL,
                  vertical: AppConstants.spacingM,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.softCoral,
                                AppConstants.softCoral.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusM,
                            ),
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingM),
                        Text(
                          'Paws Plaza',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : AppConstants.softCoral.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          size: AppConstants.iconL,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SearchDialog(),
                          );
                        },
                        color: AppConstants.softCoral,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter Chips
              FilterChips(
                selectedFilter: _selectedFilter,
                onFilterChanged: _onFilterChanged,
              ),

              const SizedBox(height: AppConstants.spacingS),

              // Posts Grid
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppConstants.softCoral,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          _loadPosts();
                        },
                        color: AppConstants.softCoral,
                        child: _filteredPosts.isEmpty
                            ? (_selectedFilter == 'Following'
                                  ? EmptyFollowingState(
                                      onExplorePressed: () {
                                        _onFilterChanged('All');
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        'No posts found',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: AppConstants.mediumGray,
                                            ),
                                      ),
                                    ))
                            : _buildMasonryGrid(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasonryGrid() {
    // Split posts into two columns
    final leftPosts = <Post>[];
    final rightPosts = <Post>[];

    for (int i = 0; i < _filteredPosts.length; i++) {
      if (i % 2 == 0) {
        leftPosts.add(_filteredPosts[i]);
      } else {
        rightPosts.add(_filteredPosts[i]);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftPosts
                  .map(
                    (post) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppConstants.spacingM,
                      ),
                      child: PostCard(
                        post: post,
                        onTap: () => _onPostTap(post),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              children: rightPosts
                  .map(
                    (post) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppConstants.spacingM,
                      ),
                      child: PostCard(
                        post: post,
                        onTap: () => _onPostTap(post),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
