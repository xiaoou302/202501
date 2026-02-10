class SprintSession {
  final DateTime startTime;
  final int durationInSeconds;
  final int totalQuestions;
  final int correctAnswers;
  final List<bool> answerHistory;
  final double accuracy;

  SprintSession({
    required this.startTime,
    required this.durationInSeconds,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.answerHistory,
  }) : accuracy = totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'durationInSeconds': durationInSeconds,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'answerHistory': answerHistory,
      'accuracy': accuracy,
    };
  }

  factory SprintSession.fromJson(Map<String, dynamic> json) {
    return SprintSession(
      startTime: DateTime.parse(json['startTime']),
      durationInSeconds: json['durationInSeconds'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      answerHistory: List<bool>.from(json['answerHistory']),
    );
  }
}