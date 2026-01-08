enum ReviewStatus {
  pending,    // 待审核
  approved,   // 审核通过
  rejected,   // 审核拒绝
}

class OOTDRecord {
  final String id;
  final DateTime date;
  final String imagePath;
  final List<String> tags;
  final String? note;
  final ReviewStatus reviewStatus;
  final String? rejectionReason;
  final DateTime? reviewedAt;

  OOTDRecord({
    required this.id,
    required this.date,
    required this.imagePath,
    required this.tags,
    this.note,
    this.reviewStatus = ReviewStatus.pending,
    this.rejectionReason,
    this.reviewedAt,
  });

  factory OOTDRecord.fromJson(Map<String, dynamic> json) {
    return OOTDRecord(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      imagePath: json['imagePath'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      note: json['note'] as String?,
      reviewStatus: ReviewStatus.values.firstWhere(
        (e) => e.name == (json['reviewStatus'] as String? ?? 'pending'),
        orElse: () => ReviewStatus.pending,
      ),
      rejectionReason: json['rejectionReason'] as String?,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
      'tags': tags,
      'note': note,
      'reviewStatus': reviewStatus.name,
      'rejectionReason': rejectionReason,
      'reviewedAt': reviewedAt?.toIso8601String(),
    };
  }

  OOTDRecord copyWith({
    String? id,
    DateTime? date,
    String? imagePath,
    List<String>? tags,
    String? note,
    ReviewStatus? reviewStatus,
    String? rejectionReason,
    DateTime? reviewedAt,
  }) {
    return OOTDRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
      tags: tags ?? this.tags,
      note: note ?? this.note,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }
}
