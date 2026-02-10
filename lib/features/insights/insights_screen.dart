import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';
import 'package:zenithsprint/data/models/badge.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Badge> badges = [
      Badge(
          name: 'Century Mark',
          description: 'Complete 100 correct calculations in a single session.',
          icon: Icons.military_tech,
          color: Colors.amber,
          earned: true),
      Badge(
          name: 'Speed Demon',
          description: 'Achieve a calculation speed of over 200 CPM.',
          icon: Icons.flash_on,
          color: Colors.blue,
          earned: true),
      Badge(
          name: 'Accuracy Ace',
          description: 'Maintain over 95% accuracy for 5 consecutive sessions.',
          icon: Icons.check_circle,
          color: Colors.green,
          earned: false),
      Badge(
          name: 'Perfect Streak',
          description: 'Complete a full session with 100% accuracy.',
          icon: Icons.star,
          color: Colors.purple,
          earned: false),
    ];

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppValues.padding_large),
          children: [
            Text(
              'Cognitive Dashboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white),
            ),
            const SizedBox(height: AppValues.margin_large),
            _buildCognitiveProfileCard(context),
            const SizedBox(height: AppValues.margin_large),
            _buildTrendCard(context),
            const SizedBox(height: AppValues.margin_large),
            _buildPerformanceMetrics(context),
            const SizedBox(height: AppValues.margin_large),
            _buildBadgesSection(context, badges),
          ],
        ),
      ),
    );
  }

  Widget _buildCognitiveProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(AppValues.radius_large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cognitive Profile',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.white),
          ),
          const SizedBox(height: AppValues.margin),
          AspectRatio(
            aspectRatio: 1.5,
            child: RadarChart(
              RadarChartData(
                dataSets: [
                  RadarDataSet(
                    dataEntries: [
                      const RadarEntry(value: 0.8),
                      const RadarEntry(value: 0.7),
                      const RadarEntry(value: 0.9),
                      const RadarEntry(value: 0.6),
                      const RadarEntry(value: 0.75),
                    ],
                    borderColor: AppColors.accent,
                    fillColor: AppColors.accent.withValues(alpha: 0.4),
                  ),
                ],
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarBorderData: const BorderSide(color: Colors.transparent),
                tickBorderData: const BorderSide(color: Colors.transparent),
                gridBorderData:
                    const BorderSide(color: AppColors.neutralLight, width: 1),
                titleTextStyle:
                    const TextStyle(color: AppColors.white, fontSize: 14),
                getTitle: (index, angle) {
                  switch (index) {
                    case 0:
                      return const RadarChartTitle(text: 'Attention');
                    case 1:
                      return const RadarChartTitle(text: 'Memory');
                    case 2:
                      return const RadarChartTitle(text: 'Speed');
                    case 3:
                      return const RadarChartTitle(text: 'Flexibility');
                    case 4:
                      return const RadarChartTitle(text: 'Problem\nSolving');
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                ticksTextStyle:
                    const TextStyle(color: Colors.transparent, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(AppValues.radius_large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pressure Accuracy Trend',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.white),
          ),
          const SizedBox(height: AppValues.margin_large),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                barGroups: [
                  _makeGroupData(0, 60),
                  _makeGroupData(1, 65),
                  _makeGroupData(2, 75),
                  _makeGroupData(3, 72),
                  _makeGroupData(4, 85),
                  _makeGroupData(5, 92),
                ],
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: AppColors.neutralLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Mon', style: style);
                            break;
                          case 1:
                            text = const Text('Tue', style: style);
                            break;
                          case 2:
                            text = const Text('Wed', style: style);
                            break;
                          case 3:
                            text = const Text('Thu', style: style);
                            break;
                          case 4:
                            text = const Text('Fri', style: style);
                            break;
                          case 5:
                            text = const Text('Sat', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 16.0,
                          child: text,
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()}%',
                        const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.accent,
          width: 22,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
              context, 'Peak Performance', '185 CPM', Icons.speed),
        ),
        const SizedBox(width: AppValues.margin),
        Expanded(
          child: _buildMetricCard(
              context, 'Cognitive Endurance', '12 mins', Icons.timer),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(AppValues.radius_large),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: 32),
          const SizedBox(height: AppValues.margin_small),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.neutralLight),
          ),
          const SizedBox(height: AppValues.margin_small),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection(BuildContext context, List<Badge> badges) {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(AppValues.radius_large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Badges & Achievements',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.white),
          ),
          const SizedBox(height: AppValues.margin),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppValues.margin_small,
              mainAxisSpacing: AppValues.margin_small,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return Opacity(
                opacity: badge.earned ? 1.0 : 0.3,
                child: Tooltip(
                  message: '${badge.name}\n${badge.description}',
                  child: CircleAvatar(
                    backgroundColor: badge.color,
                    child: Icon(badge.icon, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
