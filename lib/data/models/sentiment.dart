/// Sentiment model representing market sentiment for an asset
class Sentiment {
  final String asset; // e.g., "Bitcoin"
  final String mood; // e.g., "Optimistic", "Cautious"
  final String trendDirection; // e.g., "Increasing", "Stable"
  final List<double> chartData;
  final String summary; // Brief explanation of sentiment

  // Professional display fields
  final double sentimentScore; // Numerical score from 0-100
  final double confidence; // Confidence level of the prediction (0-100)
  final Map<String, double>
      indicators; // Technical indicators related to sentiment
  final List<String> influencingFactors; // Factors affecting sentiment
  final DateTime lastUpdated; // When the sentiment was last updated
  final String timeframe; // Short-term, Medium-term, Long-term
  final String recommendation; // Buy, Sell, Hold, etc.
  final double volatilityIndex; // Expected volatility (0-100)

  // Enhanced fields for more professional display
  final String assetFullName; // Full name of the asset (e.g., "Bitcoin (BTC)")
  final String
      assetClass; // Asset class (e.g., "Cryptocurrency", "Precious Metal")
  final String marketCap; // Market capitalization or equivalent
  final String tradingVolume; // 24h trading volume
  final Map<String, double>
      priceTargets; // Price targets (short/medium/long term)
  final List<Map<String, dynamic>>
      newsEvents; // Recent news affecting sentiment
  final Map<String, String> expertOpinions; // Expert opinions on the asset
  final double sentimentChange; // Change in sentiment over the last period
  final List<Map<String, dynamic>>
      correlatedAssets; // Assets with price correlation
  final Map<String, double> keyLevels; // Key support and resistance levels

  Sentiment({
    required this.asset,
    required this.mood,
    required this.trendDirection,
    required this.chartData,
    required this.summary,
    this.sentimentScore = 50,
    this.confidence = 70,
    this.indicators = const {},
    this.influencingFactors = const [],
    DateTime? lastUpdated,
    this.timeframe = '短期',
    this.recommendation = '观望',
    this.volatilityIndex = 50,
    this.assetFullName = '',
    this.assetClass = '',
    this.marketCap = '',
    this.tradingVolume = '',
    this.priceTargets = const {},
    this.newsEvents = const [],
    this.expertOpinions = const {},
    this.sentimentChange = 0.0,
    this.correlatedAssets = const [],
    this.keyLevels = const {},
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory Sentiment.fromJson(Map<String, dynamic> json) {
    return Sentiment(
      asset: json['asset'] as String,
      mood: json['mood'] as String,
      trendDirection: json['trendDirection'] as String,
      chartData: (json['chartData'] as List).map((e) => e as double).toList(),
      summary: json['summary'] as String,
      sentimentScore: json['sentimentScore'] as double? ?? 50,
      confidence: json['confidence'] as double? ?? 70,
      indicators: json['indicators'] != null
          ? Map<String, double>.from(json['indicators'] as Map)
          : {},
      influencingFactors: json['influencingFactors'] != null
          ? List<String>.from(json['influencingFactors'] as List)
          : [],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
      timeframe: json['timeframe'] as String? ?? '短期',
      recommendation: json['recommendation'] as String? ?? '观望',
      volatilityIndex: json['volatilityIndex'] as double? ?? 50,
      assetFullName: json['assetFullName'] as String? ?? '',
      assetClass: json['assetClass'] as String? ?? '',
      marketCap: json['marketCap'] as String? ?? '',
      tradingVolume: json['tradingVolume'] as String? ?? '',
      priceTargets: json['priceTargets'] != null
          ? Map<String, double>.from(json['priceTargets'] as Map)
          : {},
      newsEvents: json['newsEvents'] != null
          ? List<Map<String, dynamic>>.from(json['newsEvents'] as List)
          : [],
      expertOpinions: json['expertOpinions'] != null
          ? Map<String, String>.from(json['expertOpinions'] as Map)
          : {},
      sentimentChange: json['sentimentChange'] as double? ?? 0.0,
      correlatedAssets: json['correlatedAssets'] != null
          ? List<Map<String, dynamic>>.from(json['correlatedAssets'] as List)
          : [],
      keyLevels: json['keyLevels'] != null
          ? Map<String, double>.from(json['keyLevels'] as Map)
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset': asset,
      'mood': mood,
      'trendDirection': trendDirection,
      'chartData': chartData,
      'summary': summary,
      'sentimentScore': sentimentScore,
      'confidence': confidence,
      'indicators': indicators,
      'influencingFactors': influencingFactors,
      'lastUpdated': lastUpdated.toIso8601String(),
      'timeframe': timeframe,
      'recommendation': recommendation,
      'volatilityIndex': volatilityIndex,
      'assetFullName': assetFullName,
      'assetClass': assetClass,
      'marketCap': marketCap,
      'tradingVolume': tradingVolume,
      'priceTargets': priceTargets,
      'newsEvents': newsEvents,
      'expertOpinions': expertOpinions,
      'sentimentChange': sentimentChange,
      'correlatedAssets': correlatedAssets,
      'keyLevels': keyLevels,
    };
  }
}
