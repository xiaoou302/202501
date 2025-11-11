import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class FilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChips({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  static const List<String> filters = [
    'All',
    'Following',
    '#DailyMoments',
    '#HappyMoments',
    '#AdventureTime',
    '#TrainingTips',
    '#PetCare',
    '#FunnyMoments',
    '#PetCareTips',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return Padding(
            padding: EdgeInsets.only(
              right: index < filters.length - 1 ? AppConstants.spacingS : 0,
            ),
            child: _FilterChip(
              label: filter,
              isSelected: isSelected,
              isDark: isDark,
              onTap: () => onFilterChanged(filter),
            ),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      AppConstants.softCoral,
                      AppConstants.softCoral.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isSelected
                ? null
                : (widget.isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            border: Border.all(
              color: widget.isSelected
                  ? AppConstants.softCoral.withOpacity(0.3)
                  : (widget.isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05)),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppConstants.softCoral.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppConstants.softCoral.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isSelected)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    widget.label == 'Following'
                        ? Icons.favorite
                        : (widget.label == 'All'
                              ? Icons.grid_view_rounded
                              : Icons.tag),
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isSelected
                      ? FontWeight.bold
                      : FontWeight.w600,
                  color: widget.isSelected
                      ? Colors.white
                      : (widget.isDark
                            ? AppConstants.softWhite
                            : AppConstants.darkGraphite),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
