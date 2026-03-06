class FlavorProfile {
  final String id;
  final String beanId;
  final DateTime evaluatedAt;
  final Map<String, double> scores; // Key: Dimension (Acidity, Sweetness, etc.), Value: 0-10

  FlavorProfile({
    required this.id,
    required this.beanId,
    required this.evaluatedAt,
    required this.scores,
  });

  static Map<String, double> defaultScores() {
    return {
      'Acidity': 5.0,
      'Sweetness': 5.0,
      'Body': 5.0,
      'Bitter': 5.0,
      'Finish': 5.0,
      'Aroma': 5.0,
    };
  }
}
