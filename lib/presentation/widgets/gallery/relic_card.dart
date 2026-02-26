import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:orivet/data/models/relic_model.dart';
import 'package:orivet/presentation/screens/relic_detail_screen.dart';

class RelicCard extends StatelessWidget {
  final Relic relic;
  final double rotation;
  final VoidCallback? onDelete;

  const RelicCard({
    super.key,
    required this.relic,
    this.rotation = 0.0,
    this.onDelete,
  });

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.vellum,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          border: Border.all(color: AppColors.leather, width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.leather.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading:
                  const Icon(FontAwesomeIcons.flag, color: AppColors.leather),
              title: Text(
                'Report Issue',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(context);
              },
            ),
            const Divider(),
            ListTile(
              leading:
                  const Icon(FontAwesomeIcons.trashCan, color: AppColors.wax),
              title: Text(
                'Delete Permanently',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.wax,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final TextEditingController reportController = TextEditingController();
    String selectedReason = 'Inaccurate Information';

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          backgroundColor: AppColors.vellum,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.leather, width: 2),
          ),
          title: Text('Report Artifact',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontSize: 20)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedReason,
                  dropdownColor: AppColors.shale,
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Inaccurate Information',
                    'Inappropriate Content',
                    'Spam',
                    'Other'
                  ]
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (v) => selectedReason = v!,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reportController,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                    hintText: 'Describe the issue...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('CANCEL', style: TextStyle(color: AppColors.soot)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.leather,
                  foregroundColor: AppColors.vellum),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Report received. We will verify within 24 hours.'),
                    backgroundColor: AppColors.teal,
                  ),
                );
              },
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.vellum,
        title: const Text('Delete Artifact?'),
        content: const Text(
          'This action cannot be undone. The artifact will be permanently removed from the archive.',
          style: TextStyle(fontFamily: 'Courier Prime'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('CANCEL', style: TextStyle(color: AppColors.soot)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.wax,
                foregroundColor: AppColors.vellum),
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RelicDetailScreen(relic: relic),
          ),
        );
      },
      onLongPress: () => _showOptions(context),
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.vellum, // Lighter background for better contrast
            borderRadius: BorderRadius.circular(2), // Slight rounding
            border: Border.all(
                color: AppColors.leather.withValues(alpha: 0.15), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                offset: const Offset(4, 4), // Deeper shadow
                blurRadius: 8,
              ),
            ],
          ),
          padding: const EdgeInsets.all(8), // More padding inside the "frame"
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Area
              Stack(
                children: [
                  Hero(
                    tag: 'relic_${relic.id}',
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.soot,
                        border: Border.all(
                            color: AppColors.leather.withValues(alpha: 0.1)),
                      ),
                      child: Image.asset(
                        relic.imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 300,
                        gaplessPlayback: true,
                        // Removed sepia tint for clearer view, kept slight warmth
                        color: const Color(0xFF704214).withValues(alpha: 0.1),
                        colorBlendMode: BlendMode.srcATop,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.soot,
                          child: const Center(
                            child: Icon(Icons.broken_image,
                                color: AppColors.vellum, size: 32),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.leather,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          )
                        ],
                      ),
                      child: Text(
                        relic.era,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.vellum,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Info Area
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          relic.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontSize: 18, // Larger title
                                height: 1.1,
                                color: AppColors.ink,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.locationDot,
                                size: 10,
                                color: AppColors.soot.withValues(alpha: 0.7)),
                            const SizedBox(width: 4),
                            Text(
                              relic.provenance.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontSize: 9,
                                    color: AppColors.soot,
                                    letterSpacing: 1.0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
