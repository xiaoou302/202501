import 'action_item.dart';

/// Milestone status enum
enum MilestoneStatus { notStarted, inProgress, completed }

/// Milestone model, represents key stages in a mission
class Milestone {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final MilestoneStatus status;
  final List<ActionItem> actions;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.actions,
  });

  /// Create a copy of a milestone
  Milestone copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    MilestoneStatus? status,
    List<ActionItem>? actions,
  }) {
    return Milestone(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      actions: actions ?? this.actions,
    );
  }

  /// Convert milestone to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'status': status.toString().split('.').last,
    'actions': actions.map((a) => a.toJson()).toList(),
  };

  /// Create milestone from JSON
  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    dueDate: DateTime.parse(json['dueDate']),
    status: MilestoneStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
      orElse: () => MilestoneStatus.notStarted,
    ),
    actions: (json['actions'] as List)
        .map((a) => ActionItem.fromJson(a))
        .toList(),
  );

  /// Calculate milestone completion progress
  double get completionProgress {
    if (actions.isEmpty) return 0;

    int completedActions = actions.where((action) => action.isCompleted).length;
    return completedActions / actions.length;
  }
}
