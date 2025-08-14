import 'package:flutter/material.dart';
import '../models/pack_item.dart';
import '../theme/app_theme.dart';
import 'package:flutter/services.dart';

/// Smart pack grid component, displays equipment and items
class SmartPackGrid extends StatelessWidget {
  final List<PackItem> items;
  final Function(PackItem) onItemTap;
  final int columns;
  final bool showQuantity;

  const SmartPackGrid({
    Key? key,
    required this.items,
    required this.onItemTap,
    this.columns = 3,
    this.showQuantity = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGridItem(context, item);
      },
    );
  }

  /// Build grid item
  Widget _buildGridItem(BuildContext context, PackItem item) {
    return GestureDetector(
      onTap: () => onItemTap(item),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: item.isPacked
              ? Border.all(color: AppTheme.successGreen, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon(item),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      item.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: item.isPacked
                            ? AppTheme.successGreen
                            : AppTheme.primaryText,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  if (showQuantity && item.quantity > 1)
                    Text(
                      'x${item.quantity}',
                      style: const TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 9,
                      ),
                    ),
                ],
              ),
            ),

            // Completion status indicator
            if (item.isPacked)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppTheme.successGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build icon
  Widget _buildIcon(PackItem item) {
    // Using simple icon mapping, real applications might need more complex handling
    IconData iconData;

    switch (item.category) {
      case PackCategory.documents:
        iconData = Icons.description;
        break;
      case PackCategory.clothing:
        iconData = Icons.checkroom;
        break;
      case PackCategory.electronics:
        iconData = Icons.devices;
        break;
      case PackCategory.toiletries:
        iconData = Icons.bathroom;
        break;
      case PackCategory.accessories:
        iconData = Icons.watch;
        break;
      case PackCategory.equipment:
        iconData = Icons.sports;
        break;
      case PackCategory.medications:
        iconData = Icons.medication;
        break;
      case PackCategory.footwear:
        iconData = Icons.hiking;
        break;
      case PackCategory.seasonal:
        iconData = Icons.wb_sunny;
        break;
      case PackCategory.food:
        iconData = Icons.fastfood;
        break;
      case PackCategory.childcare:
        iconData = Icons.child_care;
        break;
      case PackCategory.other:
        iconData = Icons.category;
        break;
    }

    return Icon(iconData, size: 20, color: AppTheme.primaryText);
  }
}
