import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/recipe.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';
import 'brewing_modal.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  void _startBrewing(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BrewingModal(recipe: recipe, onClose: () => Navigator.pop(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Cleaner look
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.arrowLeft,
                color: ColorPalette.obsidian,
                size: 16,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Hero Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(
              recipe.imagePath,
              fit: BoxFit.cover,
              cacheWidth: 1080,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: ColorPalette.concreteDark,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 64,
                      color: ColorPalette.matteSteel,
                    ),
                  ),
                );
              },
            ),
          ),

          // Content
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 30,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 120),
                children: [
                  // Header
                  Text(
                    recipe.brewer.toUpperCase(),
                    style: AppTheme.monoStyle.copyWith(
                      color: ColorPalette.rustedCopper,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 32,
                      height: 1.1,
                      color: ColorPalette.obsidian,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Info Row (Horizontal scrolling if needed, but fitted for now)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn("DOSE", "${recipe.dose}g"),
                      _buildVerticalDivider(),
                      _buildInfoColumn(
                        "RATIO",
                        "1:${(recipe.water / recipe.dose).toStringAsFixed(1)}",
                      ),
                      _buildVerticalDivider(),
                      _buildInfoColumn("TEMP", "${recipe.temp}°C"),
                      _buildVerticalDivider(),
                      _buildInfoColumn("GRIND", recipe.grindSetting),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Divider(color: ColorPalette.concreteDark),
                  const SizedBox(height: 32),

                  // Metadata
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildMetadataChip(
                        recipe.roastLevel,
                        Colors.brown.shade400,
                      ),
                      _buildMetadataChip(
                        recipe.origin,
                        ColorPalette.rustedCopper,
                      ),
                      _buildMetadataChip(
                        recipe.process,
                        ColorPalette.matteSteel,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Description
                  Text(
                    "BARISTA NOTES",
                    style: AppTheme.monoStyle.copyWith(
                      color: ColorPalette.matteSteel,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    recipe.description,
                    style: const TextStyle(
                      color: ColorPalette.obsidian,
                      height: 1.8,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Flavor Tags
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: recipe.flavorTags
                        .map((tag) => _buildFlavorTag(tag))
                        .toList(),
                  ),

                  const SizedBox(height: 48),

                  // Steps
                  Text(
                    "BREW STEPS",
                    style: AppTheme.monoStyle.copyWith(
                      color: ColorPalette.matteSteel,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  ...recipe.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return _buildStepItem(index, step);
                  }),
                ],
              ),
            ),
          ),

          // Floating Action Button
          Positioned(
            left: 32,
            right: 32,
            bottom: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ColorPalette.charcoal.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _startBrewing(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.charcoal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.play,
                      size: 14,
                      color: ColorPalette.rustedCopper,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "START BREWING",
                      style: AppTheme.monoStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.monoStyle.copyWith(
            color: ColorPalette.matteSteel,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: ColorPalette.obsidian,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: ColorPalette.concreteDark);
  }

  Widget _buildMetadataChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTheme.monoStyle.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFlavorTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.concreteDark),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: ColorPalette.obsidian,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStepItem(int index, BrewStep step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: ColorPalette.obsidian,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: AppTheme.monoStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.description,
                  style: const TextStyle(
                    color: ColorPalette.obsidian,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${step.targetWeight}g",
                      style: AppTheme.monoStyle.copyWith(
                        color: ColorPalette.rustedCopper,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${step.durationSeconds}s",
                      style: AppTheme.monoStyle.copyWith(
                        color: ColorPalette.matteSteel,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
