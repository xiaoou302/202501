import 'dart:convert';
import 'milestone.dart';
import 'pack_item.dart';

/// Mission model, represents the main task created by the user
class Mission {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final List<Milestone> milestones;
  final List<PackItem> packItems;
  final List<KnowledgePod> knowledgePods;

  Mission({
    required this.id,
    required this.title, //asdasdasda
    required this.description,
    required this.startDate, //asdasdasdasdasdasd
    this.endDate,
    required this.milestones,
    required this.packItems,
    required this.knowledgePods,
  });

  /// Create a copy of a mission
  Mission copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<Milestone>? milestones,
    List<PackItem>? packItems,
    List<KnowledgePod>? knowledgePods,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      milestones: milestones ?? this.milestones,
      packItems: packItems ?? this.packItems,
      knowledgePods: knowledgePods ?? this.knowledgePods,
    );
  }

  /// Convert mission to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'milestones': milestones.map((m) => m.toJson()).toList(),
        'packItems': packItems.map((p) => p.toJson()).toList(),
        'knowledgePods': knowledgePods.map((k) => k.toJson()).toList(),
      };

  /// Create mission from JSON
  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        startDate: DateTime.parse(json['startDate']),
        endDate:
            json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        milestones: (json['milestones'] as List)
            .map((m) => Milestone.fromJson(m))
            .toList(),
        packItems: (json['packItems'] as List)
            .map((p) => PackItem.fromJson(p))
            .toList(),
        knowledgePods: (json['knowledgePods'] as List)
            .map((k) => KnowledgePod.fromJson(k))
            .toList(),
      );

  /// Calculate overall mission completion progress
  double get completionProgress {
    if (milestones.isEmpty) return 0;

    int completedMilestones = milestones
        .where((milestone) => milestone.status == MilestoneStatus.completed)
        .length;

    return completedMilestones / milestones.length;
  }
}

/// Knowledge pod model, represents learning resources related to the mission
class KnowledgePod {
  final String id;
  final String title;
  final String url;
  final String? description;

  KnowledgePod({
    required this.id,
    required this.title,
    required this.url,
    this.description,
  });

  /// Convert knowledge pod to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'description': description,
      };

  /// Create knowledge pod from JSON
  factory KnowledgePod.fromJson(Map<String, dynamic> json) => KnowledgePod(
        id: json['id'],
        title: json['title'],
        url: json['url'],
        description: json['description'],
      );
}
