import 'dart:convert';

class UserPreferences {
  final String petName;
  final String species;
  final String? breed;
  final double targetWeight;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final bool hasSeenOnboarding;

  UserPreferences({
    required this.petName,
    required this.species,
    this.breed,
    required this.targetWeight,
    required this.reminderEnabled,
    this.reminderTime,
    required this.hasSeenOnboarding,
  });

  Map<String, dynamic> toMap() {
    return {
      'petName': petName,
      'species': species,
      'breed': breed,
      'targetWeight': targetWeight,
      'reminderEnabled': reminderEnabled,
      'reminderTime': reminderTime?.toIso8601String(),
      'hasSeenOnboarding': hasSeenOnboarding,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      petName: map['petName'],
      species: map['species'],
      breed: map['breed'],
      targetWeight: map['targetWeight'],
      reminderEnabled: map['reminderEnabled'],
      reminderTime: map['reminderTime'] != null
          ? DateTime.parse(map['reminderTime'])
          : null,
      hasSeenOnboarding: map['hasSeenOnboarding'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPreferences.fromJson(String source) =>
      UserPreferences.fromMap(json.decode(source));
}
