import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/glass_panel.dart';

class ParameterCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final String? statusText;
  final Color? statusColor;
  final Color? valueColor;
  final Widget? trendWidget;

  const ParameterCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.statusText,
    this.statusColor,
    this.valueColor,
    this.trendWidget,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStatusColor = statusColor ?? AppColors.mossMuted;

    return GlassPanel(
      padding: const EdgeInsets.all(12), // Reduced padding
      borderRadius: BorderRadius.circular(20),
      borderColor: effectiveStatusColor.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // Prevent overflow
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.trenchBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 12, color: AppColors.mossMuted),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      // Allow text to shrink/truncate
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.mossMuted,
                          fontSize: 11, // Slightly smaller
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Status Dot
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: effectiveStatusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: effectiveStatusColor.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Value
          Expanded(
            // Use available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  // Scale text to fit
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          color: valueColor ?? AppColors.starlightWhite,
                          fontSize: 24, // Slightly smaller base size
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          shadows: valueColor != null
                              ? [
                                  Shadow(
                                    color: valueColor!.withOpacity(0.3),
                                    blurRadius: 12,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: TextStyle(
                          color: (valueColor ?? AppColors.mossMuted)
                              .withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Status Text / Bar
                if (statusText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: effectiveStatusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: effectiveStatusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  // Subtle Progress bar for aesthetic
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      height: 3,
                      width: 40,
                      color: AppColors.trenchBlue,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.6,
                        child: Container(
                          color: valueColor ?? AppColors.starlightWhite,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
