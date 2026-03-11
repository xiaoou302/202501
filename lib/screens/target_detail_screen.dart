import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/astro_target.dart';
import '../widgets/astro_image.dart';
import '../widgets/glass_panel.dart';
import '../utils/app_colors.dart';

class TargetDetailScreen extends StatelessWidget {
  final AstroTarget target;

  const TargetDetailScreen({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorder, width: 1),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.starlightWhite,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image with Hero
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AstroImage(
                    imageUrl: target.imageUrl,
                    fit: BoxFit.cover,
                    heroTag: target.id,
                  ),
                  // Gradient Overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Palette
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          target.name,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.starlightWhite,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orionPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.orionPurple,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          target.palette,
                          style: const TextStyle(
                            color: AppColors.orionPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  if (target.description != null)
                    Text(
                      target.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.starlightWhite,
                        height: 1.6,
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Object Information
                  _buildSectionHeader(
                    context,
                    'Object Information',
                    FontAwesomeIcons.circleInfo,
                  ),
                  const SizedBox(height: 12),
                  GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(context, 'Type', target.type),
                        const Divider(color: AppColors.glassBorder),
                        _buildDetailRow(context, 'Size', target.size),
                        const Divider(color: AppColors.glassBorder),
                        _buildDetailRow(
                          context,
                          'Discovery',
                          target.discoveryInfo,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Celestial Coordinates & Info
                  _buildSectionHeader(
                    context,
                    'Celestial Coordinates',
                    FontAwesomeIcons.globe,
                  ),
                  const SizedBox(height: 12),
                  GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          context,
                          'Constellation',
                          target.constellation,
                        ),
                        const Divider(color: AppColors.glassBorder),
                        _buildDetailRow(
                          context,
                          'Right Ascension',
                          target.rightAscension,
                        ),
                        const Divider(color: AppColors.glassBorder),
                        _buildDetailRow(
                          context,
                          'Declination',
                          target.declination,
                        ),
                        const Divider(color: AppColors.glassBorder),
                        _buildDetailRow(context, 'Distance', target.distance),
                        const Divider(color: AppColors.glassBorder),
                        _buildDetailRow(
                          context,
                          'Magnitude',
                          target.apparentMagnitude,
                        ),
                        const Divider(color: AppColors.glassBorder),
                        _buildDetailRow(
                          context,
                          'Best Season',
                          target.bestSeason,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Technical Details
                  _buildSectionHeader(
                    context,
                    'Acquisition Details',
                    FontAwesomeIcons.microchip,
                  ),
                  const SizedBox(height: 12),
                  GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          context,
                          'Total Integration',
                          '${target.integrationHours} hours',
                        ),
                        const Divider(color: AppColors.glassBorder),
                        _buildDetailRow(
                          context,
                          'Focal Length',
                          '${target.focalLength} mm',
                        ),
                        const Divider(color: AppColors.glassBorder),
                        _buildDetailRow(context, 'Camera', target.cameraModel),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.andromedaCyan),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.andromedaCyan,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.meteoriteGrey),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.starlightWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
