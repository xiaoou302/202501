class GrowthTrack {
  final String id;
  final String petId;
  final String title;
  final String description;
  final DateTime date;
  final List<String>? imageUrls;
  final bool isArchived;
  final DateTime createdAt;

  GrowthTrack({
    required this.id,
    required this.petId,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrls,
    this.isArchived = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imageUrls': imageUrls,
      'isArchived': isArchived,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GrowthTrack.fromJson(Map<String, dynamic> json) {
    return GrowthTrack(
      id: json['id'] as String,
      petId: json['petId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isArchived: json['isArchived'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
