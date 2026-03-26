import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/glass_panel.dart';

class GalleryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;
  final double rating;
  final List<String> tags;
  final VoidCallback onViewDetails;
  final VoidCallback onTap;
  final bool showImage;

  const GalleryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.rating,
    required this.tags,
    required this.onViewDetails,
    required this.onTap,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        if (showImage) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: onTap,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.voidBlack,
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.image,
                        color: AppColors.mossMuted,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Gradient Overlays
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.voidBlack.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 320,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.voidBlack,
                    AppColors.voidBlack.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],

        // Content
        Positioned(
          left: 24,
          right: 24,
          bottom: 120, // Space for Nav Bar
          child: GestureDetector(
            onTap: onTap,
            child: GalleryInfoCard(
              title: title,
              artist: artist,
              rating: rating,
              tags: tags,
              onViewDetails: onViewDetails,
            ),
          ),
        ),
      ],
    );
  }
}

class GalleryInfoCard extends StatelessWidget {
  final String title;
  final String artist;
  final double rating;
  final List<String> tags;
  final VoidCallback onViewDetails;

  const GalleryInfoCard({
    super.key,
    required this.title,
    required this.artist,
    required this.rating,
    required this.tags,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(24),
      borderColor: Colors.white.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
                      title,
                      style: const TextStyle(
                        color: AppColors.starlightWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: AppColors.mossMuted,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: 'by '),
                          TextSpan(
                            text: artist,
                            style: const TextStyle(color: AppColors.aquaCyan),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.voidBlack.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.trenchBlue),
                ),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.star,
                      size: 10,
                      color: AppColors.algaeWarning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        color: AppColors.algaeWarning,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.trenchBlue.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: AppColors.starlightWhite,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 24),

          // Action Button
          InkWell(
            onTap: onViewDetails,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.floraNeon,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.floraNeon.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.eye,
                    color: AppColors.voidBlack,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'View Parameters',
                    style: const TextStyle(
                      color: AppColors.voidBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
