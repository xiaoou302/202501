enum ReviewStatus {
  pending,    // 审核中
  approved,   // 审核通过
  rejected,   // 审核拒绝
}

class PracticeLog {
  final String id;
  final DateTime date;
  final int durationMinutes;
  final String notes;
  final List<String> photos;
  final DateTime createdAt;
  final ReviewStatus reviewStatus;
  final DateTime? reviewedAt;

  PracticeLog({
    required this.id,
    required this.date,
    required this.durationMinutes,
    required this.notes,
    required this.photos,
    required this.createdAt,
    this.reviewStatus = ReviewStatus.pending,
    this.reviewedAt,
  });

  PracticeLog copyWith({
    String? id,
    DateTime? date,
    int? durationMinutes,
    String? notes,
    List<String>? photos,
    DateTime? createdAt,
    ReviewStatus? reviewStatus,
    DateTime? reviewedAt,
  }) {
    return PracticeLog(
      id: id ?? this.id,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'durationMinutes': durationMinutes,
      'notes': notes,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
      'reviewStatus': reviewStatus.index,
      'reviewedAt': reviewedAt?.toIso8601String(),
    };
  }

  factory PracticeLog.fromJson(Map<String, dynamic> json) {
    return PracticeLog(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      durationMinutes: json['durationMinutes'] as int,
      notes: json['notes'] as String,
      photos: List<String>.from(json['photos'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewStatus: json['reviewStatus'] != null 
          ? ReviewStatus.values[json['reviewStatus'] as int]
          : ReviewStatus.pending,
      reviewedAt: json['reviewedAt'] != null 
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
    );
  }
}
