import 'package:flutter/material.dart';
import 'dart:io';
import '../../../theme.dart';
import '../../../shared/utils/date_utils.dart';
import '../models/memory.dart';

class TimelineItem extends StatelessWidget {
  final Memory memory;
  final bool isLast;

  const TimelineItem({super.key, required this.memory, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineLine(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 24),
            child: _buildContent(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine() {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: AppTheme.lightPurple,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightPurple.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        if (!isLast)
          Container(
            width: 2,
            height: 100,
            color: AppTheme.lightPurple.withOpacity(0.3),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          memory.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(
          AppDateUtils.formatDate(memory.date),
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(memory.description, style: const TextStyle(color: Colors.white70)),
        if (memory.imageUrls.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildImageGrid(context),
        ],
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          memory.imageUrls.map((url) => _buildImageThumbnail(url)).toList(),
    );
  }

  Widget _buildImageThumbnail(String url) {
    final bool isLocalFile = !url.startsWith('http');

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [AppTheme.deepPurple, AppTheme.accentPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: isLocalFile
            ? Image.file(
                File(url),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child:
                        Icon(Icons.broken_image, color: AppTheme.lightPurple),
                  );
                },
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.lightPurple),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child:
                        Icon(Icons.broken_image, color: AppTheme.lightPurple),
                  );
                },
              ),
      ),
    );
  }
}
