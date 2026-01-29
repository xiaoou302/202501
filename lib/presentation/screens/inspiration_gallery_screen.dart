import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oravie/core/constants/app_colors.dart';
import 'package:oravie/data/models/inspiration_post.dart';
import 'package:oravie/presentation/widgets/inspiration_card.dart';
import 'package:oravie/presentation/screens/post_detail_screen.dart';
import 'package:oravie/data/data_source.dart';

class InspirationGalleryScreen extends StatefulWidget {
  const InspirationGalleryScreen({super.key});

  @override
  State<InspirationGalleryScreen> createState() =>
      _InspirationGalleryScreenState();
}

class _InspirationGalleryScreenState extends State<InspirationGalleryScreen> {
  final List<String> _filters = [
    'All',
    'Living Room',
    'Bedroom',
    'Dining & Kitchen',
    'Office',
    'Bathroom',
  ];
  int _selectedFilterIndex = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _handleLongPress(BuildContext context, InspirationPost post) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deletePost(context, post);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.orange),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context, post);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deletePost(BuildContext context, InspirationPost post) {
    setState(() {
      dummyPosts.removeWhere((p) => p.id == post.id);
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Post deleted permanently')));
  }

  void _showReportDialog(BuildContext context, InspirationPost post) {
    final TextEditingController reportController = TextEditingController();
    String selectedReason = 'Inappropriate Content';
    final List<String> reasons = [
      'Inappropriate Content',
      'Spam',
      'False Information',
      'Other',
    ];

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            title: const Text('Report Post'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedReason,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedReason = newValue!;
                    });
                  },
                  items: reasons.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reportController,
                  decoration: const InputDecoration(
                    hintText: 'Enter details (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'We will verify the report within 24 hours and take appropriate action.',
                      ),
                    ),
                  );
                },
                child: const Text('Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Features Guide'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Tap card to view details'),
            SizedBox(height: 8),
            Text('• Long press card to access menu:'),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Delete: Permanently remove post'),
                  Text('- Report: Flag inappropriate content'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<InspirationPost> get _filteredPosts {
    List<InspirationPost> posts = dummyPosts;

    // Apply Category Filter
    if (_selectedFilterIndex != 0) {
      final filter = _filters[_selectedFilterIndex];
      posts = posts.where((post) => post.category == filter).toList();
    }

    // Apply Search Filter
    if (_searchQuery.isNotEmpty) {
      posts = posts.where((post) {
        final query = _searchQuery.toLowerCase();
        return post.title.toLowerCase().contains(query) ||
            post.description.toLowerCase().contains(query) ||
            post.styleTag.toLowerCase().contains(query) ||
            post.category.toLowerCase().contains(query);
      }).toList();
    }

    return posts;
  }

  void _showDetail(BuildContext context, InspirationPost post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (_searchController.text.isEmpty) {
          setState(() {
            _isSearching = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB), // Very light cool gray base
        body: Stack(
          children: [
            // 1. Decorative Background Elements
            _buildBackgroundDecor(),

            // 2. Main Content
            SafeArea(
              bottom: false,
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [_buildSliverAppBar(), _buildFilterBar()];
                },
                body: _buildGalleryGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        // Top Left Blob
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.slateGreen.withOpacity(0.15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.slateGreen.withOpacity(0.15),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        // Center Right Blob (Warm tone)
        Positioned(
          top: 200,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0C3A5).withOpacity(0.2), // Warm beige
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE0C3A5).withOpacity(0.2),
                  blurRadius: 80,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),
        // Blur Filter to smooth everything out
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            color: Colors.white.withOpacity(0.3), // Glass effect base
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      elevation: 0,
      backgroundColor: Colors.transparent, // Transparent to show background
      automaticallyImplyLeading: false,
      expandedHeight: _isSearching ? 80 : 110,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isSearching)
                _buildSearchBar()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 8, top: 4),
                              decoration: const BoxDecoration(
                                color: AppColors.slateGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Text(
                              'Strida',
                              style: TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: AppColors.charcoal,
                                letterSpacing: -1,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Curated spaces for your\ndaily inspiration.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.charcoal.withOpacity(0.7),
                            letterSpacing: 0.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _showHelpDialog(context),
                          child: Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.help_outline,
                              color: AppColors.charcoal,
                              size: 22,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.white, Colors.grey[100]!],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: AppColors.charcoal,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.slateGreen.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search for styles, colors...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          border: InputBorder.none,
          prefixIcon: const Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 16,
            color: AppColors.slateGreen,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _isSearching = false;
              });
            },
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        style: const TextStyle(fontSize: 15, color: AppColors.charcoal),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverFilterDelegate(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: const Color(0xFFF9FAFB).withOpacity(0.8),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedFilterIndex;
                  final category = _filters[index];
                  // Use specific colors for each category when selected
                  Color activeColor;
                  if (category == 'All') {
                    activeColor = AppColors.charcoal;
                  } else {
                    activeColor = AppColors.getCategoryTextColor(category);
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? activeColor : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: activeColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                        border: isSelected
                            ? Border.all(color: Colors.transparent)
                            : Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.charcoal.withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryGrid() {
    if (_filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.slateGreen.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                FontAwesomeIcons.compass,
                size: 40,
                color: AppColors.slateGreen.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No inspiration found',
              style: TextStyle(
                color: AppColors.charcoal,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search filters',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return MasonryGridView.count(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: _filteredPosts.length,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      itemBuilder: (context, index) {
        return InspirationCard(
          post: _filteredPosts[index],
          onTap: () => _showDetail(context, _filteredPosts[index]),
          onLongPress: () => _handleLongPress(context, _filteredPosts[index]),
        );
      },
    );
  }
}

class _SliverFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverFilterDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 76.0; // Increased height for padding

  @override
  double get minExtent => 76.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
