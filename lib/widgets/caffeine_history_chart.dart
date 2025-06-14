import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/drink.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CaffeineHistoryChart extends StatelessWidget {
  final List<Drink> drinks;
  final int days;

  const CaffeineHistoryChart({
    super.key,
    required this.drinks,
    this.days = 7,
  });

  @override
  Widget build(BuildContext context) {
    // Get history data
    final historyData = _calculateHistoryData();
    final maxValue = _findMaxValue(historyData);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deepSpace.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Caffeine Intake History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Last $days days',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200, // Increased height to fit all content
            child: historyData.isEmpty
                ? const Center(child: Text('No history data available'))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth =
                          constraints.maxWidth / historyData.length;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          historyData.length,
                          (index) => _buildBar(
                            context,
                            historyData[index],
                            maxValue,
                            index == historyData.length - 1, // Is today
                            itemWidth,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Safe intake: ${CaffeineConstants.safeDailyIntake}mg/day',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build bar chart
  Widget _buildBar(
    BuildContext context,
    Map<String, dynamic> data,
    int maxValue,
    bool isToday,
    double width,
  ) {
    final dayValue = data['value'] as int;
    final date = data['date'] as DateTime;

    // Calculate bar height percentage
    final percentage = maxValue > 0 ? dayValue / maxValue : 0.0;

    // Determine color based on intake
    Color barColor;
    if (dayValue > CaffeineConstants.safeDailyIntake) {
      barColor = AppColors.errorPink;
    } else if (dayValue > CaffeineConstants.safeDailyIntake * 0.7) {
      barColor = AppColors.hologramPurple;
    } else {
      barColor = AppColors.electricBlue;
    }

    // Safe line height percentage
    final safeLinePercentage =
        maxValue > 0 ? CaffeineConstants.safeDailyIntake / maxValue : 0.0;

    // Calculate bar height, ensuring enough space for labels
    final barHeight = 140.0;

    return SizedBox(
      width: width - 4, // Subtract some margin
      height: 200, // Fixed height to prevent overflow
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum height
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Intake label
          if (dayValue > 0)
            SizedBox(
              height: 14, // Fixed height
              child: Text(
                '${dayValue}mg',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? barColor : Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          const SizedBox(height: 4),

          // Bar chart container
          Container(
            width: 30,
            height: barHeight,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Safe line
                Positioned(
                  bottom: barHeight * safeLinePercentage.toDouble(),
                  child: Container(
                    width: 30,
                    height: 1,
                    color: AppColors.electricBlue.withOpacity(0.5),
                  ),
                ),

                // Bar
                Container(
                  width: 20,
                  height: barHeight * percentage.toDouble(),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        barColor,
                        barColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isToday
                        ? [
                            BoxShadow(
                              color: barColor.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Date label - using constrained layout to ensure no overflow
          SizedBox(
            height: 14, // Fixed height
            width: width - 4,
            child: Center(
              child: Text(
                _formatDayLabel(date),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? Colors.white : Colors.white.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Calculate history data
  List<Map<String, dynamic>> _calculateHistoryData() {
    final result = <Map<String, dynamic>>[];
    final now = DateTime.now();

    // Generate dates for the past 'days' days
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);

      // Calculate total caffeine intake for the day
      int totalCaffeine = 0;
      for (final drink in drinks) {
        if (drink.time.isAfter(dayStart) && drink.time.isBefore(dayEnd)) {
          totalCaffeine += drink.caffeine;
        }
      }

      result.add({
        'date': dayStart,
        'value': totalCaffeine,
      });
    }

    return result;
  }

  // Find maximum value
  int _findMaxValue(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0;

    int max = data.map<int>((item) => item['value'] as int).reduce(
          (a, b) => a > b ? a : b,
        );

    // Ensure max value is at least the safe intake amount
    return max > CaffeineConstants.safeDailyIntake
        ? max
        : CaffeineConstants.safeDailyIntake;
  }

  // Format date label
  String _formatDayLabel(DateTime date) {
    final now = DateTime.now();

    if (DateTimeHelper.isSameDay(date, now)) {
      return 'Today';
    }

    if (DateTimeHelper.isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }

    return DateFormat('M/d').format(date);
  }
}
