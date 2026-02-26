import 'dart:convert';

class RestorationRecord {
  final String id;
  final DateTime date;
  final String itemName;
  final String material;
  final String? originalImagePath;
  final String? restoredImageUrl;

  RestorationRecord({
    required this.id,
    required this.date,
    required this.itemName,
    this.material = 'Unknown',
    this.originalImagePath,
    this.restoredImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'itemName': itemName,
      'material': material,
      'originalImagePath': originalImagePath,
      'restoredImageUrl': restoredImageUrl,
    };
  }

  factory RestorationRecord.fromMap(Map<String, dynamic> map) {
    return RestorationRecord(
      id: map['id'],
      date: DateTime.parse(map['date']),
      itemName: map['itemName'] ?? map['name'] ?? 'Untitled',
      material: map['material'] ?? 'Unknown',
      originalImagePath: map['originalImagePath'] ?? map['imagePath'],
      restoredImageUrl: map['restoredImageUrl'],
    );
  }

  // Alias for compatibility with code expecting toJson/fromJson
  Map<String, dynamic> toJson() => toMap();
  factory RestorationRecord.fromJson(Map<String, dynamic> json) => RestorationRecord.fromMap(json);

  static String encode(List<RestorationRecord> records) => json.encode(
        records.map<Map<String, dynamic>>((record) => record.toMap()).toList(),
      );

  static List<RestorationRecord> decode(String records) =>
      (json.decode(records) as List<dynamic>)
          .map<RestorationRecord>((item) => RestorationRecord.fromMap(item))
          .toList();
}
