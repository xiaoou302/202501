import '../models/trading_pair.dart';

/// Repository for fetching trading pair data
class MarketRepository {
  // In a real app, this would fetch from an API or local storage
  Future<List<TradingPair>> getTradingPairs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return mock data
    return [
      // Major Coins
      TradingPair(
        id: 'BTC/USDT',
        buyRate: 67432.25,
        sellRate: 67420.80,
        changePercent: 2.34,
        trend: 'up',
        summary: '比特币突破67000美元，机构投资者持续流入',
        chartData: [40, 50, 45, 60, 55, 65, 70],
        category: 'Major',
        volume: 32.8,
        volatility: 58,
        technicalIndicators: {
          'RSI': 62.5,
          'MACD': 0.0023,
          'MA': 66980.5,
        },
        marketSentiment: 'Bullish',
      ),
      TradingPair(
        id: 'ETH/USDT',
        buyRate: 3425.75,
        sellRate: 3424.50,
        changePercent: -0.88,
        trend: 'down',
        summary: '以太坊网络拥堵，Gas费用创近期新高',
        chartData: [50, 30, 45, 35, 60, 40, 50],
        category: 'Major',
        volume: 18.4,
        volatility: 45,
        technicalIndicators: {
          'RSI': 41.2,
          'MACD': -0.0015,
          'MA': 3440.62,
        },
        marketSentiment: 'Bearish',
      ),
      TradingPair(
        id: 'BNB/USDT',
        buyRate: 562.55,
        sellRate: 562.10,
        changePercent: 1.28,
        trend: 'up',
        summary: '币安交易所交易量激增，BNB需求上涨',
        chartData: [55, 60, 65, 70, 68, 72, 75],
        category: 'Major',
        volume: 8.5,
        volatility: 42,
        technicalIndicators: {
          'RSI': 58.7,
          'MACD': 0.0018,
          'MA': 558.70,
        },
        marketSentiment: 'Bullish',
      ),

      // Altcoins
      TradingPair(
        id: 'SOL/USDT',
        buyRate: 142.05,
        sellRate: 141.92,
        changePercent: 3.32,
        trend: 'up',
        summary: 'Solana生态系统DApp数量突破新高',
        chartData: [42, 45, 48, 52, 55, 58, 62],
        category: 'Altcoin',
        volume: 5.3,
        volatility: 65,
        technicalIndicators: {
          'RSI': 66.3,
          'MACD': 0.0028,
          'MA': 138.98,
        },
        marketSentiment: 'Bullish',
      ),
      TradingPair(
        id: 'ADA/USDT',
        buyRate: 0.4524,
        sellRate: 0.4520,
        changePercent: -1.45,
        trend: 'down',
        summary: 'Cardano推迟主网更新计划',
        chartData: [35, 38, 36, 34, 32, 30, 28],
        category: 'Altcoin',
        volume: 2.7,
        volatility: 48,
        technicalIndicators: {
          'RSI': 38.9,
          'MACD': -0.0012,
          'MA': 0.4615,
        },
        marketSentiment: 'Bearish',
      ),

      // DeFi Tokens
      TradingPair(
        id: 'UNI/USDT',
        buyRate: 8.425,
        sellRate: 8.420,
        changePercent: -0.15,
        trend: 'down',
        summary: 'Uniswap V4即将发布，市场反应谨慎',
        chartData: [60, 58, 55, 57, 54, 52, 50],
        category: 'DeFi',
        volume: 1.2,
        volatility: 52,
        technicalIndicators: {
          'RSI': 43.5,
          'MACD': -0.0005,
          'MA': 8.430,
        },
        marketSentiment: 'Neutral',
      ),
      TradingPair(
        id: 'AAVE/USDT',
        buyRate: 98.82,
        sellRate: 98.75,
        changePercent: 2.25,
        trend: 'up',
        summary: 'AAVE推出新的借贷协议，流动性提升',
        chartData: [45, 48, 52, 55, 58, 62, 65],
        category: 'DeFi',
        volume: 0.89,
        volatility: 55,
        technicalIndicators: {
          'RSI': 62.8,
          'MACD': 0.0018,
          'MA': 96.83,
        },
        marketSentiment: 'Bullish',
      ),

      // Meme Coins
      TradingPair(
        id: 'DOGE/USDT',
        buyRate: 0.1245,
        sellRate: 0.1240,
        changePercent: 5.18,
        trend: 'up',
        summary: '马斯克再次发推提及狗狗币',
        chartData: [40, 45, 50, 55, 60, 65, 70],
        category: 'Meme',
        volume: 3.4,
        volatility: 85,
        technicalIndicators: {
          'RSI': 74.2,
          'MACD': 0.0030,
          'MA': 0.1185,
        },
        marketSentiment: 'Bullish',
      ),
      TradingPair(
        id: 'SHIB/USDT',
        buyRate: 0.00001782,
        sellRate: 0.00001780,
        changePercent: 3.65,
        trend: 'up',
        summary: 'Shibarium生态系统用户数量增长',
        chartData: [30, 35, 38, 42, 45, 48, 52],
        category: 'Meme',
        volume: 1.8,
        volatility: 90,
        technicalIndicators: {
          'RSI': 68.5,
          'MACD': 0.0000015,
          'MA': 0.00001720,
        },
        marketSentiment: 'Bullish',
      ),
    ];
  }

  Future<List<TradingPair>> getTopTradingPairs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data for top trading pairs
    return [
      TradingPair(
        id: 'BTC/USDT',
        buyRate: 67432.25,
        sellRate: 67420.80,
        changePercent: 2.34,
        trend: 'up',
        summary: '比特币突破67000美元，机构投资者持续流入',
        chartData: [40, 50, 45, 60, 55, 65, 70],
        category: 'Major',
        volume: 32.8,
        volatility: 58,
        technicalIndicators: {
          'RSI': 62.5,
          'MACD': 0.0023,
          'MA': 66980.5,
        },
        marketSentiment: 'Bullish',
      ),
      TradingPair(
        id: 'ETH/USDT',
        buyRate: 3425.75,
        sellRate: 3424.50,
        changePercent: -0.88,
        trend: 'down',
        summary: '以太坊网络拥堵，Gas费用创近期新高',
        chartData: [50, 30, 45, 35, 60, 40, 50],
        category: 'Major',
        volume: 18.4,
        volatility: 45,
        technicalIndicators: {
          'RSI': 41.2,
          'MACD': -0.0015,
          'MA': 3440.62,
        },
        marketSentiment: 'Bearish',
      ),
      TradingPair(
        id: 'DOGE/USDT',
        buyRate: 0.1245,
        sellRate: 0.1240,
        changePercent: 5.18,
        trend: 'up',
        summary: '马斯克再次发推提及狗狗币',
        chartData: [40, 45, 50, 55, 60, 65, 70],
        category: 'Meme',
        volume: 3.4,
        volatility: 85,
        technicalIndicators: {
          'RSI': 74.2,
          'MACD': 0.0030,
          'MA': 0.1185,
        },
        marketSentiment: 'Bullish',
      ),
    ];
  }

  // Added method to get pairs by category
  Future<Map<String, List<TradingPair>>> getTradingPairsByCategory() async {
    final allPairs = await getTradingPairs();
    final Map<String, List<TradingPair>> categorizedPairs = {};

    for (final pair in allPairs) {
      if (!categorizedPairs.containsKey(pair.category)) {
        categorizedPairs[pair.category] = [];
      }
      categorizedPairs[pair.category]!.add(pair);
    }

    return categorizedPairs;
  }
}
