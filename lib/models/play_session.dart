import 'dart:convert';

class PlaySession {
  final String id;
  final String gameType;
  final int durationSeconds;
  final DateTime startTime;
  final DateTime endTime;
  final int estimatedCalories;
  final bool isCompleted;

  PlaySession({
    required this.id,
    required this.gameType,
    required this.durationSeconds,
    required this.startTime,
    required this.endTime,
    required this.estimatedCalories,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameType': gameType,
      'durationSeconds': durationSeconds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'estimatedCalories': estimatedCalories,
      'isCompleted': isCompleted,
    };
  }

  factory PlaySession.fromMap(Map<String, dynamic> map) {
    return PlaySession(
      id: map['id'],
      gameType: map['gameType'],
      durationSeconds: map['durationSeconds'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      estimatedCalories: map['estimatedCalories'],
      isCompleted: map['isCompleted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaySession.fromJson(String source) =>
      PlaySession.fromMap(json.decode(source));
}
