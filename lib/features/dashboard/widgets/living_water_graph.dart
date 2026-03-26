import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/glass_panel.dart';

class LivingWaterGraph extends StatelessWidget {
  final List<FlSpot> spots;
  final double stabilityIndex;

  const LivingWaterGraph({
    super.key,
    required this.spots,
    required this.stabilityIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      height: 220,
      padding: const EdgeInsets.all(0),
      borderRadius: BorderRadius.circular(24),
      borderColor: AppColors.floraNeon.withOpacity(0.1),
      child: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.deepTeal.withOpacity(0.4),
                  AppColors.voidBlack.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // Header Info
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.chartLine,
                          size: 14,
                          color: AppColors.floraNeon.withOpacity(0.8),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'ECOSYSTEM STABILITY',
                          style: TextStyle(
                            color: AppColors.mossMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: stabilityIndex.toStringAsFixed(1),
                            style: const TextStyle(
                              color: AppColors.starlightWhite,
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -1,
                            ),
                          ),
                          const TextSpan(
                            text: '%',
                            style: TextStyle(
                              color: AppColors.floraNeon,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.floraNeon.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.floraNeon.withOpacity(0.2),
                    ),
                  ),
                  child: const Text(
                    'pH Trend',
                    style: TextStyle(
                      color: AppColors.floraNeon,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chart
          Positioned.fill(
            top: 70, // Reduced top padding
            bottom: 10, // Added bottom padding
            left: 10, // Added side padding
            right: 20, // Added right padding for labels
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.mossMuted.withOpacity(0.05),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) =>
                        AppColors.deepTeal.withOpacity(0.9),
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipBorder: const BorderSide(color: AppColors.floraNeon),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          spot.y.toStringAsFixed(1),
                          const TextStyle(
                            color: AppColors.starlightWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((spotIndex) {
                          return TouchedSpotIndicatorData(
                            const FlLine(
                              color: AppColors.floraNeon,
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            ),
                            FlDotData(
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.voidBlack,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.floraNeon,
                                );
                              },
                            ),
                          );
                        }).toList();
                      },
                ),
                minX: 0,
                maxX: spots.isNotEmpty ? spots.last.x : 10,
                minY: 5.0, // Assuming pH range roughly
                maxY: 9.0,
                clipData: const FlClipData.all(), // Ensure clipping
                lineBarsData: [
                  LineChartBarData(
                    spots: spots.isNotEmpty
                        ? spots
                        : const [FlSpot(0, 7.0), FlSpot(10, 7.0)],
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.aquaCyan,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.aquaCyan.withOpacity(0.2),
                          AppColors.aquaCyan.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
