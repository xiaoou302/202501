import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/sentiment.dart';

/// Card for each asset with a sentiment chart
class SignalCard extends StatefulWidget {
  final Sentiment sentiment;
  final VoidCallback? onTap;

  const SignalCard({Key? key, required this.sentiment, this.onTap})
      : super(key: key);

  @override
  State<SignalCard> createState() => _SignalCardState();
}

class _SignalCardState extends State<SignalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sentiment = widget.sentiment;
    final color = _getSentimentColor(sentiment.sentimentScore);
    final isPositive = sentiment.sentimentScore >= 50;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.6),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Stack(
              children: [
                // Background icon
                Positioned(
                  right: -32,
                  bottom: -32,
                  child: Icon(
                    _getIconForAsset(sentiment.asset),
                    size: 160,
                    color: color.withOpacity(0.05),
                  ),
                ),

                // Background pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: PatternPainter(color: color),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with asset name and badges
                      _buildHeader(sentiment, color),

                      const SizedBox(height: 12),

                      // Key metrics row
                      _buildKeyMetrics(sentiment, color),

                      const SizedBox(height: 12),

                      // Chart and recommendation
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Chart
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 80,
                              child: _buildChart(color),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Recommendation badge
                          Expanded(
                            flex: 2,
                            child: _buildRecommendationBadge(
                                sentiment.recommendation, color),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Summary
                      Text(
                        sentiment.summary,
                        style: AppStyles.bodyTextSmall,
                        maxLines: _isExpanded ? null : 2,
                        overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      ),

                      // Expand/collapse button
                      if (sentiment.summary.length > 100)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isExpanded ? '收起' : '展开',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color,
                                ),
                              ),
                              Icon(
                                _isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 14,
                                color: color,
                              ),
                            ],
                          ),
                        ),

                      // Additional info section
                      if (_isExpanded) _buildExpandedInfo(sentiment, color),
                    ],
                  ),
                ),

                // Sentiment score indicator
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: color,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sentiment.sentimentScore.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Sentiment sentiment, Color color) {
    return Row(
      children: [
        // Asset icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconForAsset(sentiment.asset),
            color: color,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        // Asset name and class
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sentiment.assetFullName.isNotEmpty
                    ? sentiment.assetFullName
                    : sentiment.asset,
                style: AppStyles.cardTitle.copyWith(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                sentiment.assetClass.isNotEmpty
                    ? sentiment.assetClass
                    : sentiment.mood,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.stardustWhite.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Timeframe badge
        _buildTimeframeBadge(sentiment.timeframe),
      ],
    );
  }

  Widget _buildKeyMetrics(Sentiment sentiment, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            label: '置信度',
            value: '${sentiment.confidence.toStringAsFixed(0)}%',
            icon: Icons.verified_outlined,
            color: _getConfidenceColor(sentiment.confidence),
          ),
          _buildMetricItem(
            label: '波动指数',
            value: sentiment.volatilityIndex.toStringAsFixed(0),
            icon: Icons.show_chart,
            color: _getVolatilityColor(sentiment.volatilityIndex),
          ),
          _buildMetricItem(
            label: '更新',
            value: _getTimeAgo(sentiment.lastUpdated),
            icon: Icons.access_time,
            color: AppColors.stardustWhite.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.stardustWhite.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeframeBadge(String timeframe) {
    Color badgeColor;

    switch (timeframe) {
      case '短期':
        badgeColor = Colors.amber;
        break;
      case '中期':
        badgeColor = Colors.green;
        break;
      case '长期':
        badgeColor = Colors.blue;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.5)),
      ),
      child: Text(
        timeframe,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _buildChart(Color color) {
    return CustomPaint(
      painter: SentimentChartPainter(
        data: widget.sentiment.chartData,
        color: color,
        showGradient: true,
      ),
      size: Size.infinite,
    );
  }

  Widget _buildRecommendationBadge(String recommendation, Color color) {
    Color badgeColor;
    IconData iconData;

    switch (recommendation) {
      case '强烈买入':
        badgeColor = Colors.red;
        iconData = Icons.trending_up;
        break;
      case '买入':
        badgeColor = Colors.orange;
        iconData = Icons.trending_up;
        break;
      case '持有':
        badgeColor = Colors.amber;
        iconData = Icons.trending_flat;
        break;
      case '卖出':
        badgeColor = Colors.lightBlue;
        iconData = Icons.trending_down;
        break;
      case '强烈卖出':
        badgeColor = Colors.blue;
        iconData = Icons.trending_down;
        break;
      default:
        badgeColor = Colors.grey;
        iconData = Icons.trending_flat;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: badgeColor,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            recommendation,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedInfo(Sentiment sentiment, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Divider
        Container(
          height: 1,
          color: AppColors.borderColor,
        ),

        const SizedBox(height: 16),

        // Market data
        if (sentiment.marketCap.isNotEmpty ||
            sentiment.tradingVolume.isNotEmpty)
          _buildInfoSection(
            title: '市场数据',
            children: [
              if (sentiment.marketCap.isNotEmpty)
                _buildInfoRow('市值', sentiment.marketCap),
              if (sentiment.tradingVolume.isNotEmpty)
                _buildInfoRow('24h成交量', sentiment.tradingVolume),
            ],
          ),

        // Price targets
        if (sentiment.priceTargets.isNotEmpty)
          _buildInfoSection(
            title: '价格目标',
            children: sentiment.priceTargets.entries.map((entry) {
              return _buildInfoRow(entry.key, entry.value.toString());
            }).toList(),
          ),

        // Technical indicators
        if (sentiment.indicators.isNotEmpty)
          _buildInfoSection(
            title: '技术指标',
            children: sentiment.indicators.entries.take(4).map((entry) {
              final value = entry.value;
              final valueStr = value.abs() < 0.01
                  ? value.toStringAsExponential(2)
                  : value.toStringAsFixed(4);
              return _buildInfoRow(entry.key, valueStr);
            }).toList(),
          ),

        // Key levels
        if (sentiment.keyLevels.isNotEmpty)
          _buildInfoSection(
            title: '关键价位',
            children: sentiment.keyLevels.entries.map((entry) {
              return _buildInfoRow(entry.key, entry.value.toString());
            }).toList(),
          ),

        // News events
        if (sentiment.newsEvents.isNotEmpty)
          _buildInfoSection(
            title: '相关新闻',
            children: sentiment.newsEvents.take(2).map((news) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      news['impact'] == 'positive'
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 14,
                      color: news['impact'] == 'positive'
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news['title'] as String,
                            style: AppStyles.bodyTextSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${news['source']} · ${news['date']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.stardustWhite.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildInfoSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.stardustWhite.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.stardustWhite.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.stardustWhite,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForAsset(String asset) {
    if (asset.contains('比特币')) {
      return Icons.currency_bitcoin;
    } else if (asset.contains('以太坊')) {
      return Icons.currency_exchange;
    } else if (asset.contains('黄金')) {
      return Icons.brightness_7;
    } else if (asset.contains('原油')) {
      return Icons.local_gas_station;
    } else if (asset.contains('股')) {
      return Icons.show_chart;
    } else if (asset.contains('美元')) {
      return Icons.attach_money;
    }
    return Icons.analytics;
  }

  Color _getSentimentColor(double score) {
    if (score >= 75) return Colors.red;
    if (score >= 60) return Colors.orange;
    if (score >= 45) return Colors.amber;
    if (score >= 30) return Colors.lightBlue;
    return Colors.blue;
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) return Colors.green;
    if (confidence >= 60) return Colors.lightGreen;
    if (confidence >= 40) return Colors.amber;
    return Colors.orange;
  }

  Color _getVolatilityColor(double volatility) {
    if (volatility >= 70) return Colors.red;
    if (volatility >= 50) return Colors.orange;
    if (volatility >= 30) return Colors.amber;
    return Colors.green;
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}秒前';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return DateFormat('MM-dd HH:mm').format(dateTime);
    }
  }
}

class SentimentChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final bool showGradient;

  SentimentChartPainter({
    required this.data,
    required this.color,
    this.showGradient = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Find min and max values for scaling
    final double minValue = data.reduce((a, b) => a < b ? a : b);
    final double maxValue = data.reduce((a, b) => a > b ? a : b);
    final double range = maxValue - minValue;

    // Create path for the line
    final path = Path();
    final fillPath = Path();

    // Calculate point spacing
    final double xStep = size.width / (data.length - 1);

    // Start paths
    path.moveTo(0, _getY(data[0], minValue, range, size.height));
    fillPath.moveTo(0, _getY(data[0], minValue, range, size.height));

    // Add points to the paths
    for (int i = 1; i < data.length; i++) {
      final double x = i * xStep;
      final double y = _getY(data[i], minValue, range, size.height);

      // For a smoother curve, use quadratic bezier
      if (i < data.length - 1) {
        final double nextX = (i + 1) * xStep;
        final double nextY = _getY(data[i + 1], minValue, range, size.height);

        final double controlX = x + (nextX - x) / 2;

        path.quadraticBezierTo(controlX, y, nextX, nextY);
        fillPath.quadraticBezierTo(controlX, y, nextX, nextY);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Complete the fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Apply glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawPath(path, glowPaint);

    // Draw the fill and the line
    if (showGradient) {
      canvas.drawPath(fillPath, fillPaint);
    }
    canvas.drawPath(path, paint);

    // Draw data points with small circles
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw only a few key points to avoid cluttering
    final pointsToShow = [
      0,
      data.length ~/ 4,
      data.length ~/ 2,
      3 * data.length ~/ 4,
      data.length - 1
    ];

    for (int i = 0; i < data.length; i++) {
      if (pointsToShow.contains(i)) {
        final x = i * xStep;
        final y = _getY(data[i], minValue, range, size.height);

        // Outer circle
        canvas.drawCircle(Offset(x, y), 3, pointPaint);

        // Inner highlight
        canvas.drawCircle(Offset(x, y), 1, highlightPaint);
      }
    }
  }

  double _getY(double value, double min, double range, double height) {
    // Normalize and invert (0 at top, 1 at bottom)
    final double normalizedValue = range != 0 ? (value - min) / range : 0.5;
    return height -
        (normalizedValue *
            height *
            0.8); // Use 80% of height for better visuals
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.03)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw grid pattern
    final spacing = size.width / 20;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
