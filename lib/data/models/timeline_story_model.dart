class TimelineStory {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime date;
  final String? imageUrl;

  TimelineStory({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory TimelineStory.fromJson(Map<String, dynamic> json) {
    return TimelineStory(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
