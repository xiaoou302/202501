import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/trading_pair.dart';
import 'market_chart.dart';

/// Reusable card for each trading pair
class MarketCard extends StatefulWidget {
  final TradingPair tradingPair;
  final VoidCallback? onTap;
  final bool isExpanded;

  const MarketCard({
    Key? key,
    required this.tradingPair,
    this.onTap,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  State<MarketCard> createState() => _MarketCardState();
}

class _MarketCardState extends State<MarketCard>
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
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _isExpanded = widget.isExpanded;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pair = widget.tradingPair;
    final isPositive = pair.changePercent >= 0;

    // Category badge color
    Color categoryColor;
    switch (pair.category) {
      case 'Major':
        categoryColor = AppColors.goldenHighlight;
        break;
      case 'Altcoin':
        categoryColor = AppColors.coolBlue;
        break;
      case 'DeFi':
        categoryColor = AppColors.fieryRed;
        break;
      case 'Meme':
        categoryColor = Colors.purple;
        break;
      default:
        categoryColor = Colors.grey;
    }

    return GestureDetector(
      onTap: widget.onTap ?? _toggleExpanded,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with pair ID, category badge and change percent
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(pair.id, style: AppStyles.cardTitle),
                            const SizedBox(width: 8),
                            _buildCategoryBadge(pair.category, categoryColor),
                          ],
                        ),
                        Text(
                          '${isPositive ? '+' : ''}${pair.changePercent.toStringAsFixed(2)}%',
                          style: isPositive
                              ? AppStyles.positiveChange
                              : AppStyles.negativeChange,
                        ),
                      ],
                    ),

                    // Volume and volatility indicators
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.bar_chart,
                          size: 14,
                          color: AppColors.stardustWhite.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '成交量: \$${pair.volume.toStringAsFixed(1)}B',
                          style: AppStyles.secondaryText,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.speed,
                          size: 14,
                          color: AppColors.stardustWhite.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '波动率: ${pair.volatility.toStringAsFixed(0)}',
                          style: AppStyles.secondaryText,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    MarketChart(data: pair.chartData, trend: pair.trend),
                    const SizedBox(height: 12),

                    // Buy/Sell rates and spread
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '买入: \$${pair.buyRate < 0.01 ? pair.buyRate.toStringAsExponential(2) : pair.buyRate.toStringAsFixed(pair.buyRate < 1 ? 6 : 2)}',
                          style: AppStyles.bodyTextSmall,
                        ),
                        Text(
                          '卖出: \$${pair.sellRate < 0.01 ? pair.sellRate.toStringAsExponential(2) : pair.sellRate.toStringAsFixed(pair.sellRate < 1 ? 6 : 2)}',
                          style: AppStyles.bodyTextSmall,
                        ),
                        Text(
                          '价差: ${(pair.spread / pair.sellRate * 100).toStringAsFixed(2)}%',
                          style: AppStyles.bodyTextSmall.copyWith(
                            color: AppColors.goldenHighlight,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Divider(color: AppColors.borderColor),
                    const SizedBox(height: 4),

                    // Market sentiment indicator
                    Row(
                      children: [
                        _buildSentimentIndicator(pair.marketSentiment),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(pair.summary,
                              style: AppStyles.secondaryText),
                        ),
                      ],
                    ),

                    // Technical indicators (expanded view)
                    if (_isExpanded) ...[
                      const SizedBox(height: 16),
                      _buildTechnicalIndicators(pair.technicalIndicators),
                    ],

                    // Expand/collapse button
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.stardustWhite.withOpacity(0.7),
                        ),
                        onPressed: _toggleExpanded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Widget _buildCategoryBadge(String category, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSentimentIndicator(String sentiment) {
    IconData icon;
    Color color;

    switch (sentiment) {
      case 'Bullish':
        icon = Icons.rocket_launch;
        color = AppColors.fieryRed;
        break;
      case 'Bearish':
        icon = Icons.trending_down;
        color = AppColors.coolBlue;
        break;
      default:
        icon = Icons.sync;
        color = AppColors.goldenHighlight;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }

  Widget _buildTechnicalIndicators(Map<String, double> indicators) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('技术指标',
            style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: indicators.entries.map((entry) {
            final name = entry.key;
            final value = entry.value;

            Color valueColor;
            if (name == 'RSI') {
              if (value > 70)
                valueColor = AppColors.fieryRed;
              else if (value < 30)
                valueColor = AppColors.coolBlue;
              else
                valueColor = AppColors.stardustWhite;
            } else if (name == 'MACD') {
              valueColor = value >= 0 ? AppColors.fieryRed : AppColors.coolBlue;
            } else {
              valueColor = AppColors.stardustWhite;
            }

            return Column(
              children: [
                Text(
                  name,
                  style: AppStyles.bodyTextSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.abs() < 0.01
                      ? value.toStringAsExponential(2)
                      : value.toStringAsFixed(4),
                  style: AppStyles.bodyTextSmall.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
