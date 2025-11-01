class AlchemyStep {
  final int stepNumber;
  final String action;
  final String material;
  final bool isCompleted;
  final bool isCorrect;

  AlchemyStep({
    required this.stepNumber,
    required this.action,
    required this.material,
    this.isCompleted = false,
    this.isCorrect = true,
  });

  AlchemyStep copyWith({
    int? stepNumber,
    String? action,
    String? material,
    bool? isCompleted,
    bool? isCorrect,
  }) {
    return AlchemyStep(
      stepNumber: stepNumber ?? this.stepNumber,
      action: action ?? this.action,
      material: material ?? this.material,
      isCompleted: isCompleted ?? this.isCompleted,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'action': action,
      'material': material,
      'isCompleted': isCompleted,
      'isCorrect': isCorrect,
    };
  }

  factory AlchemyStep.fromJson(Map<String, dynamic> json) {
    return AlchemyStep(
      stepNumber: json['stepNumber'] as int,
      action: json['action'] as String,
      material: json['material'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isCorrect: json['isCorrect'] as bool? ?? true,
    );
  }

  bool get isEmpty => action.isEmpty || material.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
