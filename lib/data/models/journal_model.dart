enum JournalType {
  practice,
  inspiration,
}

class JournalModel {
  final String id;
  final JournalType type;
  final String title;
  final String? imageUrl;
  final String content;
  final DateTime date;
  final String? originalArtId;

  JournalModel({
    required this.id,
    required this.type,
    required this.title,
    this.imageUrl,
    required this.content,
    required this.date,
    this.originalArtId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'title': title,
      'imageUrl': imageUrl,
      'content': content,
      'date': date.toIso8601String(),
      'originalArtId': originalArtId,
    };
  }

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'],
      type: json['type'] == 'JournalType.practice'
          ? JournalType.practice
          : JournalType.inspiration,
      title: json['title'],
      imageUrl: json['imageUrl'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      originalArtId: json['originalArtId'],
    );
  }
}
