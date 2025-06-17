import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../shared/utils/date_utils.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/app_strings.dart';
import '../../../shared/widgets/app_card.dart';
import '../models/trip.dart';
import '../models/packing_item.dart';

class TripCard extends StatefulWidget {
  final Trip trip;
  final Function(Trip) onTripUpdated;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TripCard({
    super.key,
    required this.trip,
    required this.onTripUpdated,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  bool _showPackingList = false;

  void _togglePackingItem(PackingItem item) {
    final updatedList = List<PackingItem>.from(widget.trip.packingList);
    final index = updatedList.indexWhere((i) => i.id == item.id);

    if (index != -1) {
      updatedList[index].togglePacked();

      final updatedTrip = widget.trip.copyWith(packingList: updatedList);

      widget.onTripUpdated(updatedTrip);
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.deleteTrip),
        content: Text(AppStrings.deleteTripConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onDelete != null) {
                widget.onDelete!();
              }
            },
            child: Text(AppStrings.delete),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final isTomorrow = widget.trip.startDate.year == tomorrow.year &&
        widget.trip.startDate.month == tomorrow.month &&
        widget.trip.startDate.day == tomorrow.day;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTripHeader(isTomorrow),
          if (_showPackingList) ...[
            const SizedBox(height: 20),
            _buildPackingList(),
          ],
        ],
      ),
    );
  }

  Widget _buildTripHeader(bool isTomorrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.trip.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppDateUtils.formatDateRange(
                      widget.trip.startDate,
                      widget.trip.endDate,
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  if (isTomorrow)
                    Text(
                      AppConstants.tipPackingReminder,
                      style: TextStyle(
                        color: AppTheme.lightPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    Text(
                      '${AppDateUtils.daysUntil(widget.trip.startDate)} ${AppStrings.daysLabel} until departure',
                      style: const TextStyle(color: Colors.lightBlue),
                    ),
                ],
              ),
            ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: isTomorrow
                      ? [Colors.deepPurple, Colors.purple]
                      : [Colors.blue.shade800, Colors.indigo.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.trip.duration.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    AppStrings.daysLabel,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showPackingList = !_showPackingList;
                });
              },
              child: Row(
                children: [
                  Text(
                    _showPackingList
                        ? 'Hide packing list'
                        : 'View packing list',
                    style: TextStyle(
                      color: AppTheme.lightPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showPackingList
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.lightPurple,
                    size: 18,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                if (widget.onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: widget.onEdit,
                    color: Colors.blue,
                    tooltip: AppStrings.editTrip,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                const SizedBox(width: 16),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: _showDeleteConfirmation,
                    color: Colors.red,
                    tooltip: AppStrings.deleteTrip,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPackingList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.luggage, size: 20),
            const SizedBox(width: 8),
            Text(
              AppStrings.packingList,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildProgressBar(),
        const SizedBox(height: 16),
        if (widget.trip.packingList.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                AppStrings.noItems,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...widget.trip.packingList.map((item) => _buildPackingItem(item)),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.packingProgress,
                style: const TextStyle(fontSize: 14)),
            Text(
              '${widget.trip.packedItemsCount}/${widget.trip.packingList.length} items',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                width: (widget.trip.packingProgress / 100) *
                    (MediaQuery.of(context).size.width - 72),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.accentPurple, AppTheme.lightPurple],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPackingItem(PackingItem item) {
    return GestureDetector(
      onTap: () => _togglePackingItem(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.darkBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.isPacked ? AppTheme.lightPurple : Colors.grey,
                  width: 2,
                ),
                color:
                    item.isPacked ? AppTheme.lightPurple : Colors.transparent,
              ),
              child: item.isPacked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              item.name,
              style: TextStyle(
                decoration: item.isPacked ? TextDecoration.lineThrough : null,
                color: item.isPacked ? Colors.grey : Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              item.isPacked ? AppStrings.packed : AppStrings.notPacked,
              style: TextStyle(
                fontSize: 12,
                color: item.isPacked ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
