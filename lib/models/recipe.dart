import 'alchemy_step.dart';

class Recipe {
  final List<AlchemyStep> steps;
  final bool isLocked;
  final DateTime creationDate;
  final int attemptNumber;

  Recipe({
    required this.steps,
    this.isLocked = false,
    required this.creationDate,
    required this.attemptNumber,
  });

  bool isComplete() {
    return steps.length == 12 && steps.every((step) => step.isNotEmpty);
  }

  Recipe copyWith({
    List<AlchemyStep>? steps,
    bool? isLocked,
    DateTime? creationDate,
    int? attemptNumber,
  }) {
    return Recipe(
      steps: steps ?? this.steps,
      isLocked: isLocked ?? this.isLocked,
      creationDate: creationDate ?? this.creationDate,
      attemptNumber: attemptNumber ?? this.attemptNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps.map((s) => s.toJson()).toList(),
      'isLocked': isLocked,
      'creationDate': creationDate.toIso8601String(),
      'attemptNumber': attemptNumber,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      steps: (json['steps'] as List)
          .map((s) => AlchemyStep.fromJson(s as Map<String, dynamic>))
          .toList(),
      isLocked: json['isLocked'] as bool? ?? false,
      creationDate: DateTime.parse(json['creationDate'] as String),
      attemptNumber: json['attemptNumber'] as int,
    );
  }
}
