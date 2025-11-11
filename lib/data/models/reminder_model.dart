enum ReminderType {
  deworming,
  vetCheckup,
  vaccination,
  grooming,
  birthday,
  gotchaDay,
  custom,
}

class Reminder {
  final String id;
  final String petId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final ReminderType type;
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.petId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'type': type.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      petId: json['petId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      type: ReminderType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ReminderType.custom,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Reminder copyWith({
    String? id,
    String? petId,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    ReminderType? type,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
