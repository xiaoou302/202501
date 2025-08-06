import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/repositories/market_repository.dart';
import '../../data/repositories/signals_repository.dart';
import '../../services/deepseek_service.dart';
import '../../data/models/trading_pair.dart';
import '../../data/models/sentiment.dart';
import 'market_introduction_section.dart';
import 'crypto_learning_section.dart';
import 'ai_assistant_section.dart';

/// Comprehensive analysis screen with three main sections:
/// 1. Market Introduction - Introduction to cryptocurrency markets and trading
/// 2. Crypto Learning - Educational content about cryptocurrencies
/// 3. AI Assistant - DeepSeek-powered AI chat for answering crypto questions
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final MarketRepository _marketRepository = MarketRepository();
  final SignalsRepository _signalsRepository = SignalsRepository();
  final DeepseekService _deepseekService = DeepseekService();

  late TabController _tabController;
  bool _isLoading = true;
  List<TradingPair> _tradingPairs = [];
  List<Sentiment> _sentiments = [];
  Map<String, dynamic> _marketOverview = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load data in parallel
      final futures = await Future.wait([
        _marketRepository.getTradingPairs(),
        _signalsRepository.getSentiments(),
        _signalsRepository.getMarketOverview(),
      ]);

      if (mounted) {
        setState(() {
          _tradingPairs = futures[0] as List<TradingPair>;
          _sentiments = futures[1] as List<Sentiment>;
          _marketOverview = futures[2] as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Get safe area insets to handle notch/Dynamic Island
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(16.0, topPadding + 16.0, 16.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '加密货币分析中心',
                            style: AppStyles.heading1.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '全面分析、学习与咨询',
                            style:
                                AppStyles.secondaryText.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          _buildMarketSummary(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.goldenHighlight,
                        unselectedLabelColor:
                            AppColors.stardustWhite.withOpacity(0.7),
                        indicatorColor: AppColors.goldenHighlight,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        tabs: const [
                          Tab(text: '市场介绍'),
                          Tab(text: '货币学习'),
                          Tab(text: 'AI解答'),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  // Market Introduction Section
                  MarketIntroductionSection(
                    tradingPairs: _tradingPairs,
                    sentiments: _sentiments,
                    marketOverview: _marketOverview,
                  ),

                  // Crypto Learning Section
                  CryptoLearningSection(
                    deepseekService: _deepseekService,
                  ),

                  // AI Assistant Section
                  AIAssistantSection(
                    deepseekService: _deepseekService,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMarketSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.midnightBlue.withOpacity(0.8),
            AppColors.goldenHighlight.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '市场概览',
                style: AppStyles.heading3,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      _getMarketMoodColor(_marketOverview['marketMood'] ?? '中性')
                          .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getMarketMoodColor(
                            _marketOverview['marketMood'] ?? '中性')
                        .withOpacity(0.5),
                  ),
                ),
                child: Text(
                  _marketOverview['marketMood'] ?? '中性',
                  style: TextStyle(
                    color: _getMarketMoodColor(
                        _marketOverview['marketMood'] ?? '中性'),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('看涨资产', '${_marketOverview['bullishAssets'] ?? 0}',
                  AppColors.fieryRed),
              _buildStatCard('看跌资产', '${_marketOverview['bearishAssets'] ?? 0}',
                  AppColors.coolBlue),
              _buildStatCard(
                  '平均情绪',
                  '${(_marketOverview['averageSentiment'] ?? 0).toStringAsFixed(1)}',
                  AppColors.goldenHighlight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppStyles.secondaryText.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMarketMoodColor(String mood) {
    if (mood.contains('乐观') || mood.contains('看涨')) {
      return AppColors.fieryRed;
    } else if (mood.contains('谨慎')) {
      return Colors.amber;
    } else if (mood.contains('悲观') || mood.contains('看跌')) {
      return AppColors.coolBlue;
    } else {
      return AppColors.goldenHighlight;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.midnightBlue,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
