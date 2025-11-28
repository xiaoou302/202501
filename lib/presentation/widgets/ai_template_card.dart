import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AITemplateCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final VoidCallback? onTap;

  const AITemplateCard({
    super.key,
    required this.imageUrl,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 128,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              child: Image.network(
                imageUrl,
                width: 128,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 128,
                    height: 160,
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                color: AppConstants.offWhite,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
