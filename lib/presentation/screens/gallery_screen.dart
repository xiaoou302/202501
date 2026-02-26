import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:orivet/core/constants/strings.dart';
import 'package:orivet/data/models/relic_model.dart';
import 'package:orivet/data/repositories/relic_repository.dart';
import 'package:orivet/presentation/widgets/gallery/relic_card.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<List<Relic>> _relicsFuture;
  String _selectedCategory = AppStrings.categoryWatches; // Default category
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRelics();
  }

  void _loadRelics() {
    setState(() {
      _relicsFuture = context.read<RelicRepository>().getRelics();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleDelete(String id) async {
    await context.read<RelicRepository>().deleteRelic(id);
    _loadRelics(); // Reload to refresh list
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item permanently deleted."),
          backgroundColor: AppColors.wax,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Search Bar
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 24),

          // Categories
          _buildCategories(),
          const SizedBox(height: 24),

          // Grid
          Expanded(
            child: FutureBuilder<List<Relic>>(
              future: _relicsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.brass));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No relics found."));
                }

                // Filter logic
                final allRelics = snapshot.data!;
                final filteredRelics = allRelics.where((relic) {
                  final matchesCategory = relic.category == _selectedCategory;
                  final matchesSearch = _searchQuery.isEmpty ||
                      relic.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                  return matchesCategory && matchesSearch;
                }).toList();

                if (filteredRelics.isEmpty) {
                  return const Center(
                      child: Text("No items in this collection."));
                }

                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 16,
                  itemCount: filteredRelics.length,
                  itemBuilder: (context, index) {
                    final relic = filteredRelics[index];
                    // Random slight rotation for "pile of papers" effect
                    final double rotation =
                        (index % 2 == 0 ? 0.01 : -0.01) * pi;
                    return RelicCard(
                      relic: relic,
                      rotation: rotation,
                      onDelete: () => _handleDelete(relic.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.shale.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.leather.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(FontAwesomeIcons.magnifyingGlass,
                color: AppColors.leather, size: 16),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              maxLength: 30, // Input limit
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: AppStrings.searchPlaceholder,
                hintStyle: TextStyle(
                  fontFamily: 'Courier Prime',
                  color: AppColors.soot.withValues(alpha: 0.5),
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
                border: InputBorder.none,
                isDense: true,
                counterText: "", // Hide character counter
              ),
              style: const TextStyle(
                fontFamily: 'Courier Prime',
                color: AppColors.ink,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            height: 24,
            width: 1,
            color: AppColors.leather.withValues(alpha: 0.2),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          InkWell(
            onTap: () {}, // Add filter logic later if needed
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                AppStrings.filter,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.leather,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip(AppStrings.categoryWatches),
          const SizedBox(width: 16),
          _buildCategoryChip(AppStrings.categoryCameras),
          const SizedBox(width: 16),
          _buildCategoryChip(AppStrings.categoryPens),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => _onCategorySelected(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.leather : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: isSelected
                ? AppColors.leather
                : AppColors.leather.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.leather.withValues(alpha: 0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? AppColors.vellum : AppColors.leather,
                letterSpacing: 1.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}
