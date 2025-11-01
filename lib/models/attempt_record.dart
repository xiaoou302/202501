import 'recipe.dart';

class AttemptRecord {
  final int attemptNumber;
  final DateTime timestamp;
  final Recipe attemptedRecipe;
  final bool wasSuccessful;
  final int? failedAtStep;
  final String? failureReason;

  AttemptRecord({
    required this.attemptNumber,
    required this.timestamp,
    required this.attemptedRecipe,
    required this.wasSuccessful,
    this.failedAtStep,
    this.failureReason,
  });

  AttemptRecord copyWith({
    int? attemptNumber,
    DateTime? timestamp,
    Recipe? attemptedRecipe,
    bool? wasSuccessful,
    int? failedAtStep,
    String? failureReason,
  }) {
    return AttemptRecord(
      attemptNumber: attemptNumber ?? this.attemptNumber,
      timestamp: timestamp ?? this.timestamp,
      attemptedRecipe: attemptedRecipe ?? this.attemptedRecipe,
      wasSuccessful: wasSuccessful ?? this.wasSuccessful,
      failedAtStep: failedAtStep ?? this.failedAtStep,
      failureReason: failureReason ?? this.failureReason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attemptNumber': attemptNumber,
      'timestamp': timestamp.toIso8601String(),
      'attemptedRecipe': attemptedRecipe.toJson(),
      'wasSuccessful': wasSuccessful,
      'failedAtStep': failedAtStep,
      'failureReason': failureReason,
    };
  }

  factory AttemptRecord.fromJson(Map<String, dynamic> json) {
    return AttemptRecord(
      attemptNumber: json['attemptNumber'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      attemptedRecipe: Recipe.fromJson(
        json['attemptedRecipe'] as Map<String, dynamic>,
      ),
      wasSuccessful: json['wasSuccessful'] as bool,
      failedAtStep: json['failedAtStep'] as int?,
      failureReason: json['failureReason'] as String?,
    );
  }
}
