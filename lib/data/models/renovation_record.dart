class RenovationRecord {
  final String id;
  final String imagePath;
  final String description;
  final DateTime date;

  RenovationRecord({
    required this.id,
    required this.imagePath,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory RenovationRecord.fromJson(Map<String, dynamic> json) {
    return RenovationRecord(
      id: json['id'],
      imagePath: json['imagePath'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }
}
