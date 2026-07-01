import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/constants.dart';
import '../../models/journal_entry.dart';
import '../../services/database_service.dart';

class TrendChart extends StatefulWidget {
  final String selectedName;
  final List<JournalEntry> entries;
  const TrendChart({
    super.key,
    required this.selectedName,
    required this.entries,
  });

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  bool _showWeight = true;
  bool _showActivity = false;
  List<JournalEntry> _filteredEntries = [];

  @override
  void initState() {
    super.initState();
    _filterData();
  }

  @override
  void didUpdateWidget(covariant TrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedName != widget.selectedName ||
        oldWidget.entries != widget.entries) {
      _filterData();
    }
  }

  void _filterData() {
    // Sort entries by date ascending for chart
    final sortedEntries = List<JournalEntry>.from(widget.entries);
    sortedEntries.sort((a, b) => a.date.compareTo(b.date));

    if (widget.selectedName == "All") {
      _filteredEntries = sortedEntries;
    } else {
      _filteredEntries = sortedEntries.where((e) {
        final name = e.name?.trim() ?? "Unknown";
        return name == widget.selectedName;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.creamWhite, AppColors.oatMilk],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warmGauze.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.chestnutGray.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, size: 20, color: AppColors.seafoam),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Data Mirror',
                  style: TextStyle(
                    color: AppColors.cocoaBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildToggleChip(
                'Weight',
                _showWeight,
                AppColors.peachFuzz,
                (val) => setState(() => _showWeight = val),
              ),
              _buildToggleChip(
                'Activity',
                _showActivity,
                AppColors.warmSun,
                (val) => setState(() => _showActivity = val),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: _filteredEntries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_graph,
                          color: AppColors.chestnutGray.withValues(alpha: 0.3),
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Awaiting the first footprint...',
                          style: TextStyle(
                            color: AppColors.chestnutGray,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Data mirror will reflect their journey to health',
                          style: TextStyle(
                            color: AppColors.chestnutGray,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildChart(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chart connects raw data points without any trend interpretation or health warnings.',
            style: TextStyle(
              color: AppColors.chestnutGray,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    // Generate consecutive indices for X axis to ensure line connection
    // even if dates are not strictly uniform
    final validWeightEntries = _filteredEntries
        .where((e) => e.weight > 0)
        .toList();
    final validActivityEntries = _filteredEntries
        .where((e) => e.activityTags.isNotEmpty)
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.warmGauze,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.chestnutGray,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          if (_showWeight && validWeightEntries.isNotEmpty)
            LineChartBarData(
              spots: validWeightEntries
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.weight))
                  .toList(),
              isCurved: true,
              color: AppColors.peachFuzz,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.peachFuzz.withValues(alpha: 0.1),
              ),
            ),
          if (_showActivity && validActivityEntries.isNotEmpty)
            LineChartBarData(
              spots: validActivityEntries
                  .asMap()
                  .entries
                  .map(
                    (e) => FlSpot(
                      e.key.toDouble(),
                      (e.value.activityTags.length * 10).toDouble(),
                    ),
                  )
                  .toList(),
              isCurved: true,
              color: AppColors.warmSun,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
            ),
        ],
      ),
    );
  }

  Widget _buildToggleChip(
    String label,
    bool value,
    Color activeColor,
    ValueChanged<bool> onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: value ? activeColor.withValues(alpha: 0.1) : AppColors.oatMilk,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value
                ? activeColor.withValues(alpha: 0.5)
                : AppColors.warmGauze,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_circle : Icons.circle_outlined,
              size: 14,
              color: value
                  ? activeColor
                  : AppColors.chestnutGray.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: value ? activeColor : AppColors.chestnutGray,
                fontWeight: value ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
