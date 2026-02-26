import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:orivet/core/constants/strings.dart';
import 'package:orivet/data/models/relic_model.dart';

class RelicDetailScreen extends StatelessWidget {
  final Relic relic;

  const RelicDetailScreen({super.key, required this.relic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vellum,
      body: Stack(
        children: [
          // Background Texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://www.transparenttextures.com/patterns/cream-paper.png'),
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.vellum.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FontAwesomeIcons.arrowLeft,
                        color: AppColors.leather, size: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                expandedHeight: 400,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      Hero(
                        tag: 'relic_${relic.id}',
                        child: Image.asset(
                          relic.imageUrl,
                          fit: BoxFit.cover,
                          cacheWidth:
                              1080, // Optimization: Limit max width for detail view
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                  color: AppColors.soot,
                                  child: const Center(
                                      child: Icon(Icons.broken_image,
                                          color: AppColors.vellum))),
                        ),
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.vellum.withOpacity(0.2),
                              AppColors.vellum,
                            ],
                            stops: const [0.6, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  relic.era,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        letterSpacing: 2.0,
                                        color: AppColors.brass,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  relic.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontSize: 36, // Larger
                                        height: 1.1,
                                        color: AppColors.ink,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // ID Badge - Stamp Style
                          Transform.rotate(
                            angle: -0.1, // Slight tilt for stamp effect
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.wax, width: 2),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.wax.withValues(alpha: 0.05),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "ARCHIVE REF",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontSize: 8,
                                          color: AppColors.wax,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    relic.id.split('-').last,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.wax,
                                          fontSize: 18,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Divider(color: AppColors.leather, thickness: 1),
                      const SizedBox(height: 32),

                      // Technical Specifications (Ledger Style)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.vellum,
                          border: Border.all(
                              color: AppColors.leather.withValues(alpha: 0.4),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.leather.withValues(alpha: 0.1),
                              offset: const Offset(4, 4),
                              blurRadius: 0, // Hard shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(FontAwesomeIcons.gears,
                                    size: 14, color: AppColors.leather),
                                const SizedBox(width: 8),
                                Text(
                                  AppStrings.detailSpecs,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.leather,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ...relic.techSpecs.entries
                                .map((entry) => Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 12.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: AppColors.leather
                                                      .withValues(alpha: 0.1),
                                                  width: 1,
                                                  style: BorderStyle.solid))),
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            entry.key.toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: AppColors.soot,
                                                  fontSize: 10,
                                                ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              entry.value,
                                              textAlign: TextAlign.right,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.ink,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.detailYear.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: AppColors.soot, fontSize: 10),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.brass.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    relic.year,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.leather,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Story Section
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.quoteLeft,
                              size: 14, color: AppColors.brass),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.detailStory,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        relic.story,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.8,
                              fontStyle: FontStyle.italic,
                            ),
                      ),

                      const SizedBox(height: 32),

                      // Restoration Notes (Visual only)
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.clipboardCheck,
                              size: 14, color: AppColors.teal),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.detailNotes,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                              left:
                                  BorderSide(color: AppColors.teal, width: 4)),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Text(
                          "Condition: ${relic.condition}. \nRecommended treatment: Ultrasonic cleaning followed by protective waxing.",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.soot,
                                    height: 1.5,
                                  ),
                        ),
                      ),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
