import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class AstroImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? heroTag;

  const AstroImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final isRedSafelight = context.select<ThemeService, bool>(
      (s) => s.isRedSafelight,
    );

    // Check if the image is an asset (starts with 'assets/') or a network URL
    final bool isAsset = imageUrl.startsWith('assets/');

    Widget image;
    if (isAsset) {
      image = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[900],
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.white54),
            ),
          );
        },
      );
    } else {
      image = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[900],
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.white54),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.black12,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    }

    if (isRedSafelight) {
      // Apply red safelight filter
      // CSS equivalent: filter: grayscale(100%) brightness(0.7) sepia(100%) hue-rotate(-50deg) saturate(600%) contrast(1.2);
      // In Flutter, we can use ColorFiltered. Since exact CSS matrix is hard, we approximate with a red tint.
      // A strong red color filter with modulte or multiply usually works well.
      final filteredImage = ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Colors.red,
          BlendMode
              .modulate, // Or saturation/hue if we want to be fancy, but modulate on grayscale is safest for pure red.
        ),
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]), // Grayscale first
          child: image,
        ),
      );

      return heroTag != null
          ? Hero(tag: heroTag!, child: filteredImage)
          : filteredImage;
    }

    return heroTag != null ? Hero(tag: heroTag!, child: image) : image;
  }
}
