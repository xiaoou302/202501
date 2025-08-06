import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/trading_pair.dart';
import '../../data/models/sentiment.dart';
import '../market/market_card.dart';
import '../signals/signal_card.dart';

/// Market Analysis section displaying cryptocurrency market data and trends
class MarketAnalysisSection extends StatefulWidget {
  final List<TradingPair> tradingPairs;
  final List<Sentiment> sentiments;
  final Map<String, dynamic> marketOverview;

  const MarketAnalysisSection({
    Key? key,
    required this.tradingPairs,
    required this.sentiments,
    required this.marketOverview,
  }) : super(key: key);

  @override
  State<MarketAnalysisSection> createState() => _MarketAnalysisSectionState();
}

class _MarketAnalysisSectionState extends State<MarketAnalysisSection> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<TradingPair> _filteredPairs = [];
  List<Sentiment> _filteredSentiments = [];

  // Categories for filter tabs
  final List<String> _categories = ['All', 'Major', 'Altcoin', 'DeFi', 'Meme'];

  @override
  void initState() {
    super.initState();
    _filteredPairs = widget.tradingPairs;
    _filteredSentiments = _getCryptoSentiments();
    _searchController.addListener(_filterAssets);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Sentiment> _getCryptoSentiments() {
    return widget.sentiments
        .where((sentiment) =>
            sentiment.assetClass.contains('加密货币') ||
            sentiment.asset.contains('比特币') ||
            sentiment.asset.contains('以太坊'))
        .toList();
  }

  void _filterAssets() {
    final query = _searchController.text.toUpperCase();

    setState(() {
      // Filter trading pairs
      _filteredPairs = widget.tradingPairs.where((pair) {
        final matchesQuery = pair.id.toUpperCase().contains(query);
        final matchesCategory =
            _selectedCategory == 'All' || pair.category == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();

      // Filter sentiments
      _filteredSentiments = _getCryptoSentiments().where((sentiment) {
        return sentiment.asset.toUpperCase().contains(query) ||
            sentiment.assetFullName.toUpperCase().contains(query);
      }).toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterAssets();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Search bar
          _buildSearchBar(),
          const SizedBox(height: 16),

          // Category filter tabs
          _buildCategoryTabs(),
          const SizedBox(height: 24),

          // Market trends section
          _buildSectionHeader('市场趋势', '基于链上数据和交易量分析'),
          const SizedBox(height: 16),

          // Top performing cryptocurrencies
          _buildTopPerformers(),
          const SizedBox(height: 24),

          // Market sentiment analysis
          _buildSectionHeader('市场情绪分析', '基于技术指标和社交媒体数据'),
          const SizedBox(height: 16),

          // Sentiment cards
          ..._filteredSentiments
              .take(2)
              .map((sentiment) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SignalCard(
                      sentiment: sentiment,
                      onTap: () => _showSentimentDetails(sentiment),
                    ),
                  ))
              .toList(),

          const SizedBox(height: 24),

          // All trading pairs
          _buildSectionHeader(
              _selectedCategory == 'All' ? '所有交易对' : '$_selectedCategory 交易对',
              '${_filteredPairs.length} 对'),
          const SizedBox(height: 16),

          // Trading pair cards
          if (_filteredPairs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  '没有找到匹配的交易对',
                  style: AppStyles.secondaryText,
                ),
              ),
            )
          else
            ..._filteredPairs
                .map(
                  (pair) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: MarketCard(
                      tradingPair: pair,
                      onTap: () => _showPairDetails(pair),
                    ),
                  ),
                )
                .toList(),

          // Bottom padding
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _searchFocusNode.hasFocus
              ? AppColors.goldenHighlight.withOpacity(0.5)
              : AppColors.borderColor,
        ),
        boxShadow: _searchFocusNode.hasFocus
            ? [
                BoxShadow(
                  color: AppColors.goldenHighlight.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: AppStyles.bodyText,
        cursorColor: AppColors.goldenHighlight,
        textCapitalization: TextCapitalization.characters,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _searchFocusNode.unfocus(),
        decoration: InputDecoration(
          hintText: '搜索加密货币 (例如: BTC/USDT)',
          hintStyle: AppStyles.secondaryText,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.stardustWhite,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.stardustWhite,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return GestureDetector(
            onTap: () => _filterByCategory(category),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.goldenHighlight.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.goldenHighlight
                      : AppColors.borderColor,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.goldenHighlight
                      : AppColors.stardustWhite,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.heading3,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppStyles.secondaryText.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTopPerformers() {
    // Sort by change percent
    final topPairs = List<TradingPair>.from(widget.tradingPairs)
      ..sort((a, b) => b.changePercent.compareTo(a.changePercent));

    return Column(
      children: topPairs.take(3).map((pair) {
        final isPositive = pair.changePercent >= 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Icon based on cryptocurrency
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _getCryptoColor(pair.id),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  pair.id.split('/')[0].substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pair.id,
                      style: AppStyles.bodyText.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      pair.summary,
                      style: AppStyles.secondaryText.copyWith(
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        color: isPositive
                            ? AppStyles.positiveChange.color
                            : AppStyles.negativeChange.color,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${isPositive ? '+' : ''}${pair.changePercent.toStringAsFixed(2)}%',
                        style: isPositive
                            ? AppStyles.positiveChange
                            : AppStyles.negativeChange,
                      ),
                    ],
                  ),
                  Text(
                    '\$${pair.volume.toStringAsFixed(1)}B',
                    style: AppStyles.secondaryText.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getCryptoColor(String pairId) {
    final symbol = pairId.split('/')[0];

    switch (symbol) {
      case 'BTC':
        return Colors.orange;
      case 'ETH':
        return Colors.purple;
      case 'BNB':
        return Colors.amber;
      case 'SOL':
        return Colors.green;
      case 'ADA':
        return Colors.blue;
      case 'DOGE':
        return Colors.amber.shade700;
      case 'SHIB':
        return Colors.red;
      case 'XRP':
        return Colors.blueGrey;
      case 'DOT':
        return Colors.pink;
      default:
        return Colors.teal;
    }
  }

  void _showPairDetails(TradingPair pair) {
    // In a real app, this would navigate to a detailed view
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.midnightBlue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${pair.id} 详情',
                    style: AppStyles.heading2,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Detailed card
                    MarketCard(
                      tradingPair: pair,
                      isExpanded: true,
                    ),
                    const SizedBox(height: 24),

                    // Additional details section
                    Text('市场分析', style: AppStyles.heading3),
                    const SizedBox(height: 12),
                    Text(
                      '${pair.id} 当前处于${pair.trend == 'up' ? '上升' : '下降'}趋势，'
                      '市场情绪${pair.marketSentiment == 'Bullish' ? '看涨' : pair.marketSentiment == 'Bearish' ? '看跌' : '中性'}。'
                      '交易量为 \$${pair.volume.toStringAsFixed(1)}B，波动率为 ${pair.volatility.toStringAsFixed(0)}。'
                      '${pair.summary}',
                      style: AppStyles.bodyText,
                    ),
                    const SizedBox(height: 24),

                    // Trading recommendations
                    Text('交易建议', style: AppStyles.heading3),
                    const SizedBox(height: 12),
                    _buildTradingRecommendation(pair),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradingRecommendation(TradingPair pair) {
    final isPositive = pair.changePercent >= 0;
    final sentiment = pair.marketSentiment;

    String recommendation;
    Color recommendationColor;

    if (isPositive && sentiment == 'Bullish') {
      recommendation = '强烈买入';
      recommendationColor = AppColors.fieryRed;
    } else if (isPositive && sentiment == 'Neutral') {
      recommendation = '谨慎买入';
      recommendationColor = AppColors.fieryRed.withOpacity(0.7);
    } else if (!isPositive && sentiment == 'Bearish') {
      recommendation = '强烈卖出';
      recommendationColor = AppColors.coolBlue;
    } else if (!isPositive && sentiment == 'Neutral') {
      recommendation = '谨慎卖出';
      recommendationColor = AppColors.coolBlue.withOpacity(0.7);
    } else {
      recommendation = '观望';
      recommendationColor = AppColors.goldenHighlight;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: recommendationColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: recommendationColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: recommendationColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: recommendationColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: recommendationColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '基于链上数据和市场情绪分析',
                  style: AppStyles.secondaryText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSentimentDetails(Sentiment sentiment) {
    // In a real app, this would navigate to a detailed view
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.midnightBlue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${sentiment.asset} 详细分析',
                    style: AppStyles.heading2,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Use the SignalCard to show full details
                    SignalCard(
                      sentiment: sentiment,
                      onTap: null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
