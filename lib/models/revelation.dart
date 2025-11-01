class Revelation {
  final String title;
  final String description;
  final bool isUnlocked;
  final int unlockRequirement;

  Revelation({
    required this.title,
    required this.description,
    this.isUnlocked = false,
    required this.unlockRequirement,
  });

  Revelation copyWith({
    String? title,
    String? description,
    bool? isUnlocked,
    int? unlockRequirement,
  }) {
    return Revelation(
      title: title ?? this.title,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockRequirement: unlockRequirement ?? this.unlockRequirement,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isUnlocked': isUnlocked,
      'unlockRequirement': unlockRequirement,
    };
  }

  factory Revelation.fromJson(Map<String, dynamic> json) {
    return Revelation(
      title: json['title'] as String,
      description: json['description'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockRequirement: json['unlockRequirement'] as int,
    );
  }
}
