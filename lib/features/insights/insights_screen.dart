import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/news_event.dart';
import '../../data/repositories/news_repository.dart';
import 'timeline_item.dart';

/// Insights screen with timeline of news/events
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
    with AutomaticKeepAliveClientMixin {
  final NewsRepository _repository = NewsRepository();
  List<NewsEvent> _newsEvents = [];
  List<NewsEvent> _filteredEvents = [];
  List<Map<String, dynamic>> _marketTrends = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  Timer? _refreshTimer;

  // 筛选相关
  String _selectedCategory = '全部';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // 分类列表 - 加密货币相关分类，更加全面和专业
  final List<String> _categories = [
    '全部',
    '比特币', // 比特币相关
    '以太坊', // 以太坊相关
    '稳定币', // USDT、USDC等
    'Layer2', // 二层扩容解决方案
    '公链', // 各类公链项目
    'DeFi', // 去中心化金融
    'NFT', // 非同质化代币
    '交易所', // 交易所相关
    '元宇宙', // 元宇宙项目
  ];

  @override
  void initState() {
    super.initState();
    _loadData();

    // 设置定时刷新
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _refreshData();
    });

    // 添加搜索监听
    _searchController.addListener(_filterEvents);
    _searchFocusNode.addListener(() {
      setState(() {}); // 刷新UI以响应焦点变化
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 并行加载新闻和市场趋势
      final results = await Future.wait([
        _repository.getNewsEvents(),
        _repository.getMarketTrends(),
      ]);

      if (mounted) {
        setState(() {
          _newsEvents = results[0] as List<NewsEvent>;
          _filteredEvents = _newsEvents;
          _marketTrends = results[1] as List<Map<String, dynamic>>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载失败: $e')));
      }
    }
  }

  /// 刷新数据
  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      // 并行加载新闻和市场趋势
      final results = await Future.wait([
        _repository.getNewsEvents(),
        _repository.getMarketTrends(),
      ]);

      if (mounted) {
        setState(() {
          _newsEvents = results[0] as List<NewsEvent>;
          _marketTrends = results[1] as List<Map<String, dynamic>>;

          // 应用当前筛选
          _filterEvents();
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
        // 静默失败，不显示错误提示
      }
    }
  }

  /// 根据分类和搜索关键词筛选事件
  void _filterEvents() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredEvents = _newsEvents.where((event) {
        // 先按分类筛选
        bool matchesCategory = _selectedCategory == '全部' ||
            _getCategoryForEvent(event) == _selectedCategory;

        // 再按搜索关键词筛选
        bool matchesSearch = query.isEmpty ||
            event.title.toLowerCase().contains(query) ||
            event.summary.toLowerCase().contains(query);

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  /// 根据事件内容判断其所属分类
  String _getCategoryForEvent(NewsEvent event) {
    // 检查受影响的货币对和内容
    final content = '${event.title} ${event.summary}'.toLowerCase();
    final affectedPairs = event.affectedPairs.join(' ').toLowerCase();

    // 比特币相关
    if (content.contains('比特币') ||
        content.contains('btc') ||
        content.contains('bitcoin') ||
        affectedPairs.contains('btc') ||
        content.contains('挖矿') && !content.contains('以太坊挖矿')) {
      return '比特币';
    }

    // 以太坊相关
    if (content.contains('以太坊') ||
        content.contains('eth') ||
        content.contains('ethereum') ||
        content.contains('vitalik') ||
        content.contains('以太') ||
        affectedPairs.contains('eth')) {
      return '以太坊';
    }

    // 稳定币相关
    if (content.contains('稳定币') ||
        content.contains('usdt') ||
        content.contains('usdc') ||
        content.contains('泰达币') ||
        content.contains('tether') ||
        content.contains('stablecoin') ||
        content.contains('dai') && !content.contains('daily') ||
        content.contains('busd') ||
        affectedPairs.contains('usdt') ||
        affectedPairs.contains('usdc')) {
      return '稳定币';
    }

    // Layer2相关
    if (content.contains('layer2') ||
        content.contains('二层') ||
        content.contains('扩容') ||
        content.contains('rollup') ||
        content.contains('optimism') ||
        content.contains('arbitrum') ||
        content.contains('zksync') ||
        content.contains('polygon') && !content.contains('多边形') ||
        content.contains('matic') ||
        content.contains('侧链') ||
        affectedPairs.contains('op') ||
        affectedPairs.contains('arb') ||
        affectedPairs.contains('matic')) {
      return 'Layer2';
    }

    // 公链相关
    if (content.contains('公链') ||
        content.contains('solana') ||
        content.contains('sol/') ||
        content.contains('avalanche') ||
        content.contains('avax') ||
        content.contains('cardano') ||
        content.contains('ada/') ||
        content.contains('波卡') ||
        content.contains('polkadot') ||
        content.contains('dot/') ||
        content.contains('cosmos') ||
        content.contains('atom/') ||
        content.contains('algorand') ||
        content.contains('tron') ||
        content.contains('trx/') ||
        content.contains('near') ||
        content.contains('chainlink') ||
        content.contains('link/') ||
        affectedPairs.contains('sol') ||
        affectedPairs.contains('avax') ||
        affectedPairs.contains('ada') ||
        affectedPairs.contains('dot') ||
        affectedPairs.contains('atom')) {
      return '公链';
    }

    // DeFi相关
    if (content.contains('defi') ||
        content.contains('去中心化金融') ||
        content.contains('流动性') ||
        content.contains('yield') ||
        content.contains('swap') ||
        content.contains('lending') ||
        content.contains('借贷') ||
        content.contains('uniswap') ||
        content.contains('aave') ||
        content.contains('compound') ||
        content.contains('curve') ||
        content.contains('流动性挖矿') ||
        content.contains('质押') ||
        content.contains('staking') ||
        content.contains('amm') ||
        content.contains('dex') ||
        content.contains('去中心化交易') ||
        affectedPairs.contains('uni') ||
        affectedPairs.contains('aave') ||
        affectedPairs.contains('comp') ||
        affectedPairs.contains('crv')) {
      return 'DeFi';
    }

    // NFT相关
    if (content.contains('nft') ||
        content.contains('非同质化') ||
        content.contains('数字艺术') ||
        content.contains('数字收藏品') ||
        content.contains('opensea') ||
        content.contains('blur') && content.contains('nft') ||
        content.contains('yuga') ||
        content.contains('bayc') ||
        content.contains('azuki') ||
        content.contains('数字藏品')) {
      return 'NFT';
    }

    // 元宇宙相关
    if (content.contains('元宇宙') ||
        content.contains('metaverse') ||
        content.contains('sandbox') && !content.contains('沙盒测试') ||
        content.contains('decentraland') ||
        content.contains('虚拟世界') ||
        content.contains('虚拟土地') ||
        content.contains('web3游戏') ||
        content.contains('gamefi') ||
        affectedPairs.contains('sand') ||
        affectedPairs.contains('mana') ||
        affectedPairs.contains('axs')) {
      return '元宇宙';
    }

    // 交易所相关
    if (content.contains('交易所') ||
        content.contains('binance') ||
        content.contains('币安') ||
        content.contains('coinbase') ||
        content.contains('okx') ||
        content.contains('ftx') ||
        content.contains('火币') ||
        content.contains('huobi') ||
        content.contains('gate') ||
        content.contains('kucoin') ||
        content.contains('交易平台') ||
        content.contains('cex') ||
        content.contains('中心化交易') ||
        affectedPairs.contains('bnb') ||
        affectedPairs.contains('okb') ||
        affectedPairs.contains('ht') ||
        affectedPairs.contains('gt') ||
        affectedPairs.contains('kcs') ||
        affectedPairs.contains('ftt')) {
      return '交易所';
    }

    // 默认分类
    return '全部';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Get safe area insets to handle notch/Dynamic Island
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 点击空白区域收起键盘
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                // 顶部搜索栏
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(16.0, topPadding + 8.0, 16.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('市场资讯', style: AppStyles.heading1),
                            const Spacer(),
                            if (_isRefreshing)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: _refreshData,
                                tooltip: '刷新',
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSearchBar(),
                      ],
                    ),
                  ),
                ),

                // 分类选项卡
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _buildCategoryTabs(),
                  ),
                ),

                // 市场热点趋势
                if (_marketTrends.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
                      child: _buildMarketTrends(),
                    ),
                  ),

                // 资讯列表标题
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                    child: Row(
                      children: [
                        Text(
                          '最新资讯',
                          style: AppStyles.heading2.copyWith(fontSize: 20),
                        ),
                        const Spacer(),
                        Text(
                          '${_filteredEvents.length}条',
                          style: TextStyle(
                            color: AppColors.stardustWhite.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 资讯列表或空状态
                _filteredEvents.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color:
                                      AppColors.stardustWhite.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '没有找到相关资讯',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.stardustWhite
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 80.0),
                        // 使用SliverList.builder进行更高效的列表渲染
                        sliver: SliverList.builder(
                          // 注意：SliverList.builder不支持itemExtent，这里不设置固定高度
                          // 添加缓存构建器，减少重建次数
                          findChildIndexCallback: (key) {
                            final ValueKey<String> valueKey =
                                key as ValueKey<String>;
                            final index = _filteredEvents.indexWhere((event) =>
                                '${event.title}-${event.timeAgo}' ==
                                valueKey.value);
                            return index >= 0 ? index : null;
                          },
                          itemBuilder: (context, index) {
                            if (index >= _filteredEvents.length) return null;
                            final event = _filteredEvents[index];
                            // 使用key帮助Flutter识别和重用widget
                            return TimelineItem(
                              key: ValueKey('${event.title}-${event.timeAgo}'),
                              event: event,
                            );
                          },
                          itemCount: _filteredEvents.length,
                        ),
                      ),
              ],
            ),
    );
  }

  /// 构建搜索栏
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _searchFocusNode.hasFocus
              ? AppColors.fieryRed.withOpacity(0.5)
              : AppColors.borderColor,
        ),
        boxShadow: _searchFocusNode.hasFocus
            ? [
                BoxShadow(
                  color: AppColors.fieryRed.withOpacity(0.2),
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
        cursorColor: AppColors.fieryRed,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _searchFocusNode.unfocus(),
        decoration: InputDecoration(
          hintText: '搜索市场资讯...',
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

  /// 构建分类选项卡 - 优化显示效果，添加图标和特定颜色
  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          // 为每个分类设置特定的颜色和图标
          final (Color categoryColor, IconData categoryIcon) =
              _getCategoryStyle(category);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _filterEvents();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? categoryColor.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? categoryColor : AppColors.borderColor,
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.15),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  // 图标
                  Icon(
                    categoryIcon,
                    size: 16,
                    color: isSelected
                        ? categoryColor
                        : AppColors.stardustWhite.withOpacity(0.7),
                  ),
                  const SizedBox(width: 6),
                  // 文本
                  Text(
                    category,
                    style: TextStyle(
                      color:
                          isSelected ? categoryColor : AppColors.stardustWhite,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 获取分类的样式（颜色和图标）
  (Color, IconData) _getCategoryStyle(String category) {
    switch (category) {
      case '全部':
        return (AppColors.stardustWhite, Icons.apps_rounded);
      case '比特币':
        return (Colors.orange, Icons.currency_bitcoin);
      case '以太坊':
        return (Colors.purple.shade300, Icons.diamond_outlined);
      case '稳定币':
        return (Colors.green, Icons.attach_money_rounded);
      case 'Layer2':
        return (Colors.blue, Icons.layers_outlined);
      case '公链':
        return (Colors.teal, Icons.link_rounded);
      case 'DeFi':
        return (AppColors.fieryRed, Icons.account_balance_outlined);
      case 'NFT':
        return (Colors.pink, Icons.palette_outlined);
      case '交易所':
        return (AppColors.goldenHighlight, Icons.storefront_outlined);
      case '元宇宙':
        return (AppColors.coolBlue, Icons.view_in_ar_outlined);
      default:
        return (AppColors.stardustWhite, Icons.tag);
    }
  }

  /// 构建市场热点趋势
  Widget _buildMarketTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '市场热点',
          style: AppStyles.heading2.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _marketTrends.length,
            itemBuilder: (context, index) {
              final trend = _marketTrends[index];
              return _buildTrendCard(trend);
            },
          ),
        ),
      ],
    );
  }

  /// 构建单个趋势卡片
  Widget _buildTrendCard(Map<String, dynamic> trend) {
    final hotness = trend['hotness'] as int? ?? 5;
    final relatedAssets = trend['relatedAssets'] as List? ?? [];

    // 根据热度选择颜色
    Color trendColor;
    if (hotness >= 8) {
      trendColor = AppColors.fieryRed;
    } else if (hotness >= 6) {
      trendColor = Colors.orange;
    } else if (hotness >= 4) {
      trendColor = AppColors.goldenHighlight;
    } else {
      trendColor = AppColors.coolBlue;
    }

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            trendColor.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: trendColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 热度指示器
          Row(
            children: [
              Icon(Icons.whatshot, color: trendColor, size: 16),
              const SizedBox(width: 4),
              Text(
                '热度 $hotness/10',
                style: TextStyle(
                  color: trendColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 标题
          Text(
            trend['topic'] as String? ?? '',
            style: AppStyles.heading3.copyWith(fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // 描述
          Text(
            trend['description'] as String? ?? '',
            style: AppStyles.bodyTextSmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // 相关资产
          if (relatedAssets.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: relatedAssets.take(3).map((asset) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Text(
                    asset.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.stardustWhite.withOpacity(0.8),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
