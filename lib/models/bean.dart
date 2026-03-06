import 'dart:convert';

class Bean {
  final String id;
  final String name;
  final String origin;
  final String process; // e.g., Washed, Natural
  final String roastLevel; // e.g., Light, Medium
  final DateTime roastDate;
  final int initialWeight; // in grams
  final int remainingWeight; // in grams
  final List<String> flavorNotes;
  final String? imagePath;

  Bean({
    required this.id,
    required this.name,
    required this.origin,
    required this.process,
    required this.roastLevel,
    required this.roastDate,
    required this.initialWeight,
    required this.remainingWeight,
    required this.flavorNotes,
    this.imagePath,
  });

  // Helper to calculate days aging
  int get agingDays => DateTime.now().difference(roastDate).inDays;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'process': process,
      'roastLevel': roastLevel,
      'roastDate': roastDate.toIso8601String(),
      'initialWeight': initialWeight,
      'remainingWeight': remainingWeight,
      'flavorNotes': flavorNotes,
      'imagePath': imagePath,
    };
  }

  factory Bean.fromJson(Map<String, dynamic> json) {
    return Bean(
      id: json['id'],
      name: json['name'],
      origin: json['origin'],
      process: json['process'],
      roastLevel: json['roastLevel'],
      roastDate: DateTime.parse(json['roastDate']),
      initialWeight: json['initialWeight'],
      remainingWeight: json['remainingWeight'],
      flavorNotes: List<String>.from(json['flavorNotes']),
      imagePath: json['imagePath'],
    );
  }
}
