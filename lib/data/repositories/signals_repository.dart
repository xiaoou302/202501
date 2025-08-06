import '../models/sentiment.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

/// Repository for fetching sentiment data
class SignalsRepository {
  // In a real app, this would fetch from an API or local storage
  Future<List<Sentiment>> getSentiments() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();

    // Return enhanced mock data with rich details
    return [
      Sentiment(
        asset: '比特币',
        assetFullName: '比特币 (BTC)',
        assetClass: '加密货币',
        marketCap: '1.15万亿美元',
        tradingVolume: '345.2亿美元',
        mood: '强烈看涨',
        trendDirection: 'Increasing',
        chartData: [30, 35, 40, 38, 45, 50, 55, 60, 58, 65, 70, 75],
        summary: '比特币近期突破关键阻力位，ETF申请获批后资金持续流入，机构投资者兴趣增加，技术面指标显示上行趋势明显。',
        sentimentScore: 78,
        confidence: 85,
        indicators: {
          'RSI': 68.5,
          'MACD': 0.0023,
          'MA': 0.0045,
          'OBV': 1.25,
          'Bollinger': 0.82,
          'Stochastic': 75.3,
        },
        influencingFactors: ['机构投资者增持', 'ETF申请获批', '链上活动增加', '监管环境改善', '技术突破'],
        lastUpdated: now.subtract(const Duration(minutes: 5)),
        timeframe: '中期',
        recommendation: '买入',
        volatilityIndex: 65,
        priceTargets: {
          '短期': 68500,
          '中期': 75000,
          '长期': 100000,
        },
        newsEvents: [
          {
            'title': '比特币ETF首周净流入超过10亿美元',
            'source': '金融时报',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 1))),
            'impact': 'positive'
          },
          {
            'title': '机构持仓比例创历史新高',
            'source': '彭博社',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 2))),
            'impact': 'positive'
          },
        ],
        expertOpinions: {
          '高盛分析师': '预计比特币将在年底前突破8万美元',
          '摩根大通': '机构配置将持续推高比特币价格',
          '瑞银': '比特币已成为投资组合中的重要配置',
        },
        sentimentChange: 5.2,
        correlatedAssets: [
          {'asset': '以太坊', 'correlation': 0.85},
          {'asset': '黄金', 'correlation': -0.32},
          {'asset': '纳斯达克', 'correlation': 0.45},
        ],
        keyLevels: {
          '支撑位1': 60000,
          '支撑位2': 55000,
          '阻力位1': 70000,
          '阻力位2': 75000,
        },
      ),
      Sentiment(
        asset: '以太坊',
        assetFullName: '以太坊 (ETH)',
        assetClass: '加密货币',
        marketCap: '4,250亿美元',
        tradingVolume: '142.8亿美元',
        mood: '持续看涨',
        trendDirection: 'Increasing',
        chartData: [45, 50, 48, 52, 55, 60, 58, 62, 65, 68, 72, 75],
        summary: '以太坊网络升级后，交易费用显著降低，同时质押收益率保持稳定，Layer 2解决方案生态系统持续扩张，DeFi锁仓量回升。',
        sentimentScore: 82,
        confidence: 80,
        indicators: {
          'RSI': 72.3,
          'MACD': 0.0031,
          'MA': 0.0052,
          'OBV': 1.45,
          'Bollinger': 0.91,
          'Stochastic': 82.1,
        },
        influencingFactors: [
          '网络升级成功',
          '燃烧机制效果显著',
          'DeFi项目增长',
          'NFT市场回暖',
          'Layer 2生态扩张'
        ],
        lastUpdated: now.subtract(const Duration(minutes: 8)),
        timeframe: '长期',
        recommendation: '强烈买入',
        volatilityIndex: 60,
        priceTargets: {
          '短期': 3800,
          '中期': 4500,
          '长期': 6000,
        },
        newsEvents: [
          {
            'title': '以太坊日交易量突破历史新高',
            'source': '币安研究院',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 1))),
            'impact': 'positive'
          },
          {
            'title': 'Layer 2用户数量环比增长30%',
            'source': 'DeFi Pulse',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 3))),
            'impact': 'positive'
          },
        ],
        expertOpinions: {
          'ARK投资': '以太坊可能在未来5年内超越比特币市值',
          'a16z': '以太坊生态系统将持续引领区块链创新',
          'Messari': '以太坊通缩机制将长期支撑价格上涨',
        },
        sentimentChange: 3.8,
        correlatedAssets: [
          {'asset': '比特币', 'correlation': 0.85},
          {'asset': 'Solana', 'correlation': 0.72},
          {'asset': '纳斯达克', 'correlation': 0.38},
        ],
        keyLevels: {
          '支撑位1': 3200,
          '支撑位2': 2800,
          '阻力位1': 3800,
          '阻力位2': 4200,
        },
      ),
      Sentiment(
        asset: '黄金',
        assetFullName: '黄金 (XAU)',
        assetClass: '贵金属',
        marketCap: '13.2万亿美元',
        tradingVolume: '1,280亿美元',
        mood: '避险需求增加',
        trendDirection: 'Stable',
        chartData: [70, 72, 68, 69, 71, 70, 73, 75, 74, 76, 75, 77],
        summary: '地缘政治紧张局势持续，全球经济增长放缓预期增强，各国央行黄金储备持续增加，实物黄金需求强劲，通胀预期支撑金价。',
        sentimentScore: 65,
        confidence: 75,
        indicators: {
          'RSI': 58.2,
          'MACD': 0.0012,
          'MA': 0.0008,
          'OBV': 0.85,
          'Bollinger': 0.65,
          'Stochastic': 62.4,
        },
        influencingFactors: ['地缘政治紧张', '通胀预期上升', '美元指数走弱', '央行购金增加', '实物需求强劲'],
        lastUpdated: now.subtract(const Duration(minutes: 12)),
        timeframe: '长期',
        recommendation: '持有',
        volatilityIndex: 30,
        priceTargets: {
          '短期': 2350,
          '中期': 2500,
          '长期': 2800,
        },
        newsEvents: [
          {
            'title': '中国央行连续第5个月增加黄金储备',
            'source': '世界黄金协会',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 5))),
            'impact': 'positive'
          },
          {
            'title': '全球黄金ETF持仓量创18个月新高',
            'source': '路透社',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 7))),
            'impact': 'positive'
          },
        ],
        expertOpinions: {
          '高盛': '黄金将在避险环境中持续表现良好',
          '花旗': '预计黄金将在年底前突破2500美元',
          '摩根士丹利': '建议投资组合增加黄金配置比例',
        },
        sentimentChange: 2.3,
        correlatedAssets: [
          {'asset': '美元指数', 'correlation': -0.65},
          {'asset': '美国国债', 'correlation': 0.42},
          {'asset': '白银', 'correlation': 0.78},
        ],
        keyLevels: {
          '支撑位1': 2280,
          '支撑位2': 2200,
          '阻力位1': 2350,
          '阻力位2': 2400,
        },
      ),
      Sentiment(
        asset: '原油',
        assetFullName: '原油 (WTI)',
        assetClass: '能源',
        marketCap: '不适用',
        tradingVolume: '950亿美元',
        mood: '情绪谨慎',
        trendDirection: 'Decreasing',
        chartData: [55, 52, 48, 45, 42, 40, 38, 35, 38, 40, 38, 35],
        summary: 'OPEC+减产计划执行率下降，全球经济增长放缓预期影响需求前景，美国原油库存持续增加，新能源转型加速对长期需求构成压力。',
        sentimentScore: 35,
        confidence: 65,
        indicators: {
          'RSI': 32.5,
          'MACD': -0.0018,
          'MA': -0.0025,
          'OBV': -0.65,
          'Bollinger': -0.72,
          'Stochastic': 28.6,
        },
        influencingFactors: [
          '全球需求预期下降',
          '美国库存增加',
          '减产执行率下降',
          '替代能源发展',
          '经济增长放缓'
        ],
        lastUpdated: now.subtract(const Duration(minutes: 15)),
        timeframe: '短期',
        recommendation: '卖出',
        volatilityIndex: 55,
        priceTargets: {
          '短期': 72,
          '中期': 68,
          '长期': 65,
        },
        newsEvents: [
          {
            'title': '美国原油库存连续第4周增加',
            'source': 'EIA',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 2))),
            'impact': 'negative'
          },
          {
            'title': 'OPEC+减产执行率降至85%',
            'source': '彭博社',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 4))),
            'impact': 'negative'
          },
        ],
        expertOpinions: {
          '高盛': '预计油价将在下半年承压',
          'IEA': '全球石油需求增速将放缓',
          'BP': '能源转型将加速影响石油长期需求',
        },
        sentimentChange: -4.2,
        correlatedAssets: [
          {'asset': '天然气', 'correlation': 0.58},
          {'asset': '美元指数', 'correlation': -0.45},
          {'asset': '航空股', 'correlation': -0.62},
        ],
        keyLevels: {
          '支撑位1': 72,
          '支撑位2': 70,
          '阻力位1': 78,
          '阻力位2': 80,
        },
      ),
      Sentiment(
        asset: '美股',
        assetFullName: '标普500指数 (SPX)',
        assetClass: '股票',
        marketCap: '44.5万亿美元',
        tradingVolume: '1.25万亿美元',
        mood: '谨慎乐观',
        trendDirection: 'Stable',
        chartData: [60, 62, 58, 59, 62, 64, 63, 65, 67, 66, 68, 67],
        summary: '企业财报整体好于预期，科技股表现强劲，但通胀数据高于预期可能影响美联储降息路径，估值处于历史高位引发部分谨慎情绪。',
        sentimentScore: 58,
        confidence: 70,
        indicators: {
          'RSI': 54.8,
          'MACD': 0.0008,
          'MA': 0.0012,
          'OBV': 0.55,
          'Bollinger': 0.42,
          'Stochastic': 60.3,
        },
        influencingFactors: ['财报季表现良好', '通胀数据趋稳', '就业市场强劲', '科技股领涨', '估值处于高位'],
        lastUpdated: now.subtract(const Duration(minutes: 20)),
        timeframe: '中期',
        recommendation: '谨慎买入',
        volatilityIndex: 45,
        priceTargets: {
          '短期': 5300,
          '中期': 5500,
          '长期': 5800,
        },
        newsEvents: [
          {
            'title': '科技巨头财报超预期，推动纳指创新高',
            'source': '华尔街日报',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 1))),
            'impact': 'positive'
          },
          {
            'title': 'CPI数据高于预期，美联储可能推迟降息',
            'source': '金融时报',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 3))),
            'impact': 'negative'
          },
        ],
        expertOpinions: {
          '摩根士丹利': '美股可能迎来温和调整',
          '高盛': '维持年底标普500指数5500点目标',
          '富达': '建议增持科技和医疗板块',
        },
        sentimentChange: 0.8,
        correlatedAssets: [
          {'asset': '纳斯达克', 'correlation': 0.92},
          {'asset': '美国国债', 'correlation': -0.35},
          {'asset': '黄金', 'correlation': -0.28},
        ],
        keyLevels: {
          '支撑位1': 5100,
          '支撑位2': 5000,
          '阻力位1': 5350,
          '阻力位2': 5400,
        },
      ),
      Sentiment(
        asset: '美元',
        assetFullName: '美元指数 (DXY)',
        assetClass: '货币',
        marketCap: '不适用',
        tradingVolume: '6.6万亿美元',
        mood: '中性偏弱',
        trendDirection: 'Decreasing',
        chartData: [65, 63, 62, 60, 58, 57, 55, 53, 54, 52, 50, 48],
        summary:
            '美联储降息预期增强导致美元承压，但全球经济不确定性提供部分支撑，美债收益率下行趋势明显，其他主要央行货币政策立场转向鹰派。',
        sentimentScore: 42,
        confidence: 68,
        indicators: {
          'RSI': 38.5,
          'MACD': -0.0015,
          'MA': -0.0022,
          'OBV': -0.48,
          'Bollinger': -0.55,
          'Stochastic': 35.2,
        },
        influencingFactors: [
          '美联储降息预期',
          '美债收益率下行',
          '全球经济不确定性',
          '欧央行立场转鹰',
          '贸易逆差扩大'
        ],
        lastUpdated: now.subtract(const Duration(minutes: 25)),
        timeframe: '中期',
        recommendation: '观望',
        volatilityIndex: 40,
        priceTargets: {
          '短期': 102,
          '中期': 100,
          '长期': 98,
        },
        newsEvents: [
          {
            'title': '美联储会议纪要暗示年内可能降息',
            'source': '路透社',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 2))),
            'impact': 'negative'
          },
          {
            'title': '欧央行官员表示可能维持高利率更长时间',
            'source': '彭博社',
            'date': DateFormat('yyyy-MM-dd')
                .format(now.subtract(const Duration(days: 4))),
            'impact': 'negative'
          },
        ],
        expertOpinions: {
          '摩根大通': '美元指数年底前可能跌至100以下',
          '德意志银行': '美元将在全球经济不确定性中获得支撑',
          '瑞银': '建议减少美元敞口',
        },
        sentimentChange: -2.5,
        correlatedAssets: [
          {'asset': '欧元', 'correlation': -0.85},
          {'asset': '黄金', 'correlation': -0.65},
          {'asset': '美债', 'correlation': 0.52},
        ],
        keyLevels: {
          '支撑位1': 102,
          '支撑位2': 100,
          '阻力位1': 105,
          '阻力位2': 107,
        },
      ),
    ];
  }

  // Get sentiment history for a specific asset
  Future<List<Map<String, dynamic>>> getSentimentHistory(String asset) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock historical data for the past 30 days (more comprehensive)
    final now = DateTime.now();
    final List<Map<String, dynamic>> history = [];

    // Generate base pattern based on asset
    double baseScore = 50.0;
    double trend = 0.0;

    if (asset.contains('比特币')) {
      baseScore = 65.0;
      trend = 0.5; // Upward trend
    } else if (asset.contains('以太坊')) {
      baseScore = 70.0;
      trend = 0.4; // Upward trend
    } else if (asset.contains('黄金')) {
      baseScore = 60.0;
      trend = 0.2; // Slight upward trend
    } else if (asset.contains('原油')) {
      baseScore = 45.0;
      trend = -0.3; // Downward trend
    } else if (asset.contains('美股')) {
      baseScore = 55.0;
      trend = 0.1; // Slight upward trend
    } else if (asset.contains('美元')) {
      baseScore = 48.0;
      trend = -0.2; // Slight downward trend
    }

    // Generate 30 days of data with realistic patterns
    for (int i = 30; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));

      // Create some variation in the sentiment score with realistic patterns
      // Add cyclical component, trend component, and random noise
      final cyclical = 5 * Math.sin(i / 7 * math.pi); // Weekly cycle
      final trendComponent = trend * i; // Long term trend
      final noise = (Math.random() - 0.5) * 8.0; // Random noise

      // Special events (simulate market shocks)
      double eventImpact = 0.0;
      String eventDescription = '';

      // Add some significant events for realism
      if (i == 23 && asset.contains('比特币')) {
        eventImpact = 12.0;
        eventDescription = 'ETF获批';
      } else if (i == 18 && asset.contains('原油')) {
        eventImpact = -10.0;
        eventDescription = 'OPEC+增产';
      } else if (i == 15 && asset.contains('美股')) {
        eventImpact = -8.0;
        eventDescription = '通胀数据超预期';
      } else if (i == 10 && asset.contains('美元')) {
        eventImpact = 7.0;
        eventDescription = '美联储鹰派表态';
      } else if (i == 5 && asset.contains('黄金')) {
        eventImpact = 9.0;
        eventDescription = '地缘政治紧张';
      }

      // Calculate final score
      double score =
          baseScore + trendComponent + cyclical + noise + eventImpact;
      score = score.clamp(10.0, 90.0); // Keep within reasonable bounds

      // Add to history with date formatting
      history.add({
        'date': DateFormat('MM-dd').format(date),
        'score': score,
        'recommendation': _getRecommendation(score),
        'volume': 80 + (Math.random() * 40), // Trading volume indicator (0-100)
        'event': eventDescription,
      });
    }

    return history;
  }

  // Get market overview data
  Future<Map<String, dynamic>> getMarketOverview() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    return {
      'bullishAssets': 12,
      'bearishAssets': 8,
      'neutralAssets': 5,
      'totalAssets': 25,
      'marketMood': '谨慎乐观',
      'topPerformer': '以太坊',
      'topPerformerScore': 82,
      'worstPerformer': '原油',
      'worstPerformerScore': 35,
      'averageSentiment': 58.4,
      'sentimentTrend': '上升',
      'sentimentChange': 2.3,
      'lastUpdated': DateTime.now().toString(),
    };
  }

  // Get correlated assets for a specific asset
  Future<List<Map<String, dynamic>>> getCorrelatedAssets(String asset) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Return more comprehensive correlation data
    if (asset.contains('比特币')) {
      return [
        {'asset': '以太坊', 'correlation': 0.85, 'sentiment': 82},
        {'asset': '黄金', 'correlation': -0.32, 'sentiment': 65},
        {'asset': '纳斯达克', 'correlation': 0.45, 'sentiment': 60},
        {'asset': '美元', 'correlation': -0.38, 'sentiment': 42},
        {'asset': 'Solana', 'correlation': 0.78, 'sentiment': 75},
      ];
    } else if (asset.contains('以太坊')) {
      return [
        {'asset': '比特币', 'correlation': 0.85, 'sentiment': 78},
        {'asset': 'Solana', 'correlation': 0.72, 'sentiment': 75},
        {'asset': '纳斯达克', 'correlation': 0.38, 'sentiment': 60},
        {'asset': '美元', 'correlation': -0.35, 'sentiment': 42},
        {'asset': 'Polygon', 'correlation': 0.82, 'sentiment': 68},
      ];
    }

    // Default correlations
    return [
      {'asset': '比特币', 'correlation': 0.25, 'sentiment': 78},
      {'asset': '黄金', 'correlation': 0.42, 'sentiment': 65},
      {'asset': '标普500', 'correlation': 0.65, 'sentiment': 58},
      {'asset': '美元', 'correlation': -0.45, 'sentiment': 42},
    ];
  }

  String _getRecommendation(double score) {
    if (score >= 75) return '强烈买入';
    if (score >= 60) return '买入';
    if (score >= 45) return '持有';
    if (score >= 30) return '卖出';
    return '强烈卖出';
  }
}

// Simple Math utility class for calculations
class Math {
  static double sin(double value) {
    return math.sin(value);
  }

  static double random() {
    return math.Random().nextDouble();
  }
}
