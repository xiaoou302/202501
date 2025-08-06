import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/trading_pair.dart';
import '../../data/repositories/market_repository.dart';
import 'market_card.dart';

/// Market screen displaying trading pairs and charts
class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

// Class to hold exchange statistics
class ExchangeStat {
  final String title;
  final String value;
  final IconData icon;

  ExchangeStat({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class _MarketScreenState extends State<MarketScreen>
    with AutomaticKeepAliveClientMixin {
  final MarketRepository _repository = MarketRepository();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<TradingPair> _tradingPairs = [];
  List<TradingPair> _filteredPairs = [];
  List<TradingPair> _topPairs = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  // Categories for filter tabs
  final List<String> _categories = ['All', 'Major', 'Altcoin', 'DeFi', 'Meme'];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterPairs);

    // Add listener to focus node to detect keyboard visibility
    _searchFocusNode.addListener(() {
      setState(() {}); // Rebuild UI when focus changes
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterPairs() {
    if (_searchController.text.isEmpty && _selectedCategory == 'All') {
      setState(() {
        _filteredPairs = _tradingPairs;
      });
      return;
    }

    final query = _searchController.text.toUpperCase();
    setState(() {
      _filteredPairs = _tradingPairs
          .where((pair) =>
              pair.id.toUpperCase().contains(query) &&
              (_selectedCategory == 'All' ||
                  pair.category == _selectedCategory))
          .toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterPairs();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pairs = await _repository.getTradingPairs();
      final topPairs = await _repository.getTopTradingPairs();

      if (mounted) {
        setState(() {
          _tradingPairs = pairs;
          _filteredPairs = pairs;
          _topPairs = topPairs;
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Get safe area insets to handle notch/Dynamic Island
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    // Wrap with GestureDetector to dismiss keyboard when tapping outside
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Dismiss keyboard when tapping outside input fields
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics:
                  const ClampingScrollPhysics(), // Changed to prevent overscroll bounce effect
              padding: EdgeInsets.fromLTRB(16.0, topPadding, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Exchange announcements and activities
                  _buildExchangeInfoHeader(),
                  const SizedBox(height: 16),

                  // Exchange information
                  _buildExchangeInfoCard(),
                  const SizedBox(height: 24),

                  // Search bar
                  _buildSearchBar(),
                  const SizedBox(height: 16),

                  // Category filter tabs
                  _buildCategoryTabs(),
                  const SizedBox(height: 24),

                  // Top Trading Pairs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('热门交易对', style: AppStyles.heading3),
                      Text(
                        '24h 成交量',
                        style: AppStyles.secondaryText.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTopPairs(),
                  const SizedBox(height: 24),

                  // All Trading Pairs heading
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory == 'All'
                            ? '所有交易对'
                            : '$_selectedCategory 交易对',
                        style: AppStyles.heading3,
                      ),
                      Text(
                        '${_filteredPairs.length} 对',
                        style: AppStyles.secondaryText.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Trading Pair Cards
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

                  // Add some bottom padding for the tab bar
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildExchangeInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.midnightBlue.withOpacity(0.8),
            AppColors.fieryRed.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.fieryRed.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '交易所公告',
                style: AppStyles.heading2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldenHighlight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.goldenHighlight.withOpacity(0.5)),
                ),
                child: Text(
                  '全部',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldenHighlight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAnnouncementItem(
            title: 'Binance：新上线Solana生态代币',
            date: '2025-06-12',
            isImportant: true,
            exchange: 'Binance',
          ),
          const SizedBox(height: 12),
          _buildAnnouncementItem(
            title: 'OKX：推出新版交易API',
            date: '2025-06-10',
            isImportant: false,
            exchange: 'OKX',
          ),
          const SizedBox(height: 12),
          _buildAnnouncementItem(
            title: 'Coinbase：调整BTC/ETH交易费率',
            date: '2025-06-08',
            isImportant: true,
            exchange: 'Coinbase',
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.borderColor),
          const SizedBox(height: 16),
          Text(
            '交易所活动',
            style: AppStyles.heading3,
          ),
          const SizedBox(height: 12),
          _buildActivityCard(
            title: 'Binance交易大赛',
            description: '参与BTC/USDT交易即可瓜分10万USDT奖池',
            endDate: '06月30日结束',
            color: AppColors.coolBlue,
            exchange: 'Binance',
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem({
    required String title,
    required String date,
    required bool isImportant,
    String exchange = 'CoinAtlasExchange',
  }) {
    // Sample announcement content based on the title and exchange
    String getAnnouncementContent(String title) {
      if (title.contains('Binance') && title.contains('Solana')) {
        return '尊敬的用户：\n\nBinance将于2025年6月15日16:00正式上线多个Solana生态代币，包括：\n\n- Bonk (BONK)\n- Jito (JTO)\n- Kamino (KMNO)\n- Render (RNDR)\n\n所有新上线代币将支持以下交易对：\n- X/USDT\n- X/BTC\n- X/BNB\n\n同时，为庆祝新币上线，参与交易即可瓜分总价值100万USDT奖池！活动时间：6月15日-6月25日。\n\n欢迎体验！';
      } else if (title.contains('OKX') && title.contains('API')) {
        return '尊敬的用户：\n\nOKX将于2025年6月20日推出全新V5版本交易API，为专业交易者和机构客户提供更高效的交易体验。\n\n新版API主要特点：\n1. 支持高达每秒100次的请求频率\n2. 延迟降低至5ms以内\n3. 新增高级订单类型支持\n4. 提供更全面的市场数据\n\n我们将于2025年6月18日举办线上技术研讨会，详细介绍新版API的使用方法和最佳实践。\n\n请注意，旧版API将于2025年8月31日停止服务，请及时完成升级。';
      } else if (title.contains('Coinbase') && title.contains('费率')) {
        return '尊敬的用户：\n\nCoinbase宣布自2025年7月1日起调整BTC/ETH交易对的费率结构，以优化平台流动性并回馈活跃用户。\n\n调整后费率如下：\n- BTC/USD 和 ETH/USD 交易对：\n  - Maker费率：由0.4%降至0.2%\n  - Taker费率：由0.6%降至0.4%\n\n- 高级用户（30天交易量超过100万美元）：\n  - Maker费率：0.1%\n  - Taker费率：0.2%\n\n此次调整旨在提高BTC和ETH交易对的市场深度，为用户提供更具竞争力的交易环境。\n\n如有任何疑问，请联系Coinbase客户支持团队。';
      } else if (title.contains('Kraken')) {
        return '尊敬的用户：\n\nKraken宣布推出全新的机构级托管服务，为机构客户提供更安全、更可靠的数字资产存储解决方案。\n\n新托管服务特点：\n1. 多重签名技术\n2. 冷热钱包分离\n3. 定制化保险方案\n4. 24/7全天候监控\n\n该服务将于2025年7月1日正式上线，首批支持BTC、ETH、SOL等主流加密货币。\n\n如需了解更多信息或预约演示，请联系Kraken机构服务团队。';
      } else if (title.contains('Bybit')) {
        return '尊敬的用户：\n\nBybit将于2025年6月25日推出创新的"闪电交易"功能，实现毫秒级订单执行，为高频交易者提供极致体验。\n\n闪电交易主要优势：\n1. 订单执行时间降至5ms以内\n2. 支持高达1000:1的订单分割\n3. 智能路由系统自动选择最优价格\n4. 零前置费用，仅收取标准交易手续费\n\n该功能将首先在BTC、ETH和SOL的永续合约上线，后续将扩展到更多交易对。\n\n欢迎体验Bybit闪电交易，感受前所未有的交易速度！';
      }
      return '公告详情将很快公布，请持续关注。';
    }

    return InkWell(
      onTap: () {
        // Show announcement details in a bottom sheet
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '公告详情',
                        style: AppStyles.heading2,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Divider(color: AppColors.borderColor),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (isImportant
                                        ? AppColors.fieryRed
                                        : AppColors.coolBlue)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isImportant
                                    ? Icons.campaign
                                    : Icons.notifications,
                                color: isImportant
                                    ? AppColors.fieryRed
                                    : AppColors.coolBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: AppStyles.heading3,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.goldenHighlight
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: AppColors.goldenHighlight
                                                  .withOpacity(0.3)),
                                        ),
                                        child: Text(
                                          exchange,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.goldenHighlight,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '发布时间: $date',
                                        style: AppStyles.secondaryText,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          getAnnouncementContent(title),
                          style: AppStyles.bodyText,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.coolBlue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: AppColors.coolBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '如有疑问，请联系客服: support@CoinAtlasexchange.com',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.coolBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: isImportant ? AppColors.fieryRed : AppColors.coolBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyText.copyWith(
                    fontWeight:
                        isImportant ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: AppStyles.secondaryText.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.stardustWhite.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String description,
    required String endDate,
    required Color color,
    String exchange = 'CoinAtlasExchange',
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.celebration,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppStyles.secondaryText.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.fieryRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  endDate,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.fieryRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenHighlight.withOpacity(0.05),
            blurRadius: 15,
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
              Text(
                '热门交易所',
                style: AppStyles.heading2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldenHighlight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.goldenHighlight.withOpacity(0.5)),
                ),
                child: Text(
                  '全部',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldenHighlight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Binance
          _buildExchangeDetailCard(
            name: 'Binance',
            logo: Icons.currency_bitcoin,
            description:
                'Binance是全球最大的加密货币交易所，提供400+交易对，日交易量超过320亿美元。平台支持现货、期货、期权、杠杆交易等多种交易类型，并提供质押、挖矿、借贷等多元化服务。',
            stats: [
              ExchangeStat(
                  title: '交易量', value: '320亿美元', icon: Icons.bar_chart),
              ExchangeStat(
                  title: '交易对', value: '400+', icon: Icons.currency_exchange),
              ExchangeStat(title: '用户数', value: '2.5亿+', icon: Icons.people),
            ],
            features: [
              '全球最大交易所，流动性最佳',
              'SAFU基金保障用户资产安全',
              '支持多种法币入金渠道',
            ],
            color: AppColors.fieryRed,
          ),

          const SizedBox(height: 16),

          // Coinbase
          _buildExchangeDetailCard(
            name: 'Coinbase',
            logo: Icons.account_balance,
            description:
                'Coinbase是美国最大的合规加密货币交易所，于2012年成立，是首家在纳斯达克上市的加密货币交易所。平台以安全可靠、合规运营著称，适合初学者和机构投资者。',
            stats: [
              ExchangeStat(title: '交易量', value: '80亿美元', icon: Icons.bar_chart),
              ExchangeStat(
                  title: '交易对', value: '150+', icon: Icons.currency_exchange),
              ExchangeStat(title: '用户数', value: '1.1亿+', icon: Icons.people),
            ],
            features: [
              '美国上市公司，合规运营',
              '提供机构级托管服务',
              '支持多种法币入金渠道',
            ],
            color: AppColors.coolBlue,
          ),

          const SizedBox(height: 16),

          // OKX
          _buildExchangeDetailCard(
            name: 'OKX',
            logo: Icons.rocket_launch,
            description:
                'OKX（前身为OKEx）是全球领先的数字资产交易平台，提供现货、衍生品、NFT和DeFi服务。平台以强大的交易引擎和创新产品著称，支持350+交易对和多种交易类型。',
            stats: [
              ExchangeStat(title: '交易量', value: '60亿美元', icon: Icons.bar_chart),
              ExchangeStat(
                  title: '交易对', value: '350+', icon: Icons.currency_exchange),
              ExchangeStat(title: '用户数', value: '5000万+', icon: Icons.people),
            ],
            features: [
              '高性能交易引擎，支持百万级TPS',
              '提供Web3钱包和DeFi服务',
              '全球合规运营，多国牌照',
            ],
            color: AppColors.goldenHighlight,
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeDetailCard({
    required String name,
    required IconData logo,
    required String description,
    required List<ExchangeStat> stats,
    required List<String> features,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  logo,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppStyles.heading3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '全球知名交易所',
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Exchange description
          Text(
            description,
            style: AppStyles.bodyTextSmall,
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stats.map((stat) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      stat.icon,
                      size: 16,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stat.title,
                    style: AppStyles.secondaryText.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stat.value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.stardustWhite,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Features
          ...features
              .map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _buildFeatureItem(
                      icon: Icons.check_circle_outline,
                      text: feature,
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.stardustWhite.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.stardustWhite.withOpacity(0.9),
            ),
          ),
        ),
      ],
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
        // Ensure keyboard dismisses when done button is pressed
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _searchFocusNode.unfocus(),
        decoration: InputDecoration(
          hintText: '搜索交易对 (例如: BTC/USDT)',
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
        // Input restrictions for currency pairs
        inputFormatters: [
          // Allow only letters, numbers, and the '/' character
          CurrencyPairInputFormatter(),
        ],
      ),
    );
  }

  Widget _buildTopPairs() {
    return Column(
      children: _topPairs.asMap().entries.map((entry) {
        final index = entry.key;
        final pair = entry.value;
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
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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
                      '交易量为 ${pair.volume.toStringAsFixed(1)}B，波动率为 ${pair.volatility.toStringAsFixed(0)}。'
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

  @override
  bool get wantKeepAlive => true;
}

/// Custom input formatter for currency pairs
class CurrencyPairInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only uppercase letters, numbers, and '/'
    final regExp = RegExp(r'^[A-Z0-9/]*$');

    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }

    // Convert to uppercase
    final upperCaseText = newValue.text.toUpperCase();

    if (regExp.hasMatch(upperCaseText)) {
      return TextEditingValue(
        text: upperCaseText,
        selection: newValue.selection,
      );
    }

    return oldValue;
  }
}
