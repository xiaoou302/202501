import 'dart:convert';

class JournalEntry {
  final String id;
  final DateTime date;
  final String? scanRecordId;
  final double weight;
  final String? mealDescription;
  final List<String> activityTags;
  final String notes;

  // New fields for Stray Rescue
  final String? photoPath;
  final String? name;
  final String? age;
  final String? condition;

  JournalEntry({
    required this.id,
    required this.date,
    this.scanRecordId,
    required this.weight,
    this.mealDescription,
    required this.activityTags,
    required this.notes,
    this.photoPath,
    this.name,
    this.age,
    this.condition,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'scanRecordId': scanRecordId,
      'weight': weight,
      'mealDescription': mealDescription,
      'activityTags': activityTags,
      'notes': notes,
      'photoPath': photoPath,
      'name': name,
      'age': age,
      'condition': condition,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      date: DateTime.parse(map['date']),
      scanRecordId: map['scanRecordId'],
      weight: map['weight']?.toDouble() ?? 0.0,
      mealDescription: map['mealDescription'],
      activityTags: List<String>.from(map['activityTags'] ?? []),
      notes: map['notes'] ?? '',
      photoPath: map['photoPath'],
      name: map['name'],
      age: map['age'],
      condition: map['condition'],
    );
  }

  String toJson() => json.encode(toMap());

  factory JournalEntry.fromJson(String source) =>
      JournalEntry.fromMap(json.decode(source));
}
