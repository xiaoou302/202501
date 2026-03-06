import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/parameter_card.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';
import 'recipe_detail_screen.dart';

class BrewInspirationScreen extends StatefulWidget {
  const BrewInspirationScreen({super.key});

  @override
  State<BrewInspirationScreen> createState() => _BrewInspirationScreenState();
}

class _BrewInspirationScreenState extends State<BrewInspirationScreen> {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'V60',
    'Kalita',
    'Aeropress',
    'Origami',
    'Chemex',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final allRecipes = RecipeService.getRecipes();
    final deletedIds = await RecipeService.getDeletedRecipeIds();
    final availableRecipes = allRecipes
        .where((r) => !deletedIds.contains(r.id))
        .toList();

    if (mounted) {
      setState(() {
        _recipes = availableRecipes;
        _filterRecipes();
      });
    }
  }

  void _filterRecipes() {
    if (_selectedCategory == 'All') {
      _filteredRecipes = _recipes;
    } else {
      _filteredRecipes = _recipes
          .where((r) => r.brewer.contains(_selectedCategory))
          .toList();
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _filterRecipes();
    });
  }

  void _openDetailScreen(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  void _showCardOptions(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.flag,
                  color: ColorPalette.obsidian,
                  size: 20,
                ),
                title: Text(
                  'Report',
                  style: AppTheme.monoStyle.copyWith(
                    color: ColorPalette.obsidian,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(recipe);
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.red,
                  size: 20,
                ),
                title: Text(
                  'Delete',
                  style: AppTheme.monoStyle.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteRecipe(recipe);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportDialog(Recipe recipe) {
    final TextEditingController reportController = TextEditingController();
    String reportType = 'Inappropriate Content';

    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Report Recipe',
              style: AppTheme.monoStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: reportType,
                    decoration: InputDecoration(
                      labelText: 'Reason',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items:
                        [
                          'Inappropriate Content',
                          'Spam',
                          'Incorrect Information',
                          'Other',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      reportType = newValue!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: reportController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Details',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Please describe the issue...',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTheme.monoStyle.copyWith(
                    color: ColorPalette.matteSteel,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.charcoal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'We will verify your report within 24 hours and take appropriate action.',
                        style: AppTheme.monoStyle.copyWith(color: Colors.white),
                      ),
                      backgroundColor: ColorPalette.charcoal,
                    ),
                  );
                },
                child: Text(
                  'Submit',
                  style: AppTheme.monoStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
    await RecipeService.deleteRecipe(recipe.id);
    if (mounted) {
      setState(() {
        _recipes.removeWhere((r) => r.id == recipe.id);
        _filterRecipes();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Recipe deleted.',
            style: AppTheme.monoStyle.copyWith(color: Colors.white),
          ),
          backgroundColor: ColorPalette.charcoal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.concrete,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Brew Lab.",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: ColorPalette.obsidian,
                            letterSpacing: -1.0,
                            fontSize: 40, // Larger title
                            height: 1.0,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Daily calibration required.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorPalette.matteSteel,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Category Chips
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = category == _selectedCategory;
                          return GestureDetector(
                            onTap: () => _onCategorySelected(category),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ColorPalette.obsidian
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: isSelected
                                    ? null
                                    : Border.all(
                                        color: ColorPalette.concreteDark,
                                        width: 1.5,
                                      ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: ColorPalette.obsidian
                                              .withOpacity(0.2),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                category,
                                style: AppTheme.monoStyle.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : ColorPalette.matteSteel,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final recipe = _filteredRecipes[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 24,
                    ), // Increased spacing
                    child: ParameterCard(
                      recipe: recipe,
                      onTap: () => _openDetailScreen(recipe),
                      onLongPress: () => _showCardOptions(recipe),
                    ),
                  );
                }, childCount: _filteredRecipes.length),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
          ],
        ),
      ),
    );
  }
}
