/// User statistics model
class UserStats {
  final int totalWordsSaved;
  final int chaptersCompleted;
  final Duration totalTimePlayed;
  final Map<int, ChapterProgress> chapterProgress;

  const UserStats({
    this.totalWordsSaved = 0,
    this.chaptersCompleted = 0,
    this.totalTimePlayed = Duration.zero,
    this.chapterProgress = const {},
  });

  UserStats copyWith({
    int? totalWordsSaved,
    int? chaptersCompleted,
    Duration? totalTimePlayed,
    Map<int, ChapterProgress>? chapterProgress,
  }) {
    return UserStats(
      totalWordsSaved: totalWordsSaved ?? this.totalWordsSaved,
      chaptersCompleted: chaptersCompleted ?? this.chaptersCompleted,
      totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
      chapterProgress: chapterProgress ?? this.chapterProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalWordsSaved': totalWordsSaved,
      'chaptersCompleted': chaptersCompleted,
      'totalTimePlayed': totalTimePlayed.inSeconds,
      'chapterProgress': chapterProgress.map(
        (key, value) => MapEntry(key.toString(), value.toJson()),
      ),
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    final progressMap = <int, ChapterProgress>{};
    if (json['chapterProgress'] != null) {
      (json['chapterProgress'] as Map<String, dynamic>).forEach((key, value) {
        progressMap[int.parse(key)] = ChapterProgress.fromJson(value);
      });
    }

    return UserStats(
      totalWordsSaved: (json['totalWordsSaved'] as int?) ?? 0,
      chaptersCompleted: (json['chaptersCompleted'] as int?) ?? 0,
      totalTimePlayed: Duration(
        seconds: (json['totalTimePlayed'] as int?) ?? 0,
      ),
      chapterProgress: progressMap,
    );
  }
}

/// Chapter progress model
class ChapterProgress {
  final int chapterId;
  final int starRating;
  final Set<String> savedKeywords;
  final bool isCompleted;
  final DateTime? lastPlayed;

  const ChapterProgress({
    required this.chapterId,
    this.starRating = 0,
    this.savedKeywords = const {},
    this.isCompleted = false,
    this.lastPlayed,
  });

  ChapterProgress copyWith({
    int? chapterId,
    int? starRating,
    Set<String>? savedKeywords,
    bool? isCompleted,
    DateTime? lastPlayed,
  }) {
    return ChapterProgress(
      chapterId: chapterId ?? this.chapterId,
      starRating: starRating ?? this.starRating,
      savedKeywords: savedKeywords ?? this.savedKeywords,
      isCompleted: isCompleted ?? this.isCompleted,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'starRating': starRating,
      'savedKeywords': savedKeywords.toList(),
      'isCompleted': isCompleted,
      'lastPlayed': lastPlayed?.toIso8601String(),
    };
  }

  factory ChapterProgress.fromJson(Map<String, dynamic> json) {
    return ChapterProgress(
      chapterId: json['chapterId'] as int,
      starRating: (json['starRating'] as int?) ?? 0,
      savedKeywords: Set<String>.from(json['savedKeywords'] ?? []),
      isCompleted: (json['isCompleted'] as bool?) ?? false,
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.parse(json['lastPlayed'])
          : null,
    );
  }

  /// Calculate progress percentage
  double calculateProgress(int totalKeywords) {
    if (totalKeywords == 0) return 0.0;
    return (savedKeywords.length / totalKeywords) * 100;
  }
}
