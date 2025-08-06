import 'dart:async';
import '../models/news_event.dart';
import '../../services/deepseek_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Repository for fetching timeline events
class NewsRepository {
  final DeepseekService _apiService = DeepseekService();

  // 缓存相关
  static const String _cacheKey = 'cached_news_events';
  static const Duration _cacheDuration = Duration(minutes: 30);
  DateTime? _lastFetchTime;
  List<NewsEvent>? _cachedEvents;

  // 市场趋势缓存
  static const String _trendsCacheKey = 'cached_market_trends';

  // 货币对分析缓存
  final Map<String, Map<String, dynamic>> _analysisCache = {};
  final Map<String, DateTime> _analysisCacheTime = {};

  /// 获取新闻事件列表，前3条来自API，其余使用模拟数据
  Future<List<NewsEvent>> getNewsEvents() async {
    // 检查内存缓存
    if (_cachedEvents != null && _lastFetchTime != null) {
      final now = DateTime.now();
      if (now.difference(_lastFetchTime!) < _cacheDuration) {
        return _cachedEvents!;
      }
    }

    List<NewsEvent> allEvents = [];

    try {
      // 尝试从API获取最新数据（仅前3条）
      final apiEvents = await _apiService.getFinancialNews();

      // 只取前3条API数据
      final latestApiEvents = apiEvents.take(3).toList();

      // 获取模拟数据
      final mockEvents = _getMockNewsEvents();

      // 合并API数据和模拟数据
      allEvents = [...latestApiEvents, ...mockEvents];

      // 更新缓存
      _cachedEvents = allEvents;
      _lastFetchTime = DateTime.now();

      // 保存到本地存储
      _saveEventsToCache(allEvents);
    } catch (e) {
      // 如果API请求失败，尝试从本地缓存加载
      final cachedEvents = await _loadEventsFromCache();
      if (cachedEvents.isNotEmpty) {
        _cachedEvents = cachedEvents;
        return cachedEvents;
      }

      // 如果本地缓存也没有，则返回完整的模拟数据
      allEvents = _getMockNewsEvents();
    }

    return allEvents;
  }

  /// 获取市场热点话题
  Future<List<Map<String, dynamic>>> getMarketTrends() async {
    try {
      // 尝试从API获取最新数据
      final trends = await _apiService.getMarketTrends();

      // 更新缓存

      // 保存到本地存储
      _saveTrendsToCache(trends);

      return trends;
    } catch (e) {
      // 如果API请求失败，尝试从本地缓存加载
      final cachedTrends = await _loadTrendsFromCache();
      if (cachedTrends.isNotEmpty) {
        return cachedTrends;
      }

      // 如果本地缓存也没有，则返回模拟数据
      return _getMockMarketTrends();
    }
  }

  /// 获取货币对详细分析
  Future<Map<String, dynamic>> getCurrencyPairAnalysis(String pair) async {
    // 检查缓存
    if (_analysisCache.containsKey(pair) &&
        _analysisCacheTime.containsKey(pair)) {
      final cacheTime = _analysisCacheTime[pair]!;
      if (DateTime.now().difference(cacheTime) < const Duration(hours: 6)) {
        return _analysisCache[pair]!;
      }
    }

    try {
      // 从API获取分析
      final analysis = await _apiService.getCurrencyPairAnalysis(pair);

      // 更新缓存
      _analysisCache[pair] = analysis;
      _analysisCacheTime[pair] = DateTime.now();

      return analysis;
    } catch (e) {
      // 如果API请求失败但有缓存，返回缓存
      if (_analysisCache.containsKey(pair)) {
        return _analysisCache[pair]!;
      }

      // 返回模拟数据
      return _getMockAnalysis(pair);
    }
  }

