/// Chapter model representing a game chapter/level
class Chapter {
  final int id;
  final String title;
  final String subtitle;
  final String content;
  final List<String> keywords;
  final double progress;
  final int starRating;
  final bool isUnlocked;
  final int totalTime;
  final int minKeywordsRequired;

  const Chapter({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.keywords,
    this.progress = 0.0,
    this.starRating = 0,
    this.isUnlocked = false,
    this.totalTime = 60,
    this.minKeywordsRequired = 5,
  });

  Chapter copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? content,
    List<String>? keywords,
    double? progress,
    int? starRating,
    bool? isUnlocked,
    int? totalTime,
    int? minKeywordsRequired,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      keywords: keywords ?? this.keywords,
      progress: progress ?? this.progress,
      starRating: starRating ?? this.starRating,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      totalTime: totalTime ?? this.totalTime,
      minKeywordsRequired: minKeywordsRequired ?? this.minKeywordsRequired,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'keywords': keywords,
      'progress': progress,
      'starRating': starRating,
      'isUnlocked': isUnlocked,
      'totalTime': totalTime,
      'minKeywordsRequired': minKeywordsRequired,
    };
  }

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      content: json['content'] as String,
      keywords: List<String>.from(json['keywords'] as List),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      starRating: (json['starRating'] as int?) ?? 0,
      isUnlocked: (json['isUnlocked'] as bool?) ?? false,
      totalTime: (json['totalTime'] as int?) ?? 60,
      minKeywordsRequired: (json['minKeywordsRequired'] as int?) ?? 5,
    );
  }
}
