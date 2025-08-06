/// Trading pair model representing a cryptocurrency pair with its rates and trend
class TradingPair {
  final String id; // e.g., "BTC/USDT"
  final double buyRate;
  final double sellRate;
  final double changePercent;
  final String trend; // "up" or "down"
  final String summary; // Brief news/event affecting this pair
  final List<double> chartData;

  // Added fields for more professional display
  final String category; // e.g., "Major", "Altcoin", "DeFi", "Meme"
  final double volume; // Daily trading volume in billions
  final double volatility; // Volatility index (0-100)
  final Map<String, double>
      technicalIndicators; // Technical analysis indicators
  final String marketSentiment; // e.g., "Bullish", "Bearish", "Neutral"
  final double spread; // Calculated spread between buy and sell rates

  TradingPair({
    required this.id,
    required this.buyRate,
    required this.sellRate,
    required this.changePercent,
    required this.trend,
    required this.summary,
    required this.chartData,
    this.category = 'Major',
    this.volume = 0,
    this.volatility = 0,
    this.technicalIndicators = const {},
    this.marketSentiment = 'Neutral',
    double? spread,
  }) : spread = spread ?? (buyRate - sellRate).abs();

  factory TradingPair.fromJson(Map<String, dynamic> json) {
    return TradingPair(
      id: json['id'] as String,
      buyRate: json['buyRate'] as double,
      sellRate: json['sellRate'] as double,
      changePercent: json['changePercent'] as double,
      trend: json['trend'] as String,
      summary: json['summary'] as String,
      chartData: (json['chartData'] as List).map((e) => e as double).toList(),
      category: json['category'] as String? ?? 'Major',
      volume: json['volume'] as double? ?? 0,
      volatility: json['volatility'] as double? ?? 0,
      technicalIndicators: json['technicalIndicators'] != null
          ? Map<String, double>.from(json['technicalIndicators'] as Map)
          : {},
      marketSentiment: json['marketSentiment'] as String? ?? 'Neutral',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyRate': buyRate,
      'sellRate': sellRate,
      'changePercent': changePercent,
      'trend': trend,
      'summary': summary,
      'chartData': chartData,
      'category': category,
      'volume': volume,
      'volatility': volatility,
      'technicalIndicators': technicalIndicators,
      'marketSentiment': marketSentiment,
      'spread': spread,
    };
  }
}