  /// 将事件保存到本地缓存
  Future<void> _saveEventsToCache(List<NewsEvent> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = events.map((e) => e.toJson()).toList();
      await prefs.setString(
          _cacheKey,
          jsonEncode({
            'timestamp': DateTime.now().toIso8601String(),
            'events': jsonList,
          }));
    } catch (e) {
      // 缓存保存失败，忽略错误
    }
  }

  /// 从本地缓存加载事件
  Future<List<NewsEvent>> _loadEventsFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);

      if (cachedData != null) {
        final data = jsonDecode(cachedData);
        final timestamp = DateTime.parse(data['timestamp']);

        // 检查缓存是否过期
        if (DateTime.now().difference(timestamp) < _cacheDuration) {
          final List<dynamic> jsonList = data['events'];
          return jsonList.map((json) => NewsEvent.fromJson(json)).toList();
        }
      }
    } catch (e) {
      // 缓存加载失败，忽略错误
    }

    return [];
  }

  /// 将市场趋势保存到本地缓存
  Future<void> _saveTrendsToCache(List<Map<String, dynamic>> trends) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _trendsCacheKey,
          jsonEncode({
            'timestamp': DateTime.now().toIso8601String(),
            'trends': trends,
          }));
    } catch (e) {
      // 缓存保存失败，忽略错误
    }
  }

  /// 从本地缓存加载市场趋势
  Future<List<Map<String, dynamic>>> _loadTrendsFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_trendsCacheKey);

      if (cachedData != null) {
        final data = jsonDecode(cachedData);
        final timestamp = DateTime.parse(data['timestamp']);

        // 检查缓存是否过期
        if (DateTime.now().difference(timestamp) < _cacheDuration) {
          final List<dynamic> jsonList = data['trends'];
          return jsonList.cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      // 缓存加载失败，忽略错误
    }

    return [];
  }

  /// 获取模拟新闻事件数据（当API请求失败且无缓存时使用）
  /// 注意：所有资讯不包含图片
  List<NewsEvent> _getMockNewsEvents() {
    return [
      // 比特币相关资讯
      NewsEvent(
        title: '比特币突破68,000美元关口',
        timeAgo: '3小时前',
        summary: '加密货币市场整体走强，机构投资者持续增持是推动价格上涨的主要因素。',
        impact: 'High',
        affectedPairs: ['BTC/USD', 'ETH/USD'],
        source: '币安资讯',
        url: 'https://www.binance.com',
        imageUrl:
            'https://images.unsplash.com/photo-1518546305927-5a555bb7020d',
        sentiment: 85.0,
      ),
      NewsEvent(
        title: '比特币挖矿难度创历史新高',
        timeAgo: '5小时前',
        summary: '随着更多算力加入网络，比特币挖矿难度再创新高，目前已达到66.5T，矿工收益受到影响。',
        impact: 'Medium',
        affectedPairs: ['BTC/USD'],
        source: 'CoinDesk',
        url: 'https://www.coindesk.com',
        imageUrl:
            'https://images.unsplash.com/photo-1516245834210-c4c142787335',
        sentiment: 60.0,
      ),
      NewsEvent(
        title: '比特币现货ETF资金流入创周记录',
        timeAgo: '昨天',
        summary: '上周比特币现货ETF净流入资金超过12亿美元，创下自推出以来单周最高纪录，机构投资者兴趣持续增长。',
        impact: 'High',
        affectedPairs: ['BTC/USD'],
        source: '金色财经',
        url: 'https://www.jinse.com',
        imageUrl:
            'https://images.unsplash.com/photo-1621761191319-c6fb62004040',
        sentiment: 90.0,
      ),
      NewsEvent(
        title: '比特币减半事件倒计时开始',
        timeAgo: '1天前',
        summary: '比特币第四次减半预计将在4个月内发生，历史数据显示减半后通常会带来新一轮牛市。',
        impact: 'High',
        affectedPairs: ['BTC/USD', 'ETH/USD'],
        source: 'CryptoSlate',
        url: 'https://cryptoslate.com',
        imageUrl:
            'https://images.unsplash.com/photo-1523961131990-5ea7c61b2107',
        sentiment: 80.0,
      ),
      NewsEvent(
        title: 'MicroStrategy再增持1.5亿美元比特币',
        timeAgo: '2天前',
        summary: 'MicroStrategy宣布以平均价格64,000美元再购入2,340枚比特币，总持仓量已超过19万枚。',
        impact: 'Medium',
        affectedPairs: ['BTC/USD'],
        source: 'BlockBeats',
        url: 'https://www.blockbeats.info',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 75.0,
      ),
      NewsEvent(
        title: '比特币闪电网络容量突破6,000枚BTC',
        timeAgo: '3天前',
        summary: '比特币二层扩容解决方案闪电网络总锁定价值首次超过6,000枚BTC，显示Layer2解决方案正获得更多采用。',
        impact: 'Low',
        affectedPairs: ['BTC/USD'],
        source: '星球日报',
        url: 'https://www.odaily.news',
        imageUrl:
            'https://images.unsplash.com/photo-1620321023374-d1a68fbc720d',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: '比特币链上活动激增，交易费创近期新高',
        timeAgo: '3天前',
        summary: '比特币网络活动显著增加，日交易量突破40万笔，平均交易费上升至25美元，创近三个月新高。',
        impact: 'Medium',
        affectedPairs: ['BTC/USD'],
        source: 'Glassnode',
        url: 'https://glassnode.com',
        imageUrl:
            'https://images.unsplash.com/photo-1639152201720-5e536d254d81',
        sentiment: 65.0,
      ),
      NewsEvent(
        title: '比特币算力分布更加分散，单一矿池占比下降',
        timeAgo: '4天前',
        summary: '最新数据显示，比特币网络算力分布更加去中心化，最大矿池占比已降至18%以下，提升了网络安全性。',
        impact: 'Low',
        affectedPairs: ['BTC/USD'],
        source: 'BTC.com',
        url: 'https://btc.com',
        imageUrl:
            'https://images.unsplash.com/photo-1621504450181-5d356f61d307',
        sentiment: 60.0,
      ),
      NewsEvent(
        title: '比特币MVRV比率显示市场处于健康区间',
        timeAgo: '4天前',
        summary: '链上分析指标MVRV比率目前为2.3，表明比特币价格相对于实现价值处于健康水平，尚未进入过热区域。',
        impact: 'Low',
        affectedPairs: ['BTC/USD'],
        source: 'CryptoQuant',
        url: 'https://cryptoquant.com',
        imageUrl:
            'https://images.unsplash.com/photo-1625217527288-7d1cc72d7e10',
        sentiment: 65.0,
      ),
      NewsEvent(
        title: '比特币长期持有者占比创历史新高',
        timeAgo: '5天前',
        summary: '数据显示超过70%的比特币已超过一年未移动，长期持有者比例创历史新高，表明市场信心增强。',
        impact: 'Medium',
        affectedPairs: ['BTC/USD'],
        source: 'CoinMetrics',
        url: 'https://coinmetrics.io',
        imageUrl:
            'https://images.unsplash.com/photo-1642104704074-907c0698cbd9',
        sentiment: 75.0,
      ),

      // 以太坊相关资讯
      NewsEvent(
        title: '以太坊突破3,500美元，创近期新高',
        timeAgo: '4小时前',
        summary: '以太坊价格突破3,500美元关口，创近三个月新高，市场分析师认为与即将推出的Cancun升级有关。',
        impact: 'High',
        affectedPairs: ['ETH/USD', 'ETH/BTC'],
        source: 'Cointelegraph',
        url: 'https://cointelegraph.com',
        imageUrl:
            'https://images.unsplash.com/photo-1622790698141-94e30457a8da',
        sentiment: 80.0,
      ),
      NewsEvent(
        title: '以太坊Cancun-Deneb升级确定日期',
        timeAgo: '6小时前',
        summary: '以太坊开发团队确认Cancun-Deneb升级将在下月实施，引入EIP-4844将显著降低L2网络交易成本。',
        impact: 'High',
        affectedPairs: ['ETH/USD'],
        source: 'Ethereum.org',
        url: 'https://ethereum.org',
        imageUrl:
            'https://images.unsplash.com/photo-1621501103258-3e5728600991',
        sentiment: 85.0,
      ),
      NewsEvent(
        title: '以太坊质押率突破25%，验证者数量创新高',
        timeAgo: '1天前',
        summary: '以太坊网络质押率首次突破25%，超过3000万枚ETH被锁定在质押合约中，验证者数量超过80万。',
        impact: 'Medium',
        affectedPairs: ['ETH/USD'],
        source: 'Etherscan',
        url: 'https://etherscan.io',
        imageUrl:
            'https://images.unsplash.com/photo-1620321023374-d1a68fbc720d',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: '以太坊EIP-4844将大幅降低L2费用',
        timeAgo: '2天前',
        summary:
            '即将实施的EIP-4844预计将使Arbitrum、Optimism等L2解决方案的交易费用降低高达90%，提升用户体验。',
        impact: 'High',
        affectedPairs: ['ETH/USD', 'ARB/USD', 'OP/USD'],
        source: '以太坊基金会',
        url: 'https://ethereum.foundation',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 80.0,
      ),
      NewsEvent(
        title: '以太坊销毁量突破300万枚',
        timeAgo: '3天前',
        summary: '自EIP-1559实施以来，以太坊网络已累计销毁超过300万枚ETH，相当于约100亿美元，持续降低通胀率。',
        impact: 'Medium',
        affectedPairs: ['ETH/USD'],
        source: 'Ultra Sound Money',
        url: 'https://ultrasound.money',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 75.0,
      ),
      NewsEvent(
        title: '以太坊DeFi锁仓量回升至600亿美元',
        timeAgo: '3天前',
        summary: '以太坊DeFi生态系统总锁仓量(TVL)回升至600亿美元，较年初增长40%，表明DeFi活动正在复苏。',
        impact: 'Medium',
        affectedPairs: ['ETH/USD', 'AAVE/USD', 'UNI/USD'],
        source: 'DeFiLlama',
        url: 'https://defillama.com',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: '以太坊开发者活动创历史新高',
        timeAgo: '4天前',
        summary: 'Electric Capital报告显示，以太坊生态系统开发者数量突破5,000人，创历史新高，领先其他区块链项目。',
        impact: 'Low',
        affectedPairs: ['ETH/USD'],
        source: 'Electric Capital',
        url: 'https://electriccapital.com',
        imageUrl:
            'https://images.unsplash.com/photo-1620321023374-d1a68fbc720d',
        sentiment: 65.0,
      ),
      NewsEvent(
        title: '以太坊Layer 2用户数量突破500万',
        timeAgo: '5天前',
        summary:
            '以太坊Layer 2解决方案（包括Arbitrum、Optimism和zkSync）的总用户数量首次突破500万，日交易量超过以太坊主网。',
        impact: 'Medium',
        affectedPairs: ['ETH/USD', 'ARB/USD', 'OP/USD'],
        source: 'L2Beat',
        url: 'https://l2beat.com',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 75.0,
      ),

      // DeFi相关资讯
      NewsEvent(
        title: 'Uniswap日交易量突破10亿美元',
        timeAgo: '6小时前',
        summary: '去中心化交易所Uniswap日交易量突破10亿美元，创下近一年来新高，DEX市场份额持续增长。',
        impact: 'Medium',
        affectedPairs: ['UNI/USD', 'ETH/USD'],
        source: 'Dune Analytics',
        url: 'https://dune.com',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 75.0,
      ),
      NewsEvent(
        title: 'Aave推出V3版本，优化资本效率',
        timeAgo: '1天前',
        summary: '领先的DeFi借贷协议Aave正式推出V3版本，引入隔离池和跨链功能，提高资本效率并降低风险。',
        impact: 'Medium',
        affectedPairs: ['AAVE/USD', 'ETH/USD'],
        source: 'Aave官方博客',
        url: 'https://aave.com',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: 'MakerDAO稳定费调整提案通过',
        timeAgo: '2天前',
        summary: 'MakerDAO社区投票通过稳定费调整提案，将ETH抵押品稳定费率从2.5%上调至3%，以维持DAI稳定币锚定。',
        impact: 'Low',
        affectedPairs: ['DAI/USD', 'MKR/USD'],
        source: 'MakerDAO论坛',
        url: 'https://forum.makerdao.com',
        imageUrl:
            'https://images.unsplash.com/photo-1621501103258-3e5728600991',
        sentiment: 60.0,
      ),
      NewsEvent(
        title: 'Compound推出跨链借贷功能',
        timeAgo: '3天前',
        summary:
            'DeFi借贷协议Compound宣布推出跨链借贷功能，支持以太坊、Arbitrum和Optimism等多个网络间的资产互通。',
        impact: 'Medium',
        affectedPairs: ['COMP/USD', 'ETH/USD'],
        source: 'Compound官方',
        url: 'https://compound.finance',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 65.0,
      ),
      NewsEvent(
        title: 'Curve Finance推出新算法稳定池',
        timeAgo: '3天前',
        summary: 'Curve Finance推出新的算法稳定池，优化了稳定币交易滑点，提高了资金利用效率，吸引大量流动性。',
        impact: 'Medium',
        affectedPairs: ['CRV/USD', 'USDC/USDT'],
        source: 'Curve官方',
        url: 'https://curve.fi',
        imageUrl:
            'https://images.unsplash.com/photo-1620321023374-d1a68fbc720d',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: 'SushiSwap治理提案引发社区争议',
        timeAgo: '4天前',
        summary: 'SushiSwap关于调整协议费用分配的治理提案引发社区争议，部分持币者担忧可能影响协议长期发展。',
        impact: 'Low',
        affectedPairs: ['SUSHI/USD'],
        source: 'SushiSwap论坛',
        url: 'https://forum.sushi.com',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 45.0,
      ),
      NewsEvent(
        title: 'Lido质押份额首次下降，竞争加剧',
        timeAgo: '5天前',
        summary: '以太坊最大的质押服务提供商Lido的市场份额首次出现下降，从33%降至31%，表明质押市场竞争加剧。',
        impact: 'Low',
        affectedPairs: ['LDO/USD', 'stETH/ETH'],
        source: 'Dune Analytics',
        url: 'https://dune.com',
        imageUrl:
            'https://images.unsplash.com/photo-1620321023374-d1a68fbc720d',
        sentiment: 50.0,
      ),

      // NFT和元宇宙相关资讯
      NewsEvent(
        title: 'Yuga Labs推出新NFT系列，销售一空',
        timeAgo: '1天前',
        summary:
            'Bored Ape Yacht Club创建者Yuga Labs推出新NFT系列，上线10分钟内销售一空，总成交额超过3000万美元。',
        impact: 'Medium',
        affectedPairs: ['ETH/USD', 'APE/USD'],
        source: 'NFT Evening',
        url: 'https://nftevening.com',
        imageUrl:
            'https://images.unsplash.com/photo-1620321023374-d1a68fbc720d',
        sentiment: 80.0,
      ),
      NewsEvent(
        title: 'OpenSea交易量环比增长50%',
        timeAgo: '2天前',
        summary: 'NFT交易平台OpenSea月度交易量环比增长50%，达到4亿美元，表明NFT市场正在复苏。',
        impact: 'Low',
        affectedPairs: ['ETH/USD'],
        source: 'DappRadar',
        url: 'https://dappradar.com',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: 'Blur推出NFT借贷功能',
        timeAgo: '3天前',
        summary: 'NFT交易平台Blur推出NFT借贷功能，允许用户以蓝筹NFT为抵押获取ETH贷款，进一步扩展NFT金融应用场景。',
        impact: 'Medium',
        affectedPairs: ['BLUR/USD', 'ETH/USD'],
        source: 'Blur官方',
        url: 'https://blur.io',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 65.0,
      ),
      NewsEvent(
        title: 'Sandbox与全球知名品牌达成合作',
        timeAgo: '4天前',
        summary: '元宇宙平台Sandbox宣布与多个全球知名品牌达成合作，将在虚拟世界中创建品牌体验区，推动Web3应用普及。',
        impact: 'Medium',
        affectedPairs: ['SAND/USD'],
        source: 'Sandbox官方博客',
        url: 'https://sandbox.game',
        imageUrl:
            'https://images.unsplash.com/photo-1621504450181-5d356f61d307',
        sentiment: 75.0,
      ),
      NewsEvent(
        title: 'Decentraland虚拟土地销售回暖',
        timeAgo: '5天前',
        summary: 'Decentraland平台虚拟土地销售数据显示市场回暖，平均成交价较上季度上涨30%，交易活跃度明显提升。',
        impact: 'Low',
        affectedPairs: ['MANA/USD'],
        source: 'NonFungible',
        url: 'https://nonfungible.com',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 65.0,
      ),

      // 山寨币相关资讯
      NewsEvent(
        title: 'Solana交易量创历史新高',
        timeAgo: '5小时前',
        summary: 'Solana网络日交易量突破2000万笔，创历史新高，网络性能保持稳定，平均交易费用低于0.001美元。',
        impact: 'High',
        affectedPairs: ['SOL/USD', 'SOL/BTC'],
        source: 'Solana Beach',
        url: 'https://solanabeach.io',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 85.0,
      ),
      NewsEvent(
        title: 'Cardano Hydra扩容解决方案进入测试阶段',
        timeAgo: '1天前',
        summary: 'Cardano的Layer 2扩容解决方案Hydra正式进入公开测试阶段，有望将网络吞吐量提升至每秒处理数千笔交易。',
        impact: 'Medium',
        affectedPairs: ['ADA/USD'],
        source: 'IOHK官方博客',
        url: 'https://iohk.io',
        imageUrl:
            'https://images.unsplash.com/photo-1621501103258-3e5728600991',
        sentiment: 75.0,
      ),
      NewsEvent(
        title: 'Polygon zkEVM日活用户突破50万',
        timeAgo: '2天前',
        summary: 'Polygon zkEVM网络日活跃用户数突破50万，交易量持续增长，成为以太坊扩容解决方案中增长最快的项目之一。',
        impact: 'Medium',
        affectedPairs: ['MATIC/USD', 'ETH/USD'],
        source: 'Polygon官方',
        url: 'https://polygon.technology',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 80.0,
      ),
      NewsEvent(
        title: 'Polkadot平行链插槽拍卖第二轮启动',
        timeAgo: '3天前',
        summary: 'Polkadot生态系统启动第二轮平行链插槽拍卖，共有12个项目参与竞争5个插槽，总锁仓DOT预计将超过1000万枚。',
        impact: 'Medium',
        affectedPairs: ['DOT/USD'],
        source: 'Polkadot官方',
        url: 'https://polkadot.network',
        imageUrl:
            'https://images.unsplash.com/photo-1621504450181-5d356f61d307',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: 'Avalanche推出跨链互操作性协议',
        timeAgo: '3天前',
        summary: 'Avalanche推出新的跨链互操作性协议，实现与以太坊、Solana等主流区块链的原生资产桥接，降低跨链成本。',
        impact: 'Medium',
        affectedPairs: ['AVAX/USD'],
        source: 'Avalanche官方博客',
        url: 'https://avax.network',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 75.0,
      ),
      NewsEvent(
        title: 'Chainlink推出跨链互操作性协议CCIP',
        timeAgo: '4天前',
        summary: 'Chainlink正式推出跨链互操作性协议CCIP，为区块链项目提供安全可靠的跨链通信基础设施，已获多个项目采用。',
        impact: 'Medium',
        affectedPairs: ['LINK/USD'],
        source: 'Chainlink官方博客',
        url: 'https://chain.link',
        imageUrl:
            'https://images.unsplash.com/photo-1621504450181-5d356f61d307',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: 'Cosmos生态系统总锁仓价值突破100亿美元',
        timeAgo: '5天前',
        summary: 'Cosmos生态系统总锁仓价值(TVL)首次突破100亿美元，IBC协议日交易量超过50万笔，显示跨链需求增长。',
        impact: 'Medium',
        affectedPairs: ['ATOM/USD'],
        source: 'Mintscan',
        url: 'https://mintscan.io',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 75.0,
      ),

      // 交易所和机构相关资讯
      NewsEvent(
        title: '币安推出创新交易产品，吸引机构投资者',
        timeAgo: '7小时前',
        summary: '全球最大加密货币交易所币安推出创新交易产品，针对机构投资者需求，提供更高流动性和更低交易成本。',
        impact: 'Medium',
        affectedPairs: ['BNB/USD', 'BTC/USD'],
        source: '币安官方博客',
        url: 'https://binance.com',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: 'Coinbase获得新加坡支付牌照',
        timeAgo: '1天前',
        summary: '美国加密货币交易所Coinbase宣布获得新加坡金融管理局颁发的支付牌照，将扩大在亚洲市场的业务。',
        impact: 'Medium',
        affectedPairs: ['COIN/USD'],
        source: 'Coinbase官方博客',
        url: 'https://coinbase.com',
        imageUrl:
            'https://images.unsplash.com/photo-1621501103258-3e5728600991',
        sentiment: 75.0,
      ),
      NewsEvent(
        title: 'BlackRock比特币ETF日均交易量突破5亿美元',
        timeAgo: '2天前',
        summary:
            '全球最大资产管理公司BlackRock的比特币ETF(IBIT)日均交易量突破5亿美元，成为市场最受欢迎的比特币ETF产品。',
        impact: 'High',
        affectedPairs: ['BTC/USD'],
        source: 'Bloomberg',
        url: 'https://www.bloomberg.com',
        imageUrl:
            'https://images.unsplash.com/photo-1621761191319-c6fb62004040',
        sentiment: 85.0,
      ),
      NewsEvent(
        title: 'FTX债权人将获得约31%的资产返还',
        timeAgo: '3天前',
        summary: '破产交易所FTX的重组计划获法院批准，债权人预计将获得约31%的资产返还，高于此前市场预期。',
        impact: 'Low',
        affectedPairs: ['BTC/USD', 'ETH/USD'],
        source: '法院文件',
        url: 'https://cases.ra.kroll.com/FTX/',
        imageUrl:
            'https://images.unsplash.com/photo-1621504450181-5d356f61d307',
        sentiment: 60.0,
      ),
      NewsEvent(
        title: 'OKX宣布裁员10%，专注核心业务',
        timeAgo: '4天前',
        summary: '全球加密货币交易所OKX宣布裁员10%，将资源集中于核心交易业务和产品创新，应对市场竞争。',
        impact: 'Low',
        affectedPairs: ['OKB/USD'],
        source: 'OKX官方声明',
        url: 'https://www.okx.com',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 45.0,
      ),
      NewsEvent(
        title: 'Grayscale以太坊ETF获SEC批准',
        timeAgo: '5天前',
        summary: '美国证券交易委员会(SEC)批准Grayscale以太坊ETF上市申请，这是继比特币ETF后又一重要里程碑。',
        impact: 'High',
        affectedPairs: ['ETH/USD'],
        source: 'SEC公告',
        url: 'https://www.sec.gov',
        imageUrl:
            'https://images.unsplash.com/photo-1621761191319-c6fb62004040',
        sentiment: 90.0,
      ),

      // 技术创新相关资讯
      NewsEvent(
        title: '零知识证明技术取得重大突破',
        timeAgo: '1天前',
        summary: '研究人员在零知识证明技术方面取得重大突破，新算法将验证速度提高10倍，有望大幅提升区块链扩容方案效率。',
        impact: 'Medium',
        affectedPairs: ['ETH/USD', 'ZKP相关代币'],
        source: '研究论文',
        url: 'https://arxiv.org',
        imageUrl:
            'https://images.unsplash.com/photo-1621501103258-3e5728600991',
        sentiment: 80.0,
      ),
      NewsEvent(
        title: '新型共识算法声称可实现百万TPS',
        timeAgo: '2天前',
        summary: '区块链研究团队提出新型共识算法，理论上可实现每秒处理百万级交易，同时保持去中心化和安全性。',
        impact: 'Low',
        affectedPairs: ['多种加密货币'],
        source: '技术博客',
        url: 'https://medium.com',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: '跨链安全联盟成立，应对桥接攻击',
        timeAgo: '3天前',
        summary: '多家领先区块链项目联合成立跨链安全联盟，共同应对桥接协议安全挑战，提高跨链资产安全性。',
        impact: 'Medium',
        affectedPairs: ['多种跨链代币'],
        source: '联盟公告',
        url: 'https://medium.com',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 75.0,
      ),
      NewsEvent(
        title: '新型区块链存储解决方案降低90%成本',
        timeAgo: '4天前',
        summary: '创新的区块链存储解决方案声称可降低90%的数据存储成本，同时提高检索速度，为Web3应用提供更高效基础设施。',
        impact: 'Low',
        affectedPairs: ['FIL/USD', 'AR/USD'],
        source: '技术白皮书',
        url: 'https://github.com',
        imageUrl:
            'https://images.unsplash.com/photo-1621504450181-5d356f61d307',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: '量子计算对加密货币威胁被夸大',
        timeAgo: '5天前',
        summary: '密码学专家研究表明，量子计算对当前加密货币安全性的威胁被夸大，现有算法至少在未来10-15年内仍然安全。',
        impact: 'Low',
        affectedPairs: ['BTC/USD', 'ETH/USD'],
        source: '研究报告',
        url: 'https://arxiv.org',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 65.0,
      ),

      // 行业趋势资讯
      NewsEvent(
        title: '加密支付采用率在新兴市场飙升',
        timeAgo: '1天前',
        summary: '研究报告显示，加密货币支付在新兴市场采用率同比增长200%，尤其在拉美和东南亚地区，成为跨境支付重要工具。',
        impact: 'Medium',
        affectedPairs: ['BTC/USD', 'USDT/USD', 'USDC/USD'],
        source: 'Chainalysis',
        url: 'https://chainalysis.com',
        imageUrl:
            'https://images.unsplash.com/photo-1621761191319-c6fb62004040',
        sentiment: 80.0,
      ),
      NewsEvent(
        title: 'Web3游戏用户数量同比增长150%',
        timeAgo: '2天前',
        summary: '最新行业报告显示，Web3游戏月活跃用户数量同比增长150%，达到2000万，游戏NFT交易量创历史新高。',
        impact: 'Medium',
        affectedPairs: ['游戏相关代币'],
        source: 'DappRadar',
        url: 'https://dappradar.com',
        imageUrl:
            'https://images.unsplash.com/photo-1622630998477-20aa696ecb05',
        sentiment: 75.0,
      ),
      NewsEvent(
        title: '机构投资者加密资产配置比例上升',
        timeAgo: '3天前',
        summary: '调查显示，传统机构投资者平均加密资产配置比例从去年的0.5%上升至2%，预计未来12个月将进一步增加。',
        impact: 'High',
        affectedPairs: ['BTC/USD', 'ETH/USD'],
        source: 'Fidelity Digital Assets',
        url: 'https://www.fidelitydigitalassets.com',
        imageUrl:
            'https://images.unsplash.com/photo-1621761191319-c6fb62004040',
        sentiment: 85.0,
      ),
      NewsEvent(
        title: '加密货币挖矿转向可再生能源',
        timeAgo: '4天前',
        summary: '行业报告显示，全球加密货币挖矿能源结构正在改善，可再生能源使用比例已达到59%，较去年提高15个百分点。',
        impact: 'Low',
        affectedPairs: ['BTC/USD', '挖矿相关代币'],
        source: '比特币挖矿委员会',
        url: 'https://bitcoinminingcouncil.com',
        imageUrl:
            'https://images.unsplash.com/photo-1621504450181-5d356f61d307',
        sentiment: 70.0,
      ),
      NewsEvent(
        title: '去中心化身份解决方案用户突破1000万',
        timeAgo: '5天前',
        summary: '区块链去中心化身份(DID)解决方案用户数量突破1000万，企业采用率提升，显示Web3身份基础设施逐渐成熟。',
        impact: 'Low',
        affectedPairs: ['身份相关代币'],
        source: '行业报告',
        url: 'https://identity.foundation',
        imageUrl:
            'https://images.unsplash.com/photo-1639762681057-408e52192e55',
        sentiment: 65.0,
      ),
    ];
  }

  /// 获取模拟市场趋势数据 - 只包含加密货币相关内容
  List<Map<String, dynamic>> _getMockMarketTrends() {
    return [
      {
        'topic': '比特币ETF资金流入加速',
        'description': '比特币现货ETF持续吸引大量资金流入，机构投资者参与度创历史新高，推动市场情绪转向乐观。',
        'hotness': 9,
        'relatedAssets': ['BTC', 'ETH', 'GBTC', 'IBIT']
      },
      {
        'topic': '以太坊Layer 2生态爆发',
        'description':
            '以太坊Layer 2解决方案用户数量和锁仓量快速增长，Arbitrum、Optimism和zkSync等项目竞争加剧。',
        'hotness': 8,
        'relatedAssets': ['ETH', 'ARB', 'OP', 'MATIC']
      },
      {
        'topic': '比特币减半预期升温',
        'description': '随着比特币第四次减半临近，市场对价格走势预期升温，历史数据显示减半后通常会带来新一轮牛市。',
        'hotness': 9,
        'relatedAssets': ['BTC', 'Mining Stocks', 'MARA', 'RIOT']
      },
      {
        'topic': 'DeFi 2.0创新浪潮',
        'description': 'DeFi领域创新不断，实时金融(RWA)、去中心化期权和跨链流动性协议成为新热点，吸引大量资金流入。',
        'hotness': 7,
        'relatedAssets': ['AAVE', 'UNI', 'MKR', 'CRV']
      },
      {
        'topic': '加密货币支付应用普及',
        'description': '加密货币支付解决方案在全球范围内加速普及，特别是在新兴市场，稳定币交易量创历史新高。',
        'hotness': 6,
        'relatedAssets': ['USDT', 'USDC', 'XLM', 'XRP']
      },
      {
        'topic': 'Web3游戏和元宇宙发展',
        'description': 'Web3游戏和元宇宙项目吸引大量用户和投资，游戏资产通证化和跨平台互操作性成为行业焦点。',
        'hotness': 7,
        'relatedAssets': ['AXS', 'SAND', 'MANA', 'IMX']
      },
      {
        'topic': '零知识证明技术应用扩展',
        'description': '零知识证明技术应用范围不断扩大，从隐私保护到扩容解决方案，成为区块链技术发展的重要方向。',
        'hotness': 8,
        'relatedAssets': ['ZEC', 'MATIC', 'ZKP相关代币']
      },
    ];
  }

  /// 获取模拟货币对分析数据
  Map<String, dynamic> _getMockAnalysis(String pair) {
    if (pair.contains('BTC') || pair.contains('比特币')) {
      return {
        'summary': '比特币近期表现强劲，突破关键阻力位，机构资金持续流入支撑价格上行。',
        'technicalIndicators': {
          'RSI': 68.5,
          'MACD': 'Bullish',
          'MovingAverages': 'Strong Buy',
        },
        'fundamentalFactors': ['机构投资者持续增持', 'ETF资金流入稳定', '链上活动增加', '供应减少'],
        'shortTermOutlook': {
          'direction': 'Bullish',
          'targetPrice': '72,000-75,000',
          'timeframe': '1-2周',
        },
        'mediumTermOutlook': {
          'direction': 'Bullish',
          'targetPrice': '80,000-85,000',
          'timeframe': '1-3个月',
        },
        'keyLevels': {
          'support': ['64,000', '60,000', '55,000'],
          'resistance': ['70,000', '75,000', '80,000'],
        }
      };
    } else if (pair.contains('EUR') && pair.contains('USD')) {
      return {
        'summary': '欧元/美元近期波动加剧，欧元区经济数据改善但通胀压力持续，美联储降息预期支撑欧元走强。',
        'technicalIndicators': {
          'RSI': 58.5,
          'MACD': 'Neutral',
          'MovingAverages': 'Buy',
        },
        'fundamentalFactors': ['欧元区PMI数据改善', '美联储降息预期', '欧央行鹰派立场', '通胀数据影响'],
        'shortTermOutlook': {
          'direction': 'Neutral to Bullish',
          'targetPrice': '1.0920-1.0950',
          'timeframe': '1-2周',
        },
        'mediumTermOutlook': {
          'direction': 'Bullish',
          'targetPrice': '1.1000-1.1050',
          'timeframe': '1-3个月',
        },
        'keyLevels': {
          'support': ['1.0850', '1.0820', '1.0780'],
          'resistance': ['1.0920', '1.0950', '1.1000'],
        }
      };
    } else {
      // 默认分析
      return {
        'summary': '$pair近期走势偏向震荡，市场参与者关注经济数据和央行政策变化。',
        'technicalIndicators': {
          'RSI': 52.0,
          'MACD': 'Neutral',
          'MovingAverages': 'Neutral',
        },
        'fundamentalFactors': ['全球经济增长预期', '通胀数据', '央行政策立场', '市场风险情绪'],
        'shortTermOutlook': {
          'direction': 'Neutral',
          'targetPrice': '未来一周预计在当前水平附近波动',
          'timeframe': '1周',
        },
        'mediumTermOutlook': {
          'direction': 'Neutral',
          'targetPrice': '需要更多经济数据确认方向',
          'timeframe': '1个月',
        },
        'keyLevels': {
          'support': ['当前价格-2%', '当前价格-4%'],
          'resistance': ['当前价格+2%', '当前价格+4%'],
        }
      };
    }
  }
}
