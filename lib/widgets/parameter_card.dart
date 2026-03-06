import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';
import '../models/recipe.dart';

class ParameterCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const ParameterCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0), // Handled by parent
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // More rounded
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header (Cropped)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 180, // Taller image for better impact
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        recipe.imagePath,
                        fit: BoxFit.cover,
                        cacheWidth: 800,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: ColorPalette.concreteDark,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: ColorPalette.matteSteel,
                              ),
                            ),
                          );
                        },
                      ),
                      // Subtle Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                      // Floating Brewer Badge - Updated Look
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            recipe.brewer.toUpperCase(),
                            style: AppTheme.monoStyle.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.obsidian,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800, // Bolder
                                  fontSize: 20,
                                  height: 1.2,
                                  color: ColorPalette.obsidian,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "1:${(recipe.water / recipe.dose).toStringAsFixed(1)}",
                              style: AppTheme.monoStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorPalette.rustedCopper,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Data Grid - Simplified
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDataItem(
                          "${recipe.dose}g",
                          "DOSE",
                          CrossAxisAlignment.start,
                        ),
                        _buildDataItem(
                          "${recipe.temp}°C",
                          "TEMP",
                          CrossAxisAlignment.center,
                        ),
                        _buildDataItem(
                          _calculateTotalTime(recipe),
                          "TIME",
                          CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataItem(
    String value,
    String label,
    CrossAxisAlignment alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: AppTheme.monoStyle.copyWith(
            fontSize: 10,
            color: ColorPalette.matteSteel,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.monoStyle.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: ColorPalette.obsidian,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 24, color: ColorPalette.concrete);
  }

  String _calculateTotalTime(Recipe recipe) {
    int total = recipe.steps.fold(0, (sum, step) => sum + step.durationSeconds);
    int m = total ~/ 60;
    int s = total % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }
}
