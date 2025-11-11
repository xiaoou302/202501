import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/mock_data_service.dart';
import '../profile_screen.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({Key? key}) : super(key: key);

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _searchQuery = '';
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchQuery = query.toLowerCase();
    });

    // Search in users and posts
    final allUsers = MockDataService.getSampleUsers();
    final allPosts = MockDataService.getSamplePosts();

    final matchedUserIds = <String>{};

    // Search by username or display name
    for (final user in allUsers) {
      if (user.username.toLowerCase().contains(_searchQuery) ||
          user.displayName.toLowerCase().contains(_searchQuery) ||
          (user.bio?.toLowerCase().contains(_searchQuery) ?? false)) {
        matchedUserIds.add(user.id);
      }
    }

    // Search by post content
    for (final post in allPosts) {
      if (post.content.toLowerCase().contains(_searchQuery)) {
        matchedUserIds.add(post.userId);
      }
    }

    // Get unique users
    final results = allUsers
        .where((user) => matchedUserIds.contains(user.id))
        .toList();

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside dialog
        FocusScope.of(context).unfocus();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(AppConstants.spacingM),
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping inside dialog
            FocusScope.of(context).unfocus();
          },
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              color: isDark ? AppConstants.deepPlum : AppConstants.shellWhite,
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppConstants.softCoral,
                        size: 24,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Text(
                        'Search Friends',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        color: AppConstants.mediumGray,
                      ),
                    ],
                  ),
                ),

                // Search Field
                GestureDetector(
                  onTap: () {
                    // Prevent tap from dismissing keyboard when tapping search field
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingM,
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _performSearch,
                      maxLength: 50,
                      maxLines: 1,
                      textInputAction: TextInputAction.search,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Search by name or content...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppConstants.mediumGray,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: isDark
                            ? AppConstants.darkGray
                            : AppConstants.panelWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusFull,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingM,
                          vertical: AppConstants.spacingM,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingM),

                // Results
                Expanded(child: _buildResults(theme, isDark)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(ThemeData theme, bool isDark) {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.softCoral),
        ),
      );
    }

    if (_searchQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: AppConstants.mediumGray.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              'Start typing to search',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppConstants.mediumGray,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              'Find friends by username, name, or content',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppConstants.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppConstants.mediumGray.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              'No results found',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppConstants.mediumGray,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              'Try different keywords',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppConstants.mediumGray,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return _buildUserTile(user, theme, isDark);
      },
    );
  }

  Widget _buildUserTile(User user, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppConstants.spacingM),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: user.avatarUrl != null
              ? AssetImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null
              ? const Icon(Icons.person, size: 28)
              : null,
        ),
        title: Text(
          user.displayName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.username,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppConstants.softCoral,
              ),
            ),
            if (user.bio != null) ...[
              const SizedBox(height: 4),
              Text(
                user.bio!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppConstants.mediumGray,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: AppConstants.mediumGray),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
          );
        },
      ),
    );
  }
}
