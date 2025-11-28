class AngleMeasurement {
  final String bodyPart;
  final double userAngle;
  final double standardAngle;
  final String evaluation;

  AngleMeasurement({
    required this.bodyPart,
    required this.userAngle,
    required this.standardAngle,
    required this.evaluation,
  });

  double get difference => (userAngle - standardAngle).abs();

  Map<String, dynamic> toJson() {
    return {
      'bodyPart': bodyPart,
      'userAngle': userAngle,
      'standardAngle': standardAngle,
      'evaluation': evaluation,
    };
  }

  factory AngleMeasurement.fromJson(Map<String, dynamic> json) {
    return AngleMeasurement(
      bodyPart: json['bodyPart'],
      userAngle: json['userAngle'],
      standardAngle: json['standardAngle'],
      evaluation: json['evaluation'],
    );
  }
}

class AIAnalysis {
  final String id;
  final String poseId;
  final String templatePoseName;
  final String summary;
  final List<AngleMeasurement> angleMeasurements;
  final DateTime analyzedAt;

  AIAnalysis({
    required this.id,
    required this.poseId,
    required this.templatePoseName,
    required this.summary,
    required this.angleMeasurements,
    required this.analyzedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poseId': poseId,
      'templatePoseName': templatePoseName,
      'summary': summary,
      'angleMeasurements':
          angleMeasurements.map((m) => m.toJson()).toList(),
      'analyzedAt': analyzedAt.toIso8601String(),
    };
  }

  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      id: json['id'],
      poseId: json['poseId'],
      templatePoseName: json['templatePoseName'],
      summary: json['summary'],
      angleMeasurements: (json['angleMeasurements'] as List)
          .map((m) => AngleMeasurement.fromJson(m))
          .toList(),
      analyzedAt: DateTime.parse(json['analyzedAt']),
    );
  }
}
