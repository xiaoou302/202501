/// Model representing an achievement in the game
class Achievement {
  /// Unique identifier for the achievement
  final String id;

  /// Display title of the achievement
  final String title;

  /// Description of how to earn the achievement
  final String description;

  /// Icon name (FontAwesome icon identifier)
  final String icon;

  /// Whether the achievement has been unlocked
  final bool isUnlocked;

  /// When the achievement was unlocked (null if not unlocked)
  final DateTime? unlockedAt;

  /// Category of the achievement (beginner, intermediate, advanced, hidden)
  final String category;

  /// Whether the achievement is hidden until unlocked
  final bool isHidden;

  /// Progress towards completing the achievement (0-100)
  final int progress;

  /// Constructor
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
    this.category = 'beginner',
    this.isHidden = false,
    this.progress = 0,
  });

  /// Creates a copy of this achievement with the given fields replaced with new values
  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedAt,
    String? category,
    bool? isHidden,
    int? progress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      category: category ?? this.category,
      isHidden: isHidden ?? this.isHidden,
      progress: progress ?? this.progress,
    );
  }

  /// Creates an Achievement from a map
  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      icon: map['icon'] as String,
      isUnlocked: map['isUnlocked'] as bool? ?? false,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.parse(map['unlockedAt'] as String)
          : null,
      category: map['category'] as String? ?? 'beginner',
      isHidden: map['isHidden'] as bool? ?? false,
      progress: map['progress'] as int? ?? 0,
    );
  }

  /// Converts this Achievement to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'category': category,
      'isHidden': isHidden,
      'progress': progress,
    };
  }

  /// Unlocks this achievement with the current timestamp
  Achievement unlock() {
    return copyWith(isUnlocked: true, unlockedAt: DateTime.now());
  }

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, isUnlocked: $isUnlocked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Achievement &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.icon == icon &&
        other.isUnlocked == isUnlocked &&
        other.unlockedAt == unlockedAt &&
        other.category == category &&
        other.isHidden == isHidden &&
        other.progress == progress;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        isUnlocked.hashCode ^
        unlockedAt.hashCode ^
        category.hashCode ^
        isHidden.hashCode ^
        progress.hashCode;
  }
}
