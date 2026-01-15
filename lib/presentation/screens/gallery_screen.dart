import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../viewmodels/gallery_viewmodel.dart';
import '../widgets/art_card.dart';
import 'art_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    _scrollController.addListener(() {
      if (_scrollController.offset > 500 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (_scrollController.offset <= 500 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppConstants.midnight,
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context, viewModel),
                  _buildCategoryChips(viewModel),
                  if (viewModel.isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: AppConstants.gold),
                      ),
                    )
                  else
                    _buildArtworkGrid(context, viewModel),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                ],
              ),
              if (_showScrollToTop) _buildScrollToTopButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, GalleryViewModel viewModel) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: AppConstants.midnight,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppConstants.midnight,
                AppConstants.midnight.withValues(alpha: 0.95),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppConstants.gold.withValues(alpha: 0.2),
                              AppConstants.gold.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppConstants.gold.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.palette,
                          color: AppConstants.gold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Art Gallery',
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.offwhite,
                                letterSpacing: 0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${viewModel.arts.length} masterpieces',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppConstants.gold.withValues(alpha: 0.8),
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppConstants.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: AppConstants.gold,
                            size: 20,
                          ),
                        ),
                        onPressed: () => _showInfoDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Discover artworks from passionate artists',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.metalgray.withValues(alpha: 0.9),
                      letterSpacing: 0.3,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(GalleryViewModel viewModel) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppConstants.artCategories.map((category) {
            final isSelected = viewModel.selectedCategories.contains(category);
            return FadeTransition(
              opacity: _fadeAnimation,
              child: GestureDetector(
                onTap: () => viewModel.selectCategory(category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppConstants.gold.withValues(alpha: 0.2),
                              AppConstants.gold.withValues(alpha: 0.1),
                            ],
                          )
                        : null,
                    color: isSelected ? null : AppConstants.surface,
                    border: Border.all(
                      color: isSelected
                          ? AppConstants.gold.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.1),
                      width: isSelected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppConstants.gold.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            _getCategoryIcon(category),
                            color: AppConstants.gold,
                            size: 16,
                          ),
                        ),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppConstants.gold : AppConstants.metalgray,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Oil Painting':
        return Icons.brush;
      case 'Sketch':
        return Icons.edit;
      case 'Watercolor':
        return Icons.water_drop;
      case 'Printmaking':
        return Icons.print;
      default:
        return Icons.palette;
    }
  }

  Widget _buildArtworkGrid(BuildContext context, GalleryViewModel viewModel) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
          childAspectRatio: 0.68,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final art = viewModel.arts[index];
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ArtCard(
                art: art,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtDetailScreen(art: art),
                    ),
                  );
                },
              ),
            );
          },
          childCount: viewModel.arts.length,
        ),
      ),
    );
  }

  Widget _buildScrollToTopButton() {
    return Positioned(
      right: 20,
      bottom: 120,
      child: AnimatedOpacity(
        opacity: _showScrollToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: _scrollToTop,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.gold,
                  AppConstants.gold.withValues(alpha: 0.8),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.gold.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_upward,
              color: AppConstants.midnight,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppConstants.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.gold.withValues(alpha: 0.2),
                            AppConstants.gold.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.palette, color: AppConstants.gold, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Art Gallery',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 24,
                          color: AppConstants.offwhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppConstants.metalgray),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome to the Art Gallery',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppConstants.gold,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'This is a curated collection of artworks from talented artists across different mediums. Explore various styles and techniques to inspire your own creative journey.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.offwhite,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Features',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppConstants.gold,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(Icons.filter_alt, 'Filter by Category', 'Browse artworks by Oil Painting, Sketch, Watercolor, or Printmaking'),
                        const SizedBox(height: 12),
                        _buildFeatureItem(Icons.touch_app, 'Tap to Explore', 'Click on any artwork to view details, descriptions, and artist reflections'),
                        const SizedBox(height: 12),
                        _buildFeatureItem(Icons.favorite, 'Save Favorites', 'Add artworks to your favorites for quick access'),
                        const SizedBox(height: 12),
                        _buildFeatureItem(Icons.fullscreen, 'Full Screen View', 'View artworks in full screen mode for detailed examination'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.gold,
                      foregroundColor: AppConstants.midnight,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Got it!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppConstants.gold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.offwhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.metalgray,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
