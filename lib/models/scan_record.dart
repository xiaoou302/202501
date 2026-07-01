import 'dart:convert';

class ScanRecord {
  final String id;
  final DateTime dateTime;
  final String photoPath;
  final bool isValidPet;
  final String breed;
  final String estimatedAge;
  final String condition;
  final String message;
  final List<String> tags;

  ScanRecord({
    required this.id,
    required this.dateTime,
    required this.photoPath,
    required this.isValidPet,
    required this.breed,
    required this.estimatedAge,
    required this.condition,
    required this.message,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'photoPath': photoPath,
      'isValidPet': isValidPet,
      'breed': breed,
      'estimatedAge': estimatedAge,
      'condition': condition,
      'message': message,
      'tags': tags,
    };
  }

  factory ScanRecord.fromMap(Map<String, dynamic> map) {
    return ScanRecord(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      photoPath: map['photoPath'],
      isValidPet: map['isValidPet'] ?? true,
      breed: map['breed'] ?? '',
      estimatedAge: map['estimatedAge'] ?? '',
      condition: map['condition'] ?? '',
      message: map['message'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanRecord.fromJson(String source) =>
      ScanRecord.fromMap(json.decode(source));
}
