import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/color_palette.dart';
import '../../data/models/style_image.dart';
import '../../data/repositories/home_repository.dart';
import '../providers/saved_styles_provider.dart';
import '../widgets/style_card.dart';

final similarStylesProvider = FutureProvider.family<List<StyleImage>, String>((ref, imageId) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getSimilarStyles(imageId);
});

final homeRepositoryProvider = Provider((ref) => HomeRepository());

class StyleDetailScreen extends ConsumerStatefulWidget {
  final StyleImage image;

  const StyleDetailScreen({super.key, required this.image});

  @override
  ConsumerState<StyleDetailScreen> createState() => _StyleDetailScreenState();
}

class _StyleDetailScreenState extends ConsumerState<StyleDetailScreen> {
  void _toggleSave() {
    ref.read(savedStylesProvider.notifier).toggleSave(widget.image.id);
  }

  @override
  Widget build(BuildContext context) {
    final similarStylesAsync = ref.watch(similarStylesProvider(widget.image.id));
    final savedStyles = ref.watch(savedStylesProvider);
    final isSaved = savedStyles.contains(widget.image.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(isSaved),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(),
                _buildTagsSection(),
                _buildDescriptionSection(),
                _buildInspirationSection(),
                _buildSimilarStylesSection(similarStylesAsync, savedStyles),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(isSaved),
    );
  }

  Widget _buildAppBar(bool isSaved) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      expandedHeight: 0,
      leading: Container(
        margin: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.gray.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.text),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: isSaved
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accent,
                          AppColors.accent.withValues(alpha: 0.8),
                        ],
                      )
                    : null,
                color: isSaved ? null : Colors.white.withValues(alpha: 0.95),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSaved
                      ? AppColors.accent.withValues(alpha: 0.3)
                      : AppColors.gray.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSaved
                        ? AppColors.accent.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                size: 20,
                color: isSaved ? Colors.white : AppColors.text,
              ),
            ),
            onPressed: _toggleSave,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 0.75,
          child: Stack(
            children: [
              widget.image.isLocalAsset
                  ? Image.asset(
                      widget.image.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.grayLight,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 48, color: AppColors.gray),
                          ),
                        );
                      },
                    )
                  : Image.network(
                      widget.image.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
              // Gradient overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: widget.image.tags.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent.withValues(alpha: 0.15),
                  AppColors.accent.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
                letterSpacing: 0.3,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surface.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gray.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.15),
                      AppColors.accent.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  size: 22,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            widget.image.description ?? 'No description available',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
              height: 1.5,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.image.detailedDescription ?? '',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.8,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspirationSection() {
    if (widget.image.inspiration == null || widget.image.inspiration!.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warning.withValues(alpha: 0.08),
            AppColors.warning.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.warning.withValues(alpha: 0.2),
                      AppColors.warning.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 22,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Inspiration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            widget.image.inspiration!,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.8,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarStylesSection(AsyncValue<List<StyleImage>> similarStylesAsync, Set<String> savedStyles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.15),
                      AppColors.accent.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  size: 20,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Similar Styles',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        similarStylesAsync.when(
          data: (images) => SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                final isImageSaved = savedStyles.contains(image.id);
                
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: StyleCard(
                          image: image.copyWith(isSaved: isImageSaved),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StyleDetailScreen(image: image.copyWith(isSaved: isImageSaved)),
                              ),
                            );
                          },
                          onSave: () {
                            ref.read(savedStylesProvider.notifier).toggleSave(image.id);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          loading: () => const SizedBox(
            height: 260,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
          ),
          error: (error, stack) => const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isSaved) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.gray.withValues(alpha: 0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _toggleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: isSaved ? AppColors.surface : AppColors.accent,
              foregroundColor: isSaved ? AppColors.text : Colors.white,
              elevation: 0,
              shadowColor: isSaved ? null : AppColors.accent.withValues(alpha: 0.4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: isSaved
                  ? BorderSide(
                      color: AppColors.gray.withValues(alpha: 0.2),
                      width: 1.5,
                    )
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline_rounded,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  isSaved ? 'Saved to Collection' : 'Save to Collection',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
