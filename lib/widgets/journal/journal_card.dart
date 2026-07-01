import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/constants.dart';
import '../../services/export_service.dart';
import '../../models/journal_entry.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isStackedMode;
  final int stackCount;

  const JournalCard({
    super.key,
    required this.entry,
    this.onEdit,
    this.onDelete,
    this.isStackedMode = false,
    this.stackCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(entry.date);
    final mealStr = entry.mealDescription ?? "No meal recorded";
    final weightStr = entry.weight > 0 ? "${entry.weight} kg" : "No weight";
    final nameStr = entry.name?.isNotEmpty == true ? entry.name! : "Unknown";
    final conditionStr = entry.condition?.isNotEmpty == true
        ? entry.condition!
        : "";

    Widget cardContent = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.creamWhite, Color(0xFFFCF9F7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warmGauze.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cocoaBrown.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.seafoam, width: 2),
                  color: AppColors.oatMilk,
                  image: entry.photoPath != null
                      ? DecorationImage(
                          image: FileImage(File(entry.photoPath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: entry.photoPath == null
                    ? const Center(
                        child: Icon(
                          Icons.pets,
                          color: AppColors.chestnutGray,
                          size: 30,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            nameStr,
                            style: const TextStyle(
                              color: AppColors.cocoaBrown,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              dateStr,
                              style: const TextStyle(
                                color: AppColors.chestnutGray,
                                fontSize: 12,
                              ),
                            ),
                            if (onDelete != null && !isStackedMode) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: onDelete,
                                child: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: AppColors.chestnutGray,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (conditionStr.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          conditionStr,
                          style: const TextStyle(
                            color: AppColors.peachFuzz,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Row(
                      children: [
                        Text(
                          weightStr,
                          style: const TextStyle(
                            color: AppColors.cocoaBrown,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed,
                            decorationColor: AppColors.warmGauze,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '• $mealStr',
                            style: const TextStyle(
                              color: AppColors.chestnutGray,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (var tag in entry.activityTags)
                          _buildSmallTag(
                            "🐾 $tag",
                            AppColors.morningPeach,
                            AppColors.peachFuzz,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                isStackedMode ? Icons.layers : Icons.touch_app,
                size: 12,
                color: AppColors.chestnutGray,
              ),
              const SizedBox(width: 4),
              Text(
                isStackedMode
                    ? 'tap to view $stackCount records'
                    : 'tap to add daily record · hold to export',
                style: const TextStyle(
                  color: AppColors.chestnutGray,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Widget result = GestureDetector(
      onLongPress: () {
        if (isStackedMode) return; // Prevent export in stacked mode
        ExportService.exportText(
          "Rescue Record: $dateStr\nName: $nameStr\nWeight: $weightStr\nCondition: $conditionStr\nMeal: $mealStr",
        );
      },
      onTap: onEdit,
      child: cardContent,
    );

    if (isStackedMode && stackCount > 1) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: -12,
              left: 20,
              right: 20,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.creamWhite.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  border: Border.all(
                    color: AppColors.warmGauze.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -6,
              left: 10,
              right: 10,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.creamWhite.withValues(alpha: 0.6),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  border: Border.all(
                    color: AppColors.warmGauze.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
            result,
          ],
        ),
      );
    }

    return result;
  }

  Widget _buildSmallTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
