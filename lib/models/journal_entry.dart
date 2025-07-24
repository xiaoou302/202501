class JournalEntry {
  final String id;
  final String text;
  final String colorHex;
  final DateTime date;
  final String? title;
  final String? mood;
  final List<String> tags;
  final bool isFavorite;

  JournalEntry({
    required this.id,
    required this.text,
    required this.colorHex,
    required this.date,
    this.title,
    this.mood,
    this.tags = const [],
    this.isFavorite = false,
  });

  // Convert JournalEntry to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'colorHex': colorHex,
      'date': date.toIso8601String(),
      'title': title,
      'mood': mood,
      'tags': tags,
      'isFavorite': isFavorite,
    };
  }

  // Create JournalEntry from Map (from storage)
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      text: json['text'],
      colorHex: json['colorHex'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      mood: json['mood'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Create a copy of this entry with some fields replaced
  JournalEntry copyWith({
    String? id,
    String? text,
    String? colorHex,
    DateTime? date,
    String? title,
    String? mood,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      colorHex: colorHex ?? this.colorHex,
      date: date ?? this.date,
      title: title ?? this.title,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
